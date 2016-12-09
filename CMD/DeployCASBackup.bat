xcopy \\srv-prtg-msk\Scripts\CASBackup.xml C:\bs\ /Y
xcopy \\srv-prtg-msk\Scripts\CASBKP.bat C:\bs\ /Y
SCHTASKS /create /tn CASBackup /XML C:\bs\CASBackup.xml /RU dixy\backup /RP #Backup%%

