#!/bin/bash

# This code was generated using OpenAI's ChatGPT. Use it at your own risk.
# Broadcom BCM4360 Treiber Installation Script für Debian

echo "=== Broadcom BCM4360 Treiber-Installation starten ==="

# Überprüfen auf Root-Rechte
if [ "$(id -u)" -ne 0 ]; then
  echo "Bitte führe dieses Skript als Root aus (sudo bash $0)"
  exit 1
fi

# Schritt 1: Non-Free-Repositories hinzufügen, falls nicht vorhanden
echo "Prüfe und füge Non-Free-Repositories hinzu..."
NON_FREE_LINE="deb http://deb.debian.org/debian/ $(lsb_release -cs) main contrib non-free"
if ! grep -q "$NON_FREE_LINE" /etc/apt/sources.list; then
  echo "$NON_FREE_LINE" >> /etc/apt/sources.list
  echo "Non-Free-Repositories hinzugefügt."
else
  echo "Non-Free-Repositories sind bereits vorhanden."
fi

# Paketquellen aktualisieren
echo "Aktualisiere Paketlisten..."
apt update

# Schritt 2: Broadcom-Treiber installieren
echo "Installiere Broadcom STA-Treiber (broadcom-sta-dkms)..."
apt install -y broadcom-sta-dkms

# Schritt 3: Inkompatible Treiber entfernen
echo "Entferne inkompatible Treiber..."
modprobe -r b43 brcmsmac ssb bcma

# Schritt 4: WL-Treiber laden
echo "Lade den WL-Treiber..."
modprobe wl

# Schritt 5: Blacklist für inkompatible Treiber erstellen
echo "Erstelle Blacklist für inkompatible Treiber..."
BLACKLIST_FILE="/etc/modprobe.d/blacklist-broadcom.conf"
cat << EOF > $BLACKLIST_FILE
blacklist b43
blacklist brcmsmac
blacklist ssb
blacklist bcma
EOF

echo "Blacklist erstellt unter $BLACKLIST_FILE."

# Schritt 6: Kernel-Header überprüfen
echo "Überprüfe Kernel-Header..."
apt install -y linux-headers-$(uname -r)

# Schritt 7: Neustarthinweis
echo "Installation abgeschlossen. Bitte starte das System neu, um den Treiber zu aktivieren."
echo "Führe folgenden Befehl aus, falls WLAN nicht funktioniert: dmesg | grep wl"

exit 0