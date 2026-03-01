# Magas onchain díjak környezete

Megjegyzések a Lightning Network használatról, amikor a bányász-díjak magasak.

## Felkészülés

Ajánlások a magas díjas környezetre való felkészüléshez.

### Channel kezelése

* Nyiss channel-eket stratégiailag alacsony díjas időszakokban \(hétvégeken\)
* Zárd be az inaktív és megbízhatatlan channel-eket időben, még az alacsony díjas időszakokban
* Minimalizáld az állásidőt és az instabilitást, ha routing node-ot üzemeltetsz
* Használj privát \(nem hirdetett\) channel-eket [költő node](../node-types/nodetype.spending.md)-ként, így a leállások nem okoznak kényszerített bezárást a partner részéről

### Tárca kezelése

* Egykulcsos (single sig) tárcából való finanszírozás olcsóbb
* Készíts elő megfelelő méretű UTXO-kat a minimális költségű channel nyitásokhoz
  * konszolidálj \(figyelj az adatvédelmi vonatkozásokra\)
  * egy jól feltöltött és régóta futó JoinMarket Maker tárca különböző méretű coinjoined kimeneteket biztosít

## Konfiguráció

### Általános
* maximalizáld az üzemidőt
* állíts be hibrid kapcsolatot, ha lehetséges - vedd figyelembe, hogy a proxy mindig használata felfedi az IP-címedet (használj VPN-t, mint a Tunnelsats)

