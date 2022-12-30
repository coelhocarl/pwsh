<#
Ativa o bitlocker se o dispositivo tiver o TPM habilitado e salva a chave na pasta C:\tmp
Requer elevação.

#>

mkdir c:\tmp -ErrorAction SilentlyContinue
$log = "C:\tmp\$env:COMPUTERNAME.log"

Write-Output "--- Execução iniciada $(Get-Date -UFormat "%A %d/%m/%Y %T %Z")`n" > $log

# já está ativado? 
$BitVol = Get-BitLockerVolume -MountPoint 'c:'

# suporta TPM? 
$TPMST = (Get-WmiObject -Class win32_tpm -Namespace root\cimv2\Security\MicrosoftTpm).IsActivated().IsActivated 

if ($BitVol.volumeStatus -eq 'FullyDecrypted' -and $TPMST -eq 'true') {
    Add-BitLockerKeyProtector -MountPoint 'c:' -RecoveryPasswordProtector
    Enable-Bitlocker -MountPoint 'c:' -TpmProtector
    echo "recovery pwd $((Get-BitLockerVolume -MountPoint "c:" | Select-Object -ExpandProperty KeyProtector).RecoveryPassword)" >> $log
    echo "Processo para habilitar o bitlocker concluido" >> $log
}

elseif ($BitVol.volumeStatus -ne 'FullyDecrypted') {
echo "Bitlocker já está ativado ou em processo de ativação" >> $log
}

else {
echo "Configurações TPM não suportadas" >> $log
}
Write-Output "`n--- Execução concluida $(Get-Date -UFormat "%A %d/%m/%Y %T %Z")" >> $log
