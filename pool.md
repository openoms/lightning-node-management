# Pool usage notes

Read through the [documentation](https://pool.lightning.engineering/) and the [resources below](#resources).

Follow https://twitter.com/LightningPool for an (unofficial) list of past batches and curated content.

The Pool install script for the RaspiBlitz is [in this PR](https://github.com/rootzoll/raspiblitz/pull/1739):
```
# download
wget https://raw.githubusercontent.com/openoms/raspiblitz/pool/home.admin/config.scripts/bonus.pool.sh
# install
bash bonus.pool.sh on
```

## ratings

By default nodes listed in the [Bos Score list](BosScore.md) are used to fill the bids, called `TIER_1` in the ratings.

* Check for a rating of a public node:
	```
	pool auction ratings [NODE_PUBKEY]
	```

* The check the rating of the local node:
	```
	$ pool auction ratings $(lncli getinfo | grep "identity" | cut -d '"' -f4)
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

## Resources

* Documentation: https://pool.lightning.engineering/

* Source code: https://github.com/lightninglabs/pool

* Unofficial curated info on Twitter: https://twitter.com/LightningPool

* Lightning Wiki page: https://lightningwiki.net/index.php/Lightning_Pool

* Pool release thread from @roasbeef : <https://twitter.com/roasbeef/status/1323299990916063232>

* Technical Deep Dive blogpost: <https://lightning.engineering/posts/2020-11-02-pool-deep-dive/>

* Whitepaper:  <https://lightning.engineering/lightning-pool-whitepaper.pdf>
