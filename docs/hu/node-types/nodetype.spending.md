# Költekezés

Bitcoin olcsó és privát elköltésére irányul.

## Tőkeigény

* alacsony
* a költési tervtől és a rendelkezésre álló forrásoktól függ
* lehetővé teszi a nem kevert pénzek felhasználását váltópénz keletkezése nélkül

## Csatornák és peer-ek (Channels and peers)

* egyetlen csatorna egy jól kapcsolt, tőkeerős és magas üzemidejű node-hoz jó kiindulás, lásd a [Bos lista](../advanced-tools/bosscore.md), [Lightning Terminal](https://terminal.lightning.engineering) vagy [Amboss.space](https://amboss.space) oldalakat peer választásához
* használj privát csatornákat, hogy elkerüld a node és a finanszírozási tranzakciók nyilvánosságra hozatalát
* az offline privát csatornák nem rongálják a hálózat megbízhatóságát

## Likviditás

* nagyrészben lokális

## Üzemidő

* nem számít (csak online állapotban költekezünk)

## Kezelés

* kimerült csatornák bezárása
* [feltöltés LN-en keresztül](../createoutboundliquidity.md)
* új node indítása gyakran javítja az onchain privacy-t

## Példák

* [Mobil tárcák](../createinboundliquidity.md#non-custodial-wallets)
* [Saját üzemeltetésű node dedikált hardveren](https://github.com/bavarianledger/bitcoin-nodes)
* Privacy-orientált: [diák a Lightning Node privát futtatásáról](https://keybase.pub/oms/slides/Running_a_Lightning_Node_Privately.pdf)
* Használat közösségi médiához, mint a [Sphinx chat](https://sphinx.chat/)

  Vita: [https://github.com/raspiblitz/raspiblitz/issues/2073](https://github.com/raspiblitz/raspiblitz/issues/2073)
