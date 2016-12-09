###  Enter filter tag(s) to filter devices
$prtgtag = "msk_victoria_shop_server_reserve"
###  Comment if unneeded
$dplobjid = 79012 ### enter object to dublicate
$dplname = "CL-Mart Backup CAS file"
$dplname = $dplname -replace " ", "%20"
### Request for PRTG Id's for futher operations
### Content variables may be like: sensortree, devices, sensors, tickets, ticketdata, messages, values, channels, reports, storedreports, toplists
$prtgcontent = "devices"
[xml]$xmlrequest = invoke-webrequest "http://10.1.0.142/api/table.xml?content=$prtgcontent&columns=objid,name&output=xml&filter_tags=@tag($prtgtag)&login=gsobolev&password=P@ssw0rd" ### -OutFile C:\Temp\WebRequest.xml - export to file
### Import from XML [xml]$xmlrequest = get-content C:\Temp\WebRequest.xml - import from xml
### Check file type $xmlrequest.GetType().FullName - check filetype


###
### Primary function module
### Full list of PRTG manipulation: http://10.1.0.142/api.htm?tabid=6

$items = $xmlrequest.devices.item ### Get items from XML
### an exclusion list
$exl = Get-Content U:\Scripts\PS\PrtgAPI\Exclusions.txt
### Main cycle
foreach($item in $items){

$name = $item.name
$id = [int32]$item.objid
$name = $name.trim() ### triming characters 


### exclusion check
if ($exl -notcontains $name){
### primary function with invoke-webrequest, of $name for check list of items
invoke-webrequest "http://10.1.0.142/api/duplicateobject.htm?id=$dplobjid&name=$dplname&targetid=$id&login=gsobolev&password=P@ssw0rd" >$null 2>&1



### error handler
if ($?){
write-host $name  " cloned successfully"
} else {
write-host $name  " execution error"
}

}
}
###
### End of primary function
###