$URI = "http://10.39.78.5:8090/SET-ERPIntegration/FiscalInfoExport?wsdl"
[xml]$result = (iwr $URI –infile C:\Scripts\PS\xmlinit.xml –contentType "text/xml" –method POST)
$base = $result.Envelope.Body.getPurchasesByOperDayResponse.return.ToString()
$DecodedText = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($base))
[xml]$resultXML = $DecodedText
$resultXML.GetType()