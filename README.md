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
## Getting inbound liquidity

open a channel to exchange/merchant accepting Lightning, make a LN payment, and withdraw on-chain

### zigzag.io

### LightningTo.me

### [LNTrustChain](https://www.youtube.com/watch?v=89TSOayiqtA&feature=youtu.be)

### Reduce the routing fees for more inbound channels:

```lncli updatechanpolicy 500 0.000001 144```

the default is:  
 ```lncli updatechanpolicy 1000 0.000001 144```

---
## Managing channels

### rebalance-lnd

Using this script you can easily rebalance individual channels of your lnd node.

https://github.com/C-Otto/rebalance-lnd


---
## Resources:
* https://github.com/bcongdon/awesome-lightning-network  
A curated list of awesome Lightning Network resources, apps, and libraries

* Elaine Ou - Bootstrapping and maintaining a Lightning node [38 mins video](https://www.youtube.com/watch?v=qX4Z3JY1094)
and [slides](https://lightningresidency.com/assets/presentations/Ou_Bootstrapping_and_Maintaining_a_Lightning_Node.pdf)
