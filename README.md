# Kali-Linux-issue
This is a **common Kali Linux issue** (especially with Xfce, GNOME, VMware/VirtualBox, or after driver glitches). Follow the steps **in order** — stop when the cursor comes back.

---

## 1️⃣ Try the quick fixes first

These often fix it instantly.

### 🔹 Press these keys

* **Ctrl + Alt + F2** → wait 5 seconds → **Ctrl + Alt + F1 / F7**
* Or **Alt + F2**, type:

```bash
xfwm4 --replace &
```

---

## 2️⃣ Restart the display manager (most effective)

This fixes cursor, panels, menus, freezes.

### For Kali (Xfce default)

```bash
sudo systemctl restart lightdm
```

If using **GDM** (GNOME):

```bash
sudo systemctl restart gdm
```

⚠️ This will log you out.

---

## 3️⃣ Reset mouse & cursor settings

Sometimes the cursor theme breaks.

```bash
rm -rf ~/.icons
rm -rf ~/.cache
rm -rf ~/.config/xfce4
reboot
```

---

## 4️⃣ If you are using a VM (VERY COMMON)

### 🔹 VMware

```bash
sudo apt update
sudo apt install -y open-vm-tools-desktop
reboot
```

### 🔹 VirtualBox

```bash
sudo apt install -y build-essential dkms linux-headers-$(uname -r)
sudo mount /dev/cdrom /mnt
sudo sh /mnt/VBoxLinuxAdditions.run
reboot
```

---

## 5️⃣ NVIDIA / GPU driver issue (black screen + no cursor)

Check driver:

```bash
lspci | grep -E "VGA|3D"
```

Temporary fix:

```bash
sudo apt install xserver-xorg-video-fbdev
```

Permanent fix (NVIDIA):

```bash
sudo apt install nvidia-driver
reboot
```

---

## 6️⃣ If cursor is there but INVISIBLE

Force cursor redraw:

```bash
sudo apt install unclutter
unclutter -idle 0 &
```

Or:

```bash
xsetroot -cursor_name left_ptr
```

---

## 7️⃣ Worst-case recovery (safe)

Reinstall Xorg + desktop:

```bash
sudo apt install --reinstall kali-desktop-xfce xorg lightdm
reboot
```

---

## ▶️ How to use

```bash
nano cursor_fix_kali.sh
# paste script
chmod +x cursor_fix_kali.sh
sudo bash cursor_fix_kali.sh
reboot
```

---

## 🧠 Notes (important)

* **Safe for Kali XFCE**
* Works on **VMware, VirtualBox, bare metal**
* Fixes **cursor not visible**, **menus not working**, **freezes**
* Log saved to: `~/cursor_fix.log`

---


