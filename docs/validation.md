# 検証記録（2026-11-18）

主な利用環境は WSL 2 上の Ubuntu 26.04。CI 対象は Ubuntu 24.04 / 26.04。
CI は GitHub ホストの Ubuntu で実行し、WSL 2 自体の統合動作確認とは区別する。
元の main は 3a2af0c0f347d4770dc54be9588a0415960ec3b0。
変更と検証は /tmp の checkout と一時 HOME で実施し、実ユーザーの HOME に apply していない。

| 検査 | 結果・範囲 |
| --- | --- |
| chezmoi 2.74.1 | 公式配布物を公開 checksum と照合して実行 |
| Sheldon 0.8.5 / Starship 1.27.0 | amd64 の実バイナリで適用・起動確認 |
| arm64 の配布物 | ダウンロードとハッシュ確認。実行は未実施 |
| 外部配布物の改変 | 不一致 checksum を拒否し、既存バイナリの内容を保持 |
| ShellCheck / 構文確認 | Bash・POSIX ヘルパーと Zsh 設定を確認 |
| 補完生成失敗 | 終了42を記録し、前のファイルを保持。再実行成功後も失敗記録を保持 |
| 空出力・不正構文 | 失敗として非0終了、既存ファイルを保持 |
| 記録内容 | スタブの stderr に置いた秘密本文と環境変数の値は記録しない |
| 必須 CLI 不在・初期化失敗 | 原因コードを記録。起動時は基本シェルを利用可能 |
| 再適用 | 生成済み補完の時刻と内容が変わらず、管理ファイルが収束 |

適用前レビューでユーザーの差分から判明した事項：

- MIGRATION_RUST_ENV_OMITTED：既存 `.zshenv` の Cargo 読み込みが削除対象となり、
  非対話 Zsh で Rust の環境が読み込まれなくなる差分を確認。ユーザーはまだ適用していない。
  `.zshenv` の Cargo 読み込みを保持し、非対話 Zsh の回帰テストを追加。
  Volta と pnpm の初期化設定は、ユーザーの明示的な希望により引き継がない。
- MIGRATION_DIRECTORY_MODE_WIDENING：既存 `~/.config` の750が755になる予定差分を確認。
  chezmoi の端末固有設定 `umask = 0o027` によって750を維持する手順を記載。
  ユーザーの設定ファイルをリポジトリから自動上書きしない。

検証で見つかった失敗を隠さず、下記に残す。

- LOCAL_CHECKOUT_UNAVAILABLE：元の作業ディレクトリが存在せず、/tmp に公開リポジトリを clone。
- STATUS_EXPECTATION_MISMATCH：最初の統合検証は status の完全な空出力を期待して失敗。
  原因は毎回実行する前提条件スクリプトの正常な R 表示。ファイルの収束を scripts 除外で確認し、
  run_onchange の非再実行は補完の時刻と内容で別に確認するよう修正。
- INTEGRITY_ERROR_WORDING：改変配布物の拒否試験で、CLI のエラーに checksum という語を期待して失敗。
  実際は SHA256 mismatch と報告され、適切に拒否されていた。検証する診断名を修正して再確認。
- CI_COMPINIT_ABORT：[初回 CI](https://github.com/Ningensei848/dotfiles/actions/runs/44312368652) の実バイナリ起動試験が非TTYでの compinit 中断により失敗。
  初回ログから拒否対象のパスまでは特定できていない。明示的な compaudit の結果を安全な原因コードで記録し、
  拒否されたエントリを compinit -i で除外するよう修正。監査を省略する -C/-u は使わない。
  検証では権限の緩い補完ディレクトリを注入し、除外と正常な補完の継続を確認する。
- CI_GLOBAL_COMPINIT：[2回目の CI](https://github.com/Ningensei848/dotfiles/actions/runs/44312825456) で
  管理側の補完初期化は復旧したが、それ以前の compinit 警告が残って失敗。
  Ubuntu の /etc/zsh/zshrc がユーザーの .zshrc より先に compinit を呼ぶ実装を確認。
  同ファイルが案内する skip_global_compinit=1 を小さな .zshenv に設定し、管理側へ初期化を集約。
- ENV_DANGLING_COMPLETION：検証ホストの /usr/share/zsh/vendor-completions/_docker が
  /mnt/wsl/docker-desktop 内の見えないファイルを指し、compinit がファイル不在の警告を出した。
  リンク切れは確認済み。Docker Desktop 側でファイルが見えない根本原因は未確認。
  統合テストでは壊れたリンクを含むシステム補完ディレクトリを明示的に記録し、テストの FPATH からのみ除外。
  リポジトリの設定やホストのシステムファイルを変更して直ったと主張しない。
  元のシステム FPATH を含む起動では警告が残りうる。

実施していないこと：Windows/macOS の対応、arm64 実行、ログインシェル変更、
ユーザー環境への適用、起動速度の比較測定。
GitHub Actions の最新の結果は、各変更を含む PR の Checks を参照する。
失敗処理が正常でも高速化の効果や全端末での動作を保証するものではない。
