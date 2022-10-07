$Domain = "privdnslab.co.uk"
$Net_Bios_Name = "privdnslab"
$secureSafeModePassword=(ConvertTo-SecureString "SafePass1!" -AsPlainText -Force)


try {
    Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
} catch {
    Write-Output "failed Install-WindowsFeature AD-Domain-Services -IncludeManagementTools"
}

try {
Import-Module ADDSDeployment
Install-ADDSForest `
 -DomainMode "Win2012R2" `
 -DomainName $Domain `
 -DomainNetbiosName $Net_Bios_Name  `
 -ForestMode "Win2012R2" `
 -InstallDns:$true `
 -LogPath "C:\Windows\NTDS" `
 -NoRebootOnCompletion:$true `
 -SysvolPath "C:\Windows\SYSVOL" `
 -SafeModeAdministratorPassword $secureSafeModePassword `
 -Force:$true
} catch {
    Write-Output "Promotion failed"
}

 Write-Output %errorlevel%
 Write-Output $LASTEXITCODE
 Restart-Computer -Force
 exit 1003