### LND
* ellenőrizd az opciókat a [minta lnd.conf-ban](https://github.com/lightningnetwork/lnd/blob/master/sample-lnd.conf)
* Használj Anchor Commitments-et
  * alapértelmezetten be van kapcsolva LND-ben, ha mindkét fél támogatja az anchor-okat
  * 100000 sats lesz fenntartva az LND onchain tárcájában, hogy a zárási díjat CPFP-vel fizesse ki
  * emeld meg a `max-commit-fee-rate-anchors` értékét kényelmesen magas szintre, hogy elkerüld a tranzakciók törlését a mempool-okból.
* Állítsd be a `minchansize`-t (pl. kerülj el 500k alatti channel-eket routing node-on\)
* állíts be hosszú `payments-expiration-grace-period`-ot
* növeld a CLTV delta-t: `bitcoin.timelockdelta` az alapértelmezett 80-ról
* növeld a legkisebb HTLC-t, amelyet a node hajlandó küldeni (millisatoshi-ban)
* növeld a routing díjakat (csak új channel-ekre vonatkozik)
  ```
  [Application Options]
  minchansize=500000
  max-commit-fee-rate-anchors=100
  payments-expiration-grace-period=10000h

  [Bitcoin]
  bitcoin.timelockdelta=144
  bitcoin.minhtlcout=100000
  bitcoin.basefee=1000
  bitcoin.feerate=2500

  [tor]
  tor.skip-proxy-for-clearnet-targets=true
  ```
* fontold meg a díjak növelését azok felé a partnerek felé, akik nem használnak anchor commitments-et:
  ```
  lncli listchannels | jq '.channels[] | {remote_pubkey: .remote_pubkey, commitment_type: .commitment_type}'
  ```
* állítsd be a `base_fee_msat`, `fee_rate_ppm`, `min_htlc_msat` és `time_lock_delta` értékeket a meglévő channel-eken
  ```
  lncli updatechanpolicy --base_fee_msat=1000 --fee_rate_ppm=2500 --min_htlc_msat=100000 --time_lock_delta=144
  ```
### CLN
* lásd a lehetséges konfigurációs opciókat: https://github.com/raspiblitz/raspiblitz/blob/dev/FAQ.cl.md#all-possible-config-options
* CLN konfigurációs beállítások új channel-ekhez:
  ```
  min-capacity-sat=500000
  cltv-final=144
  fee-base=1000
  fee-per-satoshi=2500
  htlc-minimum-msat=100000

  always-use-proxy=true
  ```

## Routing díjak és egyenlegek

* Minden node esetén:
  * a channel egyenleg kisebbnek fog tűnni, mert a commitment tartalék magasabb lesz
  * az offchain tranzakciós díjak is nőnek \(a fizetési összeg arányában marad\)
  * többször fordulhatnak elő fizetési hibák, ahogy a likviditás csökken
* [Routing node-ok](../node-types/nodetype.routing.md):
  * [A routing díjakat növelni kell](../advanced-tools/fees.md) a megnövekedett onchain díjak és az újraegyensúlyozási költségek kompenzálására
  * Az automatikus újraegyensúlyozás számára magasabb díjakat kell engedélyezni
* Az offchain forgalom növekszik
* Magas díjas időszakokban kevesebb channel nyílik
* Kevesebb tőke kerül újraelosztásra
* A Submarine Swap-ek drágábbak lesznek \(onchain tranzakciót igényel\)
* Összességében a channel-ek gyorsabban kerülnek egyensúlytalan állapotba

## Channel-ek nyitása

* Tartalmazz change kimenetet, hogy CPFP-vel növelhető legyen a channel nyitó tranzakció díja
* Kötegelelt nyitások
  * a legnagyobb megtakarítás egyetlen bemenet használatával több channel nyitásakor érhető el
  * a nyitó tranzakció díjával célozd meg a következő blokkot, hogy a díjak ne szaladjanak el
  * használhatsz PSBT-ket \(akár külső tárcából is\) a rendelkezésre álló parancssori eszközökkel:
    * LND: [Balance of Satoshis](https://github.com/alexbosworth/balanceofsatoshis#howtos)

      `bos open` és `bos fund`

    * [C-lightning CLI](https://lightning.readthedocs.io/lightning-fundchannel_start.7.html#)

      `lightningcli fundchannel_start id amount [feerate announce close_to push_msat]`
  * kerüld a nyilvános és privát \(nem hirdetett\) channel-ek ugyanabban a kötegelésben történő nyitását - ez aláássa a channel-ek gossip-ból való kihagyásának célját

### Ne hagyj channel-t 2016 blokk \(~2 hét\) tovább függő állapotban

A függő channel 2016 blokk után "elavulttá" válik - a partner elfelejti a finanszírozási tranzakciót, így a channel soha nem lesz online.

* az egyetlen lehetőség a pénzkioldásra a multisig-ból egy \(költséges\) kényszerített zárás lesz.
* Használj CPFP-t \(soha ne RBF-et\)
  * CPFP csak akkor használható, ha van change kimenet a nyitó tranzakcióból:  [https://api.lightning.community/?shell\#bumpfee](https://api.lightning.community/?shell#bumpfee)\):

    `lncli wallet bumpfee --sat_per_byte 110 TXID:INDEX`

    Lightningwiki.net cikk:  [https://lightningwiki.net/index.php/Bumping\_fee\_for\_lightning\_channel\_open](https://lightningwiki.net/index.php/Bumping_fee_for_lightning_channel_open)
* Lehetséges a tranzakció törlése egy change címre való elköltésével [Electrum-ban](restorelndonchainfundsinelectrum.md#manage-the-lnd-onchain-funds-in-electrum-wallet)

## Channel-ek zárása

* Lehetőleg kooperatív zárás legyen
  * a fogadó tárcából CPFP használható, ha egy függő kooperatív zárás alacsony díjjal beragadt a mempool-ba
* Futtasd újra a channel zárás parancsot, ha a tranzakciót eltávolították a mempool-ból

  `lncli closechannel FUNDING_TXID INDEX`

* A kényszerített zárás ~5x drágább, mint a következő blokk díja az utolsó frissítéskor
  * LND 10 percenként frissít egy online channel-en
  * A régóta inaktív channel-ek kockázatot jelentenek - különösen, ha utoljára alacsony bányászdíj időszakban volt online
* Kerüld el és előzd meg a kényszerített zárásokat az állásidő és az instabilitás minimalizálásával routing node-ként

## Watchtower-ok

* Ha [watchtower](../advanced-tools/watchtower.md)-okat használsz, be kell állítani a

  `wtclient.sweep-fee-rate=` értéket az [lnd.conf](https://github.com/lightningnetwork/lnd/blob/a36c95f7325d3941306ac4dfff0f2363fbb8e66d/sample-lnd.conf#L857)-ban

  olyan sat/byte szintre, amellyel a CSV késleltetés alatt megerősítést nyerhet, ha a partner megsértő tranzakciót küld, amíg a node offline.

* A CSV késleltetés hosszabbra állítható a következővel:

  `lncli updatechanpolicy`

## Jövőbeli fejlesztések

* Anchor commitments alapértelmezetten \(csak új channel-eket érint, és mindkét félnek támogatnia kell a funkciót\)
* Splicing és dual funding - a channel kapacitás bővítése egyetlen tranzakcióban
* Taproot - megtakarítást jelenthet a multisig-ból való küldésnél \(~26 bájt a minimum 140 bájtból\)
* Taproot - a multisig tárcákból való finanszírozás ugyanannyiba kerül, mint az egykulcsos tárcákból (az egykulcsos kicsit drágább lesz)
* ELTOO - többszemélyes channel-ek és channel factory-k

## Hivatkozások

* [Mi az a CPFP?](https://bitcoinops.org/en/topics/cpfp/)
* [Bezárható-e egy channel, amíg a finanszírozási tranzakció még a mempool-ban várakozik?](https://bitcoin.stackexchange.com/questions/102180/can-a-channel-be-closed-while-the-funding-tx-is-still-stuck-in-the-mempool)
