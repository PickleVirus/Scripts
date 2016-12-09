NET USE \\10.1.0.142\c$ /USER:dixy\backup #Backup%%
xcopy \\10.1.0.142\c$\usr\BackupSlip E:\bkpsrv\BackupSlip /e /y
SCHTASKS /create /tn copy_slip /XML E:\bkpsrv\BackupSlip\back_slip.xml /RU dixy\backup /RP #Backup%%
exit

