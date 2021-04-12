# Methods to create a balanced channel with a trusted peer

## Trusted swap

Perform a trusted onchain to offchain swap.

Advantage:

* creates bidirectional liquidity on both sides.
* paying a peer on a direct LN channel is free.

How to:

* Open a channel to a trusted peer
* Once the channel is confirmed pay an invoice provided py the peer \(use half of the channel capacity to end up with a perfectly balanced channel\) - this payment is free
* Send the peer an onchain address to pay back the amount of the invoice \(use a low network-fee\)

## How to open a balanced channel with a trusted peer

Open a dual funded, balanced channel with a trusted peer using the command line requiring an Lightning and an on-chain transaction.

Find below how to create a 2million sats balanced channel between the nodes `A` and `B` .

Advantages:

* Only one on-chain tx required \(cheaper\)
* Will result in a channel with 2M sats capacity instead of 2x1mil with the same amount of funds tied down \(more efficient\).

Requirements:

* `A` has 1M sats outgoing liquidity.
* `B` has 1M sats incoming liquidity + 2mil sats funds on-chain \(trusted node\).
* A payment route for 1M sats between `A` and `B` .

How to:

* `B` sends and invoice to receive 1M sats from `A` .
* `A` pays 1M sats to `B` .
* make sure A and B are peers
* `B` opens a 2M sats channel to A with the command:  

  `lncli openchannel <nodeID_of_A> --local_amt 2000000 --push_amt 1000000 --sat_per_byte 2` 

There should be no rush, so use a low fee for the on-chain tx. Check [https://whatthefee.io/](https://whatthefee.io/) for the current mempool status or use the `--conf_target 10` option for automatic fee estimation to aim to have the channel confirmed in ~10 blocks.

This will result to have a balanced channel with 1M sats on each side \(minus the commit fee\). ![a balanced channel shown in ZeusLN](.gitbook/assets/balancedChannel%20%281%29.jpg)

## The cost of liquidity

Providing liquidity on the Lightning Network comes with transaction costs, opportunity and hot wallet risks.  
Liquidity is neither abundant nor free.  
Asking other node operators for inbound liquidity is asking a favour.  
A suggestion \(example\) for pricing liquidity could be:

* Make minimum 1M sats channels.
* Pay the provider 0.02% = 2000 ppm sats for allocating funds to the channel to cover the miner fees \(of open and close + risk of force closure\).
* agree in a set routing fee \(for example 100 ppm\)
* agree in a duration for the channel to be kept open for \(for example minimum a month\)

