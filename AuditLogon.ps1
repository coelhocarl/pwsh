# Definir logon ou logoff como parametro na GPO Scripts (Logon/Logoff) 

Param(
[string]$Oper
)

$date = get-date -Format "yyyyMM"
$file = "\\example\share$\$date.txt"

$inventDate = get-date -Format "yyyy-MM-dd HH:mm:ss"
$inventCMPName = (Get-WMIObject Win32_ComputerSystem).Name
$inventIP = Get-WMIObject Win32_NetworkAdapterConfiguration | ? { $_.IPAddress } | select -expand IPAddress | ? { $_ -like '1*.*' }
$inventUSRName = (Get-WMIObject Win32_ComputerSystem).UserName
$inventDCName = $env:LOGONSERVER
$inventSOname = (Get-WmiObject Win32_OperatingSystem).Caption
$inventArch = (Get-WmiObject Win32_OperatingSystem).OSArchitecture

"$inventDate,$inventCMPName,$inventIP,$inventUSRName,$inventDCName,$inventSOname,$inventArch,$Oper" | Out-file -append $file
