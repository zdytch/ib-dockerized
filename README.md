# IB Dockerized

Run Interactive Brokers **TWS** or **Gateway** in Docker container.

Based on [IBC](https://github.com/IbcAlpha/IBC) project.

To run **Client Portal Web API Gateway** in Docker, you may want to use [IBeam](https://github.com/Voyz/ibeam) instead.

Environment variables:
- `IB_APP` — trading app, possible values are **tws** or **gw**
- `IB_MODE` — trading mode, possible values are **paper** or **live**
- `IB_USER` — username
- `IB_PASSWORD` — password
- `VNC_PASSWORD` — **OPTIONAL** — if set, VNC connection allowed with the password
