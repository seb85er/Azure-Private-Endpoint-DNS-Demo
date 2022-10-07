#Download via URI using SAS
$Storage_Account = "strprivlab"
$Resource_Group_Name = "rg-pe-spoke"
$Storage_Container = "content"
$Storage_file = "testfile.txt"
$Sub_Name = ""
$Tenant_Id = ""
$Output_Path = ".\"

#Check Az module
$Module_Check_Az = Get-InstalledModule -name Az  -ErrorAction SilentlyContinue 
if($Module_Check_Az) {
    write-host "Azure AD module is already installed."
}
else {
    install-module -name Az -force -repository "PSGallery" -ErrorAction SilentlyContinue 
    Import-Module -name Az -Force -ErrorAction SilentlyContinue
}   

$Current_Context = Get-AzContext

if ($Current_Context.Subscription.Name -eq $Sub_Name ) {
    Write-Output "Correct subscription $Sub_Name "
}  
else {
    $Current_Context = get-AzSubscription -SubscriptionName $Sub_Name -TenantId $Tenant_Id | Set-AzContext -ErrorAction Stop
    if ($null -eq $Current_Context) {
        Write-Error "Error selecting subscription please run login-azaccount"
    }
}


$Context = (Get-AzStorageAccount -ResourceGroupName $Resource_Group_Name -AccountName $Storage_Account).context
$SAS = New-AzStorageAccountSASToken -Context $Context -Service Blob,File,Table,Queue -ResourceType Service,Container,Object -Permission racwdlup

$Blob_Uri = "https://$Storage_Account.blob.core.windows.net/$Storage_Container/$Storage_file"
$Output_Path = ".\$Storage_file"

$Full_Uri = "$Blob_Uri$Sas"
(New-Object System.Net.WebClient).DownloadFile($Full_Uri, $Output_Path)






#wget -o testfile.txt https://strprivlab.blob.core.windows.net/content/testfile.txt #cleanse
