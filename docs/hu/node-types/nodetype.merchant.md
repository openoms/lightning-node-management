# Kereskedo
Fizetesek fogadasara iranyul, a bejovo likviditasra osszpontosit

## Tokeigeny
* minimalis bejovo channel-ek vasarlasahoz
* átmenetileg magas a megnyitott channel-ekbol szarmazo bejovo kapacitas letrehozasahoz

## Channel-ek es peer-ek
* keves (2-3) channel jol kapcsolt es tokeerosit node-okkal
* csatlakozz a [Bos lista](../advanced-tools/bosscore.md) node-jaihoz
* nezd meg a meglevo dijbeallitasokat az [Amboss](https://amboss.space/) / [1ml.com](https://1ml.com/) oldalakon
* Ellenorizd a node stabilitasat a [Lightning Web](https://terminal.lightning.engineering) feluleten

## Likviditas
* nagyreszben remote

## Uzemido
* magas, de nem feltetlen tokeletes
* az elerethetetlen node az eladasokra hat

## Kezeles
* [Loop out](https://github.com/lightninglabs/loop#lightning-loop) ([Autoloop](https://docs.lightning.engineering/advanced-best-practices/advanced-best-practices-overview/autoloop)) a meglevo channel-ek uritésehez
* Bezaras es ujranyitas, ha a channel-ek megtelnek
  * egy channel nyitas (es zaras) nem dragabb a Loop hasznalatanalinall, ha:
    * van onchain likviditasod tobb channel-hez (vagy a jovoben splice in) vagy
    * megenggedheted a channel leallasi idot a peer-ek kozott a bezarashoz es ujranyitashoz
* Vasarolj tovabbi [bejovo likviditast](../createinboundliquidity.md)
* Hasznalj liquidity ads-t bejovo likviditas vasarlasahoz
* Probald az Amboss Magma-t
* Adj le licitatast a [Lightning Pool](../advanced-tools/pool.md)-on
* Hirdess bejovo channel-ek fogadasahoz
* [Penzek osszegyujtese](https://github.com/lnbook/lnbook/blob/develop/05_node_operations.asciidoc#sweeping-funds)
  * Onchain vagy offchain osszegyujtesre szukseg lehet, ha a Lightning tarca egyenlege tul naggyá valik
  * Egy offchain osszegyuijtes javithatja a privacy-det, es egyben bejovo likviditast is biztosit

## Peldak
* [Sajat uzemeltetesű node](https://github.com/bavarianledger/bitcoin-nodes) helyi vagy tavoli BTCPayServer-hez csatlakoztatva
* BTCPayServer VPS-en (alacsony osszegenel elfogadhato)
* Teljesen hosztolt megoldasok (bizalmi) -- pl. Voltage
* Készul: Greenlight a Blockstream-tol

## Specialis esetek
* [Adomanyok](../donate/donations.md) elfogadasa
* Ajanlj onchain fiztest magas erteku fizteteseknel (banyasz dij < 0.5-1%)

  ![BTCPayServer beallitas](../assets/btcpay.on-offchain.png)

* atvalthat [Routing node]()-ra, ahogy a kapcsolatok szama es a toke no
