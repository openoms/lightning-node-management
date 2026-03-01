# LND csatlakoztatása a Zeus-hoz (Connecting LND to Zeus)

* Tor cím lekérdezése
    ```
    cat /var/db/tor/remote_connections/hostname
    ```
* Használd a REST portot
    ```
    8080
    ```
* Az admin.macaroon megjelenítése HEX formátumban:
    ```
    hexdump -ve '1/1 "%.2x"'  /var/db/lnd/data/chain/bitcoin/mainnet/admin.macaroon
    ```
