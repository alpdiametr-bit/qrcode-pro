Set-NetConnectionProfile -InterfaceAlias Ethernet -NetworkCategory Private -ErrorAction SilentlyContinue
Remove-NetFirewallRule -DisplayName "QRCodePro 5000" -ErrorAction SilentlyContinue
New-NetFirewallRule -DisplayName "QRCodePro 5000" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5000 -Profile Any | Out-Null
"DONE" | Out-File "$env:TEMP\qrfw.txt" -Encoding ascii
