# Lightning alapok

## Peer-kapcsolatok és csatornák (channels)

* A peer-ek az interneten (TCP/IP rétegen) keresztül egymáshoz kapcsolódó node-ok.
* A csatorna két peer között létrehozott fizetési csatorna a Lightning Networkben.
* Ahhoz, hogy bármely node-hoz csatornát nyissunk, előbb létre kell hozni a peer-kapcsolatot.
* A nyilvánosan elérhető node-okhoz automatikusan lehet csatlakozni.
* Ha egy node nem nyilvánosan elérhető, a peer-kapcsolatot a nem-nyilvános oldalról kell kezdeményezni, még akkor is, ha a másik peer nyitja a csatornát.

## Fizetések fogadása

Ahhoz, hogy egy node fizetéseket tudjon fogadni a Lightning Networkben, a következőkre van szükség:

* "bejövő likviditásra" (más néven remote balance), ami azt jelenti, hogy a csatorna másik oldalán, a másik peer-nél kell lennie satoshinak.
* egy csatorna egy jól kapcsolt node-hoz, vagy közvetlenül a fizető peer-től érkező csatorna, hogy biztosítsuk az útvonal létezését.

A bejövő fizetés maximális összege a legnagyobb bejövő likviditású egyetlen csatorna által határozott meg (nem additív a csatornák között).

## Csatornaméret és peer választása (channel size)

