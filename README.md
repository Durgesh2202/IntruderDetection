# IntruderDetection

# 🛡️   Host Baed Intruder Detection System

This project is a lightweight **Intruder Detection System** designed using PowerShell to monitor unauthorized or failed login attempts on a Windows machine. It captures logon events and sends alerts upon suspicious activities.

## 🔧 Features

- Detects **failed logon attempts** from Event Viewer.
- Sends **real-time alerts** (can be extended to email/Slack/Discord).
- Logs intruder details like **username, IP address, and timestamp**.
- Simple and **fully script-based**, no additional software required.

## 📁 Project Structure

- `FailedLogonCapture.ps1`  
  Scans Windows Event Logs for failed login attempts and logs the necessary information.

- `login_alert.ps1`  
  Monitors logon events and triggers an alert script when suspicious activity is detected.

## 🖥️ Requirements

- Windows OS (tested on Windows 10/11)
- PowerShell 5.1+
- Admin privileges to access Event Logs

## 🚀 How to Use

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Durgesh2202/intruder-detection-system.git
   cd intruder-detection-system
