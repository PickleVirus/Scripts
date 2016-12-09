######################
#### Check KB install
####################

$n=0
$i=0
try{

$list = Get-Content U:\KBInstallList.txt
write-host "Всего серверов "$list.Count
foreach ($item in $list){

get-hotfix -id KB3135445 -ComputerName $item -ErrorAction SilentlyContinue
$item | Out-File C:\Temp\HotFix.txt -Append

}

}
catch [Microsoft.PowerShell.Commands.GetHotFixCommand]{
$i++
}
catch [System.Runtime.InteropServices.COMException]{
$n++
}
finally{
write-host "Complited with $i machines haven't install hotfix yet."
write-host "$n machines unavailable"
}