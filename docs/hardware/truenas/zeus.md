# Connect LND to Zeus

* Get the Tor address
    ```
    cat /var/db/tor/remote_connections/hostname
    ```
* Use the REST port
    ```
    8080
    ```
* Display the admin.macaroon in HEX:
    ```
    hexdump -ve '1/1 "%.2x"'  /var/db/lnd/data/chain/bitcoin/mainnet/admin.macaroon
    ```