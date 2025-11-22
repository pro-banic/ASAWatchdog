# Datei: G:\ASAjHotel\_Watchdog-Service\Install-Service.ps1

# Parameter
$NSSMPath = "$PSScriptRoot\nssm-2.24\win64\nssm.exe"
$ScriptPath = "$PSScriptRoot\Watchdog-Service.ps1"
$ServiceName = "HotelWatchdog"
$DisplayName = "Hotel Watchdog"
$Description = "Prüft minütlich ob Hotel-Dienst läuft und startet ihn neu. Pausiert zwischen 03:00 und 04:00 Uhr."

# Admin-Check
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Bitte führe dieses Skript als Administrator aus!"
    exit
}

# Prüfen ob NSSM da ist
if (!(Test-Path $NSSMPath)) {
    Write-Error "nssm.exe wurde nicht in $PSScriptRoot gefunden. Bitte dort ablegen."
    exit
}

Write-Host "Installiere Dienst '$DisplayName'..." -ForegroundColor Cyan

# Dienst stoppen und entfernen falls er schon existiert (für saubere Neuinstallation)
if (Get-Service $ServiceName -ErrorAction SilentlyContinue) {
    Write-Host "Alter Dienst gefunden. Stoppe und entferne..."
    & $NSSMPath stop $ServiceName
    & $NSSMPath remove $ServiceName confirm
}

# Dienst installieren
# Wir sagen NSSM: Starte powershell.exe mit dem Skript als Argument
& $NSSMPath install $ServiceName "powershell.exe" "-ExecutionPolicy Bypass -NoProfile -File `"$ScriptPath`""

# Details konfigurieren
& $NSSMPath set $ServiceName Description $Description
& $NSSMPath set $ServiceName DisplayName $DisplayName
& $NSSMPath set $ServiceName Start SERVICE_AUTO_START
& $NSSMPath set $ServiceName AppDirectory $PSScriptRoot

# Logging für den Watchdog-Dienst selbst (falls das Skript selbst abstürzt)
& $NSSMPath set $ServiceName AppStdout "$PSScriptRoot\Watchdog-Service-Out.log"
& $NSSMPath set $ServiceName AppStderr "$PSScriptRoot\Watchdog-Service-Error.log"

# Dienst starten
Write-Host "Starte Dienst..." -ForegroundColor Cyan
Start-Service $ServiceName

Write-Host "Fertig! Der Watchdog läuft jetzt als echter Windows-Dienst." -ForegroundColor Green
