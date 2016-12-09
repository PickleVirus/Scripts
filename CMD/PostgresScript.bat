cd c:\postgresql\bin
If Not Exist "%APPDATA%\postgresql" mkdir %APPDATA%\postgresql
echo|set /p="*:*:*:*:Fgfhnfvtyn2016" > %APPDATA%\postgresql\pgpass.conf
set PGPASSFILE=%APPDATA%\postgresql\pgpass.conf
psql -U postgres -f "\\10.1.0.142\Scripts\GrantAccessSAP.txt"
echo|set /p="" > %APPDATA%\postgresql\pgpass.conf