# Set up a Watchtower and a Client on the Lightnig Network

A watchtower monitors the bitcoin blockchain for any transaction attempting to steal from it\`s client by closing a channel with a previous, invalid state. If a breach is found the watchtower immediately broadcasts a punisher transaction moving all funds in the channel to it\`s client onchain wallet.

If there are two nodes in your control from lnd v0.7.0 you can set them up to look out for each other. Best to be done with nodes in two separate physical location so any unexpected loss of contact can be covered for.

## Update lnd
Check https://github.com/lightningnetwork/lnd/releases/ for the latest version. Update manually or use this [automated helper script](https://github.com/openoms/bitcoin-tutorials/blob/master/lnd.update.v0.7.0-beta-rc2.sh) to update lnd on a RaspiBlitz or a compatible system. To run the update use this command in the RaspiBlitz terminal:  

`$ wget https://raw.githubusercontent.com/openoms/bitcoin-tutorials/master/lnd.update.v0.7.0-beta-rc2.sh && sudo bash lnd.update.v0.7.0-beta-rc2.sh`

## Set up the Watchtower
Run the commands in the node\`s terminal  
`#` stands for `$ sudo` 

* Change the lnd.conf:  
  ` # nano /mnt/hdd/lnd/lnd.conf`
* insert the lines on the end of the file:
  ```
  [Watchtower]
  watchtower.listen=0.0.0.0:8735
  watchtower.active=1
  ```
    * The IP address `0.0.0.0` is used to accept connections from everywhere
    * the port 8735 is chosen arbitrarily - can be any other unused port  

* allow the port through the firewall:  
` # ufw allow 8735`  
` # ufw enable`

* restart lnd

  `# systemctl restart lnd`

* forward the port 8735 on the router

* Check in the log if the service is working: 

    `# tail -n 1000 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log`  

    Sample log output:

    ```
    2019-06-21 09:08:58.544 [INF] WTWR: Starting watchtower
    2019-06-21 09:08:58.544 [INF] WTWR: Starting lookout
    2019-06-21 09:08:58.544 [INF] WTWR: Starting lookout from chain tip
    2019-06-21 09:08:58.544 [INF] WTWR: Lookout started successfully
    2019-06-21 09:08:58.545 [INF] WTWR: Starting watchtower server
    2019-06-21 09:08:58.544 [INF] DISC: Attempting to bootstrap with: Authenticated Channel Graph
    2019-06-21 09:08:58.545 [INF] CMGR: Server listening on 127.0.0.1:8735
    2019-06-21 09:08:58.545 [INF] NTFN: New block epoch subscription
    2019-06-21 09:08:58.545 [INF] WTWR: Watchtower server started successfully
    2019-06-21 09:08:58.546 [INF] WTWR: Watchtower started successfully
    2019-06-21 09:08:58.547 [INF] CHBU: Swapping old multi backup file from /home/bitcoin/.lnd/data/chain/bitcoin/mainnet/temp-dont-use.backup to /home/bitcoin/.lnd/data/chain/bitcoin/mainnet/channel.backup
    2019-06-21 09:08:58.575 [INF] DISC: Obtained 3 addrs to bootstrap network
    ```

    Filter the relevant messages continuously with:  
   `# tail -n 1000 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log | grep WTWR`

* Take note of the `node pubkey` and `host` address`:  
    `$ lncli getinfo`


## Set up the node to be monitored (the watchtower client)
* Change the lnd.conf:  
  ` # nano /mnt/hdd/lnd/lnd.conf`

* insert the lines on the end of the file:
  ```
  [Wtclient]
  wtclient.private-tower-uris=<watchtower-pubkey>@<host>:8735
  ```
    * Use the `node pubkey` noted previously as the `watchtower-pubkey`.  
    * Use the clearnet IP address as the `host` even if the watchtower node is running behind Tor. Similar to when connecting a mobile application your node a dynamicDNS can be used as well.

* Restart lnd

  `# systemctl restart lnd`

* Check in the log if the service is working: 

    `# tail -n 100 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log`  

    Sample log output:
    ```
    2019-06-21 14:14:50.785 [DBG] WTCL: Sending Init to 02a4c564af0f33795b438e8d76d2b5057c3dcd1115be144c3fc05e7c8c65486f23@<watchtower-pubkey>:8735
    2019-06-21 14:14:51.098 [DBG] WTCL: Received Init from 02a4c564af0f33795b438e8d76d2b5057c3dcd1115be144c3fc05e7c8c65486f23@<watchtower-pubkey>:8735
    2019-06-21 14:14:51.105 [DBG] WTCL: Sending MsgCreateSession(blob_type=[FlagCommitOutputs|No-FlagReward], max_updates=1024 reward_base=0 reward_rate=0 sweep_fee_rate=12000) to 02a4c564af0f33795b438e8d76d2b5057c3dcd1115be144c3fc05e7c8c65486f23@<watchtower-pubkey>:8735
    2019-06-21 14:14:51.299 [DBG] WTCL: Received MsgCreateSessionReply(code=0) from 02a4c564af0f33795b438e8d76d2b5057c3dcd1115be144c3fc05e7c8c65486f23@<watchtower-pubkey>:8735
    2019-06-21 14:14:51.315 [DBG] WTCL: New session negotiated with 02a4c564af0f33795b438e8d76d2b5057c3dcd1115be144c3fc05e7c8c65486f23@<watchtower-pubkey>:8735, policy: (blob-type=10 max-updates=1024 reward-rate=0 sweep-fee-rate=12000)
    2019-06-21 14:14:51.320 [INF] WTCL: Acquired new session with id=02b5792e533ad17fc77db13093ad84ea304c5069018f97083e3a8c6a2eac95a63f
    2019-06-21 14:14:51.322 [DBG] WTCL: Loaded next candidate session queue id=02b5792e533ad17fc77db13093ad84ea304c5069018f97083e3a8c6a2eac95a63f
    2019-06-21 14:15:16.588 [INF] WTCL: Client stats: tasks(received=0 accepted=0 ineligible=0) sessions(acquired=1 exhausted=0)
    2019-06-21 13:10:27.014 [INF] WTWR: Watchtower started successfully
    2019-06-21 13:14:50.743 [INF] WTWR: Accepted incoming peer 02b5792e533ad17fc77db13093ad84ea304c5069018f97083e3a8c6a2eac95a63f@171.25.193.25:34413
    2019-06-21 13:14:51.074 [INF] WTWR: Accepted session for 02b5792e533ad17fc77db13093ad84ea304c5069018f97083e3a8c6a2eac95a63f
    2019-06-21 13:14:51.074 [INF] WTWR: Releasing incoming peer 02b5792e533ad17fc77db13093ad84ea304c5069018f97083e3a8c6a2eac95a63f@171.25.193.25:34413
    ```

    Filter the relevant messages continuously with:  
   `# tail -n 1000 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log | grep WTCL`


Sit back and enjoy that now there is no way to cheat your node even if it goes offline!

---
## More info: 
https://github.com/lightningnetwork/lnd/pull/3133

https://thebitcoinnews.com/watchtowers-are-coming-to-lightning/

https://bitcoinops.org/en/newsletters/2019/06/19/

Will O`Beirne shows in this article (and GitHub repo) how to demonstrate a breach and the actions of a watchtower on a simulated network: https://medium.com/@wbobeirne/testing-out-watchtowers-with-a-simulated-breach-f1ad22c01112
