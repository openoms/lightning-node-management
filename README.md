# Lightning Node Management

## Peer connections and channels
* Peers are the nodes connected to each other through the internet \(TCP/IP layer\). 
* A channel is a payment channel between two peers established on the Lightning Network.
* To open a channel to any node the peer connection needs to be established first.
* The publicly accessible nodes can be connected to automatically.
* If a node is not publicly accessible the peer connection needs to be initiated manually from the non-public side even if the other peer is opening the channel.

## Receiving payments
To be able to receive payments on the Lightning Network a node needs:

* "inbound liquidity" \(aka remote balance\) which means that some satoshis need to be on the side of the other peer in a channel. 
* a channel to a well connected node or a direct channel from the paying peer to make sure there is a possible payment route.

The max amount of the incoming payment is determined by the highest inbound liquidity of a single channel \(not additive between channels\).

## Channel size and choosing a peer
* There is no hard number, but in general it is recommended to avoid opening channels  below 200K-500K sats.
* [https://1ml.com/statistics](https://1ml.com/statistics) shows the average channel size on the network:   

  0.028 BTC = 2 800 000 satoshis on 2019 May 28.

* A channel too small will result in being unable to close when on-chain fees are high. This will leave the channel vulnerable in a case, when the counterparty would try to close with a previous state \(the funds in the channel can be cheated out\).
* The max size of the available payment made or routed is determined by the highest directional liquidity of a single channel \(not additive between channels\).
* One big channel to a well connected and stable node is more useful than many small ones.
* It is beneficial to connect to nodes where the operator can be contacted in case of a problem.
* Choose a node you know or one from the list: [https://1ml.com/node?order=nodeconnectednodecount](https://1ml.com/node?order=nodeconnectednodecount)
* Try a custom list of recommendations for your public node: [https://moneni.com/nodematch](https://moneni.com/nodematch)

## On-chain bitcoin fees
* Opening or closing a Lightning channel is an on-chain bitcoin transaction \(settled on the blockchain\)
* The confirmation time depends on the state of the bitcoin mempool \([https://jochen-hoenicke.de/queue/\#0,24h](https://jochen-hoenicke.de/queue/#0,24h)\) and the sats/byte fee used \([https://bitcoinfees.earn.com/](https://bitcoinfees.earn.com/)\).
* Check [https://whatthefee.io/](https://whatthefee.io/) for the current estimation of confirmation time/fee.
* Use a custom fee and choose the lowest number with a good chance for an acceptable confirmation time.
* At least 141 bytes need to be covered by fees, but this number is often higher depending on the transaction inputs, script and signatures used.
* Learn what to do in a [high onchain fee environment](highonchainfees.md)

## Tor nodes
Tor is an anonymizing network designed to hide the participant\`s IP adress. Somewhat similar to using a VPN with multiple hops. Learn more at: [https://en.wikipedia.org/wiki/Tor\_\(anonymity\_network\)](https://en.wikipedia.org/wiki/Tor_%28anonymity_network%29)

* A Lightning node behind Tor can connect and open a channel to any other node. 
* The nodes running on clearnet are not able to see behind Tor.
* The clearnet node needs to be added as a peer first by the Tor node to be able to open a channel. 
* Once the channel is established the connection will persist, but might take some more time to come back online after either peer restarts.
* If both nodes restart in the same time or the clearnet node\`s IP address is changed while both offline the peer connection need to be added manually again.

## Routing payments
* Imagine a node `B` in an `A`-`B`-`C` serial connection.
* The channels of `B` are set up so  that there is inbound capacity \(remote balance\) from `A` and outgoing capacity \(local balance\) to `C`.  
* If `A` wants to pay `C` there will be 1 hop in the route.
* Under the hood: `A` sends the satoshis to `B` \(the routing node\) which will pay to `C`.
* The capacity of the channels do not change, only move.
* The whole payment can only go through if they can send a hash image \(a message\) through from the other direction first.
* The process is all or nothing, the payment cannot get stuck en route.

## Private channel
* better to be called an "unannounced" channel
* won't be advertised in the channel graph (network gossip)
* more useful to send payments
* to receive payments need to have a route hint included in the invoice:  
  `lncli addinvoice <amount> --private`
* the route hint is the identifier of the funding transaction (exposes the channel to the anyone knowing the invoice)
* possible to receive keysend payments if the route hint is known
* does not route payments (unless used in parallel with a public channel to the same node - aka shadow liquidity)

## Lightning Network routing fees
### Advanced and automated fee settings: [fees.md](fees.md)

Unlike with on-chain transactions \(where the fee is paid for the bytes the transaction takes up in a block\) Lightning Network fees are related to the amount routed. There are two fee components:

* base fee \(base\_fee\_msat\). The default is 1000 millisat, which means 1 satoshi fee per every routed payment.
* proportional fee \(fee\_rate\) which is by default in lnd: 0.000001. This means there is an additional 1 sat charged for every million satoshis in the routed payment.

There is no LN fee for payments in a direct channel between two peers.

To change routing fees of your node use the command: [https://api.lightning.community/\#updatechannelpolicy](https://api.lightning.community/#updatechannelpolicy)

* Can reduce the base fee to 500 msat and increase the proportinal fee to 100ppm/0.01% with this command: `$ lncli updatechanpolicy 500 0.0001 144`
* the default setting is \(1 sat per payment + 1 ppm/0.0001%\): `$ lncli updatechanpolicy 1000 0.000001 144`

It is important to increase the routing fee for any expensive channels so rebalancing or closure is paid for if payments are routed that way. Check the routing fees of the peers on [1ml.com](https://1ml.com/) or in [lndmanage](./#lndmanage).

Setting the fees for individual channels takes only one click in the [RTL app](./#RTL---Ride-The-Lightning).

## Watchtowers

Read more and how to set one up [watchtower.md](watchtower.md).

## Liquidity

Read the basic ideas from Alex Bosworth: [https://github.com/alexbosworth/run-lnd/blob/master/LIQUIDITY.md](https://github.com/alexbosworth/run-lnd/blob/master/LIQUIDITY.md)

## Create Inbound Liquidity

Pay with Lightning and receive onchain.  
See the a list of recommendations [CreateInboundLiquidity.md](createinboundliquidity.md)

## Create Outbound Liquidity

Simply open channels or pay onchain and receive on Lightning.  
See the a list of recommendations [CreateOutboundLiquidity.md](createoutboundliquidity.md)

## Manage channels

The channels are best to be balanced with funds on each side to maximize the ability to route payments \(allows bidirectional traffic\).

### [Balance of Satoshis](https://github.com/alexbosworth/balanceofsatoshis)

A feature rich tool to work with LND balances. Has an experimental feature to connect to a personal Telegram bot and notify about the node activity.

* [Install instructions for the RaspiBlitz](https://gist.github.com/openoms/823f99d1ab6e1d53285e489f7ba38602)
* See how to use the rebalance command with: `bos help rebalance`

### [CLBOSS The C-Lightning Node Manager](https://github.com/ZmnSCPxj/clboss)

An automated manager for C-Lightning forwarding nodes.
### [lndmanage](https://github.com/bitromortac/lndmanage)

A command-line tool for advanced channel management of an LND node written in python.

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

* Start the interactive mode \(do this at every new start\):

  ```bash
    $ source venv/bin/activate
    (venv) $ lndmanage
  ```

* To display the status of the channels:

    \`\`\`bash 

    $ lndmanage status  

    $ lndmanage listchannels rebalance

* Example rebalance command:   

    `$ lndmanage rebalance --max-fee-sat 20 --max-fee-rate 0.0001 CHANNEL_ID --reckless`

### [rebalance-lnd](https://github.com/C-Otto/rebalance-lnd)

Using this python script you can easily rebalance individual channels of your lnd node.

* To install run in the terminal of the lnd node:  

    `$ git clone https://github.com/C-Otto/rebalance-lnd`  

    `$ cd rebalance-lnd`  

    `$ pip install -r requirements.txt`  

* Use with \(more options in the [readme](https://github.com/C-Otto/rebalance-lnd/blob/master/README.md#usage)\):   

    `$ python rebalance.py -t <channel_ID-where-to-move-sats> -f <channel_ID-from-which-to-move-sats> -a <amount-of-sats-to-be-moved>`


### [Methods to create a balanced channel with a trusted peer](balancedchannelcreation.md)

* Perform a trusted onchain to offchain swap.
* Open a dual funded, balanced channel with a trusted peer using the command line requiring an Lightning and an on-chain transaction.

## Monitoring software

### [RTL - Ride The Lightning](https://github.com/ShahanaFarooqui/RTL)

RTL is a web UI for Lightning Network Daemon. Aimed to be used on the local network. [HTTPS](https://github.com/openoms/bitcoin-tutorials/tree/master/nginx) or [Tor](https://github.com/Ride-The-Lightning/RTL/blob/master/docs/RTL_TOR_setup.md) connection method is available.  
[https://medium.com/@suheb\_\_/how-to-ride-the-lightning-447af999dcd2](mailto:https://medium.com/@suheb__/how-to-ride-the-lightning-447af999dcd2)

### [ThunderHub](https://www.thunderhub.io/)

An LND Lightning Node Manager in your Browser.

* [Install instructions on the RaspiBlitz](https://gist.github.com/openoms/8ba963915c786ce01892f2c9fa2707bc)

### [ZeusLN](https://zeusln.app/)

A mobile Bitcoin app for Lightning Network Daemon \(lnd\) node operators. Android and iOS - connects through the REST API \(port 8080 or [Tor](https://github.com/openoms/bitcoin-tutorials/blob/master/Zeus_to_RaspiBlitz_through_Tor.md)\)

### [Zap](https://zap.jackmallers.com/)

A lightning wallet for desktop, iOS and Android - can connect to your LND node remotely through the GRPC interface \(port 10009\)

### [Joule](https://lightningjoule.com/)

Bring the power of lightning to the web with in-browser payments and identity, all with your own node.  
[https://medium.com/lightning-power-users/bitcoin-lightning-joule-chrome-extension-ac149bb05cb9](https://medium.com/lightning-power-users/bitcoin-lightning-joule-chrome-extension-ac149bb05cb9)

### [lndash](https://github.com/djmelik/lndash)

lndash is a simple read-only web dashboard for lnd - Lightning Network Daemon.  
Demonstration: [https://lightninglayer.com/](https://lightninglayer.com/)

Features:

* Peer view
* Channel view
* Forwarding Events \(routed payments\) view
* Looking Glass Tool \(route/path lookup\)
* Lightning Network Graph

### [lntop](https://github.com/edouardparis/lntop)

lntop is an interactive text-mode channels viewer for Unix systems.

### [lnd-admin](https://github.com/janoside/lnd-admin)

Admin web interface for LND, via gRPC. Built with Node.js, express, bootstrap-v4. Test at: [https://lnd-admin.chaintools.io/](https://lnd-admin.chaintools.io/)

### [lndmon](https://github.com/lightninglabs/lndmon)

A drop-in monitoring solution for your lnd node using Prometheus and Grafana. [https://blog.lightning.engineering/posts/2019/07/24/lndmon-v0.1.html](https://blog.lightning.engineering/posts/2019/07/24/lndmon-v0.1.html)

### [Spark wallet for C-Lightning](https://github.com/shesek/spark-wallet)

Spark is a minimalistic wallet GUI for c-lightning, accessible over the web or through mobile and desktop apps \(for Android, Linux, macOS and Windows\). It is currently oriented for technically advanced users and is not an all-in-one package, but rather a "remote control" interface for a c-lightning node that has to be managed separately.

## Lightning network explorers

* [1ml.com](https://1ml.com/)
* [explorer.acinq.co](https://explorer.acinq.co/)
* [amboss.space](https://amboss.space/)
* [ln.fiatjaf.com](https://ln.fiatjaf.com)

## Resources
* LND Builder's Guide Best Practices  
  [docs.lightning.engineering/advanced-best-practices/advanced-best-practices-overview/channels](https://docs.lightning.engineering/advanced-best-practices/advanced-best-practices-overview/channels)
* A conceptual review of the Lightning Network:  
  [dev.lightning.community/overview/index.html\#lightning-network](https://dev.lightning.community/overview/index.html#lightning-network)
* gRPC API reference documentation for LND  
  [api.lightning.community](https://api.lightning.community)
* [medium.com/lightningto-me/practical-solutions-to-inbound-capacity-problem-in-lightning-network-60224aa13393](https://medium.com/lightningto-me/practical-solutions-to-inbound-capacity-problem-in-lightning-network-60224aa13393)
* [lightningwiki.net](https://lightningwiki.net)
* [satbase.org](https://satbase.org)
* A list about How to get Channel Liquidity fast?  
  [github.com/rootzoll/raspiblitz/issues/395](https://github.com/rootzoll/raspiblitz/issues/395)
* A curated list of awesome Lightning Network resources, apps, and libraries  
  [github.com/bcongdon/awesome-lightning-network](https://github.com/bcongdon/awesome-lightning-network)
* Jameson Lopp's curated list of Lightning Network resources  
[lightning.how](https://lightning.how)
* [wiki.ion.radar.tech/tutorials/troubleshooting/bootstrapping-channels](https://wiki.ion.radar.tech/tutorials/troubleshooting/bootstrapping-channels)

### Routing
* [blog.lightning.engineering/posts/2018/05/30/routing.html](https://blog.lightning.engineering/posts/2018/05/30/routing.html)
* [diyhpl.us/wiki/transcripts/chaincode-labs/2018-10-22-alex-bosworth-channel-management/](https://diyhpl.us/wiki/transcripts/chaincode-labs/2018-10-22-alex-bosworth-channel-management/)
* [diyhpl.us/wiki/transcripts/lightning-hack-day/2021-03-27-alex-bosworth-lightning-routing/](https://diyhpl.us/wiki/transcripts/lightning-hack-day/2021-03-27-alex-bosworth-lightning-routing/)

## Videos

* Elaine Ou - Bootstrapping and maintaining a Lightning node [38 mins video](https://www.youtube.com/watch?v=qX4Z3JY1094) and [slides](https://lightningresidency.com/assets/presentations/Ou_Bootstrapping_and_Maintaining_a_Lightning_Node.pdf)
* Alex Bosworth - Lightning channel Management [35 mins video](https://www.youtube.com/watch?v=HlPIB6jt6ww&feature=youtu.be)
* [Chaincode Labs Lightning Seminar - Summer 2019](https://www.youtube.com/playlist?list=PLpLH33TRghT17_U3as2P3vHfAGL8pSOOY)
* Collection of Alex Bosworth\`s online presentations:  
[twitter.com/alexbosworth/status/1175091117668257792](https://twitter.com/alexbosworth/status/1175091117668257792)

## Forums

* A community managed group for the RaspiBlitz Lightning Node:  
[https://t.me/raspiblitz](https://t.me/raspiblitz)
* LND Developer Slack. Find the invite link on:  
  [dev.lightning.community/](https://dev.lightning.community/)
* A subreddit for Bitcoin and Lightning developers to discuss technical topics:  
  [www.reddit.com/r/lightningdevs](https://www.reddit.com/r/lightningdevs)

## Learning

https://github.com/lnbook/lnbook  
https://chaincode.applytojob.com/apply/LpQl1a0cvd/Chaincode-Labs-Online-Seminars
https://github.com/chaincodelabs/lightning-curriculum

