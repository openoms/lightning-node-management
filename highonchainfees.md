# High onchain fee enviroment 
Notes on using the Lightning Network when miner fees are high.

## Preparation
Recommendations to get ready for a high fee environment beforehand.
* Have a selection of good size UTXOs 
  * plan ahead
  * consolidate (beware of privacy implications)
  * a well funded and long running JoinMarket Maker wallet will have different sizes of coinjoined outputs available
* Spending from a single sig wallet is cheaper
* Open channels during low fee times strategically (weekends)
* Close inactive and unreliable channels early during low fee times
* Minimise downtime and instability if running a routing node
* Configure the minchansize (eg. avoid <500k channels on a routing node)
* Activate Anchor Commitments
  * affects only the new channels opened when both peers support anchors
  * `protocol.anchors=true` in the [lnd.conf](https://github.com/lightningnetwork/lnd/blob/260ea9b842ddd80fbea1df5516f557e3081f743f/sample-lnd.conf#L363)
  * available since [LND v0.12.0](https://github.com/lightningnetwork/lnd/releases/tag/v0.12.0-beta)
  * aimed to be active by default from LND v0.13
  * will need a UTXO left per channel in the onchain wallet of LND to pay the closing fee (CPFP) - these are not reserved in the wallet yet

## Opening channels
* Include a change output to be able to use CPFP to bump the fee of the channel open transaction
* Batch opens
  * the biggest saving is when using 1 input to open multiple channels
  * aim for next block with the opening transaction fee to prevent the fees running away
  * can use PSBT-s (even from ean external wallet) with the command line tools available:
      * LND: [Balance of Satoshis](https://github.com/alexbosworth/balanceofsatoshis#howtos)  
      `bos open` and `bos fund`
      * [C-lightning CLI](https://lightning.readthedocs.io/lightning-fundchannel_start.7.html#)  
      `lightningcli fundchannel_start id amount [feerate announce close_to push_msat]`
  * avoid opening public and private (unannounced) channels in the same batch - defeats the purpose of not announcing channels in the gossip
## Do not leave a channel open pending for more than 2016 blocks (~2 weeks)
A pending channel will become "stale" after 2016 blocks - the peer will forget about the funding transaction, so the channel will never become online.
- the only option left to unlock the funds from the multisig will be an (expensive) force close.

* Use CPFP (never RBF)
    * CPFP can be only used if there is a change output from the opening transaction:  https://api.lightning.community/?shell#bumpfee):  
    `lncli wallet bumpfee --sat_per_byte 110 TXID:INDEX`  
    Lightningwiki.net article:  https://lightningwiki.net/index.php/Bumping_fee_for_lightning_channel_open
* Can cancel the transaction so it is spent to a change address [in Electrum](restorelndonchainfundsinelectrum.md#manage-the-lnd-onchain-funds-in-electrum-wallet)

## Routing fees and balances
* All nodes: 
  * the channel balance will appear to be smaller as the commitment reserve will be higher
  * transaction fees will increase (remains to be proportional to the payment amount)
  * payment failures might appear more often as liquidity dries up
* [Routing nodes](nodetype.routing.md):
  * [Routing fees need to be increased](fees.md) to make up for the increased onchain fees and rebalancing costs
  * Auto-rebalancing should be allowed to use higher fees
* Offchain traffic will increase
* During high fee periods less channels will be opened
* Less capital will be reallocated
* Submarine Swaps get more expensive (requires on-chain transactions)
* Overall channels will get out of balance quicker

## Closing channels
* Aim for a cooperative close if must 
  * can use CPFP from the receiving wallet if stuck pending close
* Force closes are ~5x more expensive than the next block fee at the last update
  * LND updates every 10 min on an online channel
  * Long inactive channels are a liability - especially if was online last at low miner fee period
* Avoid and prevent force closes by minimizing downtime and instability as a routing node

## Watchtowers
* If using [watchtowers](watchtower.md) need to set the  
`wtclient.sweep-fee-rate=` in the [lnd.conf](https://github.com/lightningnetwork/lnd/blob/a36c95f7325d3941306ac4dfff0f2363fbb8e66d/sample-lnd.conf#L857)  
to a sat/byte level where it can confirm within the CSV delay in case a breach transaction is broadcasted by the peer while the node is offline.
* The CSV delay can be set to be longer with:  
`lncli updatechanpolicy`

## Future improvements 
* Anchor commitmets by default (affects only new channels and both peers need to support the feature)
* Taproot - can save on sending to the multisig (~26 byte from about the min 140 bytes)
* Taproot - funding from multisig wallets will be the same cost as from single sig wallets

## References
* [What is CPFP?](https://bitcoinops.org/en/topics/cpfp/)
* [Can a channel be closed while the funding tx is still stuck in the mempool?](https://bitcoin.stackexchange.com/questions/102180/can-a-channel-be-closed-while-the-funding-tx-is-still-stuck-in-the-mempool)