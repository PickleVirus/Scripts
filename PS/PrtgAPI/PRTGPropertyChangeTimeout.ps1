#### Request for PRTG Id's for futher operations
#### Content variables may be like: sensortree, devices, sensors, tickets, ticketdata, messages, values, channels, reports, storedreports, toplists

$prtgtag = "kld_victoria_shop_server_am"
$prtgcontent = "sensors"

#### GET XML List for futher operations ####

[xml]$xmlrequest = invoke-webrequest "http://10.1.0.142/api/table.xml?content=$prtgcontent&columns=name,objid&output=xml&filter_tags=@tag($prtgtag)&login=gsobolev&password=P@ssw0rd" ### -OutFile C:\Temp\WebRequest.xml - export to file

#### Import from XML [xml]$xmlrequest = get-content C:\Temp\WebRequest.xml - import from xml    
#### Check file type $xmlrequest.GetType().FullName - check filetype


####
#### Primary function module
#### Full list of PRTG manipulation: http://10.1.0.142/api.htm?tabid=6

$dids = $xmlrequest.sensors.item ### Get items from XML
write-host "Total devices: "$dids.Count

#### An exclusion list ####

#$exl = Get-Content U:\Scripts\PS\PrtgAPI\Exclusions.txt

#### Main cycle ####

#### Change by ID iteration ####

foreach($item in $dids){
$id = [int32]$item.objid
$name = $item.Name
write-host $name $id
try {
invoke-webrequest "http://10.1.0.142/api/setobjectproperty.htm?id=$id&name=interval&value=43200&login=gsobolev&password=P@ssw0rd" >$null 2>&1
}
catch{Write-host Where is some errors: $err}
finally{Write-Host Done }
}





