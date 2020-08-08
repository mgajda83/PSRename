#Check if autopilot config file exist on workstation
if(Test-Path -Path C:\WINDOWS\ServiceState\wmansvc\AutopilotDDSZTDFile.json) {
	#Get Autopilot profile settings
	$Autopilot = Get-Content C:\WINDOWS\ServiceState\wmansvc\AutopilotDDSZTDFile.json | ConvertFrom-Json

	#Check if current name match profile name
	if($env:COMPUTERNAME -eq $Autopilot.CloudAssignedDeviceName) {
		Write-Host "Yupi! Workstation name is correct: $($env:COMPUTERNAME) = $($Autopilot.CloudAssignedDeviceName)"
	} else {
		#Check if current name match profile name with prefix or it wait for reboot
		$AppDeviceName = Get-Content "$($env:ProgramData)\Intune.ScriptLogs\PSRename\DeviceNane.tag" -ErrorAction SilentlyContinue
		
		if($AppDeviceName -like "$($Autopilot.CloudAssignedDeviceName)*")
		{
			Write-Host "Yupi! Workstation name seems correct: $AppDeviceName = $($Autopilot.CloudAssignedDeviceName)*"
		}
	}
}
