ASA Hotel Watchdog

Ideen und Vorschläge an
berge@prohotel-edv.de

# was macht das Programm
Der Hotel Dienst verrichtet auf unerklärliche weise seinen Dienst nicht mehr? Mit dem Watchdog wird kontinuierlich geprüpft ob der Dienst noch läuft und ggfs. neu gestartet. Es wird eine Protokolldatei über die Neustarts des betreffenden Dienstes geschrieben.

<img width="834" height="264" alt="image" src="https://github.com/user-attachments/assets/933c76e4-7b26-4e85-90ab-a583fcc2369c" />

# NSSM - the Non-Sucking Service Manager herunterladen
https://nssm.cc/release/nssm-2.24.zip 

# Prüfung ob Dienst läuft (Powershell)
Get-Service HotelWatchdog

# Deinstallation (Powershell)
& ".\nssm-2.24\win64\nssm.exe" remove HotelWatchdog confirm 

# Log
G:\ASAjHotel\Logs\ServiceRestartLog.txt

2025-11-22 14:43:28 - FEHLER: Dienst 'Hotel' lief nicht. Versuche Neustart...
2025-11-22 14:43:28 - INFO: Dienst erfolgreich neu gestartet.
