# Configuración avanzada y automatizada de costos

## [Balance of Satoshis](https://github.com/alexbosworth/balanceofsatoshis)

`$ bos fees --help`

```text
USAGE
  bos fees
  List out fee rates, fix problems with routing policies, set out fees
  When setting fee, if channels pending, will wait for confirm to set
  Set-fee-rate can use formulas: https://formulajs.info/functions/
  You can use INBOUND_FEE_RATE to mirror an inbound fee
  Specify PERCENT(0.00) to set the fee as a fraction of routed amount
  Specify BIPS() to set the fee as parts per thousand
  You can use INBOUND and OUTBOUND in formulas for IF formulas
OPTIONS
  --node <node_name>         Node to find record on                    optional      
  --set-fee-rate <rate>      Forward fee in parts per million          optional      
  --to <peer>                Peer public key or alias to set fees      optional
```

## [charge-lnd](https://github.com/accumulator/charge-lnd)

Establezca los costos de uso del canal según una política.
Este script compara sus canales abiertos con una serie de criterios personalizables y aplica una política para el canal basado en dicha configuración.

## [LND fees manager](https://gitlab.com/nolith/lndfeesmanager)

lndfeesmanager es un software cuyo objetivo es  equilibrar los canales LN mediante costos dinámicos.
Cuando un canal está desbalanceado actualiza los costos.

Si el saldo es mayormente local, los costos se reducirán para incentivar el enrutamiento.
Si el saldo es mayormente remoto, las tarifas se incrementarán para desincentivar el enrutamiento.
Si el canal está equilibrado, se establecerá una tarifa media.

## Información adicional

* Artículo con fórmulas útiles: [http://satbase.org/routing-fees/](http://satbase.org/routing-fees/)
