#!/bin/bash

LOG="$HOME/cursor_fix.log"
exec > >(tee -a "$LOG") 2>&1

echo "=============================="
echo " Kali Linux Cursor Fix Script "
echo "=============================="
echo "[+] Log file: $LOG"
sleep 2

# Ensure root
if [[ $EUID -ne 0 ]]; then
  echo "[!] Run as root: sudo bash cursor_fix_kali.sh"
  exit 1
fi

echo "[+] Updating system..."
apt update -y

echo "[+] Restarting display manager..."
if systemctl list-units --type=service | grep -q lightdm; then
  systemctl restart lightdm
elif systemctl list-units --type=service | grep -q gdm; then
  systemctl restart gdm
elif systemctl list-units --type=service | grep -q sddm; then
  systemctl restart sddm
fi

echo "[+] Fixing invisible cursor..."
apt install -y unclutter
xsetroot -cursor_name left_ptr || true
unclutter -idle 0 &

echo "[+] Resetting cursor/theme cache..."
rm -rf /home/*/.icons
rm -rf /home/*/.cache
rm -rf /home/*/.config/gtk-3.0

echo "[+] Detecting Virtual Machine..."
VM=$(systemd-detect-virt)

if [[ "$VM" == "vmware" ]]; then
  echo "[+] VMware detected – installing tools..."
  apt install -y open-vm-tools open-vm-tools-desktop
fi

if [[ "$VM" == "oracle" ]]; then
  echo "[+] VirtualBox detected – installing guest tools..."
  apt install -y build-essential dkms linux-headers-$(uname -r)
fi

echo "[+] Fixing Xorg & desktop packages..."
apt install --reinstall -y \
  xorg \
  kali-desktop-xfce \
  lightdm \
  xfwm4 \
  xfce4-panel

echo "[+] Applying GPU fallback..."
apt install -y xserver-xorg-video-fbdev

echo "[+] Checking for NVIDIA GPU..."
if lspci | grep -i nvidia; then
  echo "[+] NVIDIA detected – installing driver..."
  apt install -y nvidia-driver
fi

echo "[+] Reloading window manager..."
xfwm4 --replace &

echo "===================================="
echo " ✅ FIX COMPLETED – REBOOT REQUIRED "
echo "===================================="
echo "Run: reboot"
