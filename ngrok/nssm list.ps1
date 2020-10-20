Get-WmiObject win32_service | ?{$_.PathName -like '*nssm*'} | select Name, DisplayName, State, PathName
pause