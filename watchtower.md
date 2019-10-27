# Set up a Watchtower and a Client on the Lightning Network

A watchtower monitors the bitcoin blockchain for any transaction attempting to steal from it\`s client by closing a channel with a previous, invalid state. If a breach is found the watchtower immediately broadcasts a punisher transaction moving all funds in the channel to the  on-chain wallet of it\`s client.

If there are two nodes in your control from lnd v0.7.0 you can set them up to look out for each other. Best to be done with nodes in two separate physical location so any unexpected loss of contact can be covered for.

## Update lnd
Check https://github.com/lightningnetwork/lnd/releases/ for the latest version and release notes. Update [manually](https://github.com/lightningnetwork/lnd/blob/master/docs/INSTALL.md#installing-lnd)  or use an [automated helper script](lnd.updates/README.md) to update lnd on a RaspiBlitz or a compatible system.

## Set up the Watchtower
Run the commands in the node\`s terminal  
`#` stands for `$ sudo` 

* Change the lnd.conf:  
  ` # nano /mnt/hdd/lnd/lnd.conf`
* insert the lines on the end of the file:
  ```
  [Watchtower]
  watchtower.active=1
  
  ```
    * the watchtower listens on the port 9911 by default, but can be set to any other unused port with: `watchtower.listen=0.0.0.0:PORT` in the config file.
    * The IP address `0.0.0.0` is used to accept connections from everywhere (default setting)

* allow the port through the firewall:  
` # ufw allow 9911`  
` # ufw enable`

* restart lnd  
  `# systemctl restart lnd`

* forward the port 9911 on the router

* Check in the log if the service is working:  
`# tail -n 10000 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log`  

    Sample log output:
    ```
    2019-06-21 09:08:58.544 [INF] WTWR: Starting watchtower
    2019-06-21 09:08:58.544 [INF] WTWR: Starting lookout
    2019-06-21 09:08:58.544 [INF] WTWR: Starting lookout from chain tip
    2019-06-21 09:08:58.544 [INF] WTWR: Lookout started successfully
    2019-06-21 09:08:58.545 [INF] WTWR: Starting watchtower server
    2019-06-21 09:08:58.544 [INF] DISC: Attempting to bootstrap with: Authenticated Channel Graph
    2019-06-21 09:08:58.545 [INF] CMGR: Server listening on 127.0.0.1:9911
    2019-06-21 09:08:58.545 [INF] NTFN: New block epoch subscription
    2019-06-21 09:08:58.545 [INF] WTWR: Watchtower server started successfully
    2019-06-21 09:08:58.546 [INF] WTWR: Watchtower started successfully
    2019-06-21 09:08:58.547 [INF] CHBU: Swapping old multi backup file from /home/bitcoin/.lnd/data/chain/bitcoin/mainnet/temp-dont-use.backup to /home/bitcoin/.lnd/data/chain/bitcoin/mainnet/channel.backup
    2019-06-21 09:08:58.575 [INF] DISC: Obtained 3 addrs to bootstrap network
    2019-06-21 13:10:27.014 [INF] WTWR: Watchtower started successfully
    2019-06-21 13:14:50.743 [INF] WTWR: Accepted incoming peer 02b5792e533ad17fc77db13093ad84ea304c5069018f97083e3a8c6a2eac95a63f@171.25.193.25:34413
    2019-06-21 13:14:51.074 [INF] WTWR: Accepted session for 02b5792e533ad17fc77db13093ad84ea304c5069018f97083e3a8c6a2eac95a63f
    2019-06-21 13:14:51.074 [INF] WTWR: Releasing incoming peer 02b5792e533ad17fc77db13093ad84ea304c5069018f97083e3a8c6a2eac95a63f@171.25.193.25:34413
    ```

    Filter the relevant messages continuously with (press CTRL+C to exit):  
   `# tail -f -n 10000 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log | grep WTWR`

