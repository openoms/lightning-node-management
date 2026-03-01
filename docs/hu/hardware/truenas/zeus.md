# LND csatlakoztatasa a Zeus-hoz

* Tor cim lekerdezese
    ```
    cat /var/db/tor/remote_connections/hostname
    ```
* Hasznald a REST portot
    ```
    8080
    ```
* Az admin.macaroon megjelenitese HEX formatumban:
    ```
    hexdump -ve '1/1 "%.2x"'  /var/db/lnd/data/chain/bitcoin/mainnet/admin.macaroon
    ```
