#Create logs
$LogPath = "$($env:ProgramData)\Intune.ScriptLogs\PSRename"
if(!(Test-Path -Path $LogPath)) { New-Item -Path $LogPath -ItemType Directory -Force }

$LogPathTranscript = Join-Path -Path $LogPath -ChildPath Transcript.txt
Start-Transcript -Path $LogPathTranscript -Force

#Check if autopilot config file exist on workstation
if(Test-Path -Path C:\WINDOWS\ServiceState\wmansvc\AutopilotDDSZTDFile.json) {
    #Get Autopilot profile settings
    $Autopilot = Get-Content C:\WINDOWS\ServiceState\wmansvc\AutopilotDDSZTDFile.json -ErrorAction Stop | ConvertFrom-Json

    if([String]$Autopilot.CloudAssignedDeviceName -ne "") {
        #Check if device name not exist in AD. If exist add sufix.
		$i = 0
		do {
			$CloudAssignedDeviceName = $Autopilot.CloudAssignedDeviceName
			if($i -gt 0)
			{
				$CloudAssignedDeviceName += "-$i"
			}
			
			$ADSI = [ADSISearcher]"(&(objectclass=computer)(samaccountname=$CloudAssignedDeviceName$))"
			$ADDevice = $ADSI.FindOne()
			$i++
		}
		while($null -ne $ADDevice)
		
		#Rename computer if different
        if($env:COMPUTERNAME -ne $CloudAssignedDeviceName) {
            Write-Host "Workstation: $($env:COMPUTERNAME) => $CloudAssignedDeviceName"
            try {
                Rename-Computer -NewName $CloudAssignedDeviceName -ErrorAction Stop
                
                & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Save your work."
            }
            catch {
                $_.Exception.Message
            }
        }
    }
}

Stop-Transcript
