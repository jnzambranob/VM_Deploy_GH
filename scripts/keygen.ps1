param (
    [Parameter(Mandatory = $true)][string]$kvName,
    [Parameter(Mandatory = $true)][string]$secretName,
    [Parameter(Mandatory = $false)][string]$passsafe,
    [Parameter(Mandatory = $true)][string]$mode
)
Function Get-RandomPassword {
    #define parameters
    param([int]$PasswordLength = 10)
 
    #ASCII Character set for Password
    $CharacterSet = @{
        Uppercase   = (97..122) | Get-Random -Count 10 | % { [char]$_ }
        Lowercase   = (65..90)  | Get-Random -Count 10 | % { [char]$_ }
        Numeric     = (48..57)  | Get-Random -Count 10 | % { [char]$_ }
        SpecialChar = (33,35,36,37,42) + (58,61..64) + (94,95) + (126) | Get-Random -Count 10 | % { [char]$_ }
    }
 
    #Frame Random Password from given character set
    $StringSet = $CharacterSet.Uppercase + $CharacterSet.Lowercase + $CharacterSet.Numeric + $CharacterSet.SpecialChar
 
    -join (Get-Random -Count $PasswordLength -InputObject $StringSet)
}

if ($mode -eq "Getkey") {
    Try {
        Write-Host "Script runned in Getkey mode"
        # Try reaching the DB key in kv
        #Write-Output Reaching kvname: $kvName -- keyname: $secretName
        $pass = Get-AzKeyVaultSecret -VaultName "$kvName" -Name "$secretName" -AsPlainText
        #Write-Host Found secret: $pass
        $cond = [string]::IsNullOrEmpty($pass)
        if (!$cond) {
            Write-Host "Secret found..."
            Write-Host $pass
            Write-Host "^^ This is the actual secret. the encrypted secret will be cached as a variable in the worker"
        }
        else {
            Write-Host "kv found but secret is empty..."
            Write-Host "Generating a new password..."
            $pass = Get-RandomPassword 30
            Write-Host $pass
            Write-Host "^^ This is the generated secret. the encrypted secret will be cached as a variable in the worker"
        }
    }
    Catch {
        # Catch if any error
        Write-Host "An error occurred when reaching the kv, check the issue for debugging!"
        Write-Output "Issue: $($PSItem.ToString())"
        Write-Host "kv or secret not found..."
        Write-Host "Generating a new password..."
        $pass = Get-RandomPassword 30
        Write-Host $pass
        Write-Host "^^ This is the generated secret. the encrypted secret will be cached as a variable in the worker"
    }
    finally {
        # Always execute this to avoid null variable
        #$passsafe = ConvertTo-SecureString -String $pass -AsPlainText -Force
        #Write-Host $pass
        Write-Host "Storing variable in the pipeline enviroment"
        Write-Host "##vso[task.setvariable variable=vmPass]$pass"
    }
}
elseif ($mode -eq "Setkey") {
    try {
        Write-Host "Script runned in Setkey mode"
        $pass = ConvertTo-SecureString -String $passsafe -AsPlainText -Force
        Write-Host "Creating the secret in the keyvault..."
        Set-AzKeyVaultSecret -VaultName "$kvName" -Name "$secretName" -SecretValue $pass
    }
    catch {
        Write-Host "An error occurred when reaching the kv, check the issue for debugging!"
        throw "Issue: $($PSItem.ToString())"
    }
}
else {
    throw "There is an error with the 'mode' parameter, check the syntaxis and try again"
}
