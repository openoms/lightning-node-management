# Pool hasznalati megjegyzesek

Olvasd at a [dokumentaciot](https://pool.lightning.engineering/) es az [alabb felsorolt forrasokat](pool.md#forrasok).

Parancsok es kulcsszavak keresesehez a legjobb hely: [https://lightning.engineering/poolapi](https://lightning.engineering/poolapi)

Kovetsd a [https://twitter.com/LightningPool](https://twitter.com/LightningPool) oldalt a korabbi kotegek \(nem hivatalos\) listajert es valogatott tartalmakert.

A Pool telepito szkriptje RaspiBlitz-hez [ebben a PR-ben](https://github.com/raspiblitz/raspiblitz/pull/1739) talalhato:

```text
# download
wget https://raw.githubusercontent.com/openoms/raspiblitz/pool/home.admin/config.scripts/bonus.pool.sh
# inspect the script
cat bonus.pool.sh
# install
bash bonus.pool.sh on
```

## clearing\_price\_rate

A koteg egysegesen alkalmazott elszamolasi arfolyama milliardodreszben (parts per billion). Megegyezik a kotegben szereplo legalacsonyabb elfogadott ajanlati arral.

## ratings

Visszaadja egy node aktualis Node Tier besorolasat, egyeb informaciokkal egyutt.

Alapertelmezetten a [Bos Score listaban](bosscore.md) szereplo node-okat hasznaljak az ajanlatok kitoltesehez, ezeket a ratingben `TIER_1`-nek hivjak. A valasztas az alabbi szempontok alapjan tortenik: uzemido, bejovo kapacitas, elozmeny, channel frissitesek, aktiv routing-kepesseg \(probing altal vizsgalva\).

* Egy nyilvanos node besorolasanak ellenorzese:

  ```text
    pool auction ratings [NODE_PUBKEY]
  ```

* A sajat node besorolasanak ellenorzese:

  ```text
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

* Egy channel vasarlo \(Taker\) megadhato, hogy minden besorolast elfogadjon: `--min_node_tier 0`

  ```text
   --min_node_tier value          the min node tier this bid should be matched with, tier 1 nodes are considered 'good', if set to tier 0, then all nodes will be considered regardless of 'quality' (default: 0)
  ```

## nextbatchinfo

Informaciokat ad vissza a kovetkezo kotegrol, amelyet az arveresmester vegrehajt.

Megmutatja:

* `fee_rate_sat_per_kw`: a celzott dijatvagasi hatar
* `clear_timestamp`: a kovetkezo piaci elszamolasi kiserletet tartalmazo blokkmagassag

`$ pool auction nextbatchinfo`

Pelda:

```text
{
    "conf_target": 35,
    "fee_rate_sat_per_kw": "27714",
    "clear_timestamp": "1604406782"
}
```

Ahhoz, hogy a megrendelesed bekeruljon a kovetkezo kotegbe, a `fee_rate_sat_per_kw` erteknek meg kell haladnia a hatarertek feletti szintet.

A megrendeleseid `fee_rate_sat_per_kw` ertekeinek listazasa:

```text
$ pool orders list | grep fee_rate_sat_per_kw
```

## auction snapshot

Informaciokat ad vissza egy korabbi kotegrol, peldaul az elszamolasi arrol es a kotegben szereplo megrendelesekrol. A prev\_batch\_id mezo hasznalhato a korabbi kotegek felterkepezesere a sorozatban, hasonloan a blokklaanchoz.

Legutobbi koteg informacioi:
`$ pool auction snapshot`

Korabbi kotegek rekurziv lekerdezese:

```text
# get the previous batch id
prev_batch_id=$(pool auc s |jq -r '.prev_batch_id')

# show the prior batch (just repeat the line to show the past batches)
prev_batch_id=$(pool auc s --batch_id $prev_batch_id|jq -r '.prev_batch_id') && pool auc s --batch_id $prev_batch_id

# show only the clearing price of the prior batch recursively:
prev_batch_id=$(pool auc s --batch_id $prev_batch_id|jq -r '.prev_batch_id') && pool auc s --batch_id $prev_batch_id|jq -r '.clearing_price_rate'
```

Keresd meg a koteg txid-jat a [http://1ml.com](http://1ml.com) oldalon a megerosites utan \(channel-ek megnyitva es kozeteve\), hogy lasd a channel-ek es peerek reszleteit. [https://twitter.com/openoms/status/1326482404224229376](https://twitter.com/openoms/status/1326482404224229376)

## logs

A pool naplok monitorozasa: `/home/pool/.pool/logs/mainnet/poold.log`

Pelda:

```text
tail -f -n 1000 /home/pool/.pool/logs/mainnet/poold.log
```

## Forrasok

* Dokumentacio: [https://pool.lightning.engineering/](https://pool.lightning.engineering/)
* Forráskod: [https://github.com/lightninglabs/pool](https://github.com/lightninglabs/pool)
* API referencia: [https://lightning.engineering/poolapi](https://lightning.engineering/poolapi)
* Nem hivatalos valogatott informaciok Twitteren: [https://twitter.com/LightningPool](https://twitter.com/LightningPool)
* Lightning Wiki oldal: [https://lightningwiki.net/index.php/Lightning\_Pool](https://lightningwiki.net/index.php/Lightning_Pool)
* Pool kiadasi szal @roasbeef-tol: [https://twitter.com/roasbeef/status/1323299990916063232](https://twitter.com/roasbeef/status/1323299990916063232)
* LNmarkets hirlevel a Pool-rol: [https://lnmarkets.substack.com/p/15-november-9th-2020](https://lnmarkets.substack.com/p/15-november-9th-2020)
* Technikai melyelemzes blogbejegyzes: [https://lightning.engineering/posts/2020-11-02-pool-deep-dive/](https://lightning.engineering/posts/2020-11-02-pool-deep-dive/)
* Feher konyv: [https://lightning.engineering/lightning-pool-whitepaper.pdf](https://lightning.engineering/lightning-pool-whitepaper.pdf)
