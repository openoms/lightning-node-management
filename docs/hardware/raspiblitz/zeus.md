# Connect LND to Zeus

* Get the Tor address (for mainnet) or use the LAN / VPN address
    ```
    sudo cat /mnt/hdd/tor/lndrest/hostname
    ```
* the REST port for mainnet | tesnet | signet
    ```
    8080 | 18080 | 38080
    ```
* Display the admin.macaroon in HEX:
    ```
    CHAIN=testnet
    hexmacaroon=$(sudo hexdump -ve '1/1 "%.2x"'  /mnt/hdd/lnd/data/chain/bitcoin/${CHAIN}/admin.macaroon)
    echo ${hexmacaroon}
    qr ${hexmacaroon}
    ```
