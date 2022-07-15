# IB Dockerized

Run Interactive Brokers **TWS** or **Gateway** in Docker container.

Based on [IBC](https://github.com/IbcAlpha/IBC) project.

To run **Client Portal Web API Gateway** in Docker, you may want to use [IBeam](https://github.com/Voyz/ibeam) instead.

<p align="center">
    <img src="https://github.com/zdytch/ib-dockerized/blob/master/image.jpg" alt="IB Dockerized" title="IB Dockerized" width="640"/>
</p>

## Environment variables:
- `IB_APP` — trading app, possible values are   `tws` or `gw`
- `IB_MODE` — trading mode, possible values are `paper` or `live`
- `IB_USER` — username
- `IB_PASSWORD` — password
- `VNC_PASSWORD` — **OPTIONAL** — if not set, VNC connection is disabled
- `TZ` — **OPTIONAL** — if not set, app timezone is `UTC`. Use TZ database name from [here](https://en.m.wikipedia.org/wiki/List_of_tz_database_time_zones), e.g. `Europe/Helsinki`

## IBC Configuration
By default, sample config.ini used. To use custom config.ini, [download](https://github.com/IbcAlpha/IBC/blob/master/resources/config.ini) the sample, modify it and map to `/root/ibc/config.ini`. Please see example `docker-compose.yml`.

## Run
Use configuration from included sample file `docker-compose.yml`.

Or run directly with `docker run` command:

`docker run -e IB_APP=tws -e IB_MODE=paper -e IB_USER=ib_user -e IB_PASSWORD=password -e VNC_PASSWORD=vnc_password -e TZ=Europe/Helsinki -p 5900:5900 zdytch/ib-dockerized`

## Connection
Use container address and port **4002** to connect to the IB application.

## Healthcheck
The `netstat` utility is included and used to check IB socket port. You can customize healthcheck parameters and have the container automatically restart on unhealthy status. Please read about [autoheal](https://github.com/willfarrell/docker-autoheal) and see example `docker-compose.yml`.

## Disclaimer
This method of deploying TWS/Gateway is not endorsed nor supported by Interactive Brokers.
