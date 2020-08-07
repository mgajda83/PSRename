#Check if autopilot config file exist on workstation
$goodToGo = $true
if(Test-Path -Path C:\WINDOWS\ServiceState\wmansvc\AutopilotDDSZTDFile.json) {
	#Get Autopilot profile settings
    $Autopilot = Get-Content C:\WINDOWS\ServiceState\wmansvc\AutopilotDDSZTDFile.json | ConvertFrom-Json
        
    #Check device name exist
    if($null -ne $Autopilot.CloudAssignedDeviceName) {
		Write-Host "No device name"
        $goodToGo = $true
    }
}

#Check domain joined
$details = Get-ComputerInfo
if (-not $details.CsPartOfDomain)
{
    Write-Host "Not part of a domain."
    $goodToGo = $false
}

#Check connection to DC
$dcInfo = [ADSI]"LDAP://RootDSE"
if ($dcInfo.dnsHostName -eq $null) {
    $goodToGo = $false
}

#If domain joined device name exist and DC is available then run app
if($goodToGo) {
        $true
} else {
        $false
}