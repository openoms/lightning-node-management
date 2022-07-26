# Lightning privacy

## Reading list
* Lightning privacy: from Zero to Hero <https://github.com/t-bast/lightning-docs/blob/master/lightning-privacy.md>
* Mastering the Lightning Network chapter: <https://github.com/lnbook/lnbook/blob/develop/16_security_privacy_ln.asciidoc>
* Current State of Lightning Network Privacy in 2021 - Tony <https://abytesjourney.com/lightning-privacy>
* BOLT12 proposal <https://bolt12.org>
* Make Lightning Payments Private Again (PLN)
    * <https://bc1984.com/make-lightning-payments-private-again/>
    * <https://bitcoinmagazine.com/technical/pln-makes-bitcoin-lightning-more-private>

### Onion routing
* BOLT #4: Onion Routing Protocol https://github.com/lightning/bolts/blob/master/04-onion-routing.md
https://github.com/ellemouton/onion/blob/master/docs/onionRouting.pdf
* Route Blinding proposal https://github.com/lightning/bolts/blob/route-blinding/proposals/route-blinding.md
https://github.com/ellemouton/onion/blob/master/docs/routeBlinding.pdf
* CLI tool for constructing & peeling onions both with and without route blinding. https://github.com/ellemouton/onion

## Listening and videos
* Privacy on Lightning - Bastien Teinturier - Day 2 DEV Track - AB21 <https://bitcointv.com/w/2pXyaypeMThT5tM3MUWcgN>
* Lightning Privacy - Ficsor, Teinturier, Openoms - Day 2 DEV 2pXyaypeMThT5tM3MUWcgN
<https://bitcointv.com/w/xsj5AEx36Usqts8GuNw9b3>
* [Citadel Dispatch e0.2.1 - the lightning network and bitcoin privacy with @openoms and @cycryptr](https://citadeldispatch.com/cd21/)
* RecklessVR Cryptoanarchy weekend / HCPP20 : how and why to use bitcoin privately <https://www.youtube.com/watch?v=NUlUQlgtWlM>
Slides: <https://keybase.pub/oms/slides/Running_a_Lightning_Node_Privately.pdf>
* [SLP391 BEN CARMAN – BITCOIN PRIVACY, SURVEILLANCE, LN VORTEX, P2P & AUSTIN BITDEVS](https://stephanlivera.com/episode/391/)
* [CD70: using lightning privately with tony and @futurepaul](https://citadeldispatch.com/cd70/)

## Unannounced channels are not private
* Use LDK to probe the lightning network for the detection of private channels: [hiddenlightningnetwork.com](https://github.com/BitcoinDevShop/hidden-lightning-network)
* More details and conversation: <https://lists.linuxfoundation.org/pipermail/lightning-dev/2022-June/003599.html>
* [CD69: decentralized identifiers (DIDs), “web5,” and lightning privacy with tony](https://citadeldispatch.com/cd69/)

## Onchain techniques
* Creating a Core Lightning channel funded by JoinMarket: <https://gist.github.com/BitcoinWukong/0c04d9186251b0a6497fef3737e95ceb>

## Improvements
- [x] Alias SCIDs <https://github.com/lightning/bolts/pull/910>
- [ ] Route blinding: <https://github.com/lightning/bolts/pull/765>
- [ ] Trampoline routing: <https://github.com/lightning/bolts/pull/836>
- [ ] New node for every channel open (send only): <https://github.com/BitcoinDevShop/pln>
- [ ] Coinjoin to channels: <https://github.com/ln-vortex/ln-vortex>

