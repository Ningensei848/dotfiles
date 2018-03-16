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

# TARGET dotfiles : セットアップしたい設定ファイル名を選択# - you can add more dotfiles

dotfiles=(.bashrc .bash_profile .viminfo) # please add more VAR(dotfile)

varName=()                                # initialize empty list : 配列の初期化 
dot_removed=() 
declare -A MY_ARRAY # 連想配列だから宣言しないと使えない


# MOVE to ROOT : root DIRに移動

cd ~



# PREPARE setup

LATEST_BACKUP_=`echo LATEST_BACKUP_`

for file in ${dotfiles[@]}; do

    suffix=`echo ${file#*.}`                  # Remove '.' from filename
    dot_removed+=($suffix) 
    combination=`echo $LATEST_BACKUP_$suffix` # Create new str: LATEST_BACKUP_XXXX
    varName+=($combination)                   # to Redefine the variable name to reuse it later
    targetDir=`echo ~/dotfiles/backups-$suffix`
    MY_ARRAY[$file]=$targetDir                # Add dictionary abject
    echo ${MY_ARRAY[$file]}
done


for file in ${dotfiles[@]}; do

    if [ -e $file ]; then
        echo $file found.                 # file Existed : ファイルが存在する場合
    else
        echo -n > $file                   # if NOT Existed, make NEW file : ファイルが存在しない場合
    fi

done

# comment out area
: << '#__COMMENT_OUT__'
for str in ${dot_removed[@]}; do

    targetDir=`echo ~/dotfiles/backups-$str`
    if [ -e $targetDir ]; then 
        echo $targetDir found.            # dirctory Existed : ディレクトリが存在する場合
    else
        mkdir $targetDir                  # if NOT Existed, make NEW dir : ディレクトリが存在しない場合
    fi

done
#__COMMENT_OUT__


for key in ${!MY_ARRAY[@]}; do

    if [ -e ${MY_ARRAY[$key]} ]; then
        echo ${MY_ARRAY[$key]} found.            # dirctory Existed : ディレクトリが存在する場合
    else
        
        mkdir ${MY_ARRAY[$key]}                  # if NOT Existed, make NEW dir : ディレクトリが存在しない場合
    fi

done


# BACKUP to Dotfies DIR : バックアップを専用フォルダにコピーして保存
# - latest backup file is 'XXXX-backup'
# - later version backup file is renamed to 'XXXX-backup_YYYY-MM-DD_HH:MM:SS'

for key in ${!MY_ARRAY[@]}; do

    sudo cp -b --suffix=_$(date +%Y-%m-%d_%H:%M:%S) ~/$key ${MY_ARRAY[$key]}/${key}-backup

done

# comment out area
: << '#__COMMENT_OUT__'
sudo cp -b --suffix=_$(date +%Y-%m-%d_%H:%M:%S) ~/.bashrc ~/dotfiles/backups-bashrc/bashrc-backup 
sudo cp -b --suffix=_$(date +%Y-%m-%d_%H:%M:%S) ~/.bash_profile ~/dotfiles/backups-bashprofile/bashprofile-backup
sudo cp -b --suffix=_$(date +%Y-%m-%d_%H:%M:%S) ~/.viminfo ~/dotfiles/backups-viminfo/viminfo-backup
#__COMMENT_OUT__



# REMOVE original 

for file in ${dotfiles[@]}; do
    rm -rf file
done



# FETCH latest custom dotfiles-settings
# - latest backup file is 'XXXX-backup'
# - later version backup file is renamed to 'XXXX-backup_YYYY-MM-DD_HH:MM:SS'

for key in ${!MY_ARRAY[@]}; do

    cd ${MY_ARRAY[$key]}
    targetFile=`ls -1t | head -1`
    mv $targetDir/$targetFile ~/$key
    
done



# COMPLETE

echo Setup is Completed.





