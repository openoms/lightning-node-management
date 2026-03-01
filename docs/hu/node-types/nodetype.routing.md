# Routing

Fizetesek sikeres tovabbitasara es profit termeleseire iranyul.

## Tokeigeny

* magas

## Channel-ek es peer-ek

* szamos (~10+) nagy channel [jol kapcsolt node-okhoz](../advanced-tools/bosscore.md)
* csatlakozz a halozat szelehez, hogy forgalmat kapj
* celozz meg node-klaszterek (elkülonult csoportok) összekoteset

## Likviditas

* osszessegeben kiegyensulyozott a lokalis es remote kozott
* az egyes channel-eknek mindket iranyban kepes kell lenniuk fizetesek tovabbitasara

## Uzemido

* celozd a tokeletessseget
* az offline routing node-ok sok nyilvanos channel-lel halozatszerte fizetesi hibakat okoznak
* nagymertekben befolyasolja a [routing node reputaciojat](https://github.com/openoms/lightning-node-management/tree/04d605ae69f3630c0eaeedc43eda95c6ff5d1ee3/bossscore.md)

## Kezeles

* automatikus kiegyenlites (cronjob-ok hasznosak)
* bejovo es kimeno likviditas letrehozasa szukseg szerint
* kiegyensullyozas tobb node kozott
* inaktiv channel-ek bezarasa
* nyitas olyan iranyokba, ahol likviditasra van szukseg
* hasznalj Lightning Pool, Amboss Magma vagy liquidity ads licitatast es kinalatot
* channel-nyitasok kotegeleese a banyasz dijak megtakaritasahoz
* channel-ek finanszirozasa kulso tarcakbol
* zaras kulso cimekre a hot wallet kockázat csokkentesehez
* fedezd fel a szamos [elerheto eszkozt](../#manage-channels)

## Strategiak

### Klaszterek es nagy fizetesi feldolgozok osszekotese

* ketiranyú forgalom
* alacsony dijak
* erosen versenykepes (sok likviditas van privat channel-ekben)

### Likviditas biztositasa kereskedoknek

* magas bejovo likviditas szukseges
* a dijak mertekeltesre - magasra allithatok
* channel-ek eladasa a Lightning Pool-on gyakran ebbe a kategoriaba esik

### Fizetesi kozpont kis node-oknak

* a dijak alacsonyak maradhatnak
* a forgalom nagyreszben kimeno
* osztonözni kell a privat channel-ek hasznalatat
* az offline nyilvanos channel-ek fizetesi hibakat okoznak es rontjak a routing node reputaciojat

### Bejovo likviditas ertekesitese

* [LOOP](https://1ml.com/node/021c97a90a411ff2b10dc2a8e32de2f29d2fa49d41bfbb52bd416e460db0747d0d)
* [Bitfinex](https://ln.bitfinex.com/)
* magas dijak beallitasa az egyiranyú forgalom es a bejovo kapacitas gyors kimerulese miatt
* nem minden LN-t tamogato tozsdeszolgaltatashoz lehet csatlakozni, es egyenként kell ertekelni a forgalom iranyat

## Peldak

* [Sajat uzemeltetesű dedikalt hardveren](https://github.com/bavarianledger/bitcoin-nodes)
* Egyedi rendszer vallalati hardveren, az uzemeltetesi idore es redundanciara osszpontositva
* VPS-en hosztolva (magasabb kockázat)
