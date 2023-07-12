#!/bin/sh

MY_IP=`ip addr | grep 'state UP' -A2 | grep -w 'inet' | awk '{print $2}' | awk -F/ '{print $1}'`

if [ "$NEW_CONFIG" = "true" ]; then
	cp /kamailio.cfg /etc/kamailio/kamailio.cfg
	cp /tls.cfg /etc/kamailio/tls.cfg
	cp /dispatcher.list /etc/kamailio/dispatcher.list
fi

if [ "$EN_SIPDUMP" = "true" ]; then
	sed -i "s/EN_SIPDUMP/1/g" /etc/kamailio/kamailio.cfg
else
	sed -i "s/EN_SIPDUMP/0/g" /etc/kamailio/kamailio.cfg
fi

#### fix Kamailio config file 
sed -i "s/alias=ALIAS/alias=\"$ALIAS\"/g" /etc/kamailio/kamailio.cfg
sed -i "s/SBC_NAME/$SBC_NAME/g" /etc/kamailio/kamailio.cfg
sed -i "s/SBC_PORT/$SBC_PORT/g" /etc/kamailio/kamailio.cfg
sed -i "s/MY_IP/$MY_IP/g" /etc/kamailio/kamailio.cfg
sed -i "s/ADVERTISE_IP/$ADVERTISE_IP/g" /etc/kamailio/kamailio.cfg
sed -i "s/RTP_ENG_IP:RTP_ENG_PORT/$RTP_ENG_IP:$RTP_ENG_PORT/g" /etc/kamailio/kamailio.cfg
sed -i "s/$du = \"sip:\" + PBX_IP + \":\" + PBX_PORT/$du = \"sip:\" + \"$PBX_IP\" + \":\" + \"$PBX_PORT\"/g" /etc/kamailio/kamailio.cfg
sed -i "s/from_uri =~ \".*\" + PBX_IP/from_uri =~ \".*\" + \"$PBX_IP\"/g" /etc/kamailio/kamailio.cfg
sed -i "s/PBX_IP/$PBX_IP/g" /etc/kamailio/kamailio.cfg
sed -i "s/PBX_PORT/$PBX_PORT/g" /etc/kamailio/kamailio.cfg
sed -i "s/HOST_IP/$HOST_IP/g" /etc/kamailio/kamailio.cfg
sed -i "s/UDP_SIP_PORT/$UDP_SIP_PORT/g" /etc/kamailio/kamailio.cfg

###### fix Kamailio TLS file
sed -i "s/SBC_NAME/$SBC_NAME/g" /etc/kamailio/tls.cfg
sed -i "s/CERT_FOLDER_NAME/$CERT_FOLDER_NAME/g" /etc/kamailio/tls.cfg

####  fix Dispatcher file ####
sed -i "s/SBC_NAME/$SBC_NAME/g" /etc/kamailio/dispatcher.list
sed -i "s/MY_IP/$MY_IP/g" /etc/kamailio/dispatcher.list
sed -i "s/SBC_PORT/$SBC_PORT/g" /etc/kamailio/dispatcher.list

eval "kamailio -DD -E"
