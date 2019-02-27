# My Powershell profile
# cf. https://bit.ly/2txHxQw
# cf. http://d.hatena.ne.jp/pshell/20140428/1398690933

# Cheat sheet:
# - `sal`: Set-Alias

# ########################### Function Inculding Args ################################

# ####### ll #######
function CustomListChildItems { Get-ChildItem $args[0] -force | Sort-Object -Property @{ Expression = 'LastWriteTime'; Descending = $true }, @{ Expression = 'Name'; Ascending = $true } | Format-Table -AutoSize -Property Mode, Length, LastWriteTime, Name }
sal ll CustomListChildItems

# ####### open sudo user window #######
function CustomSudo {Start-Process powershell.exe -Verb runas}
sal sudo CustomSudo

# ####### hosts #######
function CustomHosts {start notepad C:\Windows\System32\drivers\etc\hosts -verb runas}
sal hosts CustomHosts

# ####### update #######
function CustomUpdate {explorer ms-settings:windowsupdate}
sal update CustomUpdate

# ####### docker-machine #######
function CustomStartDockerMachine { docker-machine ls && docker-machine restart default && docker-machine env && & "C:\Program Files\Docker Toolbox\docker-machine.exe" env | Invoke-Expression }
sal start-docker CustomStartDockerMachine

# ####### move to custom RootDIR #######
function CustomRoot {cd "C:\Users\kiai\myDevelopment"}
sal home CustomRoot

# ####### mysql #######
function CustomMySQL {mysql -u root -p}
sal mysql CustomMySQL

# ########################### command Alias ################################

Set-Alias edit "C:\Program Files\Sublime Text 3\sublime_text.exe"

# ########################### temporary Alias ################################

# ####### move to Project root #######
function BubLog_DB_ROOT {cd "C:\Users\kiai\myDevelopment\BugLog_DB"}
sal bld BubLog_DB_ROOT

# ###### home ######
function CustomCdHome {cd "C:\Users\kiai\myDevelopment"}
sal home CustomCdHome

