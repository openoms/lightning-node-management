# Balance of Satoshis FreeBSD-n

## Telepites
```
pkg update -y
pkg install -y node npm nano tmux
npm install -g balanceofsatoshis
```

## A kapcsolodasi sztring exportalasa
```
/bin/sh
pkg install -y base64

LAN_IP=$(ifconfig | grep broadcast | head -1 | awk '{print $2}')
CERT=$(base64 /var/db/lnd/tls.cert | tr -d '\n')
MACAROON=$(base64 /var/db/lnd/data/chain/bitcoin/mainnet/admin.macaroon | tr -d '\n')
echo "{ \"cert\": \"$CERT\", \"macaroon\": \"$MACAROON\", \"socket\": \"$LAN_IP:10009\"}"
```

## Importalas a bos-ba

* valassz egy nevet a node azonositasahoz a bos-ban
```
NODE_NAME="something_short"
```
* hozd letre a hitelesito json fajlt
```
mkdir -p ~/.bos/$NODE_NAME/
```
* illeszd be a fent exportalt kapcsolodasi sztringet a `~/.bos/$NODE_NAME/credentials.json` fajlba nano-val, vagy futtasd:
```
echo "{ \"cert\": \"$CERT\", \"macaroon\": \"$MACAROON\", \"socket\": \"$LAN_IP:10009\"}" | tee -a ~/.bos/$NODE_NAME/credentials.json
```

## Futtatas

```
bos peers --node $NODE_NAME
```

## Frissites

```
npm install -g balanceofsatoshis
```

## Futtatas Tor-on keresztul
* Hozd letre a proxy fajlt
```
cat <<EOF >> /root/bos_tor_proxy.json
{
   "host": "127.0.0.1",
   "port": 9050
}
EOF
```
* Futtatas:
```
bos telegram --connect <connection code> --use-proxy /root/bos_tor_proxy.json --use-small-units --node $NODE_NAME
```
