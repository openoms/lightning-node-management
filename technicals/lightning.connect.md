<!-- omit in toc -->
# Lightning-connect
- [Resumen de formatos de conexión remota](#remote-connection-formats-summary-table)
- [LND](#lnd)
  - [RPC](#rpc)
  - [LNDconnect](#lndconnect)
  - [Balance of Satoshis](#balance-of-satoshis)
  - [BTCPayserver](#btcpayserver)
- [C-lightning](#c-lightning)
  - [Spark Wallet](#spark-wallet)
  - [Sparko](#sparko)
  - [C-lightning REST (con Zeus)](#c-lightning-rest-with-zeus)
  - [BTCPayserver](#btcpayserver-1)
- [Eclair](#eclair)
  - [BTCPayServer](#btcpayserver-2)
- [Notas](#notes)

## Resumen de formatos de conexión remota

|LND | prefix | d | server | d | auth | d | tls | d|
--- | --- | --- | --- | --- | --- | --- | --- | ---
|lndconnect | lndconnect:// || grpc_host:10009 |?| macaroon=base64_macaroon |&| cert=base64_cert|
|BoS ||{| "socket": "grpc_host:10009" |,| "macaroon": "base64_macaroon" |,| "cert": "base64_cert" |}|
|BTCPay | type=lnd-rest |;| https://rest_host:8080/ |;| macaroon=hex_macaroon |;|certthumbprint=hex_cert|


|C-lightning | prefix | d | server | d | auth | d | tls|
--- | --- | --- | --- | --- | --- | --- | ---
|Spark Wallet / Sparko ||| spark_rpc_host | ? | access-key=accessKey|
|BTCPay unix socket | type=clightning |;| server=unix://home/user/.lightning/lightning-rpc|
|BTCPay TCP| type=clightning |;| server=tcp://tcp_host:27743/|
|BTCPay Charge | type=clightning |;| server=https://charge_host:8080/ |;| api-token=myapitoken...|
|C-lightning REST ||| rest_host | ? | hex_macaroon|

|Eclair | prefix | d   | server | d   | auth | d   | tls|
---     | ---    | --- | ---    | --- | ---  | --- | ---
|BTCPay |type=eclair |;| server=https://eclair_host:8080/ |;| password=eclairpassword...|


## LND

### RPC

* lncli
```
lncli --rpcserver=IP_ADDRESS:GRPC_PORT --tlscertpath=./../tls.cert --macaroonpath=./../admin.macaroon
```

* Suez  
  https://github.com/prusnak/suez

```
poetry run ./suez --client-args=--rpcserver=IP_ADDRESS:GRPC_PORT --client-args=--tlscertpath=./../tls.cert --client-args=--macaroonpath=./../admin.macaroon
```

### LNDconnect
* Especificación  
<https://github.com/LN-Zap/lndconnect/blob/master/lnd_connect_uri.md>

```
lndconnect://<host>:<port>?[cert=<base64url DER certifcate>&]macaroon=<base64url macaroon>
```

* Implementación  
<https://github.com/rootzoll/raspiblitz/blob/a22589c86109d56ecc1e1aca7abb214c7e9189c7/home.admin/config.scripts/bonus.lndconnect.sh#L194>

```
# generate data parts
macaroon=$(sudo base64 /mnt/hdd/app-data/lnd/data/chain/${network}/${chain}net/admin.macaroon | tr -d '=' | tr '/+' '_-' | tr -d '\n')
cert=$(sudo grep -v 'CERTIFICATE' /mnt/hdd/lnd/tls.cert | tr -d '=' | tr '/+' '_-' | tr -d '\n')

# generate URI parameters
macaroonParameter="?macaroon=${macaroon}"
certParameter="&cert=${cert}"

lndconnect="lndconnect://${host}:${port}${macaroonParameter}${certParameter}"
```

### Balance of Satoshis
https://github.com/alexbosworth/balanceofsatoshis#saved-nodes
* guardado en
```
~/.bos/YOUR_NODE_NAME/credentials.json
```

* con valores base64

```
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
```
{
"cert_path": "/path/lnd/tls.cert",
"macaroon_path": "/path/lnd/data/chain/bitcoin/mainnet/admin.macaroon",
"socket": "LND_IP:10009"
}
```

### BTCPayserver

* LND a través de proxy REST:
```
type=lnd-rest;server=https://mylnd:8080/;macaroon=abef263adfe...
type=lnd-rest;server=https://mylnd:8080/;macaroon=abef263adfe...;certthumbprint=abef263adfe...
```

* macaroon
```
xxd -plain /root/.lnd/data/chain/bitcoin/mainnet/admin.macaroon | tr -d '\n'
```

* certthumbprint:
```
openssl x509 -noout -fingerprint -sha256 -in /root/.lnd/tls.cert | sed -e 's/.*=//;s/://g'
```

* optional:
```  
allowinsecure=true
```

## C-lightning

### Spark Wallet  
https://github.com/shesek/spark-wallet  
### Sparko
https://github.com/fiatjaf/sparko  
Actualmente solo funciona con un certificado firmado por una CA.  
Ver: <https://github.com/shesek/spark-wallet/blob/master/doc/tls.md#add-as-trusted-certificate-to-android>


* Simplemente:
```
URL?access-key=accessKey
```
El `accessKey` tiene permisos parecidos a macaroon

### C-lightning REST (con Zeus)
https://github.com/Ride-The-Lightning/c-lightning-REST/
* Aún no hay estándar, pero necesita:
```
URL?hex_macaroon
```

* generar el `hex_macaroon`:
```
xxd -plain /home/bitcoin/c-lightning-REST/certs/access.macaroon | tr -d '\n'
```

### BTCPayserver
* c-lightning a través TCP o una conexión unix domain socket:
```
type=clightning;server=unix://root/.lightning/lightning-rpc
type=clightning;server=tcp://1.1.1.1:27743/
```

* Lightning carga a través de HTTPS:
```
type=charge;server=https://charge:8080/;api-token=myapitoken...
```

## Eclair

### BTCPayServer
* Eclair a través de HTTPS:
```
type=eclair;server=https://eclair:8080/;password=eclairpassword...
```


## Notas

* dependencias comunes
```
sudo apt install qrencode base64 xxd
```

* generar un código QR en la consola  
(presione `CTRL` + `-` para reducir el tamaño)
```
string="desired content or $(command output)"
qrencode -t ANSIUTF8 "$string"
```

* base64_macaroon
```
base64 ~/.lnd/data/chain/bitcoin/mainnet/admin.macaroon | tr -d '\n'
```

* hex_macaroon:
```
xxd -plain /home/bitcoin/c-lightning-REST/certs/access.macaroon | tr -d '\n'
```

* base64_cert
```
base64 ~/.lnd/tls.cert | tr -d '\n'
```
* certthumbprint:
```
openssl x509 -noout -fingerprint -sha256 -in /root/.lnd/tls.cert | sed -e 's/.*=//;s/://g'
```

* inspeccionar `tls.cert`
```
openssl x509 -in /mnt/hdd/lnd/tls.cert -noout -text
```

* mostrar un servicio oculto de Tor
más en: [https://openoms.github.io/bitcoin-tutorials/tor_hidden_service_example.html](https://openoms.github.io/bitcoin-tutorials/tor_hidden_service_example.html)
```
sudo cat /var/lib/tor/SERVICE_NAME/hostname
# o en un RaspiBlitz
sudo cat /mnt/hdd/tor/SERVICE_NAME/hostname
```
