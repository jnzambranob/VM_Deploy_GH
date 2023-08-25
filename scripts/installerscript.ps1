#Declare Installing commands

$chocolatey = "Set-ExecutionPolicy Bypass -Scope Process -Force;
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
$git = "choco install git -y"
$vscode = "choco install vscode -y"
$java = "choco install jre8 -y"
$node = 'choco install nodejs-lts -y'
$office = "choco install microsoft-office-deployment --version 16.0.16626.20148 -y"
#GIT Credentials
$name = "Arroyo Consulting DEV"
$Email = "developer@arroyoconsulting.net"

Write-Output "------------Automated installation of all the tools-----------"
    Write-Output "Press ENTER and follow the instructions of each installer..."
    #pause
    Write-Output "------------Installing Chocolatey-----------"
    Invoke-Expression $chocolatey
    #pause
    Write-Output "------------Installing OFFICE 2019-----------"
    Invoke-Expression $office
    Write-Output "FINISHED!"
    #pause
    Write-Output "------------Installing NODE-----------"
    Invoke-Expression $node
    Write-Output "FINISHED!"
    #pause
    Write-Output "------------Installing JAVA-----------"
    Invoke-Expression $java
    Write-Output "FINISHED!"
    #pause
    Write-Output "------------Installing VISUAL STUDIO CODE-----------"
    Invoke-Expression $vscode
    Write-Output "FINISHED!"
    #pause
    Write-Output "------------Installing GIT-----------"
    Invoke-Expression $git
    Write-Output "FINISHED!"
    #pause
    #restart powershell
    Write-Output "UPDATING PATH WITH NEW PROGRAMS INSTALLED..."
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    Write-Output "FINISHED!"

    "------------Configuring GIT-----------"
    Write-Output "CONFIGURING GIT WITH THE PROVIDED PARAMS"
    $gitconf = "git config --global --replace user.name " + "`"$Name`"" + "
    git config --global user.email " + "$Email" + "
    git config --global core.longpaths true"
    Invoke-Expression $gitconf
    Write-Output "------------INSTALLATION FINISHED!-----------"
    exit