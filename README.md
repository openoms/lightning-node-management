# Lightning Node Management

## Receiving payments

To be able to receive payments on the Lightning Network a node needs:
- "inbound liquidity" which means that some satoshis need to be on the side of the other peer in a channel. 
- The max amount of the incoming payment is determined by the highest incoming liquidity of a single  channel (not additive between channels).
- a channel to a well connected node or a direct channel from the paying peer to make sure there is a possible payment route.

 ## Peer Connections
- To open a channel to any node the peer connection needs to be established first.
- The publicly accessible nodes can be connected to automatically.
- If a node is not publicly accessible the peer connection needs to be initiated manually even if the other peer would want to open a channel.

## Channel size and choosing a peer: 

- There is no hard number, but in general it is recommended to avoid opening channels  below 200K-500K sats.
- https://1ml.com/statistics shows the average channel size on the network:   
0.028 BTC = 2 800 000 satoshis on 2019 May 28.
- A channel too small will result in being unable to close when fees are high. This will leave the channel vulnerable in a case, when the counterparty would try to close with a previous state (the funds in the channel can be cheated out).
- The max amount of the available payment made or routed is determined by the highest liquidity of a single channel (not additive between channels).
- One big channel to a well connected and stable node is more useful than many small ones.
- It is beneficial to connect to nodes where the operator can be contacted in case of a problem.
- Choose a node you know or one from the list: https://1ml.com/node?order=nodeconnectednodecount
- Try a custom list of recommendations for your public node: https://moneni.com/nodematch


