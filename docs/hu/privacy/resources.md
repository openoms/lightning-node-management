# Lightning adatvédelem

## Fogadó oldali adatvédelem az [LNproxy](http://lnproxy.org/) segítségével
* Az lnproxy fogad egy bolt 11 invoice-t, és generál egy "becsomagolt" invoice-t, amely akkor és csak akkor teljesíthető, ha az eredeti invoice is teljesül. A "becsomagolt" invoice ugyanazzal a payment hash-sel, lejárattal és leírással rendelkezik, mint az eredeti, de egy kis routing díjat ad hozzá az összeghez. A "becsomagolt" invoice bárhol használható az eredeti helyett, hogy megbízhatóan elrejtse a fizetés célját.
* Használd az [API](http://lnproxy.org/doc)-t a `.bashrc` fájlodban (elérhető a Raspiblitz v1.9.0-tól, CLI parancsikon formájában is):
  ```
  function lnproxy() {
    echo
    echo "Requesting a wrapped invoice from http://rdq6tvulanl7aqtupmoboyk2z3suzkdwurejwyjyjf4itr3zhxrm2lad.onion ..."
    echo
    torify curl http://rdq6tvulanl7aqtupmoboyk2z3suzkdwurejwyjyjf4itr3zhxrm2lad.onion/api/${1}
  }
  ```
* Kód és saját futtatás leírása: <https://github.com/lnproxy>
* Továbbfejlesztett alias a payment hash ellenőrzéssel: <https://github.com/lnproxy/lnproxy-cli>
*
## Nem bejelentett channel-ek - árnyék likviditás
* Használj párhuzamos privát channel-eket a kapacitás és UTXO-k elrejtéséhez.
* <https://eprint.iacr.org/2021/384.pdf>
  > A nyilvános channel-egyenlegek elrejtéséhez egy node nem bejelentett
channel-eket nyithat a bejelentettekkel párhuzamosan. A bejelentett és nem bejelentett channel-ek egyenlegei közötti
viszonytól függően a támadó továbbra is képes lehet felfedezni a nem bejelentett channel-ek egyenlegeit (pl. ha a
nem bejelentett channel egyenlege meghaladja a bejelentett channel-ek egyenlegeit). Még ebben az
esetben is módosítani kell a szokásos probing technikát.

## Channel-ek nyitása jobb adatvédelemmel
### Kézi módszer
* Hozz létre channel-eket coinjoin kimenetekből.
  * A privát channel-ek nincsenek bejelentve; különösen akkor használd őket, ha már van nyilvános channel a peerhez.
  * Egyszerre egy channel-t nyiss.
  * Ne hozz létre visszajárót (change).
  * Kerüld a kerek összegeket.
* Kooperatívan zárd a channel-t egy külső címre (pl. egy Maker-ként futó Joinmarket tárcára).
* Core Lightning channel létrehozása JoinMarket finanszírozással: <https://gist.github.com/BitcoinWukong/0c04d9186251b0a6497fef3737e95ceb>
* LND szintaxis Balance of Satoshis-szal:
  ```
  bos open PUBKEY --amount SATS --coop-close-address EXTERNAL_ADDRESS --type private --external-funding
  ```
### Mutiny wallet
- LDK / Sensei alapú
- Minden channel nyitáshoz új node
- Channel-ek finanszírozása külső tárcából, visszajáró nélkül
- <https://github.com/BitcoinDevShop/pln>
- <https://mutinywallet.com/>

### LN-vortex
- Coinjoin channel-ekbe: <https://github.com/ln-vortex/ln-vortex>
- Első mainnet tranzakció: <https://twitter.com/benthecarman/status/1590886577940889600>

### Nolooking
- Payjoin channel-ekbe. A fizetés fogadója channel-eket nyithat egy payjoin keretében.
  * <https://github.com/chaincase-app/nolooking>
  * <https://chaincase.app/words/lightning-payjoin>

## LN tárcák
### Mobil tárcák (LN node a telefonon)
Tor támogatás és privát láncinformáció
* OBW - Tor + Electrum szerver támogatás
  * Opcionális letétkezelő hosted channel-ek támogatása - a fizetések a szolgáltató elől is privátak
* Breez - Tor és neutrino backend
* Blixt - Neutrino blokkforrás

### Letétkezelő tárcák
A hagyományos letétkezelők semmilyen adatvédelmet nem nyújtanak az üzemeltető elől.
* Wallet of Satoshi
* Bitcoin Beach Wallet (telefonszám szükséges)
* CoinOS (Liquid kompatibilis LN <-> Liquid átjáró)

### LN kompatibilis chaumian (vakított) mint-ek
* Cashu böngészőben - <https://cashu.space> , LNbits bővítmény
* Fedimint LN gateway-ekkel - fejlesztés alatt

## LN protokoll fejlesztések
- [x] Alias SCIDs <https://github.com/lightning/bolts/pull/910>
- [ ] Route blinding: <https://github.com/lightning/bolts/pull/765>
- [ ] Trampoline routing: <https://github.com/lightning/bolts/pull/836>
- [ ] PTLCs <https://lists.linuxfoundation.org/pipermail/lightning-dev/2021-October/003278.html>

## Támadások
### Channel jamming
* <https://jamming-dev.github.io/book>
* <https://twitter.com/ffstls/status/1559902528808140804>
### LNsploit
* Lightning Network exploit eszközkészlet: <https://www.nakamoto.codes/BitcoinDevShop/LNsploit>

### Probing
- [hiddenlightningnetwork.com](https://github.com/BitcoinDevShop/hidden-lightning-network) - LDK-t használ a Lightning Network szondázásához privát channel-ek felderítésére
* További részletek és beszélgetés: <https://lists.linuxfoundation.org/pipermail/lightning-dev/2022-June/003599.html>
* [CD69: decentralizált azonosítók (DID-ek), "web5" és Lightning adatvédelem Tony-val](https://citadeldispatch.com/cd69/)

## Olvasási lista
* Lightning adatvédelem: Nulláról a csúcsra <https://github.com/t-bast/lightning-docs/blob/master/lightning-privacy.md>
* Mastering the Lightning Network fejezet: <https://github.com/lnbook/lnbook/blob/develop/16_security_privacy_ln.asciidoc>
* A Lightning Network adatvédelem jelenlegi állapota 2021-ben - Tony <https://abytesjourney.com/lightning-privacy>
* BOLT12 javaslat <https://bolt12.org>
* Tegyük újra priváttá a Lightning fizetéseket (PLN)
    * <https://bc1984.com/make-lightning-payments-private-again/>
    * <https://bitcoinmagazine.com/technical/pln-makes-bitcoin-lightning-more-private>

### Onion routing
* BOLT #4: Onion Routing protokoll https://github.com/lightning/bolts/blob/master/04-onion-routing.md
https://github.com/ellemouton/onion/blob/master/docs/onionRouting.pdf
* Route Blinding javaslat https://github.com/lightning/bolts/blob/route-blinding/proposals/route-blinding.md
https://github.com/ellemouton/onion/blob/master/docs/routeBlinding.pdf
* CLI eszköz onion-ok építéséhez és bontásához, route blinding-gal és anélkül. https://github.com/ellemouton/onion

## Előadások és videók
* Adatvédelem a Lightning-on - Bastien Teinturier - 2. nap DEV szekció - AB21 <https://bitcointv.com/w/2pXyaypeMThT5tM3MUWcgN>
* Lightning adatvédelem - Ficsor, Teinturier, Openoms - 2. nap DEV 2pXyaypeMThT5tM3MUWcgN
<https://bitcointv.com/w/xsj5AEx36Usqts8GuNw9b3>
* [Citadel Dispatch e0.2.1 - a Lightning Network és Bitcoin adatvédelem @openoms-szal és @cycryptr-rel](https://citadeldispatch.com/cd21/)
* RecklessVR Cryptoanarchy weekend / HCPP20 : hogyan és miért használd a Bitcoin-t privát módon <https://www.youtube.com/watch?v=NUlUQlgtWlM>
Diák: <https://keybase.pub/oms/slides/Running_a_Lightning_Node_Privately.pdf>
* [SLP391 BEN CARMAN -- BITCOIN ADATVÉDELEM, MEGFIGYELÉS, LN VORTEX, P2P ÉS AUSTIN BITDEVS](https://stephanlivera.com/episode/391/)
* [CD70: a Lightning privát használata Tony-val és @futurepaul-lal](https://citadeldispatch.com/cd70/)
