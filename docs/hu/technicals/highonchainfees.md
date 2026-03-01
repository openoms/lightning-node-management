# Magas onchain dijak kornyezete

Megjegyzesek a Lightning Network hasznalatrol, amikor a banyasz-dijak magasak.

## Felkeszules

Ajanlasok a magas dijas kornyezetre valo felkeszuleshez.

### Channel kezelese

* Nyiss channel-eket strategikusan alacsony dijas idoszakokban \(hetvegeken\)
* Zard be az inaktiv es megbizhatatlan channel-eket idooen, meg az alacsony dijas idoszakokban
* Minimalizald az allasidot es az instabilitast, ha routing node-ot uzemeltetsz
* Hasznalj privat \(nem hirdetett\) channel-eket [kolto node](../node-types/nodetype.spending.md)-kent, igy a leallasok nem okoznak kenyszeritett bezarast a partner reszerol

### Tarca kezelese

* Egykulcsos (single sig) tarcabol valo finanszirozas olcsobb
* Keszits elo megfelelo meretu UTXO-kat a minimalis koltsegu channel nyitasokhoz
  * konszolidalj \(figyelj az adatvedelmi vonatkozasokra\)
  * egy jol feltoltott es regota futo JoinMarket Maker tarca kulonbozo meretu coinjoined kimeneteket biztosit

## Konfiguracio

### Altalanos
* maximalizald az uzemidot
* allits be hibrid kapcsolatot, ha lehetseges - vedd figyelembe, hogy a proxy mindig hasznalata felfedi az IP-cimedet (hasznalj VPN-t, mint a Tunnelsats)

