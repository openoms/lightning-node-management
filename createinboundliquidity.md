To create inbound liquidity on an existing channel \(to be able to receive payments\) can simply pay a merchant accepting Lightning and receive the product or receive the sats back on-chain.

To pay for various gift cards with lightning check out [Bitrefill \(referral link\)](https://www.bitrefill.com/buy/?code=XapbJJd8).

- [Dual funded channels](#dual-funded-channels)
  - [Core Lightning dual funded channels on the protocol level](#core-lightning-dual-funded-channels-on-the-protocol-level)
  - [Manual coordination on LND with Balance of Satoshis](#manual-coordination-on-lnd-with-balance-of-satoshis)
- [Buy inbound channels](#buy-inbound-channels)
  - [Comparison table of lightning channel markets](#comparison-table-of-lightning-channel-markets)
  - [Amboss Magma](#amboss-magma)
  - [zerofeerouting.com](#zerofeeroutingcom)
  - [Voltage Flow](#voltage-flow)
  - [Lightning Pool](#lightning-pool)
  - [Microlancer.io](#microlancerio)
  - [Sats4Likes](#sats4likes)
  - [Thor: Lightning Channel-Opening Service by Bitrefill.com](#thor-lightning-channel-opening-service-by-bitrefillcom)
  - [LNBIG.com](#lnbigcom)
  - [Coincept.com](#coinceptcom)
  - [Yalls.org](#yallsorg)
  - [lnd-routing](#lnd-routing)
- [Ask for incoming channels](#ask-for-incoming-channels)
  - [lightningnetwork.plus](#lightningnetworkplus)
  - [LightningTo.me](#lightningtome)
  - [Join a community](#join-a-community)
- [Swap out - trustless](#swap-out---trustless)
  - [Lightning Loop](#lightning-loop)
  - [Boltz.exchange](#boltzexchange)
- [Swap out - trusted](#swap-out---trusted)
  - [deezy.io](#deezyio)
  - [Bitfinex](#bitfinex)
  - [FixedFloat](#fixedfloat)
  - [ZigZag.io](#zigzagio)
  - [No longer available ChainMarket](#no-longer-available-chainmarket)
- [Send to a mobile wallet](#send-to-a-mobile-wallet)
  - [Self-custodial wallets](#self-custodial-wallets)
  - [Custodial wallets](#custodial-wallets)
- [More links](#more-links)

## Dual funded channels
### Core Lightning dual funded channels on the protocol level
* [How to use on the RaspiBlitz](https://github.com/raspiblitz/raspiblitz/blob/dev/FAQ.cl.md#dual-funded-channels)
* [Open a dual funded channel](https://medium.com/blockstream/c-lightning-opens-first-dual-funded-mainnet-lightning-channel-ada6b32a527c)
* [Set up liquidity ads](https://medium.com/blockstream/setting-up-liquidity-ads-in-c-lightning-54e4c59c091d)

### Manual coordination on LND with Balance of Satoshis
* [github.com/alexbosworth/balanceofsatoshis](https://github.com/alexbosworth/balanceofsatoshis)
* [Guide needed]

## Buy inbound channels
### Comparison table of lightning channel markets
* [channelmarkets.md](https://github.com/openoms/lightning-node-management/blob/en/channelmarkets.md)

### [Amboss Magma](https://amboss.space)
* lightning liquidity marketpalce

### [zerofeerouting.com](https://zerofeerouting.com/)
* The price for the channel depends on the size and can be calculated as:
  ```
  [size] * 0.005 - 2,000
  ```
  A 10M channel (0.1 BTC) would cost 48,000 sats.

### Voltage Flow
* Buy a sidecar channel through Voltage Flow from Lightning Pool
* [blog.voltage.cloud/introducing-flow/](https://blog.voltage.cloud/introducing-flow/)

### [Lightning Pool](https://pool.lightning.engineering/)
* Buy incoming channels on a permissionless marketplace: [https://pool.lightning.engineering/](https://pool.lightning.engineering/)
* Usage notes: [pool.md](advanced-tools/pool.md)

### [Microlancer.io](https://microlancer.io/services/?tag=%23lightning-network)
* Pay for incoming channels.

### [Sats4Likes](https://kriptode.com/satsforlikes/index.html)
* Post an advert and pay satoshis for incoming channels.

### [Thor: Lightning Channel-Opening Service by Bitrefill.com](https://www.bitrefill.com/thor-lightning-network-channels/?hl=en)

* Pay with Lightning for an inbound channel of up to 16 000 000 satoshis.

### [LNBIG.com](https://lnbig.com/#/open-channel)

* Buy incoming channels from [https://twitter.com/lnbig\_com](https://twitter.com/lnbig_com)

### [Coincept.com](https://coincept.com/)

### [Yalls.org](https://yalls.org/about/)

### [lnd-routing](https://github.com/lnd-routing/lnd-routing/)

## Ask for incoming channels

### [lightningnetwork.plus](http://lightningnetwork.plus)
* Claim your node on LN+ and join a channel swap for free

### [LightningTo.me](https://lightningto.me/)

* Opens a channel for free funded with 2 000 000 satoshis. Need to have 10 channels open already to use this service.  
Add their node as a peer if connecting from behind Tor:  
`$ lncli connect 03bb88ccc444534da7b5b64b4f7b15e1eccb18e102db0e400d4b9cfe93763aa26d@138.68.14.104:9735`

### Join a community

* [PLEBNET - KYCjelly.com](kycjelly.com)  
[plebnet.wiki/wiki/Welcome_to_Plebnet](https://plebnet.wiki/wiki/Welcome_to_Plebnet)

* Rings of Fire  
  [How to join a ring](https://github.com/Rings-of-Fire/ring-of-fire/wiki#how)


## Swap out - trustless

Pay with Lightning and receive onchain.

### [Lightning Loop](https://github.com/lightninglabs/loop)

Lightning Loop is a non-custodial service offered by Lightning Labs to bridge on-chain and off-chain Bitcoin using submarine swaps.

In the current iteration of the Loop software, two swap types are supported:

* Loop Out: off-chain to on-chain. The Loop client sends funds paid on Lightning to a Bitcoin address.
* Loop In: on-chain to off-chain. The Loop client sends funds paid on-chain to a Lightning channel.
* Max swap amount: 4 200 000 sats
* Example usage for lowest cost \(leads to longer confirmation time \(estimation for 25 blocks\) and higher failure rate \(max routing fee 500 sats\) - adjust the numbers accordingly\):  
  `loop out --conf_target 25 --max_swap_routing_fee 500 4200000 [optional external address]`

  ```text
     loop out [command options] amt [addr]

    # --channel value               the 8-byte compact channel ID of the channel to loop out (default: 0)
    # --addr value                  the optional address that the looped out funds should be sent to, if let blank the funds will go to lnd's wallet
    # --amt value                   the amount in satoshis to loop out (default: 0)
    # --conf_target value           the number of blocks from the swap initiation height that the on-chain HTLC should be swept within (default: 6)
    # --max_swap_routing_fee value  the max off-chain swap routing fee in satoshis, if let blank a default max fee will be used (default: 0)
    # --fast                        Indicate you want to swap immediately, paying potentially a higher fee. If not set the swap server might choose to wait up to 30 minutes before publishing the swap HTLC on-chain, to save on chain fees. Not setting this flag might result in a lower swap fee.
  ```

  [https://lightning.engineering/loopapi](https://lightning.engineering/loopapi)

### [Boltz.exchange](https://boltz.exchange/)

Fee: 0.5% both ways

## Swap out - trusted

### [deezy.io](https://deezy.io/)

Swap instantly to get inbound liquidity.

* API: <https://docs.deezy.io/>

* Get the terms for testnet:
  ```
  curl -X GET https://api-testnet.deezy.io/v1/swap/info -H "Accept: */*"
  ```

* Pay the returned invoice to make a testnet swap:
  ```
  curl -X POST https://api-testnet.deezy.io/v1/swap -H "Accept: */*" -H "Content-Type: application/json" --data-binary @- <<DATA
  {
    "amount_sats": 100000,
    "on_chain_address": "tb1qr52ajdmyeakwmnelt2c8gg7k6e7v9d0km564n9",
    "on_chain_sats_per_vbyte": 2
  }
  DATA
  ```

### [Bitfinex](https://bitfinex.com)

A non-KYC \(if not used for fiat\) exchange supporting Lightning deposits \(free\) and withdrawals \(100 sats\). Withdrawal onchain costs a fixed 40000 sats. Find it's nodes at [https://ln.bitfinex.com/](https://ln.bitfinex.com/)

### [FixedFloat](https://fixedfloat.com/)

Lightning cryptocurrency exchange Fee: 0.5 - 1% both ways

### [ZigZag.io](https://zigzag.io/#/)

An exchange that accepts Lightning payments. Max 4M sats Commission ~ 2%

### No longer available [ChainMarket](https://chainmarket.etleneum.com/)

A Lightning to onchain swap market with batched transactions. Fee: 0.5%

## Send to a mobile wallet
Most can send to an onchain address afterwards for a fee (swap out).

### Self-custodial wallets

Run a separate LN node on your phone or desktop where you can move some funds, so remote balance/ inbound liquidity is created

* [Breez](https://breez.technology/)

  A mobile wallet which creates a 1 million sats incoming channel automatically, so funds can be moved over in minutes after setting up.

  Sending the funds out to a bitcoin address on-chain costs 0.5% with [Boltz](https://boltz.exchange/)

* [Phoenix](https://phoenix.acinq.co/)

  Easy to use mobile wallet from Acinq.

* [Blixt wallet](https://blixtwallet.github.io/)

  A non-custodial open-source Lightning Wallet for Android and iOS with a focus on usability and user experience.

* [OBW -Open Bitcoin Wallet](https://github.com/nbd-wtf/obw)

  The Open Bitcoin Wallet (OBW) is an Android Bitcoin and Lightning wallet, a fork of Simple Bitcoin Wallet focused on providing a pleasant and simple experience with advanced features.

* [Muun Wallet](https://muun.com/)

  An easy-to-use cross platform ochain wallet capable of swapping in an out to lightning.


### Custodial wallets

Pay yourself via LN and benefit from the inbound liquidity created.

The drawback is that you don't control the keys of your custodial wallet.

Examples:
* [Blink](https://blink.sv/)
* [Wallet of Satoshi](https://www.walletofsatoshi.com/)
* [Alby](https://getalby.com/)

## More links
* [github.com/bitcoin-software/ln-liquidity](https://github.com/bitcoin-software/ln-liquidity)  
List of exchange services to make coin swaps LN &lt;-&gt; onchain & more
* https://cointastical.medium.com/exchanges-with-support-for-bitcoin-lightning-network-payments-739829bcb7bc  
Exchanges with support for bitcoin Lightning network ⚡ payments
