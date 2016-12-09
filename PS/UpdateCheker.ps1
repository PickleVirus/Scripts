######################
#### Check KB install
####################

$n=0
$i=0
$title



$list = Get-Content U:\KBInstallList.txt
write-host "Всего серверов "$list.Count

foreach ($item in $list){

try{
    
Get-hotfix -id KB3135445 -ComputerName $item -ErrorAction SilentlyContinue 

}


catch{
write-host $item $_.exception.message
}
<#catch [System.Runtime.InteropServices.COMException]{
$n++
}#>
finally{



}
 }
