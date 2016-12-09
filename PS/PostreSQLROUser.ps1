$databases = ('set','set_loyal','set_operday')
$role = 'tester'
$password = "Fgfhnfvtyn2016"
$user = 'postgres'
$request = "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';"
$dir = C:\PostgreSQL\8.4\bin
cd "$dir"
foreach($base in $databases){

$tables = (.\psql.exe -d $base -U $user -W Fgfhnfvtyn2016 -c $request)

write-host $tables

}