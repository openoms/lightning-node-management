# LNtop FreeBSD-n

https://github.com/edouardparis/lntop

*Valamilyen okból a terminál lefagy az LNtop futtatása közben, de ettől függetlenül hasznos információkat nyújt*


## Telepítés
```
# függőségek
pkg install -y git go

# telepítés go-val
go install github.com/edouardparis/lntop@latest

# vagy forrásból
git clone https://github.com/edouardparis/lntop.git
# telepítés
cd lntop && && go build && go install ./...
```

## Futtasd először az alapértelmezett konfiguráció létrehozásához
```
/root/go/bin/lntop
```

## Konfiguráció

```
nano /root/.lntop/config.toml
```
* Változtasd meg a következőre:
```
cert = "/var/db/lnd/tls.cert"
macaroon = "/var/db/lnd/data/chain/bitcoin/mainnet/readonly.macaroon"
```

## Futtatás
```
/root/go/bin/lntop
```
(az utolsó próbálkozásomnál be kellett zárni a terminált a kilépéshez)
