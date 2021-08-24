#!/bin/bash

set -e
set -o errexit

rm -f /tmp/.X0-lock

Xvfb :0 &
sleep 1

#Run VNC if password is set
if [ $IB_VNC_PASSWORD ] ; then
    mkdir -p .vnc 
    x11vnc -storepasswd $IB_VNC_PASSWORD .vnc/passwd
    x11vnc -rfbport $VNC_PORT -display :0 -usepw -forever &
fi

#Forward TWS port from to 4001, to simulate local connection
socat TCP-LISTEN:$TWS_PORT,fork TCP:localhost:4001,forever &

#Prepare arguments for Gateway or TWS
APP_ARGS="--mode=$IB_MODE --user=$IB_USER --pw=$IB_PASSWORD"
if [ $IB_APP = "gw" ]; then
    APP_ARGS="$(ls ~/Jts/ibgateway) --gateway $APP_ARGS"
else
    if [ $IB_APP = "tws" ]; then
        APP_ARGS="$(ls ~/Jts | head -1) $APP_ARGS"
    fi
fi

/opt/ibc/scripts/ibcstart.sh $APP_ARGS
