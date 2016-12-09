### Input ###
### Variables ###
### Module ###

### Enter filter tag(s) to filter devices ###
###  Comment if unneeded
$dplobjid = 68833 ### enter object to dublicate
$dplgroup = "23607"
$exclusion = "Victoria 02 server","Kvartal 02 server"
$inclusion = "Victoria 22","Victoria 25", "Victoria 34", "Victoria 35", "Victoria 36", "Victoria 38", "Victoria 39", "Victoria 41", 
"Victoria 42", "Victoria 44", "Victoria 45", "Victoria 51", "Victoria 26", "Victoria 29", "Victoria 30", "Victoria 31", "Victoria 32", "Victoria 11"
$vendor = "HP","IBM"
$dplname = "SQL Server Backup SES file (Query)"
$dplname = $dplname -replace " ", "%20"
$shoplist = @{}

#### Create XML if needed #############
# Create a new XML File with config root node
<####
# Create a new XML File with config root node
[System.XML.XMLDocument]$oXMLDocument=New-Object System.XML.XMLDocument
# New Node
[System.XML.XMLElement]$oXMLRoot=$oXMLDocument.CreateElement("Shops")
# Append as child to an existing node
$oXMLDocument.appendChild($oXMLRoot)
####>


##########################
#                        #
#    Duplicating Module  #
#                        #
##########################
$a = 0
foreach ($probe in $dplgroup){
    ### Request for PRTG Id's for futher operations
    ### Content variables may be like: sensortree, devices, sensors, tickets, ticketdata, messages, values, channels, reports, storedreports, toplists
    $prtgcontent = "groups"
    [xml]$xmlrequest = invoke-webrequest "http://10.1.0.142/api/table.xml?content=groups&output=xml&columns=objid,group&count=500&id=$probe&login=gsobolev&password=P@ssw0rd"
    ### Import from XML [xml]$xmlrequest = get-content C:\Temp\WebRequest.xml - import from xml
    ### Check file type $xmlrequest.GetType().FullName - check filetype
    
    foreach ($item in $xmlrequest.groups.item){
     
        if ($inclusion -contains $item.group ) {
            ###$shop = $item.group
            ###write-host $shop
            $shopid = $item.objid
            #$item.group
            #$shopid
            ###write-host "Shop object ID $shopid"
            $xmlservers = [xml](invoke-webrequest "http://10.1.0.142/api/table.xml?content=devices&output=xml&columns=objid,name&count=500&id=$shopid&login=gsobolev&password=P@ssw0rd") 
            foreach($device in $xmlservers.devices.item){if ($device.name -like "*main server" -and $device.name -notlike "*IBM*" -and $device.name -notlike "*HP*" ){
            $a += 1
            $devid = $device.objid           
            write-host Server: $device.name DeviceID: $device.objid
            try {invoke-webrequest "http://10.1.0.142/api/duplicateobject.htm?id=$dplobjid&name=$dplname&targetid=$devid&login=gsobolev&password=P@ssw0rd" >$null 2>&1}
            catch {write-host Where is some errors}
            finally{write-host Cloned}
            }
            
                }
           
            }
              
                }
                 
                    }
                     write-host $a

#$xmlservers.devices
					
<##
foreach ($item in $shoplist.keys) {

$ip = "10.39."+[int]$item.Trim("Victoria ")+".239"
$devicename = "$item KTT" 
### Release trigger ### invoke-webrequest "http://10.1.0.142/api/duplicateobject.htm?id=$dplobjid&name=$dplname&targetid=$id&login=gsobolev&password=P@ssw0rd" >$null 2>&1
write-host "$devicename with IP $ip duplicated successfully"

}
##>