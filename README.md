# PSRename
Scripts to rename workstation they are prepared by Intune Autopilot in Hybrid Azure AD Join. App renaming device based on Device Name from Windows Autopilot devices list.
Devices – Enroll devices – Devices - select device - Device Name field

Many thanks to MICHAEL NIEHAUS. 
Solution was based on:
https://oofhours.com/2020/05/19/renaming-autopilot-deployed-hybrid-azure-ad-join-devices/

# Prepare Active Directory
Delegate access to SELF for "Read All Properties" and "Write All Properties" to OU with autopilot devices

# Create an app
.\IntuneWinAppUtil.exe -c ..\App -s install.cmd -o ..\IntuneApps

Next add Windows app (Win32) and load install.intunewin file.

Install command:    install.cmd;
Uninstall command:  uninstall.cmd;
Install behavior:   System


# Additional requirement
Additional requirement detects if new device name exist in profile settings, device is part of domain and aktually device have connection to domain controller. If not, app is not applicable for now.

Additional requirement rules:	Script PSRenameReq.ps1

Select output data type:  Boolean;
Operator:                 Equals;
Value:                    Yes ($true)

# Detection rules
Detection rules check if current name is different from new.

Detection rules:	        PSRenameDetector.ps1

# Assignments
Required but not in autopilot proces. It must be excluded from ESP - we dont want to reboot device in autopilot process.

App will start when autopilot ends and device connect to corporate network. If we dont have connection to corporate network, Intune try to start it later.
