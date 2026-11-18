"""Failure behavior with local tool stubs; no network or user HOME writes."""
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class Fixture(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='dotfiles-failure-')
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name) / 'home'
        self.bin = Path(self.temp.name) / 'bin'
        self.bin.mkdir()
        self.library = self.home / '.local/share/dotfiles'
        self.library.mkdir(parents=True)
        shutil.copy(ROOT / 'dot_local/share/dotfiles/events.sh', self.library)
        self.completions = self.home / '.local/share/zsh/completions'
        self.completions.mkdir(parents=True)
        self.env = {'HOME': str(self.home), 'PATH': f'{self.bin}:/usr/bin:/bin', 'LANG': 'C.UTF-8'}
        for tool in ('chezmoi', 'sheldon'):
            self.stub(tool, "printf '#compdef stub\\n'\n")

    def stub(self, name, body):
        path = self.bin / name
        path.write_text('#!/bin/bash\n' + body)
        path.chmod(0o755)

    def run_generator(self):
        return subprocess.run(['/bin/bash', str(ROOT / 'dot_local/bin/executable_dotfiles-completions')],
                              env=self.env, capture_output=True, text=True)

    def events(self):
        return (self.home / '.local/state/dotfiles/events.log').read_text()



class CompletionFailures(Fixture):
    def test_failure_retains_previous_file_and_reports_original_exit(self):
        target = self.completions / '_uv'
        target.write_text('#compdef previous\n')
        self.stub('uv', "printf '# partial output\\n'\nexit 42\n")
        result = self.run_generator()
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(target.read_text(), '#compdef previous\n')
        self.assertIn('code=COMPLETION_GENERATION_FAILED component=uv exit=42', self.events())
        self.assertIn('recovery=retained', self.events())
        self.assertFalse(list(self.completions.glob('.uv.*')))
        # Recovery cannot erase the original failure event.
        self.stub('uv', "printf '#compdef uv\\n'\n")
        self.assertEqual(self.run_generator().returncode, 0)
        self.assertEqual(target.read_text(), '#compdef uv\n')
        self.assertIn('exit=42', self.events())
        self.assertIn('COMPLETION_GENERATION_SUCCEEDED component=uv exit=0', self.events())
        self.assertEqual((self.home / '.local/state/dotfiles/events.log').stat().st_mode & 0o077, 0)

    def test_empty_output_is_failure(self):
        self.stub('uv', 'exit 0\n')
        self.assertNotEqual(self.run_generator().returncode, 0)
        self.assertIn('code=COMPLETION_EMPTY component=uv', self.events())
        self.assertFalse((self.completions / '_uv').exists())

    def test_invalid_syntax_does_not_replace_previous_completion(self):
        target = self.completions / '_uv'
        target.write_text('#compdef previous\n')
        self.stub('uv', "printf 'if then\\n'\n")
        self.assertNotEqual(self.run_generator().returncode, 0)
        self.assertEqual(target.read_text(), '#compdef previous\n')
        self.assertIn('COMPLETION_SYNTAX_FAILED', self.events())

    def test_log_does_not_copy_tool_stderr_or_environment_values(self):
        secret = 'private-document-body-do-not-log'
        self.env['PRIVATE_DOCUMENT'] = secret
        self.stub('uv', f"printf '%s\\n' '{secret}' >&2\nexit 43\n")
        self.assertNotEqual(self.run_generator().returncode, 0)
        self.assertNotIn(secret, self.events())
        self.assertIn('exit=43', self.events())

    def test_missing_required_tool_is_not_success(self):
        (self.bin / 'sheldon').unlink()
        self.assertNotEqual(self.run_generator().returncode, 0)
        self.assertIn('COMMAND_MISSING component=sheldon exit=127', self.events())


class ShellFailures(Fixture):
    # Share the isolated HOME fixture, with real Zsh but no real plugins.
    def test_failed_init_leaves_basic_shell_and_records_safe_cause(self):
        config = self.home / '.config/zsh'
        config.mkdir(parents=True)
        shutil.copy(ROOT / 'dot_config/zsh/config.zsh', config)
        shutil.copy(ROOT / 'dot_zshrc', self.home / '.zshrc')
        self.stub('sheldon', 'exit 44\n')
        self.stub('starship', 'exit 45\n')
        source_file = self.home / 'args.zsh'
        source_file.write_text('[[ $# == 1 && $1 == expected ]]\n')
        result = subprocess.run(['/usr/bin/zsh', '-ic',
            '[[ ${+functions[source]} == 0 ]] && source "$HOME/args.zsh" expected'],
            env=self.env, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn('INIT_GENERATION_FAILED component=sheldon exit=44', self.events())
        self.assertIn('INIT_GENERATION_FAILED component=starship exit=45', self.events())


if __name__ == '__main__':
    unittest.main()
