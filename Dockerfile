# Builder
FROM debian:buster-slim AS builder

ARG IB_APP

RUN apt-get update
RUN apt-get install -y unzip wget

WORKDIR /root

RUN if [ $IB_APP = "GW" ];\
    then APP_LINK="https://download2.interactivebrokers.com/installers/ibgateway/stable-standalone/ibgateway-stable-standalone-linux-x64.sh";\
    else if [ $IB_APP = "TWS" ];\
    then APP_LINK="https://download2.interactivebrokers.com/installers/tws/stable-standalone/tws-stable-standalone-linux-x64.sh";\
    fi; fi;\
    wget -q --progress=bar:force:noscroll --show-progress $APP_LINK -O install-ib-app.sh
RUN chmod a+x install-ib-app.sh

RUN wget -q --progress=bar:force:noscroll --show-progress\
    https://github.com/IbcAlpha/IBC/releases/download/3.8.7/IBCLinux-3.8.7.zip -O ibc.zip
RUN unzip ibc.zip -d /opt/ibc
RUN chmod a+x /opt/ibc/*.sh /opt/ibc/*/*.sh

COPY run_ibc.sh run_ibc.sh
RUN chmod a+x run_ibc.sh

# Application
FROM debian:buster-slim

ARG IB_APP
ARG IB_VNC_PASSWORD

RUN apt-get update
RUN apt-get install -y x11vnc xvfb socat nano

WORKDIR /root

COPY --from=builder /root/install-ib-app.sh install-ib-app.sh
RUN yes '' | ./install-ib-app.sh

RUN mkdir .vnc
RUN if [ $IB_VNC_PASSWORD ] ; then x11vnc -storepasswd $IB_VNC_PASSWORD .vnc/passwd ; fi

COPY --from=builder /opt/ibc /opt/ibc
COPY --from=builder /root/run_ibc.sh run_ibc.sh

COPY ./ibc_config.ini /root/ibc/config.ini

ENV DISPLAY :0
ENV TWS_PORT 4002
ENV VNC_PORT 5900
ENV IB_APP $IB_APP

EXPOSE $TWS_PORT
EXPOSE $VNC_PORT

CMD ./run_ibc.sh
