# PSRename
Scripts to rename workstation they are prepared by Intune Autopilot in Hybrid Azure AD Join. App renaming device based on Device Name from Windows Autopilot devices list.
Devices – Enroll devices – Devices - select device - Device Name field

# Create an app
.\IntuneWinAppUtil.exe -c ..\App -s install.cmd -o ..\IntuneApps

Next add Windows app (Win32) and load install.intunewin file.

Install command: install.cmd
Uninstall command:	uninstall.cmd

# Additional requirement
Additional requirement detects if new device name exist in profile settings, device is part of domain and aktually device have connection to domain controller. If not, app is not applicable for now.

Additional requirement rules:	Script PSRenameReq.ps1

# Detection rules
Detection rules check if current name is different from new.

Detection rules:	PSRenameDetector.ps1