### LND
* ellenorizd az opciokat a [minta lnd.conf-ban](https://github.com/lightningnetwork/lnd/blob/master/sample-lnd.conf)
* Hasznalj Anchor Commitments-et
  * alapertelmezetten be van kapcsolva LND-ben, ha mindket fel tamogatja az anchor-okat
  * 100000 sats lesz fenntartva az LND onchain tarcajaban, hogy a zarasi dijat CPFP-vel fizesse ki
  * emeld meg a `max-commit-fee-rate-anchors` erteket kenyelmesen magas szintre, hogy elkeruld a tranzakciok torleset a mempool-okbol.
* Allitsd be a `minchansize`-t (pl. kerulj el 500k alatti channel-eket routing node-on\)
* allits be hosszu `payments-expiration-grace-period`-ot
* noveld a CLTV delta-t: `bitcoin.timelockdelta` az alapertelmezett 80-rol
* noveld a legkisebb HTLC-t, amelyet a node hajlando kuldeni (millisatoshi-ban)
* noveld a routing dijakat (csak uj channel-ekre vonatkozik)
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
* fontold meg a dijak noveleset azok fele a partnerek fele, akik nem hasznalnak anchor commitments-et:
  ```
  lncli listchannels | jq '.channels[] | {remote_pubkey: .remote_pubkey, commitment_type: .commitment_type}'
  ```
* allitsd be a `base_fee_msat`, `fee_rate_ppm`, `min_htlc_msat` es `time_lock_delta` ertekeket a meglevo channel-eken
  ```
  lncli updatechanpolicy --base_fee_msat=1000 --fee_rate_ppm=2500 --min_htlc_msat=100000 --time_lock_delta=144
  ```
### CLN
* lasd a lehetseges konfiguracios opciokat: https://github.com/raspiblitz/raspiblitz/blob/dev/FAQ.cl.md#all-possible-config-options
* CLN konfiguracios beallitasok uj channel-ekhez:
  ```
  min-capacity-sat=500000
  cltv-final=144
  fee-base=1000
  fee-per-satoshi=2500
  htlc-minimum-msat=100000

  always-use-proxy=true
  ```

## Routing dijak es egyenlegek

* Minden node eseten:
  * a channel egyenleg kisebbnek fog tunni, mert a commitment tartalek magasabb lesz
  * az offchain tranzakcios dijak is nonek \(a fizetesi osszeg aranyaban marad\)
  * tobbszor fordulhatnak elo fizetesi hibak, ahogy a likviditas csokken
* [Routing node-ok](../node-types/nodetype.routing.md):
  * [A routing dijakat novelni kell](../advanced-tools/fees.md) a megnovekedett onchain dijak es az ujraegyensulyozasi koltsegek kompenzalasara
  * Az automatikus ujraegyensulyozas szamara magasabb dijakat kell engedelyezni
* Az offchain forgalom novekszik
* Magas dijas idoszakokban kevesebb channel nyilik
* Kevesebb toke kerul ujraelosztasra
* A Submarine Swap-ek dragabbak lesznek \(onchain tranzakciot igenyel\)
* Osszessegeben a channel-ek gyorsabban kerulnek egyensulytalan allapotba

## Channel-ek nyitasa

* Tartalmazz change kimenetet, hogy CPFP-vel novelheto legyen a channel nyito tranzakcio dija
* Koetegelt nyitasok
  * a legnagyobb megtakaritas egyetlen bemenet hasznalataval tobb channel nyitasakor erheto el
  * a nyito tranzakcio dijaval celozd meg a kovetkezo blokkot, hogy a dijak ne szaladjanak el
  * hasznalhatsz PSBT-ket \(akar kulso tarcabol is\) a rendelkezesre allo parancssori eszkozokkel:
    * LND: [Balance of Satoshis](https://github.com/alexbosworth/balanceofsatoshis#howtos)

      `bos open` es `bos fund`

    * [C-lightning CLI](https://lightning.readthedocs.io/lightning-fundchannel_start.7.html#)

      `lightningcli fundchannel_start id amount [feerate announce close_to push_msat]`
  * keruldd a nyilvanos es privat \(nem hirdetett\) channel-ek ugyanabban a kotegben torteno nyitasat - ez alaaassa a channel-ek gossip-bol valo kihagyasanak celjet

### Ne hagyj channel-t 2016 blokk \(~2 het\) tovabb fuggo allapotban

A fuggo channel 2016 blokk utan "elavultta" valik - a partner elfelejti a finanszirozasi tranzakciot, igy a channel soha nem lesz online.

* az egyetlen lehetoseg a penzkioldosara a multisig-bol egy \(kolteges\) kenyszeritett zaras lesz.
* Hasznalj CPFP-t \(soha ne RBF-et\)
  * CPFP csak akkor hasznalhato, ha van change kimenet a nyito tranzakciobol:  [https://api.lightning.community/?shell\#bumpfee](https://api.lightning.community/?shell#bumpfee)\):

    `lncli wallet bumpfee --sat_per_byte 110 TXID:INDEX`

    Lightningwiki.net cikk:  [https://lightningwiki.net/index.php/Bumping\_fee\_for\_lightning\_channel\_open](https://lightningwiki.net/index.php/Bumping_fee_for_lightning_channel_open)
* Lehetseges a tranzakcio torleese egy change cimre valo elkoltesevel [Electrum-ban](restorelndonchainfundsinelectrum.md#manage-the-lnd-onchain-funds-in-electrum-wallet)

## Channel-ek zarasa

* Lehetoleg kooperativ zaras legyen
  * a fogado tarcabol CPFP hasznalhato, ha egy fuggo kooperativ zaras alacsony dijjal beragadt a mempool-ba
* Futtasd ujra a channel zaras parancsot, ha a tranzakciot eltavolitottak a mempool-bol

  `lncli closechannel FUNDING_TXID INDEX`

* A kenyszeritett zaras ~5x dragabb, mint a kovetkezo blokk dija az utolso frissiteskor
  * LND 10 percenkent frissit egy online channel-en
  * A regota inaktiv channel-ek kockazatot jelentenek - kulonosen, ha utooljara alacsony banyaszdij idoszakban volt online
* Keruldd el es elozd meg a kenyszeritett zarasokat az allasido es az instabilitas minimalizalasaval routing node-kent

## Watchtower-ok

* Ha [watchtower](../advanced-tools/watchtower.md)-okat hasznalsz, be kell allitani a

  `wtclient.sweep-fee-rate=` erteket az [lnd.conf](https://github.com/lightningnetwork/lnd/blob/a36c95f7325d3941306ac4dfff0f2363fbb8e66d/sample-lnd.conf#L857)-ban

  olyan sat/byte szintre, amellyel a CSV kesleltetes alatt megerositest nyerhet, ha a partner megserto tranzakciot kuld, amig a node offline.

* A CSV kesleltetes hosszabbra allithato a kovetkezovel:

  `lncli updatechanpolicy`

## Jovobeli fejlesztesek

* Anchor commitments alapertelmezetten \(csak uj channel-eket erint, es mindket felnek tamogatnia kell a funkciiot\)
* Splicing es dual funding - a channel kapacitas bovitese egyetlen tranzakcioban
* Taproot - megtakaritast jelenthet a multisig-bol valo kuldessnel \(~26 bajt a minimum 140 bajtbol\)
* Taproot - a multisig tarcakbol valo finanszirozas ugyanannyiba kerul, mint az egykulcsos tarcakbol (az egykulcsos kicsit dragabb lesz)
* ELTOO - tobbszemelyyes channel-ek es channel factory-k

## Hivatkozasok

* [Mi az a CPFP?](https://bitcoinops.org/en/topics/cpfp/)
* [Bezarhato-e egy channel, amig a finanszirozasi tranzakcio meg a mempool-ban varakozik?](https://bitcoin.stackexchange.com/questions/102180/can-a-channel-be-closed-while-the-funding-tx-is-still-stuck-in-the-mempool)
