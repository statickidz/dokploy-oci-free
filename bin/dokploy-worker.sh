#!/bin/bash

# Add ubuntu SSH authorized keys to the root user
mkdir -p /root/.ssh
cp /home/ubuntu/.ssh/authorized_keys /root/.ssh/
chown root:root /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

# Add ubuntu user to sudoers
echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# OpenSSH
apt install -y openssh-server
systemctl status sshd

# Permit root login
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart sshd

# Allow Docker Swarm and other required ports via UFW
ufw allow 80,443,3000,996,7946,4789,2377/tcp
ufw allow 7946,4789,2377/udp

# **Update UFW default forward policy to ACCEPT**
# This ensures that forwarded traffic isn’t dropped before Docker’s rules are applied.
sed -i 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw
ufw reload

# Allow specific ports at the INPUT chain (if not already allowed)
iptables -I INPUT 1 -p tcp --dport 2377 -j ACCEPT
iptables -I INPUT 1 -p udp --dport 7946 -j ACCEPT
iptables -I INPUT 1 -p tcp --dport 7946 -j ACCEPT
iptables -I INPUT 1 -p udp --dport 4789 -j ACCEPT

# **Insert a rule in UFW’s after.rules to explicitly allow traffic to port 3000**
# UFW builds the FORWARD chain using several files. By adding a rule in /etc/ufw/after.rules,
# we ensure that traffic destined for port 3000 is accepted before any generic REJECT rules.
if ! grep -q -- "--dport 3000" /etc/ufw/after.rules; then
    sed -i '/^# End required rules/i -A ufw-after-forward -p tcp --dport 3000 -j ACCEPT' /etc/ufw/after.rules
fi

# Save current iptables configuration for persistence across reboots
netfilter-persistent save

# Install Dokploy
curl -sSL https://dokploy.com/install.sh | sh