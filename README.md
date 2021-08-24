# IB Dockerized

Run Interactive Brokers **TWS** or **Gateway** in Docker container.

Based on [IBC](https://github.com/IbcAlpha/IBC) project.

To run **Client Portal Web API Gateway** in Docker, you may want to use [IBeam](https://github.com/Voyz/ibeam) instead.

Environment variables required:
- `IB_MODE` — trading mode, possible values are **paper** or **live**
- `IB_USER` — username
- `IB_PASSWORD` — password 