* Nincs fix szám, de általánosságban nem ajánlott 200K-500K sats alatti csatornák nyitása.
* A [https://1ml.com/statistics](https://1ml.com/statistics) oldalon láthatjuk a hálózaton lévő átlagos csatornaméretet:

  0.028 BTC = 2 800 000 satoshi, 2019. május 28-án.

* A túl kicsi csatornákat nem lehet majd bezárni, ha az onchain díjak magasak. Ez sebezhetővé teszi a csatornát abban az esetben, ha a másik fél egy korábbi állapottal próbálja bezárni (így ellophatja a csatornában lévő pénzt).
* Az elküldhető vagy továbbított fizetés maximális összege a legnagyobb egyirányú likviditású egyetlen csatorna által határozott meg (nem additív a csatornák között).
* Egyetlen nagy csatorna egy jól kapcsolt és stabil node-hoz hasznosabb, mint sok kicsi.
* Érdemes olyan node-okhoz csatlakozni, ahol az üzemeltető probléma esetén elérhető.
* Válassz egy ismerős node-ot, vagy egyet a listából: [https://1ml.com/node?order=nodeconnectednodecount](https://1ml.com/node?order=nodeconnectednodecount)
* Próbáld ki az egyedi ajánlásokat a nyilvános node-odhoz: [https://moneni.com/nodematch](https://moneni.com/nodematch)

## Onchain Bitcoin-díjak

* Egy Lightning csatorna megnyitása vagy bezárása egy onchain Bitcoin-tranzakció (a blockchainen kerül elszámolásra).
* A megerősítés ideje a Bitcoin mempool állapotától ([https://jochen-hoenicke.de/queue/\#0,24h](https://jochen-hoenicke.de/queue/#0,24h)) és a használt sats/byte díjtól ([https://bitcoinfees.earn.com/](https://bitcoinfees.earn.com/)) függ.
* Ellenőrizd a [https://whatthefee.io/](https://whatthefee.io/) oldalt az aktuális megerősítési idő/díj becslésekért.
* Használj egyéni díjat, és válaszd a legalacsonyabb értéket, amely még elfogadható megerősítési időt biztosít.
* Legalább 141 byte-ot kell fedezni díjakkal, de ez a szám gyakran magasabb a tranzakció bemeneteitől, szkripttől és aláírástól függően.
* Tudd meg, mit kell tenni [magas onchain díj környezetben](technicals/highonchainfees.md)

## Tor node-ok

A Tor egy anonimizáló hálózat, amelyet a résztvevők IP-címének elrejtésére terveztek. Valamelyest hasonlít egy több ugrásból álló VPN használatához. Továbbiak: [https://en.wikipedia.org/wiki/Tor\_\(anonymity\_network\)](https://en.wikipedia.org/wiki/Tor_%28anonymity_network%29)

* Egy Tor mögött futó Lightning node bármely másik node-hoz tud csatlakozni és csatornát nyitni.
* A clearneten futó node-ok nem látnak a Tor mögé.
* A Tor node-nak előbb peer-ként kell felvennie a clearnet node-ot ahhoz, hogy csatornát tudjon nyitni.
* A csatorna létrehozása után a kapcsolat megmarad, de az újraindítás után kicsit több időbe telhet az újracsatlakozás.
* Ha mindkét node egyszerre indul újra, vagy a clearnet node IP-címe megváltozik, amíg mindkettő offline, a peer-kapcsolatot újra kell konfigurálni manuálisan.

## Fizetések továbbítása

* Képzeljünk el egy `B` node-ot egy `A`-`B`-`C` soros kapcsolatban.
* `B` csatornái úgy vannak beállítva, hogy `A`-tól bejövő kapacitás (remote balance), és `C` felé kimenő kapacitás (local balance) áll rendelkezésre.
* Ha `A` fizetni akar `C`-nek, az 1 ugrást jelent az útvonalon.
* A motorháztető alatt: `A` elküldi a satoshikat `B`-nek (a routing node-nak), aki továbbfizeti `C`-nek.
* A csatornák kapacitása nem változik, csak mozog.
* A teljes fizetés csak akkor mehet végbe, ha a másik irányból előbb sikeresen átküldik a hash image-et (üzenetet).
* A folyamat "minden vagy semmi" -- a fizetés nem akadhat el útközben.

## Privát csatorna (private channel)

* pontosabb "be nem jelentett" (unannounced) csatornának hívni
* nem jelenik meg a csatornagrafikonban (hálózati gossip)
* fizetések küldésére hasznosabb
* fizetések fogadásához route hint szükséges az invoice-ban:

  `lncli addinvoice <amount> --private`

* a route hint a finanszírozási tranzakció azonosítója (felfedi a csatornát bárki számára, aki ismeri az invoice-t)
* keysend fizetések fogadására is alkalmas, ha a route hint ismert
* nem továbbít fizetéseket (kivéve, ha párhuzamosan egy nyilvános csatornával használják ugyanahhoz a node-hoz -- más néven shadow liquidity)

## Lightning Network routing-díjak

### Haladó és automatizált díjbeállítások: [fees.md](advanced-tools/fees.md)

Eltérően az onchain tranzakcióktól (ahol a díj a tranzakció által elfoglalt byte-okért jár), a Lightning Network díjai a továbbított összeghez kötöttek. Két díjkomponens létezik:

* alapdíj (base\_fee\_msat). Az alapértelmezett 1000 millisat, azaz 1 satoshi díj minden továbbított fizetés után.
* arányos díj (fee\_rate), amely LND-ben alapértelmezetten 0.000001. Ez azt jelenti, hogy minden egymillió satoshi után további 1 satoshi kerül felszámításra.

Közvetlenül összekötött két peer közötti fizetéseknek nincs LN-díja.

A routing-díjak módosításához használd a következő parancsot: [https://lightning.engineering/api-docs/api/lnd/lightning/update-channel-policy](https://lightning.engineering/api-docs/api/lnd/lightning/update-channel-policy)

* Az alapdíj csökkentése 500 msat-ra és az arányos díj növelése 100ppm/0.01%-ra:
`$ lncli updatechanpolicy 500 0.0001 144`
* az alapértelmezett beállítás (1 sat fizetésenként + 1 ppm/0.0001%):
`$ lncli updatechanpolicy 1000 0.000001 144`

Fontos, hogy az olcsó csatornákra magasabb routing-díjat állítsunk be, hogy a kiegyenlítés vagy a bezárás költségeit fedezzék a továbbított fizetések. Ellenőrizd a peer-ek routing-díjait az [1ml.com](https://1ml.com/) oldalon vagy az [lndmanage](./#lndmanage) eszközzel.

Az egyes csatornák díjainak beállítása egyetlen kattintás az [RTL alkalmazásban](./#RTL---Ride-The-Lightning).

## Őrtornyok (Watchtowers)

További információk és a beállítás módja: [watchtower.md](advanced-tools/watchtower.md).

## Csatornatartalék (channel reserve)

Általánosságban a csatornakapacitás 1%-a szolgál tartalékul. Ez azt jelenti, hogy bármely csatorna csak az 1% feletti összeget tudja küldeni, legfeljebb 99%-ig.

A [BOLT2](https://github.com/lightning/bolts/blob/master/02-peer-protocol.md#rationale-8) specifikálja:

>A csatornatartalékot a peer channel_reserve_satoshis értéke határozza meg: a csatorna összkapacitásának 1%-a az ajánlott. A csatorna mindkét oldala fenntartja ezt a tartalékot, így mindig van vesztenivalója, ha egy régi, visszavont commitment tranzakciót próbálna közvetíteni. Kezdetben ez a tartalék nem teljesülhet, mivel csak az egyik félnél van pénz; a protokoll azonban biztosítja, hogy folyamatos haladás történjen a tartalék elérése felé, és ha egyszer teljesült, fenntartja azt.

Részletesebb magyarázat a [Bitcoin Design Guide](https://bitcoin.design/guide/how-it-works/liquidity/#channel-reserve)-ban.

## Likviditás

Az alapvetések Alex Bosworth-tól: [https://github.com/alexbosworth/run-lnd/blob/master/LIQUIDITY.md](https://github.com/alexbosworth/run-lnd/blob/master/LIQUIDITY.md)

a [Bitcoin Design Guide](https://bitcoin.design/guide/how-it-works/liquidity)-ban

## Bejövő likviditás létrehozása

Fizess Lightninggal és kapj onchain-t.
Lásd az ajánláslistát: [CreateInboundLiquidity.md](createinboundliquidity.md)

## Kimenő likviditás létrehozása

Egyszerűen nyiss csatornákat, vagy fizess onchain-nel és fogadj Lightningon.
Lásd az ajánláslistát: [CreateOutboundLiquidity.md](createoutboundliquidity.md)

## Csatornák kezelése (channel management)

A csatornák ideálisan kiegyensúlyozottak, mindkét oldalon pénzzel, hogy maximalizáljuk a fizetések továbbításának képességét (kétirányú forgalmat tesz lehetővé).

### [Balance of Satoshis](https://github.com/alexbosworth/balanceofsatoshis)

Gazdag funkciókészletű eszköz az LND egyenlegek kezeléséhez. Kísérleti funkciójával személyes Telegram bothoz csatlakozhatunk, és értesítéseket kaphatunk a node tevékenységéről.

* [Telepítési útmutató a RaspiBlitz-hez](https://gist.github.com/openoms/823f99d1ab6e1d53285e489f7ba38602)
* A rebalance parancs használatát lásd: `bos help rebalance`

### [CLBOSS - A Core Lightning (CLN) Node Menedzser](https://github.com/ZmnSCPxj/clboss)

Automatizált menedzser Core Lightning (CLN) továbbítási node-okhoz.

### [lndmanage](https://github.com/bitromortac/lndmanage)

Parancssori eszköz az LND node haladó csatornakezeléséhez, Pythonban írva.

* Telepítés:

  ```bash
    # virtuális környezet aktiválása
    sudo apt install -y python3-venv
    python3 -m venv venv
    source venv/bin/activate
    # függőségek telepítése
    sudo apt install -y python3-dev libatlas-base-dev
    pip3 install wheel
    python3 -m pip install lndmanage
  ```

* Az interaktív mód indítása (minden új indításkor):

  ```bash
    $ source venv/bin/activate
    (venv) $ lndmanage
  ```

* A csatornák állapotának megjelenítése:

  `$ lndmanage status`
  `$ lndmanage listchannels`

* Példa rebalance parancs:

  `$ lndmanage rebalance --max-fee-sat 20 --max-fee-rate 0.0001 CHANNEL_ID --reckless`

### [rebalance-lnd](https://github.com/C-Otto/rebalance-lnd)

Ezzel a Python szkripttel egyszerűen kiegyenlítheted az LND node-od egyes csatornáit.

* Telepítéshez futtasd az LND node terminálján:

  `$ git clone https://github.com/C-Otto/rebalance-lnd`

  `$ cd rebalance-lnd`

  `$ pip install -r requirements.txt`

* Használat (további opciók a [readme](https://github.com/C-Otto/rebalance-lnd/blob/master/README.md#usage)-ban):

  `$ python rebalance.py -t <channel_ID-where-to-move-sats> -f <channel_ID-from-which-to-move-sats> -a <amount-of-sats-to-be-moved>`

### [Kiegyensúlyozott csatorna létrehozásának módszerei megbízható peer-rel](advanced-tools/balancedchannelcreation.md)

* Végezz megbízható onchain-offchain swap-ot.
* Nyiss két oldalról finanszírozott, kiegyensúlyozott csatornát megbízható peer-rel a parancssor segítségével, amihez egy Lightning és egy onchain tranzakció szükséges.

## Monitorozó szoftverek

### [RTL - Ride The Lightning](https://github.com/ShahanaFarooqui/RTL)

Az RTL egy webes felhasználói felület a Lightning Network Daemon-hoz. Helyi hálózaton való használatra tervezték. [HTTPS](https://github.com/openoms/bitcoin-tutorials/tree/master/nginx) vagy [Tor](https://github.com/Ride-The-Lightning/RTL/blob/master/docs/RTL_TOR_setup.md) kapcsolódási lehetőség áll rendelkezésre.
[https://medium.com/@suheb\_\_/how-to-ride-the-lightning-447af999dcd2](mailto:https://medium.com/@suheb__/how-to-ride-the-lightning-447af999dcd2)

### [ThunderHub](https://www.thunderhub.io/)

LND Lightning Node menedzser a böngészőben.

* [Telepítési útmutató a RaspiBlitz-en](https://gist.github.com/openoms/8ba963915c786ce01892f2c9fa2707bc)

### [ZeusLN](https://zeusln.app/)

Mobil Bitcoin alkalmazás Lightning Network Daemon (LND) node-üzemeltetők számára. Android és iOS -- a REST API-n (8080-as port vagy [Tor](https://github.com/openoms/bitcoin-tutorials/blob/master/Zeus_to_RaspiBlitz_through_Tor.md)) keresztül csatlakozik.

### [Zap](https://zap.jackmallers.com/)

Lightning tárca asztali gépre, iOS-re és Androidra -- távolról csatlakozhat az LND node-odhoz a GRPC interfészen (10009-es port) keresztül.

### [Joule](https://lightningjoule.com/)

Hozd el a Lightning erejét a webre böngészőn belüli fizetésekkel és identitással, mindezt a saját node-oddal.
[https://medium.com/lightning-power-users/bitcoin-lightning-joule-chrome-extension-ac149bb05cb9](https://medium.com/lightning-power-users/bitcoin-lightning-joule-chrome-extension-ac149bb05cb9)

### [lntop](https://github.com/edouardparis/lntop)

Az lntop egy interaktív szöveges módú csatorna-megjelenítő Unix rendszerekhez.

### [lnd-admin](https://github.com/janoside/lnd-admin)

Adminisztrációs webes felület az LND-hez gRPC-n keresztül. Node.js-sel, Express-szel és Bootstrap-v4-gyel épített. Teszteld itt: [https://lnd-admin.chaintools.io/](https://lnd-admin.chaintools.io/)

### [lndmon](https://github.com/lightninglabs/lndmon)

Azonnal telepíthető monitoring megoldás az LND node-odhoz Prometheus és Grafana segítségével. [https://blog.lightning.engineering/posts/2019/07/24/lndmon-v0.1.html](https://blog.lightning.engineering/posts/2019/07/24/lndmon-v0.1.html)

### [Spark wallet a Core Lightninghoz (CLN)](https://github.com/shesek/spark-wallet)

A Spark egy minimalista tárca-felület a Core Lightning (CLN)-hoz, elérhető weben, valamint mobil és asztali alkalmazásokkal (Android, Linux, macOS és Windows). Jelenleg technikailag haladó felhasználóknak szól, és nem egy mindent-egyben csomag, hanem inkább egy "távirányító" felület a Core Lightning (CLN) node-hoz, amelyet külön kell kezelni.

## Lightning Network felfedezők

* [1ml.com](https://1ml.com/)
* [explorer.acinq.co](https://explorer.acinq.co/)
* [amboss.space](https://amboss.space/)
* [ln.fiatjaf.com](https://ln.fiatjaf.com)

## Források

* LND Builder's Guide -- bevált gyakorlatok

  [docs.lightning.engineering/advanced-best-practices/advanced-best-practices-overview/channels](https://docs.lightning.engineering/advanced-best-practices/advanced-best-practices-overview/channels)

* A Lightning Network koncepcionális áttekintése:

  [dev.lightning.community/overview/index.html\#lightning-network](https://dev.lightning.community/overview/index.html#lightning-network)

* gRPC API referenciadokumentáció az LND-hez

  [api.lightning.community](https://api.lightning.community)

* [medium.com/lightningto-me/practical-solutions-to-inbound-capacity-problem-in-lightning-network-60224aa13393](https://medium.com/lightningto-me/practical-solutions-to-inbound-capacity-problem-in-lightning-network-60224aa13393)
* [lightningwiki.net](https://lightningwiki.net)
* [satbase.org](https://satbase.org)
* Lista arról, hogyan lehet gyorsan csatorna-likviditáshoz jutni:

  [github.com/raspiblitz/raspiblitz/issues/395](https://github.com/raspiblitz/raspiblitz/issues/395)

* Összeválogatott lista a legjobb Lightning Network forrásokról, alkalmazásokról és könyvtárakról:

  [github.com/bcongdon/awesome-lightning-network](https://github.com/bcongdon/awesome-lightning-network)

* Jameson Lopp összeválogatott Lightning Network forráslistája:

  [lightning.how](https://lightning.how)

* [wiki.ion.radar.tech/tutorials/troubleshooting/bootstrapping-channels](https://wiki.ion.radar.tech/tutorials/troubleshooting/bootstrapping-channels)

### Routing

* [blog.lightning.engineering/posts/2018/05/30/routing.html](https://blog.lightning.engineering/posts/2018/05/30/routing.html)
* [diyhpl.us/wiki/transcripts/chaincode-labs/2018-10-22-alex-bosworth-channel-management/](https://diyhpl.us/wiki/transcripts/chaincode-labs/2018-10-22-alex-bosworth-channel-management/)
* [diyhpl.us/wiki/transcripts/lightning-hack-day/2021-03-27-alex-bosworth-lightning-routing/](https://diyhpl.us/wiki/transcripts/lightning-hack-day/2021-03-27-alex-bosworth-lightning-routing/)

## Videók

* Elaine Ou - Lightning node beállítása és karbantartása [38 perces videó](https://www.youtube.com/watch?v=qX4Z3JY1094) és [diák](https://lightningresidency.com/assets/presentations/Ou_Bootstrapping_and_Maintaining_a_Lightning_Node.pdf)
* Alex Bosworth - Lightning csatornakezelés (channel management) [35 perces videó](https://www.youtube.com/watch?v=HlPIB6jt6ww&feature=youtu.be)
* [Chaincode Labs Lightning Szeminárium - 2019 nyár](https://www.youtube.com/playlist?list=PLpLH33TRghT17_U3as2P3vHfAGL8pSOOY)
* Alex Bosworth online előadásainak gyűjteménye:

  [twitter.com/alexbosworth/status/1175091117668257792](https://twitter.com/alexbosworth/status/1175091117668257792)

## Fórumok

* Közösség által kezelt csoport a RaspiBlitz Lightning Node-hoz:

  [https://t.me/raspiblitz](https://t.me/raspiblitz)

* LND Developer Slack. A meghívó link itt található:

  [dev.lightning.community/](https://dev.lightning.community/)

* Subreddit Bitcoin és Lightning fejlesztőknek technikai témák megbeszéléséhez:

  [www.reddit.com/r/lightningdevs](https://www.reddit.com/r/lightningdevs)

## Tanulás

[https://github.com/lnbook/lnbook](https://github.com/lnbook/lnbook)
[https://chaincode.applytojob.com/apply/LpQl1a0cvd/Chaincode-Labs-Online-Seminars](https://chaincode.applytojob.com/apply/LpQl1a0cvd/Chaincode-Labs-Online-Seminars) [https://github.com/chaincodelabs/lightning-curriculum](https://github.com/chaincodelabs/lightning-curriculum)
