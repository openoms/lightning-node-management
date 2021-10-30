# Circuitbreaker on FreeBSD

https://github.com/lightningequipment/circuitbreaker

## Installation
```
# install dependencies
pkg install go git tmux

# enter tmux
tmux

# download
git clone https://github.com/lightningequipment/circuitbreaker

# make data directory
mkdir .circuitbreaker

# installl
cd circuitbreaker
go install

# copy sample config
cp  circuitbreaker-example.yaml /root/.circuitbreaker/circuitbreaker.yaml
```

## See the help and usage
```
/root/go/bin/circuitbreaker -h
```
```
NAME:
   circuitbreaker - A new cli application

USAGE:
   circuitbreaker [global options] command [command options] [arguments...]

VERSION:
   0.11.1-beta.rc3 commit=

COMMANDS:
   help, h  Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --rpcserver value          host:port of ln daemon (default: "localhost:10009")
   --lnddir value             path to lnd's base directory (default: "/root/.lnd")
   --tlscertpath value        path to TLS certificate (default: "/root/.lnd/tls.cert")
   --network value, -n value  the network lnd is running on e.g. mainnet, testnet, etc. (default: "mainnet")
   --macaroonpath value       path to macaroon file
   --configdir value          path to CircuitBreaker's base directory (default: "/root/.circuitbreaker")
   --help, -h                 show help
   --version, -v              print the version
```

## Run 
* keep in tmux
    ```
    /root/go/bin/circuitbreaker --lnddir=/var/db/lnd
    ```
* sample of initial output:
    ```
    2021-09-11T06:02:06.703-0700    INFO    Read config file        {"file": "/root/.circuitbreaker/circuitbreaker.yaml"}
    2021-09-11T06:02:06.703-0700    INFO    CircuitBreaker started
    2021-09-11T06:02:06.703-0700    INFO    Hold fee        {"base": 1, "rate": 0.000005, "reporting_interval": "1h0m0s"}
    2021-09-11T06:02:06.758-0700    INFO    Connected to lnd node 
    ```

* can detach tmux with `CTRL`+`D` (circuitbreaker will keep running in the background)
* reattach with:
    ```
    tmux a
    ```