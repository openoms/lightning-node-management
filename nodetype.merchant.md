# Merchant node
Aimed for receiving payments.

### Capital requirement
* minimal to buy incoming channels
* temporarily high to create incoming capacity from channels opened

### Channels and peers
* few (2-3) channels with well connected and capitalized nodes
* connect to nodes on the [Bos list](bosscore.md)
* see existing fee settings on [1ml.com](https//1ml.com)

### Liquidity
* mostly remote

### Uptime
 * high, but not perfect
 * unavailability affects sales

### Management
* [Loop out](https://github.com/lightninglabs/loop#lightning-loop) ([Autoloop](https://docs.lightning.engineering/advanced-best-practices/advanced-best-practices-overview/autoloop)) to emprty existing channels
* Close and Reopen when channels are filled up
  * a channel open (and close) is not more expensive than using Loop given :
    * have onchain liquidity for more channels (or splice in in the future) or
    * can afford the channel downtime between peers to close and reopen
* Buy further [inbound liquidity](createinboundliquidity.md)
* Place bids on [Ligthning Pool](pool.md)
* Advertise to receive inbound

### Examples
* [Self hosted node](https://github.com/bavarianledger/bitcoin-nodes) connected to a local or remote BTCPayServer
* BTCPayServer on a VPS (acceptable with low amount of funds)
* Fully hosted solutions (trusted)

### Special cases
* Accepting [donations](donations.md)
* Offer to pay onchain for high value payments (miner fee < 0.5-1%)
  
  ![BTCPayServer setting](/.gitbook/assets/btcpay.on-offchain.png)

* can progress to a [Routing node](nodetype.routing.md) as the number of connections and capital grows
