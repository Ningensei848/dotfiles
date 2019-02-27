# cf. http://d.hatena.ne.jp/pshell/20140428/1398690933
# cf. https://qiita.com/mu_sette/items/3954759daee8ae9ad26f

# alias Including args

# ###### `ll` ######
function CustomListChildItems { Get-ChildItem $args[0] -force | Sort-Object -Property @{ Expression = 'LastWriteTime'; Descending = $true }, @{ Expression = 'Name'; Ascending = $true } | Format-Table -AutoSize -Property Mode, Length, LastWriteTime, Name }
sal ll CustomListChildItems

# ###### `sudo` ######
function CustomSudo {Start-Process powershell.exe -Verb runas}
sal sudo CustomSudo

# ###### `hosts` ######
function CustomHosts {start notepad C:\Windows\System32\drivers\etc\hosts -verb runas}
sal hosts CustomHosts

# ###### `update` ######
function CustomUpdate {explorer ms-settings:windowsupdate}
sal update CustomUpdate

# ###### `mysql` ######
function CustomMySQL {mysql -u root -p}
sal mysql CustomMySQL

# ###### `home` ######
function CustomCdHome {cd "C:\Users\kiai\myDevelopment"}
sal home CustomCdHome




# defined new alias

Set-Alias edit "C:\Program Files\Sublime Text 3\sublime_text.exe"
