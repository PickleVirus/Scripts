net stop bits
net stop wuauserv
del "c:\Windows\SoftwareDistribution" /Q /S
net start wuauserv
net start bits
exit