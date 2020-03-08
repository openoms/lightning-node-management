# Lightning Node Management

## Peer connections and channels
- Peers are the nodes connected to each other through the internet (TCP/IP layer). 
- A channel is a payment channel between two peers established on the Lightning Network.
- To open a channel to any node the peer connection needs to be established first.
- The publicly accessible nodes can be connected to automatically.
- If a node is not publicly accessible the peer connection needs to be initiated manually from the non-public side even if the other peer is opening the channel.

## Receiving payments

To be able to receive payments on the Lightning Network a node needs:
- "inbound liquidity" (aka remote balance) which means that some satoshis need to be on the side of the other peer in a channel. 
- a channel to a well connected node or a direct channel from the paying peer to make sure there is a possible payment route.

The max amount of the incoming payment is determined by the highest inbound liquidity of a single  channel (not additive between channels).

## Channel size and choosing a peer 

- There is no hard number, but in general it is recommended to avoid opening channels  below 200K-500K sats.
- <https://1ml.com/statistics> shows the average channel size on the network:   
0.028 BTC = 2 800 000 satoshis on 2019 May 28.
- A channel too small will result in being unable to close when on-chain fees are high. This will leave the channel vulnerable in a case, when the counterparty would try to close with a previous state (the funds in the channel can be cheated out).
- The max size of the available payment made or routed is determined by the highest directional liquidity of a single channel (not additive between channels).
- One big channel to a well connected and stable node is more useful than many small ones.
- It is beneficial to connect to nodes where the operator can be contacted in case of a problem.
- Choose a node you know or one from the list: <https://1ml.com/node?order=nodeconnectednodecount>
- Try a custom list of recommendations for your public node: <https://moneni.com/nodematch>

## On-chain bitcoin fees
- Opening or closing a Lightning channel is an on-chain bitcoin transaction (settled on the blockchain)
- The confirmation time depends on the state of the bitcoin mempool (<https://jochen-hoenicke.de/queue/#0,24h>) and the sats/byte fee used (<https://bitcoinfees.earn.com/>).
- Check <https://whatthefee.io/> for the current estimation of confirmation time/fee.
- Use a custom fee and choose the lowest number with a good chance for an acceptable confirmation time.
- At least 141 bytes need to be covered by fees, but this number is often higher depending on the transaction inputs, script and signatures used.

## Tor nodes
Tor is an anonymizing network designed to hide the participant`s IP adress. Somewhat similar to using a VPN with multiple hops. Learn more at: <https://en.wikipedia.org/wiki/Tor_(anonymity_network)>

- A Lightning node behind Tor can connect and open a channel to any other node. 
- The nodes running on clearnet are not able to see behind Tor.
- The clearnet node needs to be added as a peer first by the Tor node to be able to open a channel. 
- Once the channel is established the connection will persist, but might take some more time to come back online after either peer restarts.
- If both nodes restart in the same time or the clearnet node`s IP address is changed while both offline the peer connection need to be added manually again.

## Routing payments:

- Imagine a node `B` in an `A`-`B`-`C` serial connection.
- The channels of `B` are set up so  that there is inbound capacity (remote balance) from `A` and outgoing capacity (local balance) to `C`.  
- If `A` wants to pay `C` there will be 1 hop in the route.
- Under the hood: `A` sends the satoshis to `B` (the routing node) which will pay to `C`.
- The capacity of the channels do not change, only move.
- The whole payment can only go through if they can send a hash image (a message) through from the other direction first.
- The process is all or nothing, the payment cannot get stuck en route.

## Lightning Network routing fees

Unlike with on-chain transactions (where the fee is paid for the bytes the transaction takes up in a block) Lightning Network fees are related to the amount routed.
There are two fee components:
* base fee (base_fee_msat). The default is 1000 millisat, which means 1 satoshi fee per every routed payment.
* proportional fee (fee_rate) which is by default in lnd: 0.000001. This means there is an additional 1 sat charged for every million satoshis in the routed payment.

There is no LN fee for payments in a direct channel between two peers.

To change routing fees of your node use the command:
<https://api.lightning.community/#updatechannelpolicy>

* Can reduce the base fee to 500 msat and increase the proportinal fee to 100ppm/0.01% with this command:  
`$ lncli updatechanpolicy 500 0.0001 144`  

* the default setting is (1 sat per payment + 1 ppm/0.0001%):  
`$ lncli updatechanpolicy 1000 0.000001 144`

It is important to increase the routing fee for any expensive channels so rebalancing or closure is paid for if payments are routed that way.
Check the routing fees of the peers on [1ml.com](https://1ml.com/) or in [lndmanage](#lndmanage).

Setting the fees for individual channels takes only one click in the [RTL app](#RTL---Ride-The-Lightning).

## Watchtowers

Read more and how to set one up [here](watchtower.md)

---
## Getting inbound liquidity

To make outbound liquidity (to be able to send payments) is easy, you just need to open a channel to a well connected, stable node. 

To make inbound liquidity (to be able to receive payments on a channel you opened) a payment can be sent to a merchant or exchange accepting Lightning and receive the product or receive the sats back on-chain.

### Non-custodial wallets
Run a separate LN node on your phone or desktop where you can move some funds, so remote balance/ inbound liquidity is created
* [Breez](https://breez.technology/)  
A mobile wallet which creates a 1 million sats incoming channel automatically, so funds can be moved over in minutes after setting up.  
Sending the funds out to a bitcoin address on-chain costs 0.5% with [Boltz](https://boltz.exchange/)
* [Zap](https://zap.jackmallers.com/)   
Run a Lightning Node on Android, iOS or desktop. Channels are managed manually or by the autopilot.
* [Lightning App by Lightning Labs](https://github.com/lightninglabs/lightning-app)  
An easy-to-use cross platform lightning wallet
### Custodial wallets
Tip yourself via LN and benefit from the inbound liquidity created.
The drawback is that you don`t control the seed of your custodial wallet.  
Examples:  
* [Tippin.me](https://tippin.me/)
* [Wallet of Satoshi](https://www.walletofsatoshi.com/)
* [Bluewallet](https://bluewallet.io/)

### [LightningTo.me](https://lightningto.me/)
Opens a channel for free funded with 2 000 000 satoshis. Need to have 10 channels open already to use this service.  
Add their node as a peer if connecting from behind Tor:  
`$ lncli connect 03bb88ccc444534da7b5b64b4f7b15e1eccb18e102db0e400d4b9cfe93763aa26d@138.68.14.104:9735`

### [LightningPowerUsers.com](https://lightningpowerusers.com/home/)
Request inbound capacity for a small fee
Recommended channel size: Between 500 000 and 16 500 000 satoshis.

### [Thor: Lightning Channel-Opening Service by Bitrefill.com](https://www.bitrefill.com/thor-lightning-network-channels/?hl=en)
Pay with Lightning for an inbound channel of up to 16 000 000 satoshis.

### [Lightning Loop](https://github.com/lightninglabs/loop)
Lightning Loop is a non-custodial service offered by Lightning Labs to bridge on-chain and off-chain Bitcoin using submarine swaps.

In the current iteration of the Loop software, two swap types are supported:

* Loop Out: off-chain to on-chain. The Loop client sends funds paid on Lightning to a Bitcoin address.

* Loop In: on-chain to off-chain. The Loop client sends funds paid on-chain to a Lightning channel.

* Max swap amount: 4 200 000 sats

<https://lightning.engineering/loop/index.html#lightning-loop-grpc-api-reference>

### [LNBIG.com](https://lnbig.com/#/open-channel)
Free incoming channel with up to 5 000 000 sats from <https://twitter.com/lnbig_com>

Once there is higher balance on the side of your node an other incoming channel can be requested.

the service is paid in routing fees:  
![lnbig_fees](/images/lnbig_fees.png)

### Nodes which connect back:
* **stackingsats [TFTC] [NODL] [TOR]**  
<https://1ml.com/node/02d419c9af624d0e7a7c90a60b9ffa35f4934973a9d7d3b4175cc3cc28b7ffcde1>  
Will reciprocate channels over 2 000 000 sats.  
Keep in mind that channels fees can be changed by the peer arbitrarily.   
Check the latest state in a Lightning Explorer:  
https://1ml.com/node/02d419c9af624d0e7a7c90a60b9ffa35f4934973a9d7d3b4175cc3cc28b7ffcde1/channels

### [HodlHodl.com](https://HodlHodl.com)
Now open for trades through Lightning.   Select the LN icon on the menu bar on the top.  
See their [announcement on medium](
https://medium.com/@hodlhodl/lightning-trades-available-on-hodl-hodl-mainnet-78a1f0b60a9f) for details.

### [ZigZag.io](https://zigzag.io/#/)
An exchange that accepts Lightning payments.

### [t.me/LNswapBot - A Telegram bot](https://t.me/LNswapBot)
Swap on-chain coins to Lightning Network and vice versa! For less then $0.01 fee! 

### [github.com/bitcoin-software/ln-liquidity](https://github.com/bitcoin-software/ln-liquidity)
List of exchange services to make coin swaps LN <-> onchain & more

### [Boltz](https://boltz.exchange/)
Fee: 0.5% both ways

## To top up the Lightning balance

### [RedShift](https://ion.radar.tech/redshift)
Trustless transfers between the Lightning Network, the Bitcoin blockchain, and any supported digital asset (BTC and ETH so far).
Send funds on-chain and receive on Lightning.

### [Lightning Loop](https://github.com/lightninglabs/loop)
* Loop In: on-chain to off-chain, where the Loop client sends funds paid on-chain to an off-chain channel.

### [golightning.club](https://golightning.club/)
Send on-chain and receive bitcoin over Lightning!
Up to 1000000 satoshi / 0.01 BTC.

---
## Managing channels

The channels are best to be balanced with funds on each side to maximize the ability to route payments (allows bidirectional traffic).

### [lndmanage](https://github.com/bitromortac/lndmanage)
lndmanage is a command-line tool for advanced channel management of an LND node written in python.
* Install with: 
    ```bash  
    # activate virtual environment
    sudo apt install -y python3-venv
    python3 -m venv venv
    source venv/bin/activate
    # get dependencies
    sudo apt install -y python3-dev libatlas-base-dev
    pip3 install wheel
    python3 -m pip install lndmanage
    ```
* Start the interactive mode (do this at every new start):
    ```bash 
    $ source venv/bin/activate
    (venv) $ lndmanage 
    ```
* To display the status of the channels:
    ```bash 
    $ lndmanage status  
    $ lndmanage listchannels rebalance
* Example rebalance command:   
    `$ lndmanage rebalance --max-fee-sat 20 --max-fee-rate 0.0001 CHANNEL_ID --reckless`

### [Balance of Satoshis](https://github.com/alexbosworth/balanceofsatoshis)
* Install with:  
    `npm install -g balanceofsatoshis`
* Add to path:  
    `$ sudo bash -c "echo 'PATH=\$PATH:/usr/local/lib/nodejs/node-v10.16.0-linux-armv7l/bin/' >> /etc/profile"`  
    `$ export PATH=PATH=$PATH:/usr/local/lib/nodejs/node-v10.16.0-linux-armv7l/bin/`
* See how to use the rebalance command with:  
    `bos help rebalance`

### [rebalance-lnd](https://github.com/C-Otto/rebalance-lnd)
Using this python script you can easily rebalance individual channels of your lnd node.
* To install run in the terminal of the lnd node:  
    `$ git clone https://github.com/C-Otto/rebalance-lnd`  
    `$ cd rebalance-lnd`  
    `$ pip install -r requirements.txt`  
* Use with (more options in the [readme](https://github.com/C-Otto/rebalance-lnd/blob/master/README.md#usage)):   
    `$ python rebalance.py -t <channel_ID-where-to-move-sats> -f <channel_ID-from-which-to-move-sats> -a <amount-of-sats-to-be-moved>`

### [Methods to create a balanced channel with a trusted peer](BalancedChannelCreation.md)

* Perform a trusted onchain to offchain swap.

* Open a dual funded, balanced channel with a trusted peer using the command line requiring an Lightning and an on-chain transaction.

---

## Monitoring software

### [RTL - Ride The Lightning](https://github.com/ShahanaFarooqui/RTL)

RTL is a web UI for Lightning Network Daemon. Aimed to be used on the local network. [HTTPS](https://github.com/openoms/bitcoin-tutorials/tree/master/nginx) or [Tor](https://github.com/Ride-The-Lightning/RTL/blob/master/docs/RTL_TOR_setup.md) connection method is available.  
<https://medium.com/@suheb__/how-to-ride-the-lightning-447af999dcd2>

### [ZeusLN](https://zeusln.app/)

A mobile Bitcoin app for Lightning Network Daemon (lnd) node operators. Android and iOS - connects through the REST API (port 8080 or [Tor](https://github.com/openoms/bitcoin-tutorials/blob/master/Zeus_to_RaspiBlitz_through_Tor.md))

### [Zap](https://zap.jackmallers.com/)

A lightning wallet for desktop, iOS and Android - can connect to your LND node remotely through the GRPC interface (port 10009)

###  [Joule](https://lightningjoule.com/)

Bring the power of lightning to the web with in-browser payments and identity, all with your own node.   
<https://medium.com/lightning-power-users/bitcoin-lightning-joule-chrome-extension-ac149bb05cb9>

### [lndash](https://github.com/djmelik/lndash)

lndash is a simple read-only web dashboard for lnd - Lightning Network Daemon.  
Demonstration: <https://lightninglayer.com/>

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
A drop-in monitoring solution for your lnd node using Prometheus and Grafana. <https://blog.lightning.engineering/posts/2019/07/24/lndmon-v0.1.html>

### [Spark wallet for C-Lightning](https://github.com/shesek/spark-wallet)

Spark is a minimalistic wallet GUI for c-lightning, accessible over the web or through mobile and desktop apps (for Android, Linux, macOS and Windows). It is currently oriented for technically advanced users and is not an all-in-one package, but rather a "remote control" interface for a c-lightning node that has to be managed separately.

---

## Lightning network explorers

* [1ml.com](https://1ml.com/)

* [explore.casa](https://explore.casa/)

* [explorer.acinq.co](https://explorer.acinq.co/)

* [ln.alhur.es](https://ln.alhur.es/)
---
## Resources:

* A conceptual review of the Lightning Network: <https://dev.lightning.community/overview/index.html#lightning-network>

* gRPC API reference documentation for LND
<https://api.lightning.community>

* <https://medium.com/lightningto-me/practical-solutions-to-inbound-capacity-problem-in-lightning-network-60224aa13393>

* A list about How to get Channel Liquidity fast? <https://github.com/rootzoll/raspiblitz/issues/395>

* A curated list of awesome Lightning Network resources, apps, and libraries <https://github.com/bcongdon/awesome-lightning-network>

* Jameson Lopp's curated list of Lightning Network resources <https://lightning.how>

* <https://wiki.ion.radar.tech/tutorials/troubleshooting/bootstrapping-channels>

* Mathemathic principles behind routing: <https://en.wikipedia.org/wiki/Dijkstra's_algorithm>

## Videos:
* Elaine Ou - Bootstrapping and maintaining a Lightning node [38 mins video](https://www.youtube.com/watch?v=qX4Z3JY1094)
and [slides](https://lightningresidency.com/assets/presentations/Ou_Bootstrapping_and_Maintaining_a_Lightning_Node.pdf)

* Alex Bosworth - Lightning channel Management [35 mins video](https://www.youtube.com/watch?v=HlPIB6jt6ww&feature=youtu.be)

* [Chaincode Labs Lightning Seminar - Summer 2019](https://www.youtube.com/playlist?list=PLpLH33TRghT17_U3as2P3vHfAGL8pSOOY)

* Collection of Alex Bosworth`s online presentations: <https://twitter.com/alexbosworth/status/1175091117668257792>
---
## Forums:

* A community managed group for the RaspiBlitz Lightning Node:
<https://t.me/raspiblitz>

* LND Developer Slack. Find the invite link on: <https://dev.lightning.community/>

* A subreddit for Bitcoin and Lightning developers to discuss technical topics: 
<https://www.reddit.com/r/lightningdevs>
