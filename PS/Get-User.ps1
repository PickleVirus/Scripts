
Get-ADUser -Filter {(emailaddress -like '*victoria-group.ru')} -SearchBase "OU=Users,OU=VShops,OU=MSK,DC=Dixy,DC=local" -Properties * | Select-Object name, emailaddress, title | Export-Csv -Path "C:\Lists\UsersForSDO.csv" -Encoding Unicode
#Export-Csv -Path "C:\Lists\UsersForSDO.csv"

