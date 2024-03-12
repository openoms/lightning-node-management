# Advanced and automated fee settings

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

Set channel fees based on policy.  
This script matches your open channels against a number of customizable criteria and applies a channel policy based on the matching section.

## [LND fees manager](https://gitlab.com/nolith/lndfeesmanager)

lndfeesmanager is a simple software that aims to balance LN channels using a dynamic fees.  
When a channel is unbalanced it will update the fees.

If the balance is mostly local, fees will be decreased to incentivise routing.  
If the balance is mostly remote, fees will be increased to disincentivise routing.  
If the channel is balanced, a medium fee will be set.

## More reading

* An article with useful formulas: [http://satbase.org/routing-fees/](http://satbase.org/routing-fees/)

