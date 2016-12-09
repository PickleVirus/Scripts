### import modules
import-module ActiveDirectory

###vars
$serverlistad = $null
$outfile = "U:\Documents\ServersMSKVendorList.csv"
$outstring = $null
$counter = 0
$notlike = "*XX*","*yy*"
$searchbase = "OU=Servers,OU=VShops,OU=MSK,DC=Dixy,DC=Local"
$filter = "(name -like 'srv-vt*-0' -or name -like 'srv-vt*-1')"
$vendorlist = @()
$object = New-Object -TypeName PSObject
###Function get ADObjects

$serverlistad = Get-ADComputer -Filter $filter -SearchBase $searchbase

###Output List
write-host Where are $serverlistad.Count servers in a list
write-host Getting servers information ....

###Function get vendor info
foreach($item in $serverlistad){

write-host Getting $item.Name info
$wmiobject = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $item.Name
$vendorlist += $wmiobject
}

###Export CSV
$vendorlist | Select-Object Name, Manufacturer, Model, NumberOfLogicalProcessors, NumberOfProcessors, SystemType, TotalPhysicalMemory | Export-Csv -Path U:\Documents\VendorList.csv