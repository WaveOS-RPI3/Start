#!/bin/sh

ACCT_ID="a2l17138"
INSTALL_URL="https://www.dataplicity.com/$ACCT_ID.py | sudo python"
LOG_FILE="/var/log/mass-install-dp.log"

#Wait maximum 30 seconds on network connectivity before giving up
limit=30
retry=0

#Don't bother to run when lo is configured
if [ "$IFACE" = lo ]; then
    exit 0
fi

#Only run from ifup
if [ "$MODE" != start ]; then
    exit 0
fi

if [ ! -e /opt/dataplicity/mass-install-hostname ]; then
    echo "Configuring hostname..." >> $LOG_FILE 2>&1

    procinfo=$(cat /proc/cpuinfo | grep Serial)
    rpi_serial=$(echo $procinfo | tr " " "\n" | tail -1)    

    if [ -z $rpi_serial ]; then
	echo "Raspberry Pi serial number not found" >> $LOG_FILE 2>&1
    else
	echo $rpi_serial | sudo tee /etc/hostname
	
	sudo sed -i '$d' /etc/hosts
	printf "127.0.0.1\t$rpi_serial\n" | sudo tee --append /etc/hosts
	
	sudo mkdir /opt/dataplicity
	sudo touch /opt/dataplicity/mass-install-hostname
	
	echo "Rebooting..." >> $LOG_FILE 2>&1
	sudo reboot
    fi
fi

if [ ! -e /opt/dataplicity/tuxtunnel/auth ]; then
    echo $IFACE >> $LOG_FILE 2>&1

    until ping -c 1 www.dataplicity.com > /dev/null ; do
        sleep 1
        retry=$(($retry+1))
        if [ $retry -eq $limit ]; then
            echo "Interface not connected and limit reached..." >> $LOG_FILE
            exit 0
        fi
    done
       
    echo "Dataplicity will now be installed..." >> $LOG_FILE 2>&1

    /bin/sh -c "curl -k $INSTALL_URL" >> $LOG_FILE 2>&1
    
    #Self deletion (cleanup)
    /bin/sh -c "sudo rm /etc/network/if-up.d/mass-install-dp /opt/dataplicity/mass-install-hostname"
fi