## On-chain bitcoin fees
- Opening or closing a Lightning channel is an on-chain bitcoin transaction with the same rules applied.
- The confirmation time depends on the state of the bitcoin mempool (https://jochen-hoenicke.de/queue/#0,24h) and the sats/byte fee used (https://bitcoinfees.earn.com/).
- Check https://whatthefee.io/ for the current estimation of confirmation time/fee.
- Use a custom fee and choose the lowest number with a good chance for an acceptable confirmation time.
- At least 141 bytes need to be covered by fees, but this number is often higher depending on the transaction inputs, script and signatures used.

## Tor nodes
Tor is an anonymizing network designed to hide the participant`s IP adress. Somewhat similar to using a VPN with multiple hops. Learn more at: https://en.wikipedia.org/wiki/Tor_(anonymity_network)

- A Lightning node behind Tor can connect and open a channel to any other node. 
- The nodes running on clearnet are not able to see behind Tor.
- The clearnet node needs to be added as a peer first by the Tor node to be able to open a channel. 
- Once the channel is established the connection will persist, but might take some more time to come back online after either peer restarts.
- If both nodes restart in the same time or the clearnet node`s IP address is changed while both offline the peers need to be added manually again.

## Routing payments:

- Imagine a node `B` in an `A`-`B`-`C` serial connection.
- The channels of `B` are set up so  that there is inbound capacity from `A` and outgoing capacity to `C`.  
- If `A` wants to pay `C` there will be 1 hop in the route.
- Under the hood: `A` sends the satoshis to `B` (the routing node) which will pay to `C`.
- The capacity of the channels do not change, only move.
- The whole payment can only go through if they can send a hash image (a message) through from the other direction first. 
- The process is all or nothing, the payment cannot get stuck en route.

## Lightning Network routing fees

Unlike with on-chain transactions (where the fee is paid for the bytes the transaction takes up in a block) Lightning Network fees are related to the amount routed.
There are two fee components:
* base fee (base_fee_msat). The default is 1000 millisat, which means 1 satoshi fee per every routed payment.
* proportional fee (fee_rate) which is set to the minimum by default in lnd: 0.000001. This means there is an additional 1 sat charged for every million satoshis in the routed payment.

There is no fee in a direct channel between two peers.

To change routing fees of your node use the command:
https://api.lightning.community/#updatechannelpolicy

For example can reduce the base fee to 100 with this command:  
`lncli updatechanpolicy 100 0.000001 144`  
This will result in more payments routed as this route will become cheaper.

the default setting is:  
`lncli updatechanpolicy 1000 0.000001 144`

## Watchtowers

* Read more and how to set one up [here](watchtower.md)

---
## Get inbound liquidity

To make outbound liquidity (to be able to send payments) is easy, you just need to open a channel to well connected, stable node. To make liquidity on existing (outgoing) channels a payment can be made to a merchant or exchange accepting Lightning and receive the product or withdraw on-chain.

### Nodes which connect back:
* **stackingsats [NODL] [TFTC] [RHR]**  
https://1ml.com/node/02d419c9af624d0e7a7c90a60b9ffa35f4934973a9d7d3b4175cc3cc28b7ffcde1  
Will reciprocate channels over 2 000 000 sats.

### [LNBIG.com](https://lnbig.com/#/open-channel)
Free incoming channel with up to 5 000 000 sats from https://twitter.com/lnbig_com

Once there is higher balance on the side of your node an other incoming channel can be requested.

### [LightningTo.me](https://lightningto.me/)
Opens a channel for free funded with 2 000 000 satoshis. Need to have 10 channels open already to use this service.  
Add their node as a peer if connecting from behind Tor:  
`lncli connect 03bb88ccc444534da7b5b64b4f7b15e1eccb18e102db0e400d4b9cfe93763aa26d@138.68.14.104:9735`

### [Tippin.me](https://tippin.me/)
Tip yourself via LN and withdraw on-chain.

### [LightningPowerUsers.com](https://lightningpowerusers.com/home/)
Request inbound capacity for a small fee
Recommended channel size: Between 500 000 and 16 500 000 satoshis.

### [Thor: Lightning Channel-Opening Service by Bitrefill.com](https://www.bitrefill.com/thor-lightning-network-channels/?hl=en)
Pay with Lightning for an inbound channel of up to 16 000 000 satoshis.

### [HodlHodl.com](https://HodlHodl.com)
Now open for trades through Lightning.   Select the LN icon on the menu bar on the top.  
See their [announcement on medium](
https://medium.com/@hodlhodl/lightning-trades-available-on-hodl-hodl-mainnet-78a1f0b60a9f) for details.


### [ZigZag.io](https://zigzag.io/#/)
An exchange that accepts Lightning payments.

### [Lightning Loop](https://github.com/lightninglabs/loop)
Lightning Loop is a non-custodial service offered by Lightning Labs to bridge on-chain and off-chain Bitcoin using submarine swaps. 

In the current iteration of the Loop software, only off-chain to on-chain swaps are supported, where the Loop client sends funds off-chain in exchange for the funds back on-chain. This is called a Loop Out.

https://lightning.engineering/loop/index.html#lightning-loop-grpc-api-reference

---
## Managing channels

The channels are best to be balanced with funds on each side to maximize the ability to accept and route payments.

### [A method to create a balanced channel](BalancedChannelCreation.md)

Open a dual funded, balanced channel with a trusted peer using the command line requiring only one on-chain transaction.

### [lndmanage](https://github.com/bitromortac/lndmanage)
lndmanage is a command line tool for advanced channel management of an LND node written in python.

* Install with:
    
    `$ virtualenv -p python3 ~/.venvs/lndmanage`  
    `$ source ~/.venvs/lndmanage/bin/activate`  
    `$ git clone https://github.com/bitromortac/lndmanage`  
    `$ cd lndmanage`  
    `$ sudo apt install pkg-config libfreetype6-dev python3-dev libatlas-base-dev`  
    `$ pip install -r requirements.txt`  
       
* Config.ini for the RaspiBlitz:

    `$ nano config.ini`

* Fill in as follows:
    ``` 
    # network settings
    [network]
    lnd_grpc_host = 127.0.0.1:10009
    # tls and admin macaroon can be found in .lnd folder
    tls_cert_file = /home/admin/.lnd/tls.cert
    admin_macaroon_file = /home/admin/.lnd/data/chain/bitcoin/mainnet/admin.macaroon

    [logging]
    loglevel = INFO
    ```
* To display the status of the channels:
    
    `$ source ~/.venvs/lndmanage/bin/activate`
    `$ cd lndmanage`  
    `$ /lndmanage.py status`  
    `$ ./lndmanage.py listchannels rebalance` 
    
* Rebalance with:   
    `$ ./lndmanage.py rebalance --max-fee-sat 20 --max-fee-rate 0.00001 CHANNEL_ID --reckless`

### [rebalance-lnd](https://github.com/C-Otto/rebalance-lnd)
Using this python script you can easily rebalance individual channels of your lnd node.
* To use run in the terminal of the lnd node (more options in the [readme](https://github.com/C-Otto/rebalance-lnd/blob/master/README.md#usage)): 
    ```
    $ git clone https://github.com/C-Otto/rebalance-lnd
    $ cd rebalance-lnd
    $ pip install -r requirements.txt
    $ ./rebalance.py -t <channelID-where-to-move-sats> -f <channelID-from-which-to-move-sats> -a <amount-of-sats-to-be-moved>
    ```
---

## Monitoring software

### [RTL - Ride The Lightning](https://github.com/ShahanaFarooqui/RTL)

RTL is a web UI for Lightning Network Daemon.  
https://medium.com/@suheb__/how-to-ride-the-lightning-447af999dcd2

### [ZeusLN](https://zeusln.app/)

A mobile Bitcoin app for Lightning Network Daemon (lnd) node operators. Android and iOS.

### [Zap](https://zap.jackmallers.com/)

A lightning wallet for desktop, iOS and Android.

###  [Joule](https://lightningjoule.com/)

Bring the power of lightning to the web with in-browser payments and identity, all with your own node.   
https://medium.com/lightning-power-users/bitcoin-lightning-joule-chrome-extension-ac149bb05cb9

### [lndash](https://github.com/djmelik/lndash)

lndash is a simple read-only web dashboard for lnd - Lightning Network Daemon.  
Demonstration: https://lightninglayer.com/ 

Features:

* Peer view
* Channel view
* Forwarding Events (routed payments) view
* Looking Glass Tool (route/path lookup)
* Lightning Network Graph

### [lntop](https://github.com/edouardparis/lntop)

lntop is an interactive text-mode channels viewer for Unix systems.

### [lnd-admin](https://github.com/janoside/lnd-admin)

Admin web interface for LND, via gRPC. Built with Node.js, express, bootstrap-v4. Test at: https://lnd-admin.chaintools.io/

### [lndmon](https://github.com/lightninglabs/lndmon)
A drop-in monitoring solution for your lnd node using Prometheus and Grafana. https://blog.lightning.engineering/posts/2019/07/24/lndmon-v0.1.html

### [Spark wallet for C-Lightning](https://github.com/shesek/spark-wallet)

Spark is a minimalistic wallet GUI for c-lightning, accessible over the web or through mobile and desktop apps (for Android, Linux, macOS and Windows). It is currently oriented for technically advanced users and is not an all-in-one package, but rather a "remote control" interface for a c-lightning node that has to be managed separately.

### Lightning network explorers

* [1ml.com](https://1ml.com/)

* [explore.casa](https://explore.casa/)

* [explorer.acinq.co](https://explorer.acinq.co/)

---
## Resources:

* A conceptual review of the Lightning Network: https://dev.lightning.community/overview/index.html#lightning-network

* gRPC API reference documentation for LND
https://api.lightning.community

* Elaine Ou - Bootstrapping and maintaining a Lightning node [38 mins video](https://www.youtube.com/watch?v=qX4Z3JY1094)
and [slides](https://lightningresidency.com/assets/presentations/Ou_Bootstrapping_and_Maintaining_a_Lightning_Node.pdf)

* Alex Bosworth - Lightning channel Management [35 mins video](https://www.youtube.com/watch?v=HlPIB6jt6ww&feature=youtu.be)

* https://medium.com/lightningto-me/practical-solutions-to-inbound-capacity-problem-in-lightning-network-60224aa13393

* A list about How to get Channel Liquidity fast? https://github.com/rootzoll/raspiblitz/issues/395

* A curated list of awesome Lightning Network resources, apps, and libraries https://github.com/bcongdon/awesome-lightning-network  

* Jameson Lopp's curated list of Lightning Network resources https://lightning.how

* https://wiki.ion.radar.tech/tutorials/troubleshooting/bootstrapping-channels

* https://en.wikipedia.org/wiki/Dijkstra's_algorithm

---
## Forums:

* A community managed group for the RaspiBlitz Lightning Node:
https://t.me/raspiblitz  

* LND Developer Slack. Find the invite link on: https://dev.lightning.community/

* A subreddit for Bitcoin and Lightning developers to discuss technical topics: 
https://www.reddit.com/r/lightningdevs   
