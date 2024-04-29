 # My Powershell profile
 # cf. https://bit.ly/2txHxQw
 # cf. http://d.hatena.ne.jp/pshell/20140428/1398690933
 # cf. https://qiita.com/kkdd/items/ac6e65f6e2e8fc32e7ca (proxy, env)
 # cf. https://bit.ly/2T7fbMn (reuse powershell Scripts)


 # ######################### System Enviroment Variable ################################
 # システム情報を取得し、「計算機の名前+現在のユーザ名」を取得し、ユーザ名だけを切り出す
 $localuser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.Split("\")[1]

 if (Test-Path "C:\Users\$($localuser)\Documents\WindowsPowerShell\ProxyEnviromentConfig.ps1") {

     . "C:\Users\$($localuser)\Documents\WindowsPowerShell\ProxyEnviromentConfig.ps1"
     }

# Cheat sheet:
# - `sal`: Set-Alias

# ########################### Function Inculding Args ################################

# ####### ll #######
function CustomListChildItems { Get-ChildItem $args[0] -force | Sort-Object -Property @{ Expression = 'LastWriteTime'; Descending = $true }, @{ Expression = 'Name'; Ascending = $true } | Format-Table -AutoSize -Property Mode, Length, LastWriteTime, Name }
sal ll CustomListChildItems

# ####### open sudo user window #######
function CustomSudo {Start-Process powershell.exe -Verb runas}
sal sudo CustomSudo

# ####### update #######
function CustomUpdate {explorer ms-settings:windowsupdate}
sal update CustomUpdate

# ####### move to custom RootDIR #######
function CustomRoot {cd "C:\Users\kiai\Dev"}
sal home CustomRoot

