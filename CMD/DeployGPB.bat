NET USE \\10.177.0.205\E$ /USER:SlipBackup $SlipBackup$
xcopy \\10.177.0.205\E$\BKP\dbbackup C:\dbbackup\ /e /y
start C:\dbbackup\vcredist_x86.exe /q
start C:\dbbackup\7z920-x64.msi /quiet
SCHTASKS /create /tn slip_bkp /XML C:\dbbackup\SlipTask.xml /RU admin /RP 123
start "Telnet-server starting"/wait pkgmgr /iu:"TelnetServer"
sc config tlntsvr start= auto
net start tlntsvr
net localgroup "TelnetClients" Admin /add
net localgroup "TelnetClients" Operator /add