$azcli = "Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; Remove-Item .\AzureCLI.msi"
$adext = "az vm extension set --publisher Microsoft.Azure.ActiveDirectory --name AADLoginForWindows --resource-group $(ResourceGroup) --vm-name $(vmName)'"

Write-Output "------------Automated installation of all the tools-----------"
    Write-Output "Auto install Enabled"
    #pause
    Write-Output "------------Installing AZ CLI-----------"
    Invoke-Expression $azcli
    Write-Output "UPDATING PATH WITH NEW PROGRAMS INSTALLED..."
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    Write-Output "------------Installing AZ AD Extension-----------"
    Invoke-Expression $adext
    exit