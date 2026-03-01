# LND csatlakoztatása a Zeus-hoz (Connecting LND to Zeus)

* Szerezd meg a Tor címet (mainnet esetén), vagy használd a LAN / VPN címet
    ```
    sudo cat /mnt/hdd/tor/lndrest/hostname
    ```
* A REST port mainnet | testnet | signet esetén
    ```
    8080 | 18080 | 38080
    ```
* Az admin.macaroon megjelenítése HEX formátumban:
    ```
    CHAIN=testnet
    hexmacaroon=$(sudo hexdump -ve '1/1 "%.2x"'  /mnt/hdd/lnd/data/chain/bitcoin/${CHAIN}/admin.macaroon)
    echo ${hexmacaroon}
    qr ${hexmacaroon}
    ```
