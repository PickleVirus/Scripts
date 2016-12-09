net stop bits
net stop wuauserv
rem del "c:\Windows\SoftwareDistribution" /Q /S
net start wuauserv
net start bits
wusa \\10.1.0.142\scripts\Windows6.1-KB3135445-x64.msu /quiet /norestart
exit