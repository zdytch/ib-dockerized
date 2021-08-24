#!/bin/bash

set -e
set -o errexit

rm -f /tmp/.X0-lock

Xvfb :0 &
sleep 1

x11vnc -rfbport $VNC_PORT -display :0 -usepw -forever &
socat TCP-LISTEN:$TWS_PORT,fork TCP:localhost:4001,forever &

APP_ARGS="--mode=$IB_MODE --user=$IB_USER --pw=$IB_PASSWORD"
if [ $IB_APP = "GW" ]; then
    APP_ARGS="$(ls ~/Jts/ibgateway) --gateway $APP_ARGS"
else
    if [ $IB_APP = "TWS" ]; then
        APP_ARGS="$(ls ~/Jts) $APP_ARGS"
    fi
fi

/opt/ibc/scripts/ibcstart.sh $APP_ARGS
