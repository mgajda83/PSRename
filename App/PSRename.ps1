[CmdletBinding()]
param (
    [Parameter()]
    [Switch]
    $Strict
)

#Create logs
$LogPath = "$($env:ProgramData)\Intune.ScriptLogs\PSRename"
if(!(Test-Path -Path $LogPath)) { New-Item -Path $LogPath -ItemType Directory -Force }

$LogPathTranscript = Join-Path -Path $LogPath -ChildPath Transcript.txt
Start-Transcript -Path $LogPathTranscript -Force

#Check if autopilot config file exist on workstation
if(Test-Path -Path C:\WINDOWS\ServiceState\wmansvc\AutopilotDDSZTDFile.json) {
    #Get Autopilot profile settings
    $Autopilot = Get-Content C:\WINDOWS\ServiceState\wmansvc\AutopilotDDSZTDFile.json -ErrorAction Stop | ConvertFrom-Json

	#Check if device name exist in profile
    if([String]$Autopilot.CloudAssignedDeviceName -ne "") {
        $doIt = $false

        #Check if it first run
        if(!(Test-Path -Path "$($env:ProgramData)\Intune.ScriptLogs\PSRename\DeviceName.tag")) {
            #Check if current name is correct
            if($env:COMPUTERNAME -ne $Autopilot.CloudAssignedDeviceName) {
                $doIt = $true

                #Strict mode will use exact device name from profile. If device name will exist in AD, it return error.
                if($Strict) {
                    $CloudAssignedDeviceName = $Autopilot.CloudAssignedDeviceName
                } else {
                    #If it first run check device name not exist in AD. If exist add sufix.
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
                }
            } 
        } else {
            #Get first run device name
            $CloudAssignedDeviceName = Get-Content -Path "$($env:ProgramData)\Intune.ScriptLogs\PSRename\DeviceName.tag"

            #Check if current name is different then first run name
            if($Env:COMPUTERNAME -ne $CloudAssignedDeviceName)
            {
                $doIt = $true
            }
        }

        #If must rename then do it
        if($doIt)
        {
            Write-Host "Workstation: $($env:COMPUTERNAME) => $CloudAssignedDeviceName"
            try {
                Rename-Computer -NewName $CloudAssignedDeviceName -ErrorAction Stop
                Set-Content "$($env:ProgramData)\Intune.ScriptLogs\PSRename\DeviceNane.tag" -Value $CloudAssignedDeviceName

                & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Save your work."
            }
            catch {
                $_.Exception.Message
            }
        }
    }
}

Stop-Transcript
