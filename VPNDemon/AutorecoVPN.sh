#!/bin/bash
# étape 1 : récupérer le UUI du vpn : nmcli con
# étape 2 : saisir le UUI dans ce script et DecoVPN.sh

TargetProgramName="qbittorrent"
VPNUUID="xxxxxxxxxxxx" # <<<<<<<< modifier ce UUI
#notify-send "Connexion du VPN..."
exec /ThePathTo/vpndemon.sh &
while [ "true" ]
do
	VPNCON=$(nmcli con show --active | grep "$VPNUUID")
	if [ -z "$VPNCON" ]; then
		echo "VPN déconnecté"
		(sleep 1s && nmcli con up uuid "$VPNUUID") 
		FLAGRECO="vrai"
	else
		if [[ $FLAGRECO = "vrai" ]]; then
			FLAGRECO="faux"
			#exec $TargetProgramName &
		fi
	fi
	sleep 10
done
