# Balance of Satoshis on FreeBSD

## Install
```
pkg update -y
pkg install -y node npm nano tmux
npm install -g balanceofsatoshis
```

## Export the connection string
```
/bin/sh
pkg install -y base64

LAN_IP=$(ifconfig | grep broadcast | head -1 | awk '{print $2}')
CERT=$(base64 /var/db/lnd/tls.cert | tr -d '\n')
MACAROON=$(base64 /var/db/lnd/data/chain/bitcoin/mainnet/admin.macaroon | tr -d '\n')
echo "{ \"cert\": \"$CERT\", \"macaroon\": \"$MACAROON\", \"socket\": \"$LAN_IP:10009\"}"
```

## Import to bos

* choose a name to identify your node in bos
```
NODE_NAME="something_short"
```
* create a credential json
```
mkdir -p ~/.bos/$NODE_NAME/
```
* paste the connection string exported above to `~/.bos/$NODE_NAME/credentials.json` with nano or run:
```
echo "{ \"cert\": \"$CERT\", \"macaroon\": \"$MACAROON\", \"socket\": \"$LAN_IP:10009\"}" | tee -a ~/.bos/$NODE_NAME/credentials.json
```

## Run

```
bos peers --node $NODE_NAME
```

## Update

```
npm install -g balanceofsatoshis
```

## Running over Tor
* Create the proxy file
```
cat <<EOF >> /root/bos_tor_proxy.json
{
   "host": "127.0.0.1",
   "port": 9050
}
EOF
```
* Run:
```
bos telegram --connect <connection code> --use-proxy /root/bos_tor_proxy.json --use-small-units --node $NODE_NAME
```
