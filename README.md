# dotfiles — WSL / Linux

chezmoi で設定とユーザー用 CLI を管理する。主な利用環境は **WSL 2 上の Ubuntu 26.04**。
対応は Linux amd64 / arm64。CI は Ubuntu 24.04 / 26.04 で実行する。
Zsh、Sheldon、Starship を継続し、シェル起動時のネットワーク取得や独自の生成コード管理を減らす。

## 導入

先にディストリビューションのパッケージ管理で Git・Zsh・Bash を用意する。
Ubuntu / Debian の例：

```sh
sudo apt-get update
sudo apt-get install --no-install-recommends git zsh bash
```

chezmoi は **2.74.1 以上**を使う。
[公式インストール手順](https://www.chezmoi.io/install/)で導入し、`chezmoi --version` を確認する。
既存版がある場合は `chezmoi upgrade` を使える。

```sh
chezmoi init Ningensei848
chezmoi diff
chezmoi apply
exec zsh
```

作業中のローカル checkout を使う場合：

```sh
chezmoi --source "$PWD" diff
chezmoi --source "$PWD" apply
```

apply は `.local/bin/sheldon` と `.local/bin/starship` を取得する。
版と SHA256 は `.chezmoidata/tools.toml` に固定し、chezmoi の externals 機能が検証・配置する。
Rust / CMake によるソースビルド、sudo、OS 全体の upgrade、ログインシェル変更は apply に含めない。
初回は Sheldon のプラグイン取得も行うため GitHub への接続が必要。

## 配置と責務

| 管理対象 | 配置 |
| --- | --- |
| Rust の共通環境と Ubuntu の補完初期化制御 | `~/.zshenv` |
| 起動用の小さなファイル | `~/.zshrc` |
| Zsh 設定 | `~/.config/zsh/config.zsh` |
| Sheldon 宣言 | `~/.config/sheldon/plugins.toml` |
| Starship の表示設定 | `~/.config/starship.toml` |
| ユーザー用 CLI | `~/.local/bin` |
| 補完生成コマンド | `~/.local/bin/dotfiles-completions` |
| プラグイン実体・端末固有のロック | `$XDG_DATA_HOME/sheldon` |
| 生成した補完 | `$XDG_DATA_HOME/zsh/completions` |
| 補完初期化のキャッシュ | `$XDG_CACHE_HOME/zsh` |
| 安全な実行記録 | `$XDG_STATE_HOME/dotfiles/events.log` |

DATA / CACHE / STATE は未指定なら XDG の既定値を使う。
管理する設定・CLI・共有ヘルパーのパスは上表のホーム相対位置に固定。
`XDG_CONFIG_HOME` を変えても管理ファイルの配置先は変わらない。
履歴は移行時に失わないよう既存の `~/.zsh_history` を使う。
生成物は Git に含めず、プラグイン参照は TOML の commit SHA で固定する。

Rust の rustup/Cargo、proto、uv は既存の導入を利用する。
Rust の環境は `.zshenv` で非対話 Zsh にも引き継ぐ。Volta と pnpm の初期化設定は移行しない。
言語環境やプロジェクト依存の導入・更新はこの shell 設定に含めない。
`~/.local/bin` を優先するため、Cargo 等に同名 CLI があってもここで固定した版を使う。

## 更新と復旧

```sh
chezmoi cd
git pull --ff-only
chezmoi diff
chezmoi apply
```

版を上げるときは `.chezmoidata/tools.toml` の version・URL・SHA256 をまとめて更新する。
Starship は公開 `.sha256` と照合する。Sheldon 0.8.5 は公開 checksum ファイルがないため、
公式 HTTPS 配布物から算出したハッシュを固定している。署名による発行者検証とは区別する。
プラグイン更新は `plugins.toml` の rev を更新し、検証後に commit する。
補完の権限監査で拒否されたエントリは原因コードを記録して除外する。監査自体は省略しない。
`apply` のたびに latest を解決する構成にはしない。

`.chezmoiscripts/run_onchange_after_20-initialize-shell.sh.tmpl` は、ツール一覧・プラグイン宣言・
生成コマンド・記録ヘルパーの内容が変わったときにロック確認と補完生成を行う。
変更がない再適用では補完を書き直さない。前提条件の確認スクリプトは毎回実行するので、
`chezmoi status` にそのスクリプトの `R` が表示されるのは正常。

後から任意の CLI を入れたとき、または生成物を手動で消したとき：

```sh
dotfiles-completions
exec zsh
```

補完生成に失敗すると非0で終了し、そのツールの直前の正常な補完を保持する。
失敗・復旧後の成功を、安全な原因コード、対象、終了コード、時刻、PID とともに追記する。
自動再試行は行わず、各実行の attempt は1。後の成功でも以前の失敗を消さない。
生のツール出力や環境変数の値は記録しない。
シェル初期化の失敗時は診断を出して基本シェルを利用可能にする。

## 旧構成からの移行

最初の `chezmoi diff` で `~/.zshenv`・`~/.zshrc` と `~/.local/bin` の変更を確認する。
独自の追記がある場合は適用前に保存・移植する。
既存 `~/.config` が 750 なのに diff が 755 への変更を示す場合は、端末固有の権限方針を先に指定する。
`chezmoi edit-config` で TOML のトップレベル（最初のセクションより前）に `umask = 0o027` を設定し、
改めて diff を確認する。これは全管理対象に適用され、通常のディレクトリは750、ファイルは640になる。
リポジトリから端末固有の chezmoi 設定ファイルを上書きしない。
旧 `~/.zsh` 内の設定と Starship 初期化キャッシュは新構成では読まない。
旧ファイルや `~/.scripts/nf_downloader.sh` をユーザーの HOME から自動削除しない。
`~/.scripts/get_completion.sh` は新しい生成コマンドへの互換入口を維持する。

フォントは端末を描画する側に Nerd Font を設定する。
WSL + Windows Terminal なら Windows 側に設定し、WSL のフォント導入だけで済ませない。
[公式のフォント導入経路](https://www.nerdfonts.com/font-downloads)を使う。
Windows PowerShell の旧ファイルは参考用に残すが Linux の HOME へは配布しない。

## 検証

Python 3、Zsh、Git と、PATH 上の chezmoi 2.74.1 以上を使用する。

```sh
python3 -m unittest discover -s tests -p 'test_*.py' -v
python3 tests/integration.py
```

隔離した HOME で失敗・空出力・不正構文・秘密本文を記録しないことを確認する。
統合検証は実バイナリとプラグインを取得して初回適用・再適用・シェル起動を行う。
arm64 は配布物のハッシュを確認したが、この変更時の実行検証は amd64 のみ。
[検証時の失敗と制約](docs/validation.md)も参照。

[chezmoi externals](https://www.chezmoi.io/reference/special-files/chezmoiexternal-format/) /
[スクリプトの作法](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/) /
[Sheldon の設定](https://sheldon.cli.rs/Configuration.html) /
[Starship の初期化](https://starship.rs/)

MIT License — see LICENSE.
