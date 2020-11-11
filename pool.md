# Pool usage notes

Read through the [documentation](https://pool.lightning.engineering/) and the [resources below](#resources).

The best place to search for commands and keywords: https://lightning.engineering/poolapi

Follow https://twitter.com/LightningPool for an (unofficial) list of past batches and curated content.

The Pool install script for the RaspiBlitz is [in this PR](https://github.com/rootzoll/raspiblitz/pull/1739):
```
# download
wget https://raw.githubusercontent.com/openoms/raspiblitz/pool/home.admin/config.scripts/bonus.pool.sh
# inspect the script
cat bonus.pool.sh
# install
bash bonus.pool.sh on
```

## clearing_price_rate
The uniform clearing price rate in parts per billion of the batch.
It equals to the lowest included bid rate in the batch.

## ratings
Returns the current Node Tier of a node, along with other
information.


By default nodes listed in the [Bos Score list](BosScore.md) are used to fill the bids, called `TIER_1` in the ratings.

* Check for a rating of a public node:
	```
	pool auction ratings [NODE_PUBKEY]
	```

* The check the rating of the local node:
	```
	$ pool auc r $(lncli getinfo|grep "identity"|cut -d'"' -f4)
	{
		"node_ratings": [
			{
				"node_pubkey": "REDACTED_NODE_PUBKEY",
				"node_tier": "TIER_1"
			}
		]
	}
	```

* A channel buyer (Taker) can specify a bid to accept all tiers with `--min_node_tier 0`

   ```
   --min_node_tier value          the min node tier this bid should be matched with, tier 1 nodes are considered 'good', if set to tier 0, then all nodes will be considered regardless of 'quality' (default: 0)
   ```


## nextbatchinfo
Returns information about the next batch the auctioneer will perform.

Shows:
* `fee_rate_sat_per_kw`: what the target fee rate cut off will be

* `clear_timestamp`: the blockheight of the next marker clearing attempt 

`$ pool auction nextbatchinfo`

Example:
```
{
	"conf_target": 35,
	"fee_rate_sat_per_kw": "27714",
	"clear_timestamp": "1604406782"
}

```
For your order to be included in the next batch the `fee_rate_sat_per_kw` should be above the cut off value.

List the `fee_rate_sat_per_kw` of your orders with:
```
$ pool orders list | grep fee_rate_sat_per_kw
```

## auction snapshot
Returns information about a prior batch such as the clearing
price and the set of orders included in the batch. The
prev_batch_id field can be used to explore prior batches in the
sequence, similar to a block chain.

last batch info:  
`$ pool auction snapshot`

query the prior batches recursively:
```
# get the previous batch id
prev_batch_id=$(pool auc s |jq -r '.prev_batch_id')

# show the prior batch (just repeat the line to show the past batches)
prev_batch_id=$(pool auc s --batch_id $prev_batch_id|jq -r '.prev_batch_id') && pool auc s --batch_id $prev_batch_id

# show only the clearing price of the prior batch recursively:
prev_batch_id=$(pool auc s --batch_id $prev_batch_id|jq -r '.prev_batch_id') && pool auc s --batch_id $prev_batch_id|jq -r '.clearing_price_rate'
```

Search the txid of a batch on http://1ml.com after it is confirmed (channels opened and published) to see the details of the channels and peers involved.
https://twitter.com/openoms/status/1326482404224229376

## logs

Monitor the pool logs in:
`/home/pool/.pool/logs/mainnet/poold.log`

Example:  
```
tail -f -n 1000 /home/pool/.pool/logs/mainnet/poold.log
```

## Resources

* Documentation: https://pool.lightning.engineering/

* Source code: https://github.com/lightninglabs/pool

* API reference: https://lightning.engineering/poolapi

* Unofficial curated info on Twitter: https://twitter.com/LightningPool

* Lightning Wiki page: https://lightningwiki.net/index.php/Lightning_Pool

* Pool release thread from @roasbeef : <https://twitter.com/roasbeef/status/1323299990916063232>

* LNmarkets newletter about Pool: https://lnmarkets.substack.com/p/15-november-9th-2020

* Technical Deep Dive blogpost: <https://lightning.engineering/posts/2020-11-02-pool-deep-dive/>

* Whitepaper:  <https://lightning.engineering/lightning-pool-whitepaper.pdf>
