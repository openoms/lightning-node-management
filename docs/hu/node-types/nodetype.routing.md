# Routing

Fizetések sikeres továbbítására és profit termelésére irányul.

## Tőkeigény

* magas

## Csatornák és peer-ek (Channels and peers)

* számos (~10+) nagy csatorna [jól kapcsolt node-okhoz](../advanced-tools/bosscore.md)
* csatlakozz a hálózat széléhez, hogy forgalmat kapj
* célozz meg node-klaszterek (elkülönült csoportok) összekötését

## Likviditás

* összességében kiegyensúlyozott a lokális és remote között
* az egyes csatornáknak mindkét irányban képesnek kell lenniük fizetések továbbítására

## Üzemidő

* célozd a tökéletességet
* az offline routing node-ok sok nyilvános csatornával hálózatszerte fizetési hibákat okoznak
* nagymértékben befolyásolja a [routing node reputációját](https://github.com/openoms/lightning-node-management/tree/04d605ae69f3630c0eaeedc43eda95c6ff5d1ee3/bossscore.md)

## Kezelés

* automatikus kiegyenlítés (cronjob-ok hasznosak)
* bejövő és kimenő likviditás létrehozása szükség szerint
* kiegyensúlyozás több node között
* inaktív csatornák bezárása
* nyitás olyan irányokba, ahol likviditásra van szükség
* használj Lightning Pool, Amboss Magma vagy liquidity ads licitálást és kínálatot
* csatornanyitások kötegelése a bányász díjak megtakarításához
* csatornák finanszírozása külső tárcákból
* zárás külső címekre a hot wallet kockázat csökkentéséhez
* fedezd fel a számos [elérhető eszközt](../#csatornak-kezelese-channel-management)

## Stratégiák

### Klaszterek és nagy fizetési feldolgozók összekötése

* kétirányú forgalom
* alacsony díjak
* erősen versenyképes (sok likviditás van privát csatornákban)

### Likviditás biztosítása kereskedőknek

* magas bejövő likviditás szükséges
* a díjak mérsékeltesre - magasra állíthatók
* csatornák eladása a Lightning Pool-on gyakran ebbe a kategóriába esik

### Fizetési központ kis node-oknak

* a díjak alacsonyak maradhatnak
* a forgalom nagyrészben kimenő
* ösztönözni kell a privát csatornák használatát
* az offline nyilvános csatornák fizetési hibákat okoznak és rontják a routing node reputációját

### Bejövő likviditás értékesítése

* [LOOP](https://1ml.com/node/021c97a90a411ff2b10dc2a8e32de2f29d2fa49d41bfbb52bd416e460db0747d0d)
* [Bitfinex](https://ln.bitfinex.com/)
* magas díjak beállítása az egyirányú forgalom és a bejövő kapacitás gyors kimerülése miatt
* nem minden LN-t támogató tőzsdeszolgáltatáshoz lehet csatlakozni, és egyenként kell értékelni a forgalom irányát

## Példák

* [Saját üzemeltetésű dedikált hardveren](https://github.com/bavarianledger/bitcoin-nodes)
* Egyedi rendszer vállalati hardveren, az üzemeltetési időre és redundanciára összpontosítva
* VPS-en hosztolva (magasabb kockázat)
