   #!/bin/bash
   THRESHOLD=$1
   echo "Setting battery charge threshold to $THRESHOLD%"
   sudo bash -c "echo $THRESHOLD > /sys/class/power_supply/BAT0/charge_control_end_threshold"
