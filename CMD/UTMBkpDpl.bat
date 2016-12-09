xcopy /y "\\srv-prtg-msk\Scripts\UTMBackup.ps1" "c:\windows\system32"
xcopy /y "\\srv-prtg-msk\Scripts\BackupUTM.xml" "c:\windows"
SCHTASKS /create /tn BackupUTM /XML c:\windows\BackupUTM.xml /RU dixy\backup /RP #Backup%%
del "c:\windows\BackupUTM.xml"
del "c:\windows\UTMBkpDpl.bat"
