# Balance of Satoshis FreeBSD-n (Balance of Satoshis on FreeBSD)

## Telepítés (Installation)
```
pkg update -y
pkg install -y node npm nano tmux
npm install -g balanceofsatoshis
```

## A kapcsolódási sztring exportálása (Exporting the Connection String)
```
/bin/sh
pkg install -y base64

LAN_IP=$(ifconfig | grep broadcast | head -1 | awk '{print $2}')
CERT=$(base64 /var/db/lnd/tls.cert | tr -d '\n')
MACAROON=$(base64 /var/db/lnd/data/chain/bitcoin/mainnet/admin.macaroon | tr -d '\n')
echo "{ \"cert\": \"$CERT\", \"macaroon\": \"$MACAROON\", \"socket\": \"$LAN_IP:10009\"}"
```

## Importálás a bos-ba (Importing into bos)

* válassz egy nevet a node azonosításához a bos-ban
```
NODE_NAME="something_short"
```
* hozd létre a hitelesítő json fájlt
```
mkdir -p ~/.bos/$NODE_NAME/
```
* illeszd be a fent exportált kapcsolódási sztringet a `~/.bos/$NODE_NAME/credentials.json` fájlba nano-val, vagy futtasd:
```
echo "{ \"cert\": \"$CERT\", \"macaroon\": \"$MACAROON\", \"socket\": \"$LAN_IP:10009\"}" | tee -a ~/.bos/$NODE_NAME/credentials.json
```

## Futtatás (Running)

```
bos peers --node $NODE_NAME
```

## Frissítés (Updating)

```
npm install -g balanceofsatoshis
```

## Futtatás Tor-on keresztül (Running via Tor)
* Hozd létre a proxy fájlt
```
cat <<EOF >> /root/bos_tor_proxy.json
{
   "host": "127.0.0.1",
   "port": 9050
}
EOF
```
* Futtatás:
```
bos telegram --connect <connection code> --use-proxy /root/bos_tor_proxy.json --use-small-units --node $NODE_NAME
```
