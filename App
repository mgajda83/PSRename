#Create logs
$LogPath = "C:\ProgramData\Intune.ScriptLogs\PSRename"
if(!(Test-Path -Path $LogPath)) { New-Item -Path $LogPath -ItemType Directory -Force }

$LogPathTranscript = Join-Path -Path $LogPath -ChildPath Transcript.txt
Start-Transcript -Path $LogPathTranscript -Force

#Check if autopilot config file exist on workstation
if(Test-Path -Path C:\WINDOWS\ServiceState\wmansvc\AutopilotDDSZTDFile.json)
{
    #Get Autopilot profile settings
    $Autopilot = Get-Content C:\WINDOWS\ServiceState\wmansvc\AutopilotDDSZTDFile.json -ErrorAction Stop | ConvertFrom-Json

    if([String]$Autopilot.CloudAssignedDeviceName -ne "")
    {
        #Rename computer if different
        if($env:COMPUTERNAME -ne $Autopilot.CloudAssignedDeviceName)
        {
            Write-Host "Workstation: $($env:COMPUTERNAME) => $($Autopilot.CloudAssignedDeviceName)"
            try {
                Rename-Computer -NewName $Autopilot.CloudAssignedDeviceName -ErrorAction Stop
                   
                & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Save your work."
            }
            catch {
                $_.Exception.Message
            }
        }
    }
}

Stop-Transcript
