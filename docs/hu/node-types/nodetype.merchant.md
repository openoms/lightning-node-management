# Kereskedő
Fizetések fogadására irányul, a bejövő likviditásra összpontosít

## Tőkeigény
* minimális bejövő channel-ek vásárlásához
* átmenetileg magas a megnyitott channel-ekből származó bejövő kapacitás létrehozásához

## Channel-ek és peer-ek
* kevés (2-3) channel jól kapcsolt és tőkeerős node-okkal
* csatlakozz a [Bos lista](../advanced-tools/bosscore.md) node-jaihoz
* nézd meg a meglévő díjbeállításokat az [Amboss](https://amboss.space/) / [1ml.com](https://1ml.com/) oldalakon
* Ellenőrizd a node stabilitását a [Lightning Web](https://terminal.lightning.engineering) felületen

## Likviditás
* nagyrészben remote

## Üzemidő
* magas, de nem feltétlen tökéletes
* az elérhetetlen node az eladásokra hat

## Kezelés
* [Loop out](https://github.com/lightninglabs/loop#lightning-loop) ([Autoloop](https://docs.lightning.engineering/advanced-best-practices/advanced-best-practices-overview/autoloop)) a meglévő channel-ek ürítéséhez
* Bezárás és újranyitás, ha a channel-ek megtelnek
  * egy channel nyitás (és zárás) nem drágább a Loop használatánál, ha:
    * van onchain likviditásod több channel-hez (vagy a jövőben splice in) vagy
    * megengedheted a channel leállási időt a peer-ek között a bezáráshoz és újranyitáshoz
* Vásárolj további [bejövő likviditást](../createinboundliquidity.md)
* Használj liquidity ads-t bejövő likviditás vásárlásához
* Próbáld az Amboss Magma-t
* Adj le licitálást a [Lightning Pool](../advanced-tools/pool.md)-on
* Hirdess bejövő channel-ek fogadásához
* [Pénzek összegyűjtése](https://github.com/lnbook/lnbook/blob/develop/05_node_operations.asciidoc#sweeping-funds)
  * Onchain vagy offchain összegyűjtésre szükség lehet, ha a Lightning tárca egyenlege túl naggyá válik
  * Egy offchain összegyűjtés javíthatja a privacy-det, és egyben bejövő likviditást is biztosít

## Példák
* [Saját üzemeltetésű node](https://github.com/bavarianledger/bitcoin-nodes) helyi vagy távoli BTCPayServer-hez csatlakoztatva
* BTCPayServer VPS-en (alacsony összegnél elfogadható)
* Teljesen hosztolt megoldások (bizalmi) -- pl. Voltage
* Készül: Greenlight a Blockstream-tól

## Speciális esetek
* [Adományok](../donate/donations.md) elfogadása
* Ajánlj onchain fizetést magas értékű fizetéseknél (bányász díj < 0.5-1%)

  ![BTCPayServer beállítás](../assets/btcpay.on-offchain.png)

* átválthat [Routing node]()-ra, ahogy a kapcsolatok száma és a tőke nő
