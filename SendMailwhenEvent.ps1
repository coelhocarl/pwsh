<#

2024-01
Realiza uma query nos eventos de aplicativo em busca da primeira correspondência do id 12325, 
retornando à descrição do evento disparando um e-mail. 

Defina os parametros $username, $password e To

#>

$message = (Get-WinEvent -LogName Application | ? {$_.id -eq 12325} | Select-Object -First 1 -ExpandProperty Message)
$username = 'your_gmail@gmail.com'
$password = (ConvertTo-SecureString "password app here" -AsPlainText -Force)
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $password

$sendMailHash = @{
   SmtpServer = 'smtp.gmail.com'
   Port = '587'
   UseSSL = $true
   Credential = $credential
   From = $username
   To = 'destinatario_here@outlook.com'
   Subject = 'Exceeded the quota threshold'
   Body = [String]$message
}
Send-MailMessage @sendMailHash
