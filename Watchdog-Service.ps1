# Datei: G:\ASAjHotel\_Watchdog-Service\Watchdog.ps1

# Konfiguration
$ServiceName = "Hotel"
$LogPath = "G:\ASAjHotel\Logs"
$LogFile = "$LogPath\ServiceRestartLog.txt"
$CheckIntervalSeconds = 60
$MaintenanceHour = 3 # 03:00 - 03:59 Uhr Pause

# Sicherstellen, dass Log-Ordner existiert
if (!(Test-Path $LogPath)) { New-Item -ItemType Directory -Force -Path $LogPath | Out-Null }

while ($true) {
    try {
        $CurrentHour = (Get-Date).Hour
        if ($CurrentHour -eq $MaintenanceHour) {
            # Wartungsfenster: Nichts tun
        }
        else {
            $Service = Get-Service -Name $ServiceName -ErrorAction Stop
            if ($Service.Status -ne 'Running') {
                $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                $LogMessage = "$Timestamp - FEHLER: Dienst '$ServiceName' lief nicht. Versuche Neustart..."
                Add-Content -Path $LogFile -Value $LogMessage
                
                Start-Service -Name $ServiceName
                Start-Sleep -Seconds 10 # Etwas länger warten beim Service-Start
                
                $ServiceCheck = Get-Service -Name $ServiceName
                if ($ServiceCheck.Status -eq 'Running') {
                    Add-Content -Path $LogFile -Value "$Timestamp - INFO: Dienst erfolgreich neu gestartet."
                } else {
                    Add-Content -Path $LogFile -Value "$Timestamp - KRITISCH: Dienst konnte nicht gestartet werden!"
                }
            }
        }
    }
    catch {
        $ErrTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Add-Content -Path $LogFile -Value "$ErrTimestamp - SYSTEMFEHLER: $($_.Exception.Message)"
    }
    Start-Sleep -Seconds $CheckIntervalSeconds
}
