# LNtop on FreeBSD

https://github.com/edouardparis/lntop

*For some reason the terminal freezes when running LNtop, but still provides valuable info*


## Installation
```
# dependencies
pkg install -y git go

# install with go
go install github.com/edouardparis/lntop@latest

# or from source
git clone https://github.com/edouardparis/lntop.git
# install
cd lntop && && go build && go install ./...
```

## Run first to create the default config
```
/root/go/bin/lntop
```

## Config

```
nano /root/.lntop/config.toml
```
* Change to:
```
cert = "/var/db/lnd/tls.cert"
macaroon = "/var/db/lnd/data/chain/bitcoin/mainnet/readonly.macaroon"
```

## Run
```
/root/go/bin/lntop
```
(as my last attempt would need to close the terminal to exit)
