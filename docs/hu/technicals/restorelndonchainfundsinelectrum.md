# LND onchain penzkeszlet kezelese Electrum / Sparrow / Specter tarcakban

* A master publikus kulcsok letrehozasahoz (az LND onchain tarca YPUB / ZPUB megjelenitese) a tranzakciok kulso monitorozasahoz es epiteesehez a kovetkezo parancs hasznalhato:
  ```
  lncli wallet accounts list --name default
  ```

* PSBT alairasa:
  ```
  lncli wallet psbt finalize --funded_psbt "base64_encoded_PSBT"
  ```

* Tranzakcio kozvetetise LND-vel:
  ```
  lncli wallet publishtx "tx_hex"
  ```

* A reszletekert kovesdd a beszelgetest: https://github.com/raspiblitz/raspiblitz/issues/2192

## Onchain penzkeszlet visszaallitasa LND tarcabol Electrum Wallet-be

Ezt csak akkor csinaldd, ha erted a folyamatot.
Soha ne adj meg titkos adatokat online weboldalakon.
Keruldd a bovitmenyekkel rendelkezo bongeszoablakokat.
A Tor Browser jo kiindulasi pont \(celozd meg az offline hasznalat\).

Szukseges:

* LND 24 szavas seed \(+ jelszo, ha hasznaltal\)
* hasznos, ha tudod a feltoltott cimeket
* hasznalj dedikalt, biztonsagos operacios rendszert, pl. [Tails](https://tails.boum.org/)
* mentsd el az online oldalakat lemezre es nyisd meg egy uj bongeszoablakban

### Nyisd meg: [https://guggero.github.io/cryptography-toolkit/\#!/aezeed](https://guggero.github.io/cryptography-toolkit/#!/aezeed)

* a `Decode mnemonic` resz alatt

  add meg a 24 szavas seed-et \(+ jelszot, ha hasznaltal\)

* masold ki a `HD node root key base58` erteket

### Nyisd meg: [https://iancoleman.io/bip39/](https://iancoleman.io/bip39/)

* add meg a `HD node root key base58` erteket a `BIP32 Root Key` mezobe
* a `Derivation Path` resz alatt
  * Valaszd a `BIP84` fult a bc1.. cimekhez.
  * Valaszd a `BIP49` fult a 3.. cimekhez.
* Masold ki a privat kulcsokat az ismert vagy osszes cimhez \(`Account Extended Private Key`\).

### Nyisd meg az Electrum Wallet-et

Kovesd: [https://bitcoinelectrum.com/importing-your-private-keys-into-electrum/](https://bitcoinelectrum.com/importing-your-private-keys-into-electrum/)

A privat kulcsok importalasakor hasznald az alabbi prefixeket:

* `p2wpkh:` a `bc1...` cimek privat kulcsai elott
* `p2wpkh-p2sh:` a `3...` cimek privat kulcsai elott

Kesz. Miutan az Electrum Server befejezte a beolvasast, a penzkeszletnek meg kell jelennie.

## Az LND tarca onchain reszenek importalasa Electrum Wallet-be

Ez nem egy ajanlott modja a penzkeszlet kezelesenek az LND tarcabol, jobban hasznalhato csak megfigyeles (watch-only) modban.
A seed-bol torteno visszaallitas Electrum-ban nem erinti a channel-ekben levo offchain penzkeszletet.
Nincs garancia arra, hogy az Electrum change kimenetei megjelennek LND-ben, es forditva.

Ezt csak akkor csinaldd, ha erted a folyamatot.
Soha ne adj meg titkos adatokat online weboldalakon.
Keruldd a bovitmenyekkel rendelkezo bongeszoablakokat.
A Tor Browser jo kiindulasi pont \(celozd meg az offline hasznalat\).

Szukseges:

* LND 24 szavas seed \(+ jelszo, ha hasznaltal\)
* hasznalj dedikalt, biztonsagos operacios rendszert, pl. [Tails](https://tails.boum.org/)
* mentsd el az online oldalakat lemezre es nyisd meg egy uj bongeszoablakban

### Nyisd meg: [https://guggero.github.io/cryptography-toolkit/\#!/aezeed](https://guggero.github.io/cryptography-toolkit/#!/aezeed)

* a `Decode mnemonic` resz alatt

  add meg a 24 szavas seed-et \(+ jelszot, ha hasznaltal\)

* masold ki a `HD node root key base58` erteket BTC \(Bitcoin, Native SegWit, BIP84\) vagy BTC \(Bitcoin, SegWit, BIP49\) szamara

### Nyisd meg: [https://iancoleman.io/bip39/](https://iancoleman.io/bip39/)

* add meg a `HD node root key base58` erteket a `BIP32 Root Key` mezobe
* a `Derivation Path` resz alatt
  * Valaszd a `BIP84` fult a bc1.. cimekhez.
  * Valaszd a `BIP49` fult a 3.. cimekhez.
* Importald az `Account Extended Public key`-t Electrum-ba csak megfigyeles (watch-only) tarcahoz. Lasd: [https://bitcoinelectrum.com/creating-a-watch-only-wallet/](https://bitcoinelectrum.com/creating-a-watch-only-wallet/)
* Importald az `Account Extended Private Key`-t Electrum-ba hot wallet-kent \(nem ajanlott\).

Alternativakent nezd meg ezt a videot:
[https://light-tube.eu/?latest=Latest&search=How+to+import+your+lighting+wallet+into+Electrum](https://light-tube.eu/?latest=Latest&search=How+to+import+your+lighting+wallet+into+Electrum)

A kovetkezo eszkoz hasznalatat mutatja be:

[https://github.com/guggero/chantools](https://github.com/guggero/chantools)

```text
showrootkey

This command converts the 24 word lnd aezeed phrase and password to the BIP32 HD root key that is used as the rootkey parameter in other commands of this tool.

Example command:

chantools showrootkey
```

Az xpub zpub-ra konvertalasa ezzel a kis python szkripttel:

[https://gist.github.com/freenancial/d82fec076c13158fd34d1c4300b2b300](https://gist.github.com/freenancial/d82fec076c13158fd34d1c4300b2b300)