* Take note of the `pubkey` from:  
    `$ lncli tower info`

    The watchtower\`s pubkey is distinct from the pubkey of the lnd node.


## Set up the node to be monitored (the watchtower client)
* [LND v0.8.0+] Register one or more watchtower(s):
  * Change the lnd.conf:  
    ` # nano /mnt/hdd/lnd/lnd.conf`
  * insert the lines on the end of the file:
    ```
    [Wtclient]
    wtclient.active=1
    ```
  Add a watchtower from the command line (can add multiple one-by-one):
  ```
  $ lncli wtclient add <watchtower-pubkey>@<host>:9911
  ```

* [LND <v0.8.0] Register a watchtower:
  * Change the lnd.conf:  
    ` # nano /mnt/hdd/lnd/lnd.conf`

  * insert the lines on the end of the file:
    ```
    [Wtclient]
    wtclient.private-tower-uris=<watchtower-pubkey>@<host>:9911
    ```
  * Use the `watchtower-pubkey` noted previously from `$ lncli tower info`.
  * For a clearnet client the `host` needs to be the clearnet IP (or dynamicDNS) of the watchtower even if the watchtower is running behind Tor. 

* Restart lnd  
  `# systemctl restart lnd`

* Check in the log if the service is working:  
    `# tail -n 100 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log`  

    Sample log output:
    ```
    2019-06-21 14:14:50.785 [DBG] WTCL: Sending Init to 02a4c564af0f33795b438e8d76d2b5057c3dcd1115be144c3fc05e7c8c65486f23@<host>:9911
    2019-06-21 14:14:51.098 [DBG] WTCL: Received Init from 02a4c564af0f33795b438e8d76d2b5057c3dcd1115be144c3fc05e7c8c65486f23@<host>:9911
    2019-06-21 14:14:51.105 [DBG] WTCL: Sending MsgCreateSession(blob_type=[FlagCommitOutputs|No-FlagReward], max_updates=1024 reward_base=0 reward_rate=0 sweep_fee_rate=12000) to 02a4c564af0f33795b438e8d76d2b5057c3dcd1115be144c3fc05e7c8c65486f23@<host>:9911
    2019-06-21 14:14:51.299 [DBG] WTCL: Received MsgCreateSessionReply(code=0) from 02a4c564af0f33795b438e8d76d2b5057c3dcd1115be144c3fc05e7c8c65486f23@<host>:9911
    2019-06-21 14:14:51.315 [DBG] WTCL: New session negotiated with 02a4c564af0f33795b438e8d76d2b5057c3dcd1115be144c3fc05e7c8c65486f23@<host>:9911, policy: (blob-type=10 max-updates=1024 reward-rate=0 sweep-fee-rate=12000)
    2019-06-21 14:14:51.320 [INF] WTCL: Acquired new session with id=02b5792e533ad17fc77db13093ad84ea304c5069018f97083e3a8c6a2eac95a63f
    2019-06-21 14:14:51.322 [DBG] WTCL: Loaded next candidate session queue id=02b5792e533ad17fc77db13093ad84ea304c5069018f97083e3a8c6a2eac95a63f
    2019-06-21 14:15:16.588 [INF] WTCL: Client stats: tasks(received=0 accepted=0 ineligible=0) sessions(acquired=1 exhausted=0)
    ```

    Filter the relevant messages continuously with (press CTRL+C to exit):  
   `# tail -f -n 10000 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log | grep WTCL`  

    To have more information in the log add the line to the lnd.conf file:
    ```
    debuglevel=WTWR=debug,WTCL=debug
    ```
    or run the command on the go:  
    `lncli debuglevel --level=WTWR=debug,WTCL=debug`  

   Sample result in the log:
    ```
    2019-07-29 15:26:51.386 [DBG] WTWR: Fetching block for (height=587633, hash=0000000000000000000b047fbe6d93c2af193249bdb864a99186914fc4b0b2c6)
    2019-07-29 15:26:52.192 [DBG] WTWR: Scanning 3007 transaction in block (height=587633, hash=0000000000000000000b047fbe6d93c2af193249bdb864a99186914fc4b0b2c6) for breaches
    2019-07-29 15:26:52.301 [DBG] WTWR: No breaches found in (height=587633, hash=0000000000000000000b047fbe6d93c2af193249bdb864a99186914fc4b0b2c6)
    2019-07-29 15:34:17.877 [DBG] WTWR: Fetching block for (height=587634, hash=00000000000000000010615b2c0b3c32cb4ebcb7eb0bd452812f5c48d0edad0c)
    2019-07-29 15:34:18.463 [DBG] WTWR: Scanning 2691 transaction in block (height=587634, hash=00000000000000000010615b2c0b3c32cb4ebcb7eb0bd452812f5c48d0edad0c) for breaches
    2019-07-29 15:34:18.619 [DBG] WTWR: No breaches found in (height=587634, hash=00000000000000000010615b2c0b3c32cb4ebcb7eb0bd452812f5c48d0edad0c)
    ```
