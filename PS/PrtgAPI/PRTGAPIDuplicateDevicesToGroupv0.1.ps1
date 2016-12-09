###  Enter filter tag(s) to filter devices
$prtgtag = "msk_victoria_shop_server"
###  Comment if unneeded
$dplobjid = 79012 ### enter object to dublicate
$dplname = "CL-Mart Backup CAS file"
$dplname = $dplname -replace " ", "%20"
$dplgroup = "23607", "74248"
$exclusion = "Victoria 01", "Victoria 02", "Victoria 03", "Victoria 04", "Victoria 06", "Victoria 07", "Victoria 08", "Victoria 09"
##########################
#                        #
#    Duplicating Module  #
#                        #
##########################

foreach ($probe in $dplgroup){
    ### Request for PRTG Id's for futher operations
    ### Content variables may be like: sensortree, devices, sensors, tickets, ticketdata, messages, values, channels, reports, storedreports, toplists
    $prtgcontent = "groups"
    [xml]$xmlrequest = invoke-webrequest "http://10.1.0.142/api/table.xml?content=groups&output=xml&columns=objid,group&count=500&id=$probe&login=gsobolev&password=P@ssw0rd"
    ### Import from XML [xml]$xmlrequest = get-content C:\Temp\WebRequest.xml - import from xml
    ### Check file type $xmlrequest.GetType().FullName - check filetype
    foreach ($item in $xmlrequest.groups.item){

        if ($item.group -like "Victoria*") {

            $shop = $item.group

        }
        elseif($item.group -like "Devices" -and $exclusion -notcontains $shop){

            $device = "$shop KTT"
            $group = [int]$item.objid
            $outstring =  "Device " + $group
            $ip = [int]$shop.Trim("Victoria")
            $ip = "10.81.$ip.239"
            write-host $outstring
            write-host $device
            write-host $ip
            $devicename = $device -replace " ", "%20" 
            invoke-webrequest "http://10.1.0.142/api/duplicateobject.htm?id=80632&name=$devicename&host=$ip&targetid=$group&login=gsobolev&password=P@ssw0rd"
            write-host "$Device duplicated successfuly"
        }            
            }
                }