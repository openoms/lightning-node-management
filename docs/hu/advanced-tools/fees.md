# Haladó és automatizált díjbeállítások

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

Csatorna-díjak beállítása szabályzat alapján.
Ez a szkript az aktív csatornáidat egyedi feltételek alapján vizsgálja, és a megfelelő szabályzatot alkalmazza rájuk.

## [LND fees manager](https://gitlab.com/nolith/lndfeesmanager)

Az lndfeesmanager egy egyszerű szoftver, amelynek célja a LN csatornák kiegyensúlyozása dinamikus díjak segítségével.
Ha egy csatorna kiegyensúlyozatlan, a díjakat automatikusan módosítja.

Ha az egyenleg nagyrészt helyi (local), a díjak csökkennek, hogy ösztönözzék a routing-ot.
Ha az egyenleg nagyrészt távoli (remote), a díjak emelkednek, hogy visszafogják a routing-ot.
Ha a csatorna kiegyensúlyozott, közepes díj kerül beállításra.

## További olvasnivaló

* Hasznos képleteket tartalmazó cikk: [http://satbase.org/routing-fees/](http://satbase.org/routing-fees/)
