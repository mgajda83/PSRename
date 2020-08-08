#Check if autopilot config file exist on workstation
if(Test-Path -Path C:\WINDOWS\ServiceState\wmansvc\AutopilotDDSZTDFile.json) {
	#Get Autopilot profile settings
	$Autopilot = Get-Content C:\WINDOWS\ServiceState\wmansvc\AutopilotDDSZTDFile.json | ConvertFrom-Json

	if($Autopilot.CloudAssignedDeviceName -match $env:COMPUTERNAME) {
		Write-Host "Yupi! Workstation name is correct: $($env:COMPUTERNAME) = $($Autopilot.CloudAssignedDeviceName)"
	}
}
