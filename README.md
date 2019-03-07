# Lightning Node Management

## Monitoring software

### lndash

lndash is a simple read-only web dashboard for lnd - Lightning Network Daemon.  
Demonstration: https://lightninglayer.com/ 

Features:

* Peer view
* Channel view
* Forwarding Events (routed payments) view
* Looking Glass Tool (route/path lookup)
* Lightning Network Graph

https://github.com/djmelik/lndash

### RTL - Ride The Lightning

RTL is a web UI for Lightning Network Daemon.  
https://medium.com/coinmonks/introducing-rtl-a-web-ui-for-lnd-d0bb0d937e91

https://github.com/ShahanaFarooqui/RTL

---
## Get inbound liquidity

Open a channel to exchange/merchant accepting Lightning, make a LN payment, and withdraw on-chain

### LightningTo.me
Opens a channel for free funded with 2 000 000 satoshis. Need to have 10 channels open already to use this service.

### [LightningPowerUsers.com](https://lightningpowerusers.com/home/)
Open a channel and register on the website to have a matching inbound channel back. 
Recommended channel size: Between 500,000 satoshis (~$20) and 16,500,000 satoshis (~$600).

### [Bitrefill.com](https://www.bitrefill.com/buy/lightning-channel/lightning/?hl=en)
pay with Lightning for an inbound channel of up to 16 000 000 satoshis.

### Tippin.me
Tip yourself via LN and withdraw onchain.

### zigzag.io
An exchange that accepts Lightning payments

## Pass around Lightning Torches

### [LNTrustChain](https://www.youtube.com/watch?v=89TSOayiqtA&feature=youtu.be)
Find out on twitter who holds the torch.
every participant adds 10000 satoshis

### [LNTinyTorch](http://lntinytorch.com/)
Every participant adds 1 satoshi


## Reduce the routing fees for more inbound channels

```lncli updatechanpolicy 0 0.000001 144```

the default is:  
 ```lncli updatechanpolicy 1000 0.000001 144```

---
## Managing channels

Rebalance your channels regularly to keep the inbound liquidity.

### rebalance-lnd

Using this script you can easily rebalance individual channels of your lnd node.

https://github.com/C-Otto/rebalance-lnd


---
## Resources:
* https://github.com/bcongdon/awesome-lightning-network  
A curated list of awesome Lightning Network resources, apps, and libraries

* Elaine Ou - Bootstrapping and maintaining a Lightning node [38 mins video](https://www.youtube.com/watch?v=qX4Z3JY1094)
and [slides](https://lightningresidency.com/assets/presentations/Ou_Bootstrapping_and_Maintaining_a_Lightning_Node.pdf)

* https://medium.com/lightningto-me/practical-solutions-to-inbound-capacity-problem-in-lightning-network-60224aa13393

* Alex Bosworth - Lightning channel Management [35 mins video](https://www.youtube.com/watch?v=HlPIB6jt6ww&feature=youtu.be)

* A list about How to get Channel Liquidity fast? https://github.com/rootzoll/raspiblitz/issues/395

* https://wiki.ion.radar.tech/tutorials/troubleshooting/bootstrapping-channels