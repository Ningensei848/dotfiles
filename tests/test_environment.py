"""Rust must remain available to non-interactive Zsh after migration."""
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class ExistingRustEnvironment(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='dotfiles-rust-env-')
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name)
        shutil.copy(ROOT / 'dot_zshenv', self.home / '.zshenv')
        self.env = {'HOME': str(self.home), 'PATH': '/usr/bin:/bin', 'LANG': 'C.UTF-8'}
        cargo = self.home / '.cargo'
        cargo.mkdir()
        (cargo / 'env').write_text('export DOTFILES_CARGO_PROBE=loaded\nexport PATH="$HOME/.cargo/bin:$PATH"\n')
        (cargo / 'bin').mkdir()
        executable = cargo / 'bin/cargo'
        executable.write_text('#!/bin/sh\nprintf "existing-cargo\\n"\n')
        executable.chmod(0o755)

    def test_noninteractive_zsh_keeps_cargo(self):
        for option in ('-c', '-lc'):
            with self.subTest(option=option):
                result = subprocess.run(['/usr/bin/zsh', option,
                    '[[ $DOTFILES_CARGO_PROBE == loaded ]] && cargo'],
                    env=self.env, capture_output=True, text=True)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(result.stdout.strip(), 'existing-cargo')

    def test_cargo_source_failure_is_reported(self):
        (self.home / '.cargo/env').write_text('return 52\n')
        result = subprocess.run(['/usr/bin/zsh', '-c', ':'],
            env=self.env, capture_output=True, text=True)
        self.assertIn('code=ENV_SOURCE_FAILED component=rustup exit=52', result.stderr)


if __name__ == '__main__':
    unittest.main()
