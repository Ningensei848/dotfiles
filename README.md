# らくしたっていいじゃない、にんげんだもの　みつを

### あいさつ
とりあえず毎回鯖立てるときにアレコレするのが面倒なのでここにまとめて置いておくことにしました。使い方を学ぶ意味でも少しづつどうにかやっていけたらと思います。現状、centosから```.bashrc```と```.bash_profile```とかが置いてあります。

**参考にしたページ**: [最強の dotfiles 駆動開発と GitHub で管理する運用方法](https://goo.gl/AR31Pg)

やり残していること: [pycharmを起動するときに自動でWSLデーモンサーバを起動しlocalhostにsshで接続する](https://twitter.com/Ningensei848/status/974516408552796160)

こちらもどうぞ => [PyCharm + WSLを導入したWindows10でのDjango開発日記 - Qiita](https://goo.gl/7o3Tuh)

## 目次

- 使い方 (初心者でもコピペでどうにかなります笑)
- .bashrc
- .bash_profile
- .viminfo
- README_template.md
- 参考文献


### 使い方:how to use

1. `$ cd ~` (本来`.FILE`が置かれているはずのディレクトリへ移動)
1. `$ git clone https://github.com/Ningensei848/dotfiles.git`
1. `$ sudo bash ~/dotfiles/setup.sh` (コピペして実行して、完了！)
1. また、任意のディレクトリに於いて`$ (dot_REMOVED_FILE)-backup`とすればいつでもバックアップをとることができる

### .bashrc

エイリアス\[alias\]とか設定して保存しておくところ
基本的に自分がいつでも使う必須なものを入れてあとは環境によってカスタマイズする（長いパスを入れとくとか）

### .bash\_profile

えくすぽーと？\[export\]するものを設定して保存しておくところ
なんかまだよくわからない。とりあえず```PS1```っていう変数が必要だったので置いてある

### .viminfo

Vimの設定を保存しておくところ
まだあんまりいじっていない。
Vimはどうにか使いこなせるようになりたいね。

### README\_template.md

RDD（README.md Driven Development）なんて言葉もあるらしい（笑)　　
実際にgithubなんかでフリー配布する際に必要なライセンスの問題とか、そもそもの使い方とかをキチンと書いていくためにテンプレートを用意した。もちろん今後は必要に応じて追記していく。

#### 参考文献

- [最強の dotfiles 駆動開発と GitHub で管理する運用方法](https://goo.gl/AR31Pg)
- [bash起動時の設定ファイル実行順序](https://goo.gl/xxvThn)
- [【初心者向け】エイリアスの設定方法](https://goo.gl/C4UM3g)
- [Bashプロンプトの変更](https://goo.gl/DKwx5Q)
- [Bash prompt basics - LinuxConfig.org](https://linuxconfig.org/bash-prompt-basics)
- [Linuxで、bash プロンプトを素敵で実用的なものに変更する](https://goo.gl/lxNNyR)
- [Linuxの権限確認と変更（超初心者向け）](https://goo.gl/8xRm1X)
- 

