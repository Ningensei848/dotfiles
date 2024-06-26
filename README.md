# らくしたっていいじゃない、にんげんだもの

![`.dotfiles` をﾘﾎﾟｼﾞﾄﾘとして `chezmoi` で管理する](https://custom-og-image-generator.vercel.app/api/%60.dotfiles%60%20%E3%82%92%EF%BE%98%EF%BE%8E%EF%BE%9F%EF%BD%BC%EF%BE%9E%EF%BE%84%EF%BE%98%E3%81%A8%E3%81%97%E3%81%A6%20%60chezmoi%60%20%E3%81%A7%E7%AE%A1%E7%90%86%E3%81%99%E3%82%8B.png?theme=dark&copyright=Kiai+de+Nantoka&logo=https%3A%2F%2Fwww.chezmoi.io%2Flogo.svg&avater=https%3A%2F%2Favatars.githubusercontent.com%2Fu%2F20794309&author=Kiai&aka=%40Ningensei848&site=%E6%B0%97%E5%90%88%E3%81%A7%E3%81%AA%E3%82%93%E3%81%A8%E3%81%8B&tags=dev&tags=dotfiles&tags=chezmoi)

## 使い方:how to use

[`chezmoi`](https://www.chezmoi.io/) を入手して、`dotfiles` リポジトリから必要なものを展開する

```shell
export GITHUB_USERNAME="Ningensei848" && \
export ZSH_CUSTOM="${HOME}/.zsh" && \
export PATH="${HOME}/bin:${PATH}" && \
sh -c "$(wget -qO- get.chezmoi.io)" -- -b $HOME/bin && \
echo '# chezmoi\npath+=("$HOME/bin")\n' >> ~/.zshrc && \
source ~/.zshrc && which chezmoi && chezmoi --version && \
echo $ZSH_CUSTOM && mkdir -p $ZSH_CUSTOM/plugins/chezmoi && \
chezmoi completion zsh --output=$ZSH_CUSTOM/plugins/chezmoi/_chezmoi && \
chezmoi init --apply $GITHUB_USERNAME
```

## zsh

Ubuntu の場合：

```shell
sudo apt-get -y update && \
sudo apt-get -y upgrade && \
sudo apt-get -y install zsh && \
zsh --version && chsh -s $(which zsh) && \
echo $SHELL && $SHELL --version
```

## 管理したい

- rye
- volta
- rustup (rust+cargo)

### rye

N/A

### volta

N/A

### rustup

How to install:

```shell
curl https://sh.rustup.rs -sSf | sh
```

### zsh

`$HOME/.zshrc` は別の場所に動かせないから、設定ファイルを纏めるための `.zsh/` を別途つくることにする
（`.zshrc` 等の動かせない基本ファイルからは `.zsh/` の設定ファイルを読みに行かせる）

#### sheldon

pre-requisitory: `cargo`

```shell
# install GCC
sudo apt update && \
sudo apt install pkg-config libssl-dev build-essential && \
cargo install sheldon
```


#### Starship

```shell
cargo install starship --locked
```

Cmake がない！と怒られたら：

```shell
sudo apt -y update && \
sudo apt -y install build-essential && \
echo "cmake には curl, zlib が必要" && \
sudo apt -y install zlib1g-dev libcurl4-gnutls-dev && \
cd /tmp && \
git clone https://github.com/Kitware/CMake.git && \
cd CMake && \
./configure --system-curl --system-zlib && \
make && \
sudo make install
```

cf. https://www.kkaneko.jp/tools/ubuntu/cmake_buildout.html

## Author

[![Twitter is what's happening in the world and what people are talking about right now.](https://img.shields.io/badge/@Ningensei848-%231DA1F2.svg?&style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/Ningensei848)

[![](https://img.shields.io/badge/k.kubokawa@klis.tsukuba.ac.jp-%23757575.svg?&style=for-the-badge&logo=gmail&logoColor=EA4335)](mailto:k.kubokawa@klis.tsukuba.ac.jp)

## License

_This software is released under the [MIT License](LICENSE)._

## TODO:

- [ ] CI/CD の導入
  - [ ] 異なる OS 間での導入スクリプトの作成
- [ ] zsh のカスタマイズ(with `Oh My Zsh`)
