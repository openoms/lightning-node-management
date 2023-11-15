# Spending

Aimed for spending bitcoin cheaply and privately.

## Capital requirement

* low
* depends on spending plan and available funds
* allows to use up unmixed funds without creating change

## Channels and peers

* one channel to a well connected, capitalized and high uptime node is a good start, see the [Bos list](../advanced-tools/bosscore.md), [Lightning Terminal](https://terminal.lightning.engineering) or [Amboss.space](https://amboss.space) to pick a peer
* use private channels to avoid publishing the node and the funding transactions
* offline private channels don't damage the reliability of the network

## Liquidity

* mostly local

## Uptime

* not a factor \(spend only when online\)

## Management

* close depleted channels 
* [can refill via LN](../createoutboundliquidity.md)
* starting a new node often improves the onchain privacy

## Examples

* [Mobile wallets](../createinboundliquidity.md#non-custodial-wallets)
* [Self hosted node on dedicated hardware](https://github.com/bavarianledger/bitcoin-nodes)
* Privacy oriented: [slides about Running a Lightning Node Privately](https://keybase.pub/oms/slides/Running_a_Lightning_Node_Privately.pdf)
* Use for social media like [Sphinx chat](https://sphinx.chat/)  

  Discussion: [https://github.com/raspiblitz/raspiblitz/issues/2073](https://github.com/raspiblitz/raspiblitz/issues/2073)

