# High onchain fee environment

Notes on using the Lightning Network when miner fees are high.

## Preparation

Recommendations to get ready for a high fee environment beforehand.

### Channel management

* Open channels during low fee times strategically \(weekends\)
* Close inactive and unreliable channels early during low fee times
* Minimise downtime and instability if running a routing node
* Use private \(unannounced\) channels as a [spending node](../node-types/nodetype.spending.md) so downtimes won't make the peer force-close  

### Wallet management

* Funding from a single sig wallet is cheaper
* Prepare a selection of good size UTXOs for minimal cost channel opens
  * consolidate \(beware of privacy implications\)
  * a well funded and long running JoinMarket Maker wallet will have different sizes of coinjoined outputs available

## Configuration

### General
* maximise uptime
* configure a hybrid connection if possible - note that skipping to always use a proxy will expose your IP address (use a VPN like Tunnelsats)

### LND
* check the options in the [sample lnd.conf](https://github.com/lightningnetwork/lnd/blob/master/sample-lnd.conf)
* Use Anchor Commitments
  * on by default on LND when both peers support anchors
  * will have 100000 sats reserved in the onchain wallet of LND to pay the closing fee with CPFP
  * raise the `max-commit-fee-rate-anchors` to a comfortably high level to avoid purging the transactions from the mempools.
* Set the `minchansize` (eg. avoid &lt;500k channels on a routing node\)
* set a long `payments-expiration-grace-period`
* increase the CLTV delta: `bitcoin.timelockdelta` from the default 80
* increase the smallest HTLC the node is willing to send out (in millisatoshi)
* increase routing fees (applies to new channels only)
  ```
  [Application Options]
  minchansize=500000
  max-commit-fee-rate-anchors=100
  payments-expiration-grace-period=10000h
  bitcoin.timelockdelta=144
  bitcoin.minhtlcout=100000
  bitcoin.basefee=1000
  bitcoin.feerate=2500

  [tor]
  tor.skip-proxy-for-clearnet-targets=true
  ```
* consider increasing the fees towards peers not using anchor commitments:
  ```
  lncli listchannels | jq '.channels[] | {remote_pubkey: .remote_pubkey, commitment_type: .commitment_type}'
  ```
* set the `base_fee_msat`, `fee_rate_ppm`, `min_htlc_msat` and `time_lock_delta` on existing channels
  ```
  lncli updatechanpolicy --base_fee_msat=1000 --fee_rate_ppm=2500000 --min_htlc_msat=100000 --time_lock_delta=144
  ```
### CLN
* see the possible config options: https://github.com/rootzoll/raspiblitz/blob/dev/FAQ.cl.md#all-possible-config-options
* cln config settings for new channels:
  ```
  min-capacity-sat=500000
  cltv-final=144
  fee-base=1000
  fee-per-satoshi=2500
  htlc-minimum-msat=100000

  always-use-proxy=true
  ```

## Routing fees and balances

* All nodes:
  * the channel balance will appear to be smaller as the commitment reserve will be higher
  * offchain transaction fees will also increase \(remains to be proportional to the payment amount\)
  * payment failures might appear more often as liquidity dries up
* [Routing nodes](../node-types/nodetype.routing.md):
  * [Routing fees need to be increased](../advanced-tools/fees.md) to make up for the increased onchain fees and rebalancing costs
  * Auto-rebalancing should be allowed to use higher fees
* Offchain traffic will increase
* During high fee periods less channels will be opened
* Less capital will be reallocated
* Submarine Swaps get more expensive \(requires on-chain transactions\)
* Overall channels will get out of balance quicker

## Opening channels

* Include a change output to be able to use CPFP to bump the fee of the channel open transaction
* Batch opens
  * the biggest saving is when using 1 input to open multiple channels
  * aim for next block with the opening transaction fee to prevent the fees running away
  * can use PSBT-s \(even from ean external wallet\) with the command line tools available:
    * LND: [Balance of Satoshis](https://github.com/alexbosworth/balanceofsatoshis#howtos)  

      `bos open` and `bos fund`

    * [C-lightning CLI](https://lightning.readthedocs.io/lightning-fundchannel_start.7.html#)  

      `lightningcli fundchannel_start id amount [feerate announce close_to push_msat]`
  * avoid opening public and private \(unannounced\) channels in the same batch - defeats the purpose of not announcing channels in the gossip

### Do not leave a channel open pending for more than 2016 blocks \(~2 weeks\)

A pending channel will become "stale" after 2016 blocks - the peer will forget about the funding transaction, so the channel will never become online.

* the only option left to unlock the funds from the multisig will be an \(expensive\) force close.
* Use CPFP \(never RBF\)
  * CPFP can be only used if there is a change output from the opening transaction:  [https://api.lightning.community/?shell\#bumpfee](https://api.lightning.community/?shell#bumpfee)\):  

    `lncli wallet bumpfee --sat_per_byte 110 TXID:INDEX`  

    Lightningwiki.net article:  [https://lightningwiki.net/index.php/Bumping\_fee\_for\_lightning\_channel\_open](https://lightningwiki.net/index.php/Bumping_fee_for_lightning_channel_open)
* Can cancel the transaction by spending it to a change address [in Electrum](restorelndonchainfundsinelectrum.md#manage-the-lnd-onchain-funds-in-electrum-wallet)

## Closing channels

* Aim for a cooperative close if must 
  * can use CPFP from the receiving wallet if a pending ccooperative close is stuck in the mempool with a low fee
* Run the channel close command again if the transaction has been removed from the mempool  

  `lncli closechannel FUNDING_TXID INDEX`

* Force closes are ~5x more expensive than the next block fee at the last update
  * LND updates every 10 min on an online channel
  * Long inactive channels are a liability - especially if was online last at low miner fee period
* Avoid and prevent force closes by minimizing downtime and instability as a routing node

## Watchtowers

* If using [watchtowers](../advanced-tools/watchtower.md) need to set the  

  `wtclient.sweep-fee-rate=` in the [lnd.conf](https://github.com/lightningnetwork/lnd/blob/a36c95f7325d3941306ac4dfff0f2363fbb8e66d/sample-lnd.conf#L857)  

  to a sat/byte level where it can confirm within the CSV delay in case a breach transaction is broadcasted by the peer while the node is offline.

* The CSV delay can be set to be longer with:  

  `lncli updatechanpolicy`

## Future improvements

* Anchor commitments by default \(affects only new channels and both peers need to support the feature\)
* Splicing and dual funding - extend the channel capacity in a single transaction
* Taproot - can save on sending from the multisig \(~26 byte from the min 140 bytes\)
* Taproot - funding from multisig wallets will be the same cost as from single sig wallets (slightly more expensive for single-sig)
* ELTOO - multiparty channels and channel factories

## References

* [What is CPFP?](https://bitcoinops.org/en/topics/cpfp/)
* [Can a channel be closed while the funding tx is still stuck in the mempool?](https://bitcoin.stackexchange.com/questions/102180/can-a-channel-be-closed-while-the-funding-tx-is-still-stuck-in-the-mempool)

