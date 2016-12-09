$datetime = Get-Date
$servername = get-childitem -path env:computername 
$servername = $servername.Value -replace "-1", "-0"
#If c:\tt doesn't exist then test c:UTM
if (!(Test-Path -path c:\tt)) {
    #If c:\UTM doesn't exist then write error message
    if (!(Test-Path -path c:\UTM)){
        add-content -Value "$datetime $servername UTM Directory doesn't exists" -path "\\$servername\e$\UTMBackup\backerror.log" 
        }
    #If c:\UTM exists then, do backup
    else {
    del "\\$servername\e$\UTMBackup\UTMBackup3.bak"
    ren "\\$servername\e$\UTMBackup\UTMBackup2.bak" "\\$servername\e$\UTMBackup\UTMBackup3.bak"
    ren "\\$servername\e$\UTMBackup\UTMBackup1.bak" "\\$servername\e$\UTMBackup\UTMBackup2.bak"
    c:\Program Files\7-Zip\7z.exe "c:\UTM" "c:\UTM\UTMBackup1.bak"
    xcopy "c:\UTM\UTMBackup1.bak" "\\$servername\e$\UTMBackup\UTMBackup1.bak"}
        }
#If c:\TT exists, do backup
else {
    del "\\$servername\e$\UTMBackup\UTMBackup3.bak"
    ren "\\$servername\e$\UTMBackup\UTMBackup2.bak" "\\$servername\e$\UTMBackup\UTMBackup3.bak"
    ren "\\$servername\e$\UTMBackup\UTMBackup1.bak" "\\$servername\e$\UTMBackup\UTMBackup2.bak"
    c:\Program Files\7-Zip\7z.exe  "c:\TT" "c:\TT\UTMBackup1.bak"
    xcopy "c:\TT\UTMBackup1.bak" "\\$servername\e$\UTMBackup\UTMBackup1.bak"}
