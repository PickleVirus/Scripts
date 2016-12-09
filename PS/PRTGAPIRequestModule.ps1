[xml]$xmlrequest = invoke-webrequest "http://10.1.0.142/api/table.xml?content=devices&columns=objid,name&output=xml&filter_tags=@tag(msk_victoria_shop_server_main)&login=gsobolev&password=P@ssw0rd" ### -OutFile C:\Temp\WebRequest.xml - export to file
###[xml]$xmlrequest = get-content C:\Temp\WebRequest.xml - import from xml
### $xmlrequest.GetType().FullName - check filetype
$items = $xmlrequest.devices.item
### 
foreach($id in $items){
$id = [string]$id.objid
### tryin' to make an exclusion list
[xml]$web = invoke-webrequest http://10.1.0.142/api/getobjectstatus.htm?id=$id"&"name=name"&"show=text"&"login=gsobolev"&"password=P@ssw0rd
$name = $web.prtg.result.a.'#text'.ToString()
$name = $name.trim() ### triming characters 
$exl = "OFFICE Altufevo main server", "Fabric Kitchen main server", "Chernaya gryaz shop server"
##if ($name -notlike "Chernaya Gryaz shop server" -and $name -notlike "Fabric Kitchen main server" -and $name -notlike "Victoria 09 cso server" ){ 
if ($exl -notcontains $name){

$name  ### operation

}
}