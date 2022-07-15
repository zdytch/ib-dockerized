FROM --platform=linux/amd64 debian:bullseye-slim

RUN apt-get update
RUN apt-get install -y unzip wget x11vnc xvfb socat net-tools nano

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
RUN rm install-ib-gw.sh

#Install IB TWS
RUN yes '' | ./install-ib-tws.sh
RUN rm install-ib-tws.sh

#Download IBC
RUN wget -q --progress=bar:force:noscroll --show-progress\
    https://github.com/IbcAlpha/IBC/releases/download/3.13.0/IBCLinux-3.13.0.zip -O ibc.zip
RUN unzip ibc.zip -d /opt/ibc
RUN rm ibc.zip
RUN chmod a+x /opt/ibc/*.sh /opt/ibc/*/*.sh

#Copy IBC files
COPY run_ibc.sh run_ibc.sh
RUN mkdir ibc
RUN cp /opt/ibc/config.ini ./ibc/
RUN chmod a+x run_ibc.sh

#Environment variables and ports
ENV IB_PORT 4000
ENV GW_LIVE_PORT 4001
ENV GW_PAPER_PORT 4002
ENV TWS_LIVE_PORT 7496
ENV TWS_PAPER_PORT 7497
ENV DISPLAY :0
ENV VNC_PORT 5900

EXPOSE $IB_PORT
EXPOSE $VNC_PORT

#Enable healthcheck
HEALTHCHECK CMD netstat -ltn | grep -c ":$GW_LIVE_PORT\|:$GW_PAPER_PORT\|:$TWS_LIVE_PORT\|:$TWS_PAPER_PORT"

#Run IBC
CMD ./run_ibc.sh
