FROM debian:buster-slim

RUN apt-get update
RUN apt-get install -y unzip wget x11vnc xvfb socat nano

WORKDIR /root

#Download IB Gateway
RUN wget -q --progress=bar:force:noscroll --show-progress\
    https://download2.interactivebrokers.com/installers/ibgateway/stable-standalone/ibgateway-stable-standalone-linux-x64.sh -O install-ib-gw.sh
RUN chmod a+x install-ib-gw.sh

#Download IB TWS
RUN wget -q --progress=bar:force:noscroll --show-progress\
    https://download2.interactivebrokers.com/installers/tws/stable-standalone/tws-stable-standalone-linux-x64.sh -O install-ib-tws.sh
RUN chmod a+x install-ib-tws.sh

#Install IB Gateway
RUN yes '' | ./install-ib-gw.sh

#Install IB TWS
RUN yes '' | ./install-ib-tws.sh

#Download IBC
RUN wget -q --progress=bar:force:noscroll --show-progress\
    https://github.com/IbcAlpha/IBC/releases/download/3.8.7/IBCLinux-3.8.7.zip -O ibc.zip
RUN unzip ibc.zip -d /opt/ibc
RUN chmod a+x /opt/ibc/*.sh /opt/ibc/*/*.sh

#Copy IBC files
COPY ./ibc_config.ini /root/ibc/config.ini
COPY run_ibc.sh run_ibc.sh
RUN chmod a+x run_ibc.sh

#Environment variables and ports
ENV DISPLAY :0
ENV TWS_PORT 4002
ENV VNC_PORT 5900
EXPOSE $TWS_PORT
EXPOSE $VNC_PORT

#Run IBC
CMD ./run_ibc.sh
