# Lightning Node Management

## Receiving payments

To be able to receive payments on the Lightning Network a node needs:
- "inbound liquidity" which means that some satoshis need to be on the side of the other peer in a channel. 
- The max amount of the incoming payment is determined by the highest incoming liquidity of a single  channel (not additive between channels).
- a channel to a well connected node or a direct channel from the paying peer to make sure there is a possible payment route.

 ## Peer Connections
- Too open a channel to any node the peer connection needs to be established first.
- The publicly accessible nodes can be connected to automatically.
- If a node is not publicly accessible the peer connection needs to be initiated manually even if the other peer would want to open a channel

## Tor nodes
Tor is an anonymizing network designed to hide the participant`s IP adress. Somewhat similar to using a VPN with multiple hops. Learn more at: https://en.wikipedia.org/wiki/Tor_(anonymity_network)

- A Lightning node behind Tor can connect and open a channel to any other node. 
- The nodes running on clearnet are not able to see behind Tor.
- The clearnet node needs to be added as a peer first by the Tor node to be able to open a channel. 
- Once the channel is established the connection will persist, but might take some more time to come back online after either peer restarts.


## Get inbound liquidity

To make liquidity on existing (outgoing) channels a payment can be made to a merchant or exchange accepting Lightning and receive the product or withdraw on-chain.

### Nodes which connect back:
* **stackingsats [NODL] [TFTC] [RHR]**  
https://1ml.com/node/02d419c9af624d0e7a7c90a60b9ffa35f4934973a9d7d3b4175cc3cc28b7ffcde1  
Will reciprocate channels over 2 000 000 sats.

### [LNBIG.com](https://lnbig.com/#/open-channel)
Free incoming channel with up to 4 000 000 sats from https://twitter.com/lnbig_com

### [LightningTo.me](https://lightningto.me/)
Opens a channel for free funded with 2 000 000 satoshis. Need to have 10 channels open already to use this service.

### [Tippin.me](https://tippin.me/)
Tip yourself via LN and withdraw onchain.

### [LightningPowerUsers.com](https://lightningpowerusers.com/home/)
Request inbound capacity for a small fee
Recommended channel size: Between 500 000 and 16 500 000 satoshis.

### [Thor: Lightning Channel-Opening Service by Bitrefill.com](https://www.bitrefill.com/thor-lightning-network-channels/?hl=en)
Pay with Lightning for an inbound channel of up to 16 000 000 satoshis.

### [zigzag.io](https://zigzag.io/#/)
An exchange that accepts Lightning payments.

### [Lightning Loop](https://github.com/lightninglabs/loop)
Lightning Loop is a non-custodial service offered by Lightning Labs to bridge on-chain and off-chain Bitcoin using submarine swaps. 

In the current iteration of the Loop software, only off-chain to on-chain swaps are supported, where the Loop client sends funds off-chain in exchange for the funds back on-chain. This is called a Loop Out.

https://lightning.engineering/loop/index.html#lightning-loop-grpc-api-reference

## Pass around Lightning Torches

### [LNTrustChain - now finished](https://www.youtube.com/watch?v=89TSOayiqtA&feature=youtu.be)
Find out on twitter who holds the torch.
every participant adds 10000 satoshis

### [LNTinyTorch](http://lntinytorch.com/)
Every participant adds 1 satoshi


## Reduce the routing fees to receive more inbound channels

https://api.lightning.community/#updatechannelpolicy

Lightning fees are related to the amount routed.
There are two fee components:
* base fee (base_fee_msat). The default is 1000 millisat, which means 1 satoshi fee per every routed payment.
* proportional fee (fee_rate) which is set to the minimum by default in lnd: 0.000001. This means there is an additional 1 sat charged for every million satoshis in the routed payment.

`lncli updatechanpolicy 0 0.000001 144`

the default is:  
 `lncli updatechanpolicy 1000 0.000001 144`

---
## Managing channels

Rebalance your channels regularly to keep the ability to accept payments.

### [rebalance-lnd](https://github.com/C-Otto/rebalance-lnd)
Using this pyhton script you can easily rebalance individual channels of your lnd node.

---

## Monitoring software

### [RTL - Ride The Lightning](https://github.com/ShahanaFarooqui/RTL)

RTL is a web UI for Lightning Network Daemon.  
https://medium.com/coinmonks/introducing-rtl-a-web-ui-for-lnd-d0bb0d937e91


### [ZeusLN](https://zeusln.app/)

A mobile Bitcoin app for Lightning Network Daemon (lnd) node operators. Android and iOS.

###  [Joule](https://lightningjoule.com/)

Bring the power of lightning to the web with in-browser payments and identity, all with your own node.   
https://medium.com/lightning-power-users/bitcoin-lightning-joule-chrome-extension-ac149bb05cb9

### [Zap](https://zap.jackmallers.com/)

A lightning wallet for desktop and iOS.


### [lndash](https://github.com/djmelik/lndash)

lndash is a simple read-only web dashboard for lnd - Lightning Network Daemon.  
Demonstration: https://lightninglayer.com/ 

Features:

* Peer view
* Channel view
* Forwarding Events (routed payments) view
* Looking Glass Tool (route/path lookup)
* Lightning Network Graph

### [Spark wallet for C-Lightning](https://github.com/shesek/spark-wallet)

Spark is a minimalistic wallet GUI for c-lightning, accessible over the web or through mobile and desktop apps (for Android, Linux, macOS and Windows). It is currently oriented for technically advanced users and is not an all-in-one package, but rather a "remote control" interface for a c-lightning node that has to be managed separately.

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


* https://wiki.ion.radar.tech/tutorials/troubleshooting/bootstrapping-channels

* https://en.wikipedia.org/wiki/Dijkstra's_algorithm

