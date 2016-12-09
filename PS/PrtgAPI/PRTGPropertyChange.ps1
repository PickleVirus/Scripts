#### Request for PRTG Id's for futher operations
#### Content variables may be like: sensortree, devices, sensors, tickets, ticketdata, messages, values, channels, reports, storedreports, toplists

$prtgtag = "msk_victoria_shop_dmvpn_enforta"
$prtgcontent = "sensors"

#### GET XML List for futher operations ####

[xml]$xmlrequest = invoke-webrequest "http://10.1.0.142/api/table.xml?content=$prtgcontent&columns=device,parentid&output=xml&filter_tags=@tag($prtgtag)&login=gsobolev&password=P@ssw0rd" ### -OutFile C:\Temp\WebRequest.xml - export to file

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
$id = [int32]$item.parentid
[xml]$xmlrequest = invoke-webrequest "http://10.1.0.142/api/table.xml?content=sensors&columns=objid,tags&output=xml&id=$id&login=gsobolev&password=P@ssw0rd" 
    $list = $xmlrequest.sensors.item
    foreach($obj in $list){
    
#### Property change Filter ####

    if ($obj.tags -notlike "*msk_victoria_shop_dmvpn_enforta*"){
        $oid = [int32]$obj.objid
        
#### Property change with conditions #####
        
        if ($item.device -like "*main*"){
            invoke-webrequest "http://10.1.0.142/api/setobjectproperty.htm?id=$oid&name=tags&value=msk_victoria_shop_wan,msk_victoria_shop_wan_enforta_helpdesk&login=gsobolev&password=P@ssw0rd"
            }
        elseif($item.device -like "*reserve*"){
            invoke-webrequest "http://10.1.0.142/api/setobjectproperty.htm?id=$oid&name=tags&value=msk_victoria_shop_wan_reserve,msk_victoria_shop_wan_enforta_helpdesk&login=gsobolev&password=P@ssw0rd"
                }
    }
    
    }    
}




