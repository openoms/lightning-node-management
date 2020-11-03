# Pool usage notes

Read the notes on usage with examples:   
* https://pool.lightning.engineering/
* https://github.com/lightninglabs/pool

The install script for the RaspiBlitz is [in this PR](https://github.com/rootzoll/raspiblitz/pull/1739):
```
# download
wget https://raw.githubusercontent.com/openoms/raspiblitz/pool/home.admin/config.scripts/bonus.pool.sh
# install
bash bonus.pool.sh on
```

## ratings

Generally nodes listed in the [Bos Score list](BosScore.md) are used to fill the asks, called `TIER_1` in the ratings:

Check for a rating of a node:
```
pool auction ratings [NODE_PUBKEY]
```

The check own node rating:

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

## nextbatchinfo
gives you an idea of when the next marker clearing attempt is in addition to what the target fee rate cut off will be
```
{
        "conf_target": 30,
        "fee_rate_sat_per_kw": "26541",
        "clear_timestamp": "1604359217"
}
```
For your order to be included in the next batch the `fee_rate_sat_per_kw` should be above the cut off value.

List the `fee_rate_sat_per_kw` of your order with:
```
$ pool orders list | grep fee_rate_sat_per_kw
```