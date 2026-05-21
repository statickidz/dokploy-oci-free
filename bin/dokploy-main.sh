#!/bin/bash

# Disable automatic updates to prevent apt lock being re-acquired mid-install
systemctl disable --now unattended-upgrades apt-daily.service apt-daily-upgrade.service \
  apt-daily.timer apt-daily-upgrade.timer 2>/dev/null || true

# Wait for any remaining apt lock to be released
while fuser /var/lib/dpkg/lock-frontend /var/lib/apt/lists/lock /var/lib/dpkg/lock >/dev/null 2>&1; do
  sleep 5
done

# Install dependencies
apt-get install -y openssh-server ufw iptables-persistent

# Install Docker before running the Dokploy installer so it finds it already present
DOCKER_INSTALLER="$(mktemp)"
curl -fsSL https://get.docker.com -o "$DOCKER_INSTALLER"
chmod 700 "$DOCKER_INSTALLER"
sh "$DOCKER_INSTALLER"
rm -f "$DOCKER_INSTALLER"
systemctl enable docker
systemctl start docker

# Install ufw-docker to prevent Docker from bypassing UFW rules
curl -fsSL https://github.com/chaifeng/ufw-docker/raw/master/ufw-docker \
  -o /usr/local/bin/ufw-docker
chmod +x /usr/local/bin/ufw-docker
ufw-docker install

# Install Dokploy
DOKPLOY_INSTALLER="$(mktemp)"
curl -sSfL https://dokploy.com/install.sh -o "$DOKPLOY_INSTALLER"
chmod 700 "$DOKPLOY_INSTALLER"
bash "$DOKPLOY_INSTALLER"
rm -f "$DOKPLOY_INSTALLER"

# Allow Docker Swarm traffic
/usr/sbin/ufw allow 80,443,996,7946,4789,2377/tcp
/usr/sbin/ufw allow 7946,4789,2377/udp

iptables -I INPUT 1 -p tcp --dport 2377 -j ACCEPT
iptables -I INPUT 1 -p udp --dport 7946 -j ACCEPT
iptables -I INPUT 1 -p tcp --dport 7946 -j ACCEPT
iptables -I INPUT 1 -p udp --dport 4789 -j ACCEPT

# Reorder FORWARD chain rules:
# Remove the default REJECT rule (ignore error if not found)
iptables -D FORWARD -j REJECT --reject-with icmp-host-prohibited || true
# Append the REJECT rule at the end so that Docker rules can be matched first
iptables -A FORWARD -j REJECT --reject-with icmp-host-prohibited

netfilter-persistent save
