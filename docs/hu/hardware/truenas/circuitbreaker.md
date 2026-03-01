# Circuitbreaker FreeBSD-n

https://github.com/lightningequipment/circuitbreaker

## Telepites
```
# fuggosegek telepitese
pkg install -y go git tmux

# tmux inditasa
tmux

# letoltes
git clone https://github.com/lightningequipment/circuitbreaker

# telepites
cd circuitbreaker
go install
```

## Sugo es hasznalat megtekintese
```
/root/.gopkg/bin/circuitbreaker -h

NAME:
   circuitbreakerd - A new cli application

USAGE:
   circuitbreaker [global options] command [command options] [arguments...]

VERSION:
   0.15.4-beta commit=

COMMANDS:
   help, h  Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --rpcserver value          host:port of ln daemon (default: "localhost:10009")
   --lnddir value             path to lnd's base directory (default: "/root/.lnd")
   --tlscertpath value        path to TLS certificate (default: "/root/.lnd/tls.cert")
   --network value, -n value  the network lnd is running on e.g. mainnet, testnet, etc. (default: "mainnet")
   --macaroonpath value       path to macaroon file
   --configdir value          path to CircuitBreaker's base directory (default: "/root/.circuitbreaker")
   --listen value             grpc server listen address (default: "127.0.0.1:9234")
   --httplisten value         http server listen address (default: "127.0.0.1:9235")
   --stub                     set to enable stub mode (no lnd instance connected)
   --help, -h                 show help
   --version, -v              print the version
```

## Futtatas
* tartsd tmux-ban
   ```
   /root/.gopkg/bin/circuitbreaker --lnddir=/var/db/lnd
   ```
* pelda a kezdeti kimenetre:
   ```
   INFO    Opening database        {"path": "/root/.circuitbreaker/circuitbreaker.db"}
   INFO    Applied migrations      {"count": 1}
   INFO    CircuitBreaker started
   INFO    Grpc server starting    {"listenAddress": "127.0.0.1:9234"}
   INFO    HTTP server starting    {"listenAddress": "127.0.0.1:9235"}
   INFO    Connected to lnd node   {"pubkey": "PUBKEY"}
   INFO    Interceptor/notification handlers registered
   ```

* a tmux-bol levalaszthatsz a `CTRL`+`D` billentyukombinavioval (a circuitbreaker tovabb fut a hatterben)
* ujracsatlakozas:
   ```
   tmux a
   ```

## Tor Hidden Service
* Hozd letre itt:
  ```
  nano /usr/local/etc/tor/torrc
  ```
  ```
  HiddenServiceDir /var/db/tor/circuitbreaker
  HiddenServiceVersion 3
  HiddenServicePort 80 127.0.0.1:9235
  ```
* toltsd ujra a Tor-t
   ```
   service tor reload
   ```
* olvasd ki a Hidden Service cimet
  ```
  cat /var/db/tor/circuitbreaker/hostname
  ```
* Tor logok
  ```
  tail -f /var/log/tor/tor.log
  ```
