$Storage_Account = "strprivlab"
$Storage_Container = "content"
$Storage_file = "testfile.txt"
$Output_Path = ".\"
$Sas = ""
$Sas = $Sas.replace("\u0026","&") # replacing json encoding for ambersand character


$Blob_Uri = "https://$Storage_Account.blob.core.windows.net/$Storage_Container/$Storage_file"
$Output_Path = ".\$Storage_file"

$Full_Uri = "$Blob_Uri$Sas"
(New-Object System.Net.WebClient).DownloadFile($Full_Uri, $Output_Path)
