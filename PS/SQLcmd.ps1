cd C:\Users\gasobolev\Documents\SQLScripts\JobReplacement
### Import Module ###
$import = get-content -Path SQLJobTemplate.txt
$shops = get-content shops.txt
### Import Module ###
foreach ($shop in $shops){

$server = "10.81."+$shop + ".5"
$dest = "10.81."+$shop + ".4"
$server
$output = $import -replace "server!", "$dest" > "C:\Users\gasobolev\Documents\SQLScripts\JobReplacement\JobQuery.sql"
Invoke-Sqlcmd -ServerInstance $server -InputFile "C:\Users\gasobolev\Documents\SQLScripts\JobReplacement\JobQuery.sql" -QueryTimeout 5 -ConnectionTimeout 5
}
