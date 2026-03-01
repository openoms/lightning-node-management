# LND onchain pénzkészlet kezelése Electrum / Sparrow / Specter tárcákban

* A master publikus kulcsok létrehozásához (az LND onchain tárca YPUB / ZPUB megjelenítése) a tranzakciók külső monitorozásához és építéséhez a következő parancs használható:
  ```
  lncli wallet accounts list --name default
  ```

* PSBT aláírása:
  ```
  lncli wallet psbt finalize --funded_psbt "base64_encoded_PSBT"
  ```

* Tranzakció közvetítése LND-vel:
  ```
  lncli wallet publishtx "tx_hex"
  ```

* A részletekért kövesd a beszélgetést: https://github.com/raspiblitz/raspiblitz/issues/2192

## Onchain pénzkészlet visszaállítása LND tárcából Electrum Wallet-be

Ezt csak akkor csináld, ha érted a folyamatot.
Soha ne adj meg titkos adatokat online weboldalakon.
Kerüld a bővítményekkel rendelkező böngészőablakokat.
A Tor Browser jó kiindulási pont \(célozd meg az offline használat\).

Szükséges:

* LND 24 szavas seed \(+ jelszó, ha használtál\)
* hasznos, ha tudod a feltöltött címeket
* használj dedikált, biztonságos operációs rendszert, pl. [Tails](https://tails.boum.org/)
* mentsd el az online oldalakat lemezre és nyisd meg egy új böngészőablakban

### Nyisd meg: [https://guggero.github.io/cryptography-toolkit/\#!/aezeed](https://guggero.github.io/cryptography-toolkit/#!/aezeed)

* a `Decode mnemonic` rész alatt

  add meg a 24 szavas seed-et \(+ jelszót, ha használtál\)

* másold ki a `HD node root key base58` értéket

### Nyisd meg: [https://iancoleman.io/bip39/](https://iancoleman.io/bip39/)

* add meg a `HD node root key base58` értéket a `BIP32 Root Key` mezőbe
* a `Derivation Path` rész alatt
  * Válaszd a `BIP84` fület a bc1.. címekhez.
  * Válaszd a `BIP49` fület a 3.. címekhez.
* Másold ki a privát kulcsokat az ismert vagy összes címhez \(`Account Extended Private Key`\).

### Nyisd meg az Electrum Wallet-et

Kövesd: [https://bitcoinelectrum.com/importing-your-private-keys-into-electrum/](https://bitcoinelectrum.com/importing-your-private-keys-into-electrum/)

A privát kulcsok importálásakor használd az alábbi prefixeket:

* `p2wpkh:` a `bc1...` címek privát kulcsai előtt
* `p2wpkh-p2sh:` a `3...` címek privát kulcsai előtt

Kész. Miután az Electrum Server befejezte a beolvasást, a pénzkészletnek meg kell jelennie.

## Az LND tárca onchain részének importálása Electrum Wallet-be

Ez nem egy ajánlott módja a pénzkészlet kezelésének az LND tárcából, jobban használható csak megfigyelés (watch-only) módban.
A seed-ből történő visszaállítás Electrum-ban nem érinti a channel-ekben lévő offchain pénzkészletet.
Nincs garancia arra, hogy az Electrum change kimenetei megjelennek LND-ben, és fordítva.

Ezt csak akkor csináld, ha érted a folyamatot.
Soha ne adj meg titkos adatokat online weboldalakon.
Kerüld a bővítményekkel rendelkező böngészőablakokat.
A Tor Browser jó kiindulási pont \(célozd meg az offline használat\).

Szükséges:

* LND 24 szavas seed \(+ jelszó, ha használtál\)
* használj dedikált, biztonságos operációs rendszert, pl. [Tails](https://tails.boum.org/)
* mentsd el az online oldalakat lemezre és nyisd meg egy új böngészőablakban

### Nyisd meg: [https://guggero.github.io/cryptography-toolkit/\#!/aezeed](https://guggero.github.io/cryptography-toolkit/#!/aezeed)

* a `Decode mnemonic` rész alatt

  add meg a 24 szavas seed-et \(+ jelszót, ha használtál\)

* másold ki a `HD node root key base58` értéket BTC \(Bitcoin, Native SegWit, BIP84\) vagy BTC \(Bitcoin, SegWit, BIP49\) számára

### Nyisd meg: [https://iancoleman.io/bip39/](https://iancoleman.io/bip39/)

* add meg a `HD node root key base58` értéket a `BIP32 Root Key` mezőbe
* a `Derivation Path` rész alatt
  * Válaszd a `BIP84` fület a bc1.. címekhez.
  * Válaszd a `BIP49` fület a 3.. címekhez.
* Importáld az `Account Extended Public key`-t Electrum-ba csak megfigyelés (watch-only) tárcához. Lásd: [https://bitcoinelectrum.com/creating-a-watch-only-wallet/](https://bitcoinelectrum.com/creating-a-watch-only-wallet/)
* Importáld az `Account Extended Private Key`-t Electrum-ba hot wallet-ként \(nem ajánlott\).

Alternatívaként nézd meg ezt a videót:
[https://light-tube.eu/?latest=Latest&search=How+to+import+your+lighting+wallet+into+Electrum](https://light-tube.eu/?latest=Latest&search=How+to+import+your+lighting+wallet+into+Electrum)

A következő eszköz használatát mutatja be:

[https://github.com/guggero/chantools](https://github.com/guggero/chantools)

```text
showrootkey

This command converts the 24 word lnd aezeed phrase and password to the BIP32 HD root key that is used as the rootkey parameter in other commands of this tool.

Example command:

chantools showrootkey
```

Az xpub zpub-ra konvertálása ezzel a kis python szkripttel:

[https://gist.github.com/freenancial/d82fec076c13158fd34d1c4300b2b300](https://gist.github.com/freenancial/d82fec076c13158fd34d1c4300b2b300)
