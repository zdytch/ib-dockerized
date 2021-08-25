# IB Dockerized

Run Interactive Brokers **TWS** or **Gateway** in Docker container.

Based on [IBC](https://github.com/IbcAlpha/IBC) project.

To run **Client Portal Web API Gateway** in Docker, you may want to use [IBeam](https://github.com/Voyz/ibeam) instead.

## Environment variables:
- `IB_APP` — trading app, possible values are   `tws` or `gw`
- `IB_MODE` — trading mode, possible values are `paper` or `live`
- `IB_USER` — username
- `IB_PASSWORD` — password
- `VNC_PASSWORD` — **OPTIONAL** — if set, VNC connection allowed with the password

## Run
Use the environment variables in `docker compose` file or directly with `docker run` command:

`docker run --publish 5900:5900 -e IB_APP= -e IB_MODE= -e IB_USER= -e IB_PASSWORD= -e VNC_PASSWORD= zdytch/ib-dockerized`

## Disclaimer
This method of deploying TWS/Gateway is not endorsed nor supported by Interactive Brokers.
