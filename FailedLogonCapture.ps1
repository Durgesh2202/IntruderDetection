# Paths
$logFile = "C:\SecurityScripts\Logs\login_log.txt"
$imageFolder = "C:\SecurityScripts\Logs\IntruderImages"
$ffmpegPath = "C:\ffmpeg\bin\ffmpeg.exe"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$imagePath = Join-Path $imageFolder "$timestamp.jpg"

# Email Config
$emailFrom = "useridnumber01@gmail.com"
$emailTo = "useridnumber03@gmail.com"
$smtpServer = "smtp.gmail.com"
$smtpPort = 587
$smtpUsername = "useridnumber01@gmail.com"
$smtpPassword = "sbaxeoteordbfnfk"

# Ensure folders exist
if (-not (Test-Path $imageFolder)) { New-Item -Path $imageFolder -ItemType Directory -Force }
if (-not (Test-Path $logFile)) { New-Item -Path $logFile -ItemType File -Force | Out-Null }

# Log entry
Add-Content -Path $logFile -Value "`n[$timestamp] Failed logon attempt detected. Capturing image..."

# Capture image
try {
    & $ffmpegPath -f dshow -i video="USB2.0 HD UVC WebCam" -frames:v 1 "$imagePath" -y -loglevel quiet
    Add-Content -Path $logFile -Value "Intruder image saved at $imagePath"

    # Send email
    $msg = New-Object System.Net.Mail.MailMessage
    $msg.From = $emailFrom
    $msg.To.Add($emailTo)
    $msg.Subject = "⚠️ Failed Logon Attempt Detected"
    $msg.Body = "A failed logon attempt was recorded at $timestamp. See attached image."
    $msg.Attachments.Add($imagePath)

    $smtp = New-Object Net.Mail.SmtpClient($smtpServer, $smtpPort)
    $smtp.EnableSsl = $true
    $smtp.Credentials = New-Object System.Net.NetworkCredential($smtpUsername, $smtpPassword)

    $smtp.Send($msg)
    Add-Content -Path $logFile -Value "Alert email sent."
}
catch {
    Add-Content -Path $logFile -Value "Error: $_"
}
