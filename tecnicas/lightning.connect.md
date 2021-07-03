# Conectarse a un nodo Lightning de forma remota

* [Resumen de formatos de conexión remota](lightning.connect.md#remote-connection-formats-summary-table)
* [LND](lightning.connect.md#lnd)
  * [RPC](lightning.connect.md#rpc)
  * [LNDconnect](lightning.connect.md#lndconnect)
  * [Balance of Satoshis](lightning.connect.md#balance-of-satoshis)
  * [BTCPayserver](lightning.connect.md#btcpayserver)
* [C-lightning](lightning.connect.md#c-lightning)
  * [Spark Wallet](lightning.connect.md#spark-wallet)
  * [Sparko](lightning.connect.md#sparko)
  * [C-lightning REST \(con Zeus\)](lightning.connect.md#c-lightning-rest-with-zeus)
  * [BTCPayserver](lightning.connect.md#btcpayserver-1)
* [Eclair](lightning.connect.md#eclair)
  * [BTCPayServer](lightning.connect.md#btcpayserver-2)
* [Notas](lightning.connect.md#notes)

## Resumen de formatos de conexión remota

| LND | prefix | d | server | d | auth | d | tls | d |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| lndconnect | lndconnect:// |  | grpc\_host:10009 | ? | macaroon=base64\_macaroon | & | cert=base64\_cert |  |
| BoS |  | { | "socket": "grpc\_host:10009" | , | "macaroon": "base64\_macaroon" | , | "cert": "base64\_cert" | } |
| BTCPay | type=lnd-rest | ; | [https://rest\_host:8080/](https://rest_host:8080/) | ; | macaroon=hex\_macaroon | ; | certthumbprint=hex\_cert |  |

| C-lightning | prefix | d | server | d | auth | d | tls |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Spark Wallet / Sparko |  |  | spark\_rpc\_host | ? | access-key=accessKey |  |  |
| BTCPay unix socket | type=clightning | ; | server=unix://home/user/.lightning/lightning-rpc |  |  |  |  |
| BTCPay TCP | type=clightning | ; | server=tcp://tcp\_host:27743/ |  |  |  |  |
| BTCPay Charge | type=clightning | ; | server=[https://charge\_host:8080/](https://charge_host:8080/) | ; | api-token=myapitoken... |  |  |
| C-lightning REST |  |  | rest\_host | ? | hex\_macaroon |  |  |

| Eclair | prefix | d | server | d | auth | d | tls |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| BTCPay | type=eclair | ; | server=[https://eclair\_host:8080/](https://eclair_host:8080/) | ; | password=eclairpassword... |  |  |

## LND

### RPC

* lncli

  ```text
  lncli --rpcserver=IP_ADDRESS:GRPC_PORT --tlscertpath=./../tls.cert --macaroonpath=./../admin.macaroon
  ```

* Suez [https://github.com/prusnak/suez](https://github.com/prusnak/suez)

```text
poetry run ./suez --client-args=--rpcserver=IP_ADDRESS:GRPC_PORT --client-args=--tlscertpath=./../tls.cert --client-args=--macaroonpath=./../admin.macaroon
```

### LNDconnect

* Especificación  

  [https://github.com/LN-Zap/lndconnect/blob/master/lnd\_connect\_uri.md](https://github.com/LN-Zap/lndconnect/blob/master/lnd_connect_uri.md)

```text
lndconnect://<host>:<port>?[cert=<base64url DER certifcate>&]macaroon=<base64url macaroon>
```

* Implementación  

  [https://github.com/rootzoll/raspiblitz/blob/a22589c86109d56ecc1e1aca7abb214c7e9189c7/home.admin/config.scripts/bonus.lndconnect.sh\#L194](https://github.com/rootzoll/raspiblitz/blob/a22589c86109d56ecc1e1aca7abb214c7e9189c7/home.admin/config.scripts/bonus.lndconnect.sh#L194)

```text
# generate data parts
macaroon=$(sudo base64 /mnt/hdd/app-data/lnd/data/chain/${network}/${chain}net/admin.macaroon | tr -d '=' | tr '/+' '_-' | tr -d '\n')
cert=$(sudo grep -v 'CERTIFICATE' /mnt/hdd/lnd/tls.cert | tr -d '=' | tr '/+' '_-' | tr -d '\n')

# generate URI parameters
macaroonParameter="?macaroon=${macaroon}"
certParameter="&cert=${cert}"

lndconnect="lndconnect://${host}:${port}${macaroonParameter}${certParameter}"
```

### Balance of Satoshis

[https://github.com/alexbosworth/balanceofsatoshis\#saved-nodes](https://github.com/alexbosworth/balanceofsatoshis#saved-nodes)

* guardado en

  ```text
  ~/.bos/YOUR_NODE_NAME/credentials.json
  ```

* con valores base64

```text
{
"cert": "base64 tls.cert value",
"macaroon": "base64 .macaroon value",
"socket": "host:port"
}

# For `cert`
base64 ~/.lnd/tls.cert | tr -d '\n'
# For `macaroon`
base64 ~/.lnd/data/chain/bitcoin/mainnet/admin.macaroon | tr -d '\n'
```

* con path

  ```text
  {
  "cert_path": "/path/lnd/tls.cert",
  "macaroon_path": "/path/lnd/data/chain/bitcoin/mainnet/admin.macaroon",
  "socket": "LND_IP:10009"
  }
  ```

### BTCPayserver

* LND a través de proxy REST:

  ```text
  type=lnd-rest;server=https://mylnd:8080/;macaroon=abef263adfe...
  type=lnd-rest;server=https://mylnd:8080/;macaroon=abef263adfe...;certthumbprint=abef263adfe...
  ```

* macaroon

  ```text
  xxd -plain /root/.lnd/data/chain/bitcoin/mainnet/admin.macaroon | tr -d '\n'
  ```

* certthumbprint:

  ```text
  openssl x509 -noout -fingerprint -sha256 -in /root/.lnd/tls.cert | sed -e 's/.*=//;s/://g'
  ```

* optional:

  ```text
  allowinsecure=true
  ```

## C-lightning

### Spark Wallet

[https://github.com/shesek/spark-wallet](https://github.com/shesek/spark-wallet)

### Sparko

[https://github.com/fiatjaf/sparko](https://github.com/fiatjaf/sparko)  
Actualmente solo funciona con un certificado firmado por una CA.  
Ver: [https://github.com/shesek/spark-wallet/blob/master/doc/tls.md\#add-as-trusted-certificate-to-android](https://github.com/shesek/spark-wallet/blob/master/doc/tls.md#add-as-trusted-certificate-to-android)

* Simplemente:

  ```text
  URL?access-key=accessKey
  ```

  El `accessKey` tiene permisos parecidos a macaroon

### C-lightning REST \(con Zeus\)

[https://github.com/Ride-The-Lightning/c-lightning-REST/](https://github.com/Ride-The-Lightning/c-lightning-REST/)

* Aún no hay estándar, pero necesita:

  ```text
  URL?hex_macaroon
  ```

* generar el `hex_macaroon`:

  ```text
  xxd -plain /home/bitcoin/c-lightning-REST/certs/access.macaroon | tr -d '\n'
  ```

### BTCPayserver

* c-lightning a través TCP o una conexión unix domain socket:

  ```text
  type=clightning;server=unix://root/.lightning/lightning-rpc
  type=clightning;server=tcp://1.1.1.1:27743/
  ```

* Lightning carga a través de HTTPS:

  ```text
  type=charge;server=https://charge:8080/;api-token=myapitoken...
  ```

## Eclair

### BTCPayServer

* Eclair a través de HTTPS:

  ```text
  type=eclair;server=https://eclair:8080/;password=eclairpassword...
  ```

## Notas

* dependencias comunes

  ```text
  sudo apt install qrencode base64 xxd
  ```

* generar un código QR en la consola  
  \(presione `CTRL` + `-` para reducir el tamaño\)

  ```text
  string="desired content or $(command output)"
  qrencode -t ANSIUTF8 "$string"
  ```

* base64\_macaroon

  ```text
  base64 ~/.lnd/data/chain/bitcoin/mainnet/admin.macaroon | tr -d '\n'
  ```

* hex\_macaroon:

  ```text
  xxd -plain /home/bitcoin/c-lightning-REST/certs/access.macaroon | tr -d '\n'
  ```

* base64\_cert

  ```text
  base64 ~/.lnd/tls.cert | tr -d '\n'
  ```

* certthumbprint:

  ```text
  openssl x509 -noout -fingerprint -sha256 -in /root/.lnd/tls.cert | sed -e 's/.*=//;s/://g'
  ```

* inspeccionar `tls.cert`

  ```text
  openssl x509 -in /mnt/hdd/lnd/tls.cert -noout -text
  ```

* mostrar un servicio oculto de Tor más en: [https://openoms.github.io/bitcoin-tutorials/tor\_hidden\_service\_example.html](https://openoms.github.io/bitcoin-tutorials/tor_hidden_service_example.html)

  ```text
  sudo cat /var/lib/tor/SERVICE_NAME/hostname
  # o en un RaspiBlitz
  sudo cat /mnt/hdd/tor/SERVICE_NAME/hostname
  ```

