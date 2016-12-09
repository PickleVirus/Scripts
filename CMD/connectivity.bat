set %ip=%1
FOR /F %i IN ('ping -n 1 %IP ^| find /i /c "получено = 1"') DO set var=%i
IF %var% >= 1 ECHO "Connection established"


