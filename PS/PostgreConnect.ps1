param(
[array]$h,
[string]$f,
[string]$d,
[string]$u,
[string]$c,
[string]$q
)

####INIT###
	chcp 1251
$servers = @()

####DEFINITIONS####

if ($h){$servers += $h}
if ($f){$servers += Get-Content $f}

###########################
####EXECUTE####POSTGRES####
###########################

if (!$u){write-host "Default user is postgres `n"}
else{ write-host "User is $u `n"}

if($servers){

    foreach($server in $servers) {
        

        [string]$command = "psql -h " + $server

        if($d){$command += " -d $d"}else{$command += " -d postgres"} 

        if($u){$command += " -U $u"}else{$command += " -U postgres"}
 
        if($c){$command += " -c '$c'" }
		
        elseif($q){$command += " -f $q"}
        
		else{$command += " -c '\du'"}
        		
        $command += " -w"

        write-host "SQL INSTANCE $server `n"
        Invoke-Expression $command

        }
    }
else{write-host "No host IP was given"}
	chcp 866