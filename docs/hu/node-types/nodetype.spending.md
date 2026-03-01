# Koltekezes

Bitcoin olcso es privat elkoltesere iranyul.

## Tokeigeny

* alacsony
* a koltesi tervtol es a rendelkezesre allo forrasoktol fugg
* lehetove teszi a nem kevert penzek felhasznalasat valtopenz keletkezese nelkul

## Channel-ek es peer-ek

* egyetlen channel egy jol kapcsolt, tokeerős es magas uzemideju node-hoz jo kiindulas, lasd a [Bos lista](../advanced-tools/bosscore.md), [Lightning Terminal](https://terminal.lightning.engineering) vagy [Amboss.space](https://amboss.space) oldalakat peer valasztasahoz
* hasznalj privat channel-eket, hogy elkeruld a node es a finanszirozasi tranzakciok nyilvanossagra hozatalat
* az offline privat channel-ek nem rongaljak a halozat megbizhatosagat

## Likviditas

* nagyreszben lokalis

## Uzemido

* nem szamit (csak online allapotban koltekezunk)

## Kezeles

* kimerult channel-ek bezarasa
* [feltoltes LN-en keresztul](../createoutboundliquidity.md)
* uj node inditasa gyakran javitja az onchain privacy-t

## Peldak

* [Mobil tarcak](../createinboundliquidity.md#non-custodial-wallets)
* [Sajat uzemeltetesű node dedikalt hardveren](https://github.com/bavarianledger/bitcoin-nodes)
* Privacy-orientalt: [diak a Lightning Node privat futtatásarol](https://keybase.pub/oms/slides/Running_a_Lightning_Node_Privately.pdf)
* Hasznalat kozossegi mediahoz, mint a [Sphinx chat](https://sphinx.chat/)

  Vita: [https://github.com/raspiblitz/raspiblitz/issues/2073](https://github.com/raspiblitz/raspiblitz/issues/2073)
