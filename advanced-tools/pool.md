# Notas de uso de Lightning Pool

Lea la [documentación](https://pool.lightning.engineering/) y los [siguientes recursos](pool.md#resources).

Mejor lugar para encontrar comandos y palabras clave: [https://lightning.engineering/poolapi](https://lightning.engineering/poolapi)

Siga [https://twitter.com/LightningPool](https://twitter.com/LightningPool) para obtener una lista \(no oficial\) de lotes anteriores y contenido seleccionado.

El script de instalación de Lightning Pool para RaspiBlitz está [en este PR](https://github.com/rootzoll/raspiblitz/pull/1739):

```text
# descargar
wget https://raw.githubusercontent.com/openoms/raspiblitz/pool/home.admin/config.scripts/bonus.pool.sh
# ver el script
cat bonus.pool.sh
# instalar
bash bonus.pool.sh on
```

## clearing\_price\_rate

Tasa de compensación uniforme en partes por billón(US) del lote. Equivale a la oferta más baja incluida en el lote.

## ratings

Devuelve el "Node Tier" de un nodo e información adicional.

Por defecto los nodos listados en la [Bos Score list](bosscore.md) se utilizan para completar los bids (ofertas) y se conocen como "TIER_1" en los ratings. Se seleccionan de acuerdo a: tiempo de actividad, capacidad de entrada, historial, actualizaciones de los canales y capacidad de enrutar activamente \(mediante sondeo\).

* Verifique el rating de un nodo público:

  ```text
    pool auction ratings [NODE_PUBKEY]
  ```

* Verifique el rating de un nodo local:

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

* Un comprador de canal \(Taker\) puede especificar un bid (oferta) para aceptar todos los "tiers" con `--min_node_tier 0`

  ```text
   --min_node_tier value          the min node tier this bid should be matched with, tier 1 nodes are considered 'good', if set to tier 0, then all nodes will be considered regardless of 'quality' (default: 0)
  ```

## nextbatchinfo

Devuelve información sobre el próximo lote que se subastará.

Muestra:

* `fee_rate_sat_per_kw`: cuál será el límite de la tasa objetivo
* `clear_timestamp`: el timestamp en el que se intetará la compensación próximo bloque

`$ pool auction nextbatchinfo`

Ejemplo:

```text
{
    "conf_target": 35,
    "fee_rate_sat_per_kw": "27714",
    "clear_timestamp": "1604406782"
}
```

Para que su orden sea incluida en el siguiente lote el `fee_rate_sat_per_kw` debe estar por encima del valor de corte.

Consulte el `fee_rate_sat_per_kw` de sus ordenes con:

```text
$ pool orders list | grep fee_rate_sat_per_kw
```

## auction snapshot

Devuelve información sobre un lote anterior, entre otros, el precio de compensación y las órdenes incluidas en el lote. El campo prev\_batch\_id se puede usar para explorar lotes anteriores de forma similar a una blockchain.

Obtener información del último lote:
`$ pool auction snapshot`

consultar lotes anteriores recursivamente:

```text
# get the previous batch id
prev_batch_id=$(pool auc s |jq -r '.prev_batch_id')

# show the prior batch (just repeat the line to show the past batches)
prev_batch_id=$(pool auc s --batch_id $prev_batch_id|jq -r '.prev_batch_id') && pool auc s --batch_id $prev_batch_id

# show only the clearing price of the prior batch recursively:
prev_batch_id=$(pool auc s --batch_id $prev_batch_id|jq -r '.prev_batch_id') && pool auc s --batch_id $prev_batch_id|jq -r '.clearing_price_rate'
```

Busque el txid de un lote en [http://1ml.com](http://1ml.com) después de que se confirme \(canales abiertos y publicados\) para ver los detalles de los canales e involucrados. [https://twitter.com/openoms/status/1326482404224229376](https://twitter.com/openoms/status/1326482404224229376)

## logs

Monitoree los logs del Pool en: `/home/pool/.pool/logs/mainnet/poold.log`

Example:

```text
tail -f -n 1000 /home/pool/.pool/logs/mainnet/poold.log
```

## Recursos

* Documentación: [https://pool.lightning.engineering/](https://pool.lightning.engineering/)
* Código fuente: [https://github.com/lightninglabs/pool](https://github.com/lightninglabs/pool)
* API: [https://lightning.engineering/poolapi](https://lightning.engineering/poolapi)
* Información no oficial en Twitter: [https://twitter.com/LightningPool](https://twitter.com/LightningPool)
* Wiki de Lightning: [https://lightningwiki.net/index.php/Lightning\_Pool](https://lightningwiki.net/index.php/Lightning_Pool)
* Hilo del release de Pool por @roasbeef : [https://twitter.com/roasbeef/status/1323299990916063232](https://twitter.com/roasbeef/status/1323299990916063232)
* Boletín de noticias de LNmarkets acerca de Pool: [https://lnmarkets.substack.com/p/15-november-9th-2020](https://lnmarkets.substack.com/p/15-november-9th-2020)
* Artículo con análisis técnico: [https://lightning.engineering/posts/2020-11-02-pool-deep-dive/](https://lightning.engineering/posts/2020-11-02-pool-deep-dive/)
* Whitepaper: [https://lightning.engineering/lightning-pool-whitepaper.pdf](https://lightning.engineering/lightning-pool-whitepaper.pdf)
