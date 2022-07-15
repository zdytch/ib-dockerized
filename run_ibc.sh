#!/bin/bash

set -e
set -o errexit

rm -f /tmp/.X0-lock

Xvfb :0 &
sleep 1


#Prepare arguments and port for Gateway or TWS
APP_ARGS="--mode=$IB_MODE --user=$IB_USER --pw=$IB_PASSWORD"
INT_PORT=0

if [ $IB_APP = "gw" ] ; then
    APP_ARGS="$(ls ~/Jts/ibgateway) --gateway $APP_ARGS"
    
    if [ $IB_MODE = "live" ] ; then
        INT_PORT=$GW_LIVE_PORT
    elif [ $IB_MODE = "paper" ] ; then
        INT_PORT=$GW_PAPER_PORT
    fi

elif [ $IB_APP = "tws" ] ; then
    APP_ARGS="$(ls ~/Jts | head -1) $APP_ARGS"

    if [ $IB_MODE = "live" ] ; then
        INT_PORT=$TWS_LIVE_PORT
    elif [ $IB_MODE = "paper" ] ; then
        INT_PORT=$TWS_PAPER_PORT
    fi
fi


#Run VNC if password is set
if [ $VNC_PASSWORD ] ; then
    mkdir -p .vnc 
    x11vnc -storepasswd $VNC_PASSWORD .vnc/passwd
    x11vnc -rfbport $VNC_PORT -display :0 -usepw -forever &
fi


#Forward IB port from internal to external, to simulate local connection
socat TCP-LISTEN:$IB_PORT,fork TCP:localhost:$INT_PORT,forever &


/opt/ibc/scripts/ibcstart.sh $APP_ARGS
