<#

Basic Inventory
Requer elevação 
Last update 2024-02-10

#>

$file = "\\example\share$\$env:computername"

$name = (Get-WMIObject Win32_ComputerSystem).Name
$ip = Get-WMIObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress } | Select-Object -expand IPAddress | Where-Object { $_ -like '1*.*' }
$processor = (Get-WmiObject Win32_Processor).Name
$ram = (Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb
$diskCapacityb = Get-WmiObject Win32_LogicalDisk | Where-Object {$_.DeviceID -like 'c:'} | Select-Object -expand Size
    [int]$diskCapacity = $diskCapacityb / 1024 / 1024 / 1024
$diskFreeb = Get-WmiObject Win32_LogicalDisk | Where-Object {$_.DeviceID -like 'c:'} | Select-Object -expand FreeSpace
    [int]$diskFree = $diskFreeb / 1024 / 1024 / 1024
$so = (Get-WmiObject Win32_OperatingSystem).Caption
$build = (Get-WmiObject Win32_OperatingSystem).Version
$language = (Get-WMIObject Win32_OperatingSystem).OSLanguage
$arch = (Get-WmiObject Win32_OperatingSystem).OSArchitecture
$manufacturer = (Get-WMIObject Win32_ComputerSystem).Manufacturer
$model = (Get-WMIObject Win32_ComputerSystem).Model
$bios = (Get-WmiObject Win32_Bios).Name
$biosRelease = (Get-WmiObject Win32_Bios).ReleaseDate
$sn = (Get-WmiObject Win32_Bios).SerialNumber
$last = Get-Date -Format "yyyyMMddHHmm"

# Index
# Name,IP,Processor,RAM,DiskCTotal,DiskCFree,SO,Build,Language,Arch,Manufacturer,Model,BIOS,BIOSRelease,SN
"$name;$ip;$processor;$ram;$diskCapacity;$diskFree;$so;$build;$language;$arch;$manufacturer;$model;$bios;$biosRelease;$sn;$last" | Out-File $file'.dev.txt'

$Apps = @()
$Apps += Get-CimInstance Win32_InstalledWin32Program
$Apps += Get-CimInstance Win32_InstalledStoreProgram
$Apps | Format-Table -HideTableHeaders Name,Version | Out-File $file'.apps.txt'

Get-ChildItem C:\ -Depth 1 | Format-Table -HideTableHeaders FullName, LastAccessTime, LastWriteTime, Length | Out-File $file'.folders.txt'
