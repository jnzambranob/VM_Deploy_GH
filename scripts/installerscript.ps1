#Declare Installing commands

$chocolatey = "Set-ExecutionPolicy Bypass -Scope Process -Force;
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
$git = "choco install git -y"
$vscode = "choco install vscode -y"
$java = "choco install jre8 -y"
$node = 'choco install nodejs-lts -y'

#GIT Credentials
$name = "Arroyo Consulting DEV"
$Email = "developer@arroyoconsulting.net"

Write-Output "------------Automated installation of all the tools-----------"
    Write-Output "Press ENTER and follow the instructions of each installer..."
    #pause
    Write-Output "------------Installing Chocolatey-----------"
    Invoke-Expression $chocolatey
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
    Write-Output "------------Setting up WinRM Cert and Rules-----------"
    Enable-PSRemoting -Force
    New-NetFirewallRule -Name "Allow WinRM HTTPS" -DisplayName "WinRM HTTPS" -Enabled True -Profile Any -Action Allow -Direction Inbound -LocalPort 5986 -Protocol TCP
    $thumbprint = (New-SelfSignedCertificate -DnsName $env:COMPUTERNAME -CertStoreLocation Cert:\LocalMachine\My).Thumbprint
    $command = "winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname=""$env:computername""; CertificateThumbprint=""$thumbprint""}"
    cmd.exe /C $command
    Write-Output "------------Installation Finished!-----------"
    exit