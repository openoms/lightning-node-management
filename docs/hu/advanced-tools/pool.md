# Pool használati megjegyzések

Olvasd át a [dokumentációt](https://pool.lightning.engineering/) és az [alább felsorolt forrásokat](pool.md#forrasok).

Parancsok és kulcsszavak kereséséhez a legjobb hely: [https://lightning.engineering/poolapi](https://lightning.engineering/poolapi)

Kövesd a [https://twitter.com/LightningPool](https://twitter.com/LightningPool) oldalt a korábbi kötegek \(nem hivatalos\) listájáért és válogatott tartalmakért.

A Pool telepítő szkriptje RaspiBlitz-hez [ebben a PR-ben](https://github.com/raspiblitz/raspiblitz/pull/1739) található:

```text
# download
wget https://raw.githubusercontent.com/openoms/raspiblitz/pool/home.admin/config.scripts/bonus.pool.sh
# inspect the script
cat bonus.pool.sh
# install
bash bonus.pool.sh on
```

## clearing\_price\_rate

A köteg egységesen alkalmazott elszámolási árfolyama milliárdodrészben (parts per billion). Megegyezik a kötegben szereplő legalacsonyabb elfogadott ajánlati árral.

## ratings

Visszaadja egy node aktuális Node Tier besorolását, egyéb információkkal együtt.

Alapértelmezetten a [Bos Score listában](bosscore.md) szereplő node-okat használják az ajánlatok kitöltéséhez, ezeket a ratingben `TIER_1`-nek hívják. A választás az alábbi szempontok alapján történik: üzemidő, bejövő kapacitás, előzmény, channel frissítések, aktív routing-képesség \(probing által vizsgálva\).

* Egy nyilvános node besorolásának ellenőrzése:

  ```text
    pool auction ratings [NODE_PUBKEY]
  ```

* A saját node besorolásának ellenőrzése:

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

* Egy channel vásárló \(Taker\) megadható, hogy minden besorolást elfogadjon: `--min_node_tier 0`

  ```text
   --min_node_tier value          the min node tier this bid should be matched with, tier 1 nodes are considered 'good', if set to tier 0, then all nodes will be considered regardless of 'quality' (default: 0)
  ```

## nextbatchinfo

Információkat ad vissza a következő kötegről, amelyet az árverésmester végrehajt.

Megmutatja:

* `fee_rate_sat_per_kw`: a célzott díjátvágási határ
* `clear_timestamp`: a következő piaci elszámolási kísérletet tartalmazó blokkmagasság

`$ pool auction nextbatchinfo`

Példa:

```text
{
    "conf_target": 35,
    "fee_rate_sat_per_kw": "27714",
    "clear_timestamp": "1604406782"
}
```

Ahhoz, hogy a megrendelésed bekerüljön a következő kötegbe, a `fee_rate_sat_per_kw` értéknek meg kell haladnia a határérték feletti szintet.

A megrendeléseid `fee_rate_sat_per_kw` értékeinek listázása:

```text
$ pool orders list | grep fee_rate_sat_per_kw
```

## auction snapshot

Információkat ad vissza egy korábbi kötegről, például az elszámolási árról és a kötegben szereplő megrendelésekről. A prev\_batch\_id mező használható a korábbi kötegek feltérképezésére a sorozatban, hasonlóan a blokklánchoz.

Legutóbbi köteg információi:
`$ pool auction snapshot`

Korábbi kötegek rekurzív lekérdezése:

```text
# get the previous batch id
prev_batch_id=$(pool auc s |jq -r '.prev_batch_id')

# show the prior batch (just repeat the line to show the past batches)
prev_batch_id=$(pool auc s --batch_id $prev_batch_id|jq -r '.prev_batch_id') && pool auc s --batch_id $prev_batch_id

# show only the clearing price of the prior batch recursively:
prev_batch_id=$(pool auc s --batch_id $prev_batch_id|jq -r '.prev_batch_id') && pool auc s --batch_id $prev_batch_id|jq -r '.clearing_price_rate'
```

Keresd meg a köteg txid-ját a [http://1ml.com](http://1ml.com) oldalon a megerősítés után \(channel-ek megnyitva és közzétéve\), hogy lásd a channel-ek és peerek részleteit. [https://twitter.com/openoms/status/1326482404224229376](https://twitter.com/openoms/status/1326482404224229376)

## logs

A pool naplók monitorozása: `/home/pool/.pool/logs/mainnet/poold.log`

Példa:

```text
tail -f -n 1000 /home/pool/.pool/logs/mainnet/poold.log
```

## Források

* Dokumentáció: [https://pool.lightning.engineering/](https://pool.lightning.engineering/)
* Forráskód: [https://github.com/lightninglabs/pool](https://github.com/lightninglabs/pool)
* API referencia: [https://lightning.engineering/poolapi](https://lightning.engineering/poolapi)
* Nem hivatalos válogatott információk Twitteren: [https://twitter.com/LightningPool](https://twitter.com/LightningPool)
* Lightning Wiki oldal: [https://lightningwiki.net/index.php/Lightning\_Pool](https://lightningwiki.net/index.php/Lightning_Pool)
* Pool kiadási szál @roasbeef-tól: [https://twitter.com/roasbeef/status/1323299990916063232](https://twitter.com/roasbeef/status/1323299990916063232)
* LNmarkets hírlevél a Pool-ról: [https://lnmarkets.substack.com/p/15-november-9th-2020](https://lnmarkets.substack.com/p/15-november-9th-2020)
* Technikai mélyélemzés blogbejegyzés: [https://lightning.engineering/posts/2020-11-02-pool-deep-dive/](https://lightning.engineering/posts/2020-11-02-pool-deep-dive/)
* Fehér könyv: [https://lightning.engineering/lightning-pool-whitepaper.pdf](https://lightning.engineering/lightning-pool-whitepaper.pdf)
