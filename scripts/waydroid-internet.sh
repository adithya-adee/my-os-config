#!/bin/bash
# Script to enable internet for Waydroid

echo "Enabling internet for Waydroid..."

# Flush the rules first to avoid duplicates. 
# The 2>/dev/null is to ignore errors if the rules don't exist.
sudo iptables -D FORWARD -i waydroid0 -o wlo1 -j ACCEPT 2>/dev/null
sudo iptables -D FORWARD -i wlo1 -o waydroid0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT 2>/dev/null
sudo iptables -t nat -D POSTROUTING -o wlo1 -j MASQUERADE 2>/dev/null

# Re-add the rules
sudo iptables -I FORWARD -i waydroid0 -o wlo1 -j ACCEPT
sudo iptables -I FORWARD -i wlo1 -o waydroid0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -t nat -A POSTROUTING -o wlo1 -j MASQUERADE

echo "Done. Waydroid should now have internet access."
