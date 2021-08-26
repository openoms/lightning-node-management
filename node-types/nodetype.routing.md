# Routing

Aimed for forwading payments successfully while generating profit.

## Capital requirement

* high

## Channels and peers

* numerous \(~10+\) big channels to [well connected nodes](../advanced-tools/bosscore.md)
* connect to the network edge to get usage
* aim to connect node clusters \(isolated groups\)

## Liquidity

* balanced between local and remote overall
* individual channels should be able to forward payments in both directions

## Uptime

* aim to be perfect
* offline routing nodes with many public channels are causing networkwide payment failures
* greatly affects the [reputation of the routing node](https://github.com/openoms/lightning-node-management/tree/04d605ae69f3630c0eaeedc43eda95c6ff5d1ee3/bossscore.md)

## Management

* autorebalancing \(cronjobs are useful\)
* create inbound and outbound liquidity as required
* balance between multiple nodes
* close inactive channels
* open to directions where liquidity is required
* use Lightning Pool bids and asks
* batch channel opens to save on miner fees 
* fund channels from external wallets
* close to external addresses to reduce the hot wallet risk
* explore the many [tools available](../#manage-channels)

## Strategies

### Connect clusters and big payment processors

* bidirectional traffic 
* fees are low 
* highly competitive \(lots of liquidity is in private channels\)

### Provide liquidity to merchants

* high incoming liquidity required
* fees can be set to moderate - high
* selling channels via Lightning Pool often falls into this category

### Payment hub for small nodes

* fees can be left to be low 
* traffic is mostly outgoing
* should encourage the usage of private channels 
* offline public channels lead to payment failures and affecting the routing node's reputation\)

### Sell incoming liquidity

* [LOOP](https://1ml.com/node/021c97a90a411ff2b10dc2a8e32de2f29d2fa49d41bfbb52bd416e460db0747d0d)
* [Bitfinex](https://ln.bitfinex.com/)
* set high fees due to unidirectional traffic and the quick drain of inbound capacity
* not all LN supporting exchanges are connectable and need individual evaluation about the direction of traffic

## Examples

* [Self hosted on dedicated hardware](https://github.com/bavarianledger/bitcoin-nodes)
* Custom system on enterprise hardware focused on uptime and redundancy
* Hosted on a VPS \(higher risk\)

