"""Real chezmoi apply/reapply and Zsh startup in an isolated HOME (downloads tools)."""
import hashlib
from pathlib import Path
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
chezmoi = shutil.which('chezmoi')
if not chezmoi:
    raise SystemExit('chezmoi >= 2.74.1 must be on PATH')

with tempfile.TemporaryDirectory(prefix='dotfiles-integration-') as temp:
    home = Path(temp) / 'home'
    home.mkdir()
    env = {'HOME': str(home), 'PATH': f'{Path(chezmoi).parent}:/usr/bin:/bin',
           'TERM': 'xterm-256color', 'LANG': 'C.UTF-8'}
    command = [chezmoi, '--source', str(ROOT), '--destination', str(home)]

    def run(args):
        result = subprocess.run(args, env=env, capture_output=True, text=True)
        if result.returncode:
            raise AssertionError(f'{args[0]} failed ({result.returncode})\n{result.stdout}\n{result.stderr}')
        return result

    run(command + ['apply', '--force'])
    assert (home / '.local/bin/sheldon').is_file()
    assert (home / '.local/bin/starship').is_file()
    assert not (home / 'tests').exists()
    assert not (home / 'README.md').exists()
    assert not (home / 'Microsoft.PowerShell_profile.ps1').exists()
    completion = home / '.local/share/zsh/completions/_sheldon'
    before = (completion.stat().st_mtime_ns, hashlib.sha256(completion.read_bytes()).hexdigest())
    run(command + ['apply', '--force'])
    after = (completion.stat().st_mtime_ns, hashlib.sha256(completion.read_bytes()).hexdigest())
    assert before == after, 'run_onchange unexpectedly re-ran on identical input'
    assert run(command + ['status', '--exclude', 'scripts']).stdout == '', 'managed files did not converge'
    # External system completions belong to the test host, not the source state.
    # Record dangling symlinks and exclude affected directories only in this test.
    default_paths = run(['/usr/bin/zsh', '-fc', 'printf \"%s\\n\" \"${fpath[@]}\"']).stdout.splitlines()
    healthy_paths = []
    for directory in default_paths:
        path = Path(directory)
        broken = path.is_dir() and any(p.is_symlink() and not p.exists() for p in path.iterdir())
        if broken:
            print('ENV_DANGLING_COMPLETION: system completion directory excluded from test FPATH')
        else:
            healthy_paths.append(directory)
    env['FPATH'] = ':'.join(healthy_paths)
    startup = run(['/usr/bin/zsh', '-ic', '''
[[ ${+functions[source]} == 0 ]] || exit 10
[[ $commands[sheldon] == "$HOME/.local/bin/sheldon" ]] || exit 11
[[ ${+_comps[git]} == 1 ]] || exit 12
(( $+functions[history-substring-search-up] )) || exit 13
(( $+functions[_zsh_highlight] )) || exit 14
(( $+functions[_zsh_autosuggest_start] )) || exit 15
[[ $PROMPT == *starship* ]] || exit 16
# Exercise prompt expansion as well as loading the initialization code.
print -P -- "$PROMPT" >/dev/null
print -r -- 'shell startup passed'
'''])
    assert startup.stderr == '', startup.stderr
    events = (home / '.local/state/dotfiles/events.log').read_text()
    assert 'FAILED' not in events and 'MISSING' not in events, events
    bad_source = Path(temp) / 'bad-source'
    shutil.copytree(ROOT, bad_source, ignore=shutil.ignore_patterns('.git', '__pycache__'))
    manifest = bad_source / '.chezmoidata/tools.toml'
    import re
    manifest.write_text(re.sub(r'sha256 = "[0-9a-f]{64}"', 'sha256 = "' + '0' * 64 + '"', manifest.read_text()))
    binary = home / '.local/bin/starship'
    binary_hash = hashlib.sha256(binary.read_bytes()).hexdigest()
    rejected = subprocess.run([chezmoi, '--source', str(bad_source), '--destination', str(home),
                               'apply', '--force'], env=env, capture_output=True, text=True)
    assert rejected.returncode != 0, 'invalid external checksums were accepted'
    assert 'sha256 mismatch' in rejected.stderr.lower(), rejected.stderr
    assert hashlib.sha256(binary.read_bytes()).hexdigest() == binary_hash, 'checksum failure changed installed binary'
    print('PASS: clean apply, reapply, unchanged generator timestamp, converged files, real startup, checksum rejection')
