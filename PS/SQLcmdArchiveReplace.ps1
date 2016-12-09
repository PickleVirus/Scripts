cd C:\Users\gasobolev\Documents\SQLScripts\JobReplacement
### Import Module ###
$shops = get-content shops.txt
### Import Module ###
foreach ($shop in $shops){

$server = "10.81."+$shop + ".5"
Invoke-Sqlcmd -ServerInstance $server -InputFile "C:\Users\gasobolev\Documents\SQLScripts\JobReplacement\JobQueryArchiveReplace.sql"
}