Sit back and enjoy that now there is no way to cheat your node even when it is offline!

---

## Setup for nodes behind Tor

Both nodes (the watchtower and the client) must be behind Tor to be able to communicate.

### Tor Watchtower setup

* Change the lnd.conf:  
  ` # nano /mnt/hdd/lnd/lnd.conf`
* insert the lines on the end of the file: 
    ```
    [Watchtower]
    watchtower.active=1
    ```
* Edit the Tor config file of the watchtower:  
    `# nano /etc/tor/torrc`

    add the lines:
    ```
    # Hidden Service for incoming LND WatchTower connections
    HiddenServiceDir /mnt/hdd/tor/lndWT9911
    HiddenServicePort 9911 127.0.0.1:9911
    ```

* restart Tor and lnd with systemctl:  
    `# systemctl restart tor`  
    `# systemctl restart lnd`

* Take note of the watchtower's onion address by running:  
`# cat /mnt/hdd/tor/lndWT9911/hostname`
* Take note of the watchtower-pubkey by running  
`$ lncli tower info`

* Filter the log continuously with (CTRL+C to exit):  
   `# tail -f -n 10000 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log | grep WTWR`
    
    Example output on the watchtower side: 

    ```
    2019-08-20 11:26:30.555 [INF] WTWR: Accepted incoming peer WTCLIENT_PUBKEY@127.0.0.1:57264
    2019-08-20 11:26:30.558 [DBG] WTWR: Received Init from WTCLIENT_PUBKEY@127.0.0.1:57264
    2019-08-20 11:26:30.565 [DBG] WTWR: Sending Init to WTCLIENT_PUBKEY@127.0.0.1:57264
    2019-08-20 11:26:30.931 [DBG] WTWR: Received MsgCreateSession(blob_type=[FlagCommitOutputs|No-FlagReward], max_updates=1024 reward_base=0 reward_rate=0 sweep_fee_rate=2500) from WTCLIENT_PUBKEY@127.0.0.1:57264
    2019-08-20 11:26:30.968 [INF] WTWR: Accepted session for WTCLIENT_PUBKEY
    2019-08-20 11:26:30.968 [DBG] WTWR: Sending MsgCreateSessionReply(code=0) to WTCLIENT_PUBKEY@127.0.0.1:57264
    2019-08-20 11:26:30.981 [INF] WTWR: Releasing incoming peer WTCLIENT_PUBKEY@127.0.0.1:57264
    2019-08-20 11:27:27.260 [DBG] WTWR: Fetching block for (height=590941, hash=000000000000000000069b8d2739cb8736cc6a14927d760a7b7dfa47e1e5059e)
    2019-08-20 11:27:28.464 [DBG] WTWR: Scanning 3621 transaction in block (height=590941, hash=000000000000000000069b8d2739cb8736cc6a14927d760a7b7dfa47e1e5059e) for breaches
    2019-08-20 11:27:28.729 [DBG] WTWR: No breaches found in (height=590941, hash=000000000000000000069b8d2739cb8736cc6a14927d760a7b7dfa47e1e5059e)
    ```

