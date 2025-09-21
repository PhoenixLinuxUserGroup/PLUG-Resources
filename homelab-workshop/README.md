# Homelab Workshop

A straightforward guide to set up a basic homelab server with Ubuntu Server.

## What You'll Build

By the end of this guide, you'll have:
- Secure SSH access
- Basic firewall protection
- Web management interface
- Network file sharing
- Media streaming server

## What You Need

- Server hardware (physical or VM)
- Network connection
- USB drive (8GB+) for installation
- Another computer to connect from

## Step 1: Install Ubuntu Server

### Download and Create Installation Media

1. Go to [ubuntu.com/download/server](https://ubuntu.com/download/server)
2. Download Ubuntu Server 22.04 LTS (most stable for homelab)
3. Create bootable USB using Rufus (Windows) or `dd` (Linux/Mac)

### Install Ubuntu

1. Boot from USB and follow the installer
2. **Network**: Set static IP (like 192.168.1.10) or use DHCP
3. **Storage**: Use entire disk
4. **Profile**: Create your user (e.g., `admin`)
5. **SSH**: Install OpenSSH server
6. **Snaps**: Skip for now
7. Let it install and reboot

### First Login

```bash
# SSH from your main computer
ssh <username>@<ip-address>

# Or login directly on the server
```

## Step 2: Basic Setup and Security

### Update Everything

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install useful tools
sudo apt install htop curl wget git vim -y
```

### Set Up Firewall

```bash
# Configure UFW firewall
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw enable

# Check status
sudo ufw status
```

### Secure SSH (Optional but Recommended)

```bash
# Edit SSH config
sudo vim /etc/ssh/sshd_config

# Find and change these lines:
# PermitRootLogin no
# MaxAuthTries 3

# Save and restart SSH
sudo systemctl restart ssh
```

## Step 3: Remote Access

### Install Tailscale (Easy VPN)

```bash
# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Connect to your network
sudo tailscale up

# Check status
tailscale status
```

This gives you secure remote access from anywhere without port forwarding.

## Step 4: Web Management

### Install Cockpit

```bash
# Install Cockpit web interface
sudo apt install cockpit -y

# Start the service
sudo systemctl enable --now cockpit.socket

# Allow through firewall
sudo ufw allow 9090/tcp

# Check it's running
sudo systemctl status cockpit
```

**Access Cockpit**: Open browser to `https://your-server-ip:9090`
- Username: your server username
- Password: your server password

## Step 5: File Sharing

### Create Storage Directories

```bash
# Create main storage folders
sudo mkdir -p /srv/storage/{files,media,backups}

# Set permissions
sudo chown -R $USER:$USER /srv/storage
chmod -R 755 /srv/storage

# Check structure
ls -la /srv/storage/
```

### Install Samba

```bash
# Install Samba
sudo apt install samba -y

# Backup original config
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.backup

# Create simple config
sudo tee /etc/samba/smb.conf > /dev/null << 'EOF'
[global]
   workgroup = WORKGROUP
   server string = Home Server
   security = user

[Files]
   comment = Shared Files
   path = /srv/storage/files
   browseable = yes
   writable = yes
   valid users = %S

[Media]
   comment = Media Files
   path = /srv/storage/media
   browseable = yes
   writable = yes
   valid users = %S
EOF

# Test config
testparm

# Start Samba
sudo systemctl enable --now smbd nmbd

# Allow through firewall
sudo ufw allow Samba

# Add your user to Samba
sudo smbpasswd -a $USER
```

### Test File Sharing

**From Windows**: Open File Explorer, type `\\your-server-ip`
**From Mac**: Finder → Go → Connect to Server → `smb://your-server-ip`
**From Linux**: Files → Other Locations → `smb://your-server-ip`

## Step 6: Media Server

### For Ubuntu 22.04 LTS (Recommended)

```bash
# Add Jellyfin repository
curl -fsSL https://repo.jellyfin.org/ubuntu/jellyfin_team.gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/jellyfin.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/jellyfin.gpg] https://repo.jellyfin.org/ubuntu jammy main" | sudo tee /etc/apt/sources.list.d/jellyfin.list

# Update and install
sudo apt update
sudo apt install jellyfin -y

# Start Jellyfin
sudo systemctl enable --now jellyfin

# Allow through firewall
sudo ufw allow 8096/tcp

# Check status
sudo systemctl status jellyfin
```

### For Ubuntu 25.04 (Alternative Methods)

If the repository doesn't work on Ubuntu 25.04:

**Method 1: Flatpak (Recommended)**
```bash
# Install Flatpak
sudo apt install flatpak -y

# Add Flathub repository
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install Jellyfin Server
flatpak install flathub org.jellyfin.JellyfinServer -y

# Run Jellyfin (will run on port 8096)
flatpak run org.jellyfin.JellyfinServer &

# Allow through firewall
sudo ufw allow 8096/tcp
```

**Method 2: AppImage (Portable)**
```bash
# Create jellyfin directory
mkdir -p ~/jellyfin
cd ~/jellyfin

# Download Jellyfin AppImage (check latest version at github.com/jellyfin/jellyfin/releases)
wget https://github.com/jellyfin/jellyfin/releases/download/v10.8.13/jellyfin_10.8.13_amd64.AppImage

# Make executable
chmod +x jellyfin_10.8.13_amd64.AppImage

# Create config directories
mkdir -p ~/.local/share/jellyfin/{config,data,cache,log}

# Run Jellyfin
./jellyfin_10.8.13_amd64.AppImage --datadir ~/.local/share/jellyfin/data --configdir ~/.local/share/jellyfin/config --cachedir ~/.local/share/jellyfin/cache --logdir ~/.local/share/jellyfin/log &

# Allow through firewall
sudo ufw allow 8096/tcp
```

**Method 3: Manual .deb Installation**
```bash
# Download latest .deb packages directly
cd /tmp
wget https://repo.jellyfin.org/files/server/ubuntu/latest-stable/amd64/jellyfin-server_10.8.13-1_amd64.deb
wget https://repo.jellyfin.org/files/server/ubuntu/latest-stable/amd64/jellyfin-web_10.8.13-1_all.deb

# Install dependencies first
sudo apt install at bc curl lsof

# Install Jellyfin packages
sudo dpkg -i jellyfin-server_10.8.13-1_amd64.deb jellyfin-web_10.8.13-1_all.deb

# Fix any dependency issues
sudo apt install -f -y

# Start Jellyfin
sudo systemctl enable --now jellyfin

# Allow through firewall
sudo ufw allow 8096/tcp

# Check status
sudo systemctl status jellyfin
```

**Note**: For Ubuntu 25.04, Method 3 (manual .deb) often works best as it uses the official packages.

### Setup Jellyfin

1. Open browser to `http://your-server-ip:8096`
2. Create admin account
3. Add media libraries:
   - Movies: `/srv/storage/media`
   - TV Shows: `/srv/storage/media`
4. Complete setup wizard

## Step 7: Basic Maintenance

### Create Simple Backup Script

```bash
# Create backup script
sudo vim /usr/local/bin/backup-homelab

# Add this content:
```

```bash
#!/bin/bash
# Simple backup script

BACKUP_DIR="/srv/storage/backups"
DATE=$(date +%Y%m%d)

# Create backup directory
mkdir -p $BACKUP_DIR

# Backup important configs
tar -czf $BACKUP_DIR/configs-$DATE.tar.gz \
    /etc/samba/ \
    /etc/ssh/ \
    /etc/ufw/

# Clean old backups (keep 7 days)
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

echo "Backup completed: $BACKUP_DIR/configs-$DATE.tar.gz"
```

```bash
# Make executable
sudo chmod +x /usr/local/bin/backup-homelab

# Test it
sudo /usr/local/bin/backup-homelab

# Schedule weekly backups
echo "0 2 * * 0 root /usr/local/bin/backup-homelab" | sudo tee -a /etc/crontab
```

## Step 8: Final Testing

### Check All Services

```bash
# Check service status
sudo systemctl status ssh samba jellyfin cockpit

# Check firewall
sudo ufw status

# Check listening ports
sudo ss -tlnp
```

### Test Everything

1. **SSH**: Connect from another computer
2. **Cockpit**: Access web interface at `:9090`
3. **File Sharing**: Connect to `\\your-server-ip` and upload a file
4. **Jellyfin**: Access `:8096` and test media playback
6. **Tailscale**: Connect from outside your network

## Quick Reference

### Service Management
```bash
# Check status
sudo systemctl status service-name

# Start/stop/restart
sudo systemctl start service-name
sudo systemctl stop service-name
sudo systemctl restart service-name

# Enable/disable auto-start
sudo systemctl enable service-name
sudo systemctl disable service-name
```

### Common Services
- `ssh` - SSH access
- `smbd` - Samba file sharing
- `jellyfin` - Media server
- `cockpit` - Web management

### Log Viewing
```bash
# View service logs
sudo journalctl -u service-name

# Follow logs in real-time
sudo journalctl -u service-name -f

# System logs
sudo journalctl --since "1 hour ago"
```

### Network Info
```bash
# Show IP addresses
ip addr show

# Show listening ports
sudo ss -tlnp

# Test connectivity
ping 8.8.8.8
```

## Troubleshooting

### Can't Connect via SSH
```bash
# Check SSH service
sudo systemctl status ssh

# Check firewall
sudo ufw status | grep 22
```

### Can't Access File Shares
```bash
# Check Samba
sudo systemctl status smbd
testparm

# Reset Samba password
sudo smbpasswd -a $USER
```

### Jellyfin Not Working
```bash
# Check Jellyfin status
sudo systemctl status jellyfin

# Check logs
sudo journalctl -u jellyfin

# Restart service
sudo systemctl restart jellyfin
```

### Web Interfaces Not Loading
```bash
# Check if services are listening
sudo ss -tlnp | grep -E "(9090|8096|19999)"

# Check firewall
sudo ufw status
```

## Daily Maintenance (2 minutes)

```bash
# Check system health
df -h          # Disk space
free -h        # Memory usage
uptime         # System load

# Check service status
sudo systemctl status ssh samba jellyfin
```

## Weekly Maintenance (10 minutes)

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Check logs for errors
sudo journalctl --priority=err --since "1 week ago"

# Run backup
sudo /usr/local/bin/backup-homelab
```

## Expanding Your Homelab

Once comfortable with the basics, consider adding:

- **Pi-hole**: Network-wide ad blocking
- **Home Assistant**: Smart home automation
- **Nextcloud**: Self-hosted cloud storage
- **Portainer**: Docker container management
- **Additional drives**: More storage space
- **UPS**: Uninterruptible power supply

## Getting Help

- **Ubuntu Server Guide**: [ubuntu.com/server/docs](https://ubuntu.com/server/docs)
- **r/homelab**: Reddit community
- **r/selfhosted**: Self-hosting community
- **YouTube**: TechnoTim, Craft Computing, Lawrence Systems

---

## Summary

**Access Points:**
- SSH: `ssh username@server-ip`
- Cockpit: `https://server-ip:9090`
- Jellyfin: `http://server-ip:8096`
- File Shares: `\\server-ip` or `smb://server-ip`

