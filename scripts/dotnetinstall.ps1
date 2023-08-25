#Declare Installing commands

$chocolatey = "Set-ExecutionPolicy Bypass -Scope Process -Force;
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"

Write-Output "------------Automated installation of all the tools-----------"
    Write-Output "Press ENTER and follow the instructions of each installer..."
    #pause
    Write-Output "------------Installing DOTNET THROUGH CHOCOLATEY-----------"
    Invoke-Expression $chocolatey
    exit