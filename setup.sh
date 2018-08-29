#!/bin/bash

# 使い方: How to use
# 1. `cd ~` # root Dirに移動
# 2. `git clone https://github.com/Ningensei848/dotfiles.git` # ~/dotfilesを作成
# 3. `bash dotfiles/setup.sh` # run shell script and setup whole settings in `dotfiles/`

# !! COUTION !! : DON'T USE the COMMAND `sh`; it occurs 'Syntax Error'. 

# (root DIR) ~/dotfiles/setup.sh
# であるいう前提のもと書いていく

# おまじない（いろいろな表示出力を出してくれるらしい）
set -eux 

# TARGET dotfiles : セットアップしたい設定ファイル名を選択 
# - you can add more dotfiles if you want

dotfiles=(.bashrc .bash_profile .viminfo .gitconfig) # please add more VAR(dotfile)

declare -A MY_ARRAY                       # Declare ARRAY object : 連想配列だから宣言しないと使えない



# MOVE to ROOT : root DIRに移動
cd ~



# PREPARE setup : もろもろ必要な関数の初期設定

LATEST_BACKUP_=`echo LATEST_BACKUP_`

for file in ${dotfiles[@]}; do

    suffix=`echo ${file#*.}`              # Remove '.' from filename
    targetDir=`echo ~/dotfiles/backups-$suffix`
    MY_ARRAY[$file]=$targetDir            # Register '$file' to Dict object as a KEY
done



# CONFIRM existance of neccessary FILE and DIR

for file in ${dotfiles[@]}; do

    if [ -e $file ]; then
        echo $file found.                 # file Existed : ファイルが存在する場合
    else
        echo -n > $file                   # if NOT Existed, make NEW file : ファイルが存在しない場合
    fi

done

for key in ${!MY_ARRAY[@]}; do

    if [ -e ${MY_ARRAY[$key]} ]; then
        echo ${MY_ARRAY[$key]} found.     # dirctory Existed : ディレクトリが存在する場合
    else
        
        mkdir ${MY_ARRAY[$key]}           # if NOT Existed, make NEW dir : ディレクトリが存在しない場合
    fi

done


# BACKUP to Dotfies DIR : バックアップを専用フォルダにコピーして保存
# - latest backup file is 'XXXX-backup'
# - later version backup file is renamed to 'XXXX-backup_YYYY-MM-DD_HH:MM:SS'

for key in ${!MY_ARRAY[@]}; do

    cp -b --suffix=_$(date +%Y-%m-%d_%H:%M:%S) ~/$key ${MY_ARRAY[$key]}/${key}-backup-default

done



# REMOVE original 

for file in ${dotfiles[@]}; do
    sudo rm -rf file
done



# FETCH latest custom dotfiles-settings
# - latest backup file is 'XXXX-backup'
# - later version backup file is renamed to 'XXXX-backup_YYYY-MM-DD_HH:MM:SS'

for key in ${!MY_ARRAY[@]}; do

    cd ${MY_ARRAY[$key]}
    cp $key ~/$key
    
done



# COMPLETE

echo Setup is Completed.

