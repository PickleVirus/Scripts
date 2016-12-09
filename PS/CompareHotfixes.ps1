function hotfixcompare ($computer1, $computer2)
{
$node1 = Get-HotFix -ComputerName $computer1
Write-Host $computer1 $node1
$node2 = Get-HotFix -ComputerName $computer2
Write-Host $computer2 $node2
Compare-Object -ReferenceObject $node1 -DifferenceObject $node2  -Property HotFixID
}
hotfixcompare VT77004-117 VT39005-21|sort -Property sideindicator