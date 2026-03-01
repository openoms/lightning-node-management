# LNtop FreeBSD-n

https://github.com/edouardparis/lntop

*Valamilyen okbol a terminal lefagy az LNtop futtatasa kozben, de ettol fuggetlenul hasznos informaciokat nyujt*


## Telepites
```
# fuggosegek
pkg install -y git go

# telepites go-val
go install github.com/edouardparis/lntop@latest

# vagy forrasbol
git clone https://github.com/edouardparis/lntop.git
# telepites
cd lntop && && go build && go install ./...
```

## Futtasd eloszor az alapertelmezett konfiguracio letrehozasahoz
```
/root/go/bin/lntop
```

## Konfiguracio

```
nano /root/.lntop/config.toml
```
* Valtoztasd meg a kovetkezore:
```
cert = "/var/db/lnd/tls.cert"
macaroon = "/var/db/lnd/data/chain/bitcoin/mainnet/readonly.macaroon"
```

## Futtatas
```
/root/go/bin/lntop
```
(az utolso probalkozasomnal be kellett zarni a terminalt a kilepeshez)
