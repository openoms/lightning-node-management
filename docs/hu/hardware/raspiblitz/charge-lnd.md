A charge-lnd-ről további információ: https://github.com/accumulator/charge-lnd

Telepítsd az alábbi parancsokkal soronként (a kódban a megjegyzések # jellel kezdődnek):
```
# váltás a bitcoin felhasználóra
sudo su - bitcoin
# charge-lnd letöltése
git clone https://github.com/accumulator/charge-lnd.git
# dedikált macaroon létrehozása
lncli bakemacaroon offchain:read offchain:write onchain:read info:read --save_to=~/.lnd/data/chain/bitcoin/mainnet/charge-lnd.macaroon
# könyvtárváltás
cd charge-lnd
# charge-lnd telepítése
pip install -U setuptools && pip install -r requirements.txt .
# kilépés a bitcoin felhasználóból
exit
```

Illeszd be az alábbi teljes kódblokkot a példakonfiguráció létrehozásához a `/home/bitcoin/charge-lnd/charge.config` helyen:
```
echo "
[default]
strategy = static
base_fee_msat = 1000
fee_ppm = 1000
time_lock_delta = 144

[exchanges-drain-sats]
node.id = 033d8656219478701227199cbd6f670335c8d408a92ae88b962c49d4dc0e83e025, 03cde60a6323f7122d5178255766e38114b4722ede08f7c9e0c5df9b912cc201d6,037f990e61acee8a7697966afd29dd88f3b1f8a7b14d625c4f8742bd952003a590,03cde60a6323f7122d5178255766e38114b4722ede08f7c9e0c5df9b912cc201d6,033d8656219478701227199cbd6f670335c8d408a92ae88b962c49d4dc0e83e025, 021c97a90a411ff2b10dc2a8e32de2f29d2fa49d41bfbb52bd416e460db0747d0d
strategy = static
base_fee_msat = 50000
fee_ppm = 2500
time_lock_delta = 144

[discourage-routing]
chan.max_ratio = 0.10
chan.min_capacity = 250000
strategy = static
base_fee_msat = 1000
fee_ppm = 2000
time_lock_delta = 144

[encourage-routing]
chan.min_ratio = 0.90
chan.min_capacity = 250000
strategy = static
base_fee_msat = 1000
fee_ppm = 10
time_lock_delta = 144

" | sudo -u bitcoin tee /home/bitcoin/charge-lnd/charge.config
```

Állíts be egy cron feladatot az alábbi paranccsal:
```
crontab -e
```
Illeszd be az alábbit a crontab-ba, hogy 5 percenként fusson (<https://crontab.guru/#*/5_*_*_*_*>):
```
*/5 * * * * sudo -u bitcoin /home/bitcoin/.local/bin/charge-lnd -c /home/bitcoin/charge-lnd/charge.config
```

## További példakonfigurációkat tartalmazó gist:
<https://gist.github.com/openoms/9d0c554f620f4584c17bec268d4519e8>

A bejegyzés itt is megtalálható: https://habla.news/a/naddr1qqxnzd3c8qunzv35x5mr2wfsqgs24sraj5yfee4d7z9ez4k58sdy4dv5ccfsklwtztkpnyqgckqe5tcrqsqqqa28xwrv7e
