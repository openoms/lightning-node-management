This setup is not proved to be working yet. Need to use the clearnet IP of the watchtower even if the nodes are behind Tor.

## Setup for nodes behind Tor

Both nodes (the watchtower and the client) must be behind Tor to be able to communicate.

### Tor Watchtower setup

* Take note of your node's Tor address by copying address after the `@` in the `uris` when running `$ lncli getinfo` (using my example here).

* Change the lnd.conf:  
  ` # nano /mnt/hdd/lnd/lnd.conf`
* insert the lines on the end of the file: 
    ```
    [Watchtower]
    watchtower.active=1
    watchtower.listen=0.0.0.0:9911
    watchtower.externalip=uorbu2ucom46pcrx.onion:9911
    ```

* Edit the Tor config file of the watchtower:  
    `sudo nano /etc/tor/torrc`

    add the lines:
    ```
    # Hidden Service v3 for incoming LND WatchTower connections
    HiddenServiceDir /mnt/hdd/tor/lndWT9911
    HiddenServiceVersion 3
    HiddenServicePort 9911 127.0.0.1:9911
    ```

* restart Tor and lnd with systemctl:  
    `sudo systemctl restart tor`  
    `sudo systemctl restart lnd`

* Take note of the watchtower-pubkey by running `$ lncli tower info`.

### Tor Watchtower Client setup    
* Change the lnd.conf:  
  ` # nano /mnt/hdd/lnd/lnd.conf`
* insert the lines on the end of the file:   

  ```
    [Wtclient] 
    wtclient.private-tower-uris=033b6d3d94b331b3e5d336cc368584bac5600f0376d97f455fa53877faee443272@uorbu2ucom46pcrx.onion:9911
    ```
    * The details of a test node are prefilled. Connections are welcome, but there are no guarantees for this service.
    * Use the `watchtower-pubkey` noted previously from `$ lncli tower info`.
    * The host is the Tor address of the Watchtower node.

* restart lnd with systemctl:  
    `sudo systemctl restart lnd`

* Filter the log continuously with (CTRL+C to exit):  
   `# tail -f -n 10000 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log | grep WT`
    
    Example output on the client side: 

    ```
    2019-07-26 10:30:08.041 [INF] WTCL: Client stats: tasks(received=8 accepted=8 ineligible=0) sessions(acquired=0 exhausted=0)
    2019-07-26 10:30:34.105 [DBG] WTCL: Processing backup(8fd5d5dc97fc6e52da36bd527357a9c87f2a2529379f9f50241e35ab0c95c404, 6315)
    2019-07-26 10:30:34.106 [DBG] WTCL: SessionQueue(026d7b4f4fd7dcdb5a2acce00a8d1cca5bbaeb7e9d89a30ded7d4b62b7b50b3399) deciding to accept backup(8fd5d5dc97fc6e52da36bd527357a9c87f2a2529379f9f50241e35ab0c95c404, 6315) seqnum=0 pending=8 max-updates=1024
    2019-07-26 10:30:34.108 [INF] WTCL: Queued backup(8fd5d5dc97fc6e52da36bd527357a9c87f2a2529379f9f50241e35ab0c95c404, 6315) successfully for session 026d7b4f4fd7dcdb5a2acce00a8d1cca5bbaeb7e9d89a30ded7d4b62b7b50b3399
    2019-07-26 10:31:08.041 [INF] WTCL: Client stats: tasks(received=9 accepted=9 ineligible=0) sessions(acquired=0 exhausted=0)
    ```
