<#

Script exige elevação 
Coleta os dados e salva como o nome do computador
A cada execução os dados são substituidos 

#>

$file = "\\example\share$\$env:computername.txt"

$invent = @(
write "-- Inventario gerado $(get-date -Format "yyyy-MM-dd HH:mm:ss")"
write ""

write "-------- Programas instalados --------"
Get-WmiObject Win32_InstalledWin32Program | Select Name,Version | ft -autosize
write ""

write "-------- Outras informacoes --------"
(Get-WMIObject Win32_ComputerSystem).Name
Get-WMIObject Win32_NetworkAdapterConfiguration | ? { $_.IPAddress } | select -expand IPAddress | ? { $_ -like '1*.*' }
(Get-WmiObject Win32_Processor).Name
Get-WMIObject Win32_PhysicalMemory | select -expand Capacity
Get-WmiObject Win32_LogicalDisk | ? {$_.DriveType -eq 3} | select -expand Size
Get-WmiObject Win32_LogicalDisk | ? {$_.DriveType -eq 3} | select -expand FreeSpace
(Get-WmiObject Win32_OperatingSystem).Caption
(Get-WmiObject Win32_OperatingSystem).OSArchitecture
(Get-WMIObject Win32_ComputerSystem).Manufacturer
(Get-WMIObject Win32_ComputerSystem).Model
(Get-WMIObject Win32_OperatingSystem).OSLanguage
(Get-WmiObject Win32_Bios).Name
(Get-WmiObject Win32_Bios).SerialNumber
(Get-WmiObject Win32_Bios).ReleaseDate
write ""

write "-------- Folders --------"
ls C:\ -Depth 1 | Select FullName, LastAccessTime, LastWriteTime

)
$invent | Out-File $file

write "-- Inventario finalizado $(get-date -Format "yyyy-MM-dd HH:mm:ss")" | Out-File -Append $file


<#
... 

Codigo de idiomas
https://learn.microsoft.com/en-us/deployoffice/office2016/language/language-identifiers-optionstate-id-values
Conversão de bytes 
em MB =bytes


#>