### Tor Watchtower Client setup
* [LND v0.8.0+] Register one or more watchtower(s):
  * Change the lnd.conf:  
    ` # nano /mnt/hdd/lnd/lnd.conf`
  * insert the lines on the end of the file:
    ```
    [Wtclient]
    wtclient.active=1
    ```
  * Add a watchtower from the command line (can add multiple one-by-one):
    ```
    $ lncli wtclient add 02b745aa2c27881f2494978fe76494137f86fef6754e5fd19313670a5bc639ea82@xjyldrwmtxtutdqqhgvxvnykk4ophz6ygr3ci4gxnnt5wibl7k4g2vad.onion:9911
    ```
    * The details of a test node are prefilled. Connections are welcome, but there is no guarantee for this service to stay online.
    * Use the `watchtower-pubkey` noted previously from `$ lncli tower info`.
    * The host is watchtower's .onion address noted previously from: `# cat /mnt/hdd/tor/lndWT9911/hostname`
* [LND <v0.8.0] Register a watchtower:
  * Change the lnd.conf:  
    ` # nano /mnt/hdd/lnd/lnd.conf`

  * insert the lines on the end of the file:
    ```
    [Wtclient]
    wtclient.private-tower-uris=02b745aa2c27881f2494978fe76494137f86fef6754e5fd19313670a5bc639ea82@xjyldrwmtxtutdqqhgvxvnykk4ophz6ygr3ci4gxnnt5wibl7k4g2vad.onion:9911
    ```
    * The details of a test node are prefilled. Connections are welcome, but there is no guarantee for this service to stay online.
    * Use the `watchtower-pubkey` noted previously from `$ lncli tower info`.
    * The host is watchtower's .onion address noted previously from: `# cat /mnt/hdd/tor/lndWT9911/hostname`
    
* restart lnd with systemctl:  
    `# systemctl restart lnd`

* Filter the log continuously with (CTRL+C to exit):  
   `# tail -f -n 10000 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log | grep WTCL`
    
    Example output on the client side: 

    ```
    2019-07-26 10:30:08.041 [INF] WTCL: Client stats: tasks(received=8 accepted=8 ineligible=0) sessions(acquired=0 exhausted=0)
    2019-07-26 10:30:34.105 [DBG] WTCL: Processing backup(8fd5d5dc97fc6e52da36bd527357a9c87f2a2529379f9f50241e35ab0c95c404, 6315)
    2019-07-26 10:30:34.106 [DBG] WTCL: SessionQueue(026d7b4f4fd7dcdb5a2acce00a8d1cca5bbaeb7e9d89a30ded7d4b62b7b50b3399) deciding to accept backup(8fd5d5dc97fc6e52da36bd527357a9c87f2a2529379f9f50241e35ab0c95c404, 6315) seqnum=0 pending=8 max-updates=1024
    2019-07-26 10:30:34.108 [INF] WTCL: Queued backup(8fd5d5dc97fc6e52da36bd527357a9c87f2a2529379f9f50241e35ab0c95c404, 6315) successfully for session 026d7b4f4fd7dcdb5a2acce00a8d1cca5bbaeb7e9d89a30ded7d4b62b7b50b3399
    2019-07-26 10:31:08.041 [INF] WTCL: Client stats: tasks(received=9 accepted=9 ineligible=0) sessions(acquired=0 exhausted=0)
    ```

---
## More info: 
https://github.com/lightningnetwork/lnd/blob/master/docs/watchtower.md

Latest lnd release notes:
https://github.com/lightningnetwork/lnd/releases

https://thebitcoinnews.com/watchtowers-are-coming-to-lightning/

https://bitcoinops.org/en/newsletters/2019/06/19/

Will O`Beirne shows in this article (and GitHub repo) how to demonstrate a breach and the actions of a watchtower on a simulated network: https://medium.com/@wbobeirne/testing-out-watchtowers-with-a-simulated-breach-f1ad22c01112

SLP83 Conner Fromknecht – Bitcoin Lightning Watchtowers in depth  
podcast: https://stephanlivera.com/episode/83  
transcript: http://diyhpl.us/wiki/transcripts/stephan-livera-podcast/2019-06-24-conner-fromknecht-stephan-livera/

Check for some altruistic watchtowers and share your own: https://github.com/openoms/lightning-node-management/issues/4
