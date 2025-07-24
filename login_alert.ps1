# Define Paths
$logPath = "C:\SecurityLogs\login_attempts.log"
$imagePath = "C:\SecurityLogs\intruder.jpg"

# Ensure SecurityLogs Directory Exists
if (!(Test-Path "C:\SecurityLogs\")) {
    New-Item -ItemType Directory -Path "C:\SecurityLogs\" | Out-Null
}

# Get Last Security Event (Login Failure or Unlock)
$events = Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4625,4801} -MaxEvents 1 -ErrorAction SilentlyContinue
if (-not $events) {
    Start-Sleep -Seconds 2
    $events = Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4625,4801} -MaxEvents 1
}

if ($events) {
    $eventID = $events.Id
    $user = $events.Properties[5].Value
    $time = $events.TimeCreated
    $computer = $env:COMPUTERNAME

    # Determine Alert Type
    if ($eventID -eq 4625) {
        $status = "Failed Login Attempt ❌"
    } elseif ($eventID -eq 4801) {
        $status = "PC Unlocked 🔓"
    }

    $emailBody = "ALERT DURGESH..! Unauthorized Access Detected on $computer.`nStatus: $status`nUser: $user`nTime: $time"

    # Save Log Entry
    Add-Content -Path $logPath -Value "$time - $status by $user"

    # Capture Image using Webcam (ffmpeg)
    Start-Process -FilePath "C:\ffmpeg-2025-03-20-git-76f09ab647-full_build\bin\ffmpeg.exe" `
        -ArgumentList "-f dshow -rtbufsize 100M -i video=`"USB2.0 HD UVC WebCam`" -frames:v 1 -y $imagePath" `
        -NoNewWindow -Wait

    # Email Configuration
    $smtpServer = "smtp.gmail.com"
    $smtpPort = "587"
    $username = "yourmail"
    $password = "password"   # Replace with your App Password

    $message = New-Object System.Net.Mail.MailMessage
    $message.From = $username
    $message.To.Add("yourmail")
    $message.Subject = "Security Alert - $status on $computer"
    $message.Body = $emailBody

    # Attach Photo if Exists
    if (Test-Path $imagePath) {
        $attachment = New-Object System.Net.Mail.Attachment($imagePath)
        $message.Attachments.Add($attachment)
    }

    # Send Email Alert
    $smtp = New-Object System.Net.Mail.SmtpClient($smtpServer, $smtpPort)
    $smtp.EnableSsl = $true
    $smtp.Credentials = New-Object System.Net.NetworkCredential($username, $password)
    
    try {
        $smtp.Send($message)
        Write-Host "✅ Email Sent Successfully!"
    } catch {
        Write-Host "❌ Failed to send email: $_"
    }

    # Cleanup
    if ($attachment) { $attachment.Dispose() }
}
