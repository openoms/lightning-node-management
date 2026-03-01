# Lightning alapok

## Peer-kapcsolatok es channel-ek

* A peer-ek az interneten (TCP/IP retegen) keresztul egymashoz kapcsolodo node-ok.
* A channel ket peer kozott letrehozott fizetesi csatorna a Lightning Networkben.
* Ahhoz, hogy barmely node-hoz channel-t nyissunk, elobb letre kell hozni a peer-kapcsolatot.
* A nyilvanosan elerheto node-okhoz automatikusan lehet csatlakozni.
* Ha egy node nem nyilvanosan elerheto, a peer-kapcsolatot a nem-nyilvanos oldalrol kell kezdemenyezni, meg akkor is, ha a masik peer nyitja a channel-t.

## Fizetesek fogadasa

Ahhoz, hogy egy node fizeteseket tudjon fogadni a Lightning Networkben, a kovetkezokre van szukseg:

* "bejovo likviditasra" (mas neven remote balance), ami azt jelenti, hogy a channel masik oldalan, a masik peer-nel kell lennie satoshinak.
* egy channel egy jol kapcsolt node-hoz, vagy kozvetlenul a fizeto peer-tol erkezo channel, hogy biztositsuk az utvonal letezeset.

A bejovo fizetes maximalis osszege a legnagyobb bejovo likviditasu egyetlen channel altal hatarozott meg (nem additiv a channel-ek kozott).

## Channel-meret es peer valasztasa

* Nincs fix szam, de altalanossagban nem ajanlott 200K-500K sats alatti channel-ek nyitasa.
* A [https://1ml.com/statistics](https://1ml.com/statistics) oldalon lathatjuk a halozaton levo atlagos channel-meretet:

  0.028 BTC = 2 800 000 satoshi, 2019. majus 28-an.

* A tul kicsi channel-eket nem lehet majd bezarni, ha az onchain dijak magasak. Ez sebezhetove teszi a channel-t abban az esetben, ha a masik fel egy korabbi allapottal probalja bezarni (igy ellophatja a channel-ben levo penzt).
* Az elkuldheto vagy tovabbitott fizetes maximalis osszege a legnagyobb egyiranyú likviditasu egyetlen channel altal hatarozott meg (nem additiv a channel-ek kozott).
* Egyetlen nagy channel egy jol kapcsolt es stabil node-hoz hasznosabb, mint sok kicsi.
* Erdemes olyan node-okhoz csatlakozni, ahol az uzemelteto problema eseten elerheto.
* Valassz egy ismerős node-ot, vagy egyet a listabol: [https://1ml.com/node?order=nodeconnectednodecount](https://1ml.com/node?order=nodeconnectednodecount)
* Probald ki az egyedi ajanlasokat a nyilvanos node-odhoz: [https://moneni.com/nodematch](https://moneni.com/nodematch)

## Onchain Bitcoin-dijak

* Egy Lightning channel megnyitasa vagy bezarasa egy onchain Bitcoin-tranzakcio (a blockchainen kerül elszamolasra).
* A megerosites ideje a Bitcoin mempool allapotatol ([https://jochen-hoenicke.de/queue/\#0,24h](https://jochen-hoenicke.de/queue/#0,24h)) es a hasznalt sats/byte dijtol ([https://bitcoinfees.earn.com/](https://bitcoinfees.earn.com/)) fugg.
* Ellenorizd a [https://whatthefee.io/](https://whatthefee.io/) oldalt az aktualis megerositesi ido/dij becslesekert.
* Hasznalj egyeni dijat, es valaszd a legalacsonyabb erteket, amely meg elfogadhato megerositesi idot biztosit.
* Legalabb 141 byte-ot kell fedezni dijakkal, de ez a szam gyakran magasabb a tranzakcio bemeneteitol, szkripttol es alairastol fuggoen.
* Tudd meg, mit kell tenni [magas onchain dij kornyezetben](technicals/highonchainfees.md)

## Tor node-ok

A Tor egy anonimizalo halozat, amelyet a resztvevok IP-cimenek elrejtesere terveztek. Valamelyest hasonlit egy tobb ugrasbol allo VPN hasznalatahoz. Tovabbiak: [https://en.wikipedia.org/wiki/Tor\_\(anonymity\_network\)](https://en.wikipedia.org/wiki/Tor_%28anonymity_network%29)

* Egy Tor mogott futo Lightning node barmely masik node-hoz tud csatlakozni es channel-t nyitni.
* A clearneten futo node-ok nem latnak a Tor moge.
* A Tor node-nak elobb peer-kent kell felvennie a clearnet node-ot ahhoz, hogy channel-t tudjon nyitni.
* A channel letrehozasa utan a kapcsolat megmarad, de az ujrainditas utan kicsit tobb idobe telhet az ujracsatlakozas.
* Ha mindket node egyszerre indul ujra, vagy a clearnet node IP-cime megvaltozik, amig mindketto offline, a peer-kapcsolatot ujra kell konfiguralni manuálisan.

## Fizetesek tovabbitasa

* Kepzeljunk el egy `B` node-ot egy `A`-`B`-`C` soros kapcsolatban.
* `B` channel-jei ugy vannak beallitva, hogy `A`-tol bejovo kapacitas (remote balance), es `C` fele kimeno kapacitas (local balance) all rendelkezesre.
* Ha `A` fizetni akar `C`-nek, az 1 ugrast jelent az utvonalon.
* A motorhazteto alatt: `A` elkuldi a satoshikat `B`-nek (a routing node-nak), aki tovabbfizeti `C`-nek.
* A channel-ek kapacitasa nem valtozik, csak mozog.
* A teljes fizetes csak akkor mehet vegbe, ha a masik iranybol elobb sikeresen atkuldik a hash image-et (uzenetet).
* A folyamat "minden vagy semmi" -- a fizetes nem akadhat el utközben.

## Privat channel

* pontosabb "be nem jelentett" (unannounced) channel-nek hivni
* nem jelenik meg a channel-grafban (halozati gossip)
* fizetesek kuldesere hasznosabb
* fizetesek fogadasahoz route hint szukseges az invoice-ban:

  `lncli addinvoice <amount> --private`

* a route hint a finanszirozasi tranzakcio azonositoja (feledi a channel-t barki szamara, aki ismeri az invoice-t)
* keysend fizetesek fogadasara is alkalmas, ha a route hint ismert
* nem tovabbit fizeteseket (kiveve, ha parhuzamosan egy nyilvanos channel-lel hasznaljak ugyanahhoz a node-hoz -- mas neven shadow liquidity)

## Lightning Network routing-dijak

### Halado es automatizalt dijbeallitasok: [fees.md](advanced-tools/fees.md)

Elteroen az onchain tranzakcioktol (ahol a dij a tranzakcio altal elfoglalt byte-okert jar), a Lightning Network dijai a tovabbitott osszeghez kotottek. Ket dijkomponens letezik:

* alapdij (base\_fee\_msat). Az alapertelmezett 1000 millisat, azaz 1 satoshi dij minden tovabbitott fizetes utan.
* aranyos dij (fee\_rate), amely LND-ben alapertelmezetten 0.000001. Ez azt jelenti, hogy minden egymillio satoshi utan tovabbi 1 satoshi kerul felszamitasra.

Kozvetlenul osszekotott ket peer kozotti fizeteseknek nincs LN-dija.

A routing-dijak modositasahoz hasznald a kovetkezo parancsot: [https://lightning.engineering/api-docs/api/lnd/lightning/update-channel-policy](https://lightning.engineering/api-docs/api/lnd/lightning/update-channel-policy)

* Az alapdij csokkentese 500 msat-ra es az aranyos dij novelese 100ppm/0.01%-ra:
`$ lncli updatechanpolicy 500 0.0001 144`
* az alapertelmezett beallitas (1 sat fizetesenként + 1 ppm/0.0001%):
`$ lncli updatechanpolicy 1000 0.000001 144`

Fontos, hogy az olcso channel-ekre magasabb routing-dijat allitsunk be, hogy a kiegyenlites vagy a bezaras koltsegeit fedezzek a tovabbitott fizetesek. Ellenorizd a peer-ek routing-dijait az [1ml.com](https://1ml.com/) oldalon vagy az [lndmanage](./#lndmanage) eszkozzel.

Az egyes channel-ek dijainak beallitasa egyetlen kattintas az [RTL alkalmazasban](./#RTL---Ride-The-Lightning).

## Watchtower-ok

Tovabbi informaciok es a beallitas modja: [watchtower.md](advanced-tools/watchtower.md).

## Channel-tartalek

Altalanossagban a channel kapacitasanak 1%-a szolgal tartalekul. Ez azt jelenti, hogy barmely channel csak az 1% feletti osszeget tudja kuldeni, legfeljebb 99%-ig.

A [BOLT2](https://github.com/lightning/bolts/blob/master/02-peer-protocol.md#rationale-8) specifikalja:

>A channel-tartalekot a peer channel_reserve_satoshis erteke hatarozza meg: a channel osszkapacitasanak 1%-a az ajanlott. A channel mindket oldala fenntartja ezt a tartalekot, igy mindig van vesztenivaloja, ha egy regi, visszavont commitment tranzakciot probalna kozevetiteni. Kezdetben ez a tartalek nem teljesulhet, mivel csak az egyik felnel van penz; a protokoll azonban biztositja, hogy folyamatos haladas tortenjen a tartalek elerese fele, es ha egyszer teljesult, fenntartja azt.

Reszletesebb magyarazat a [Bitcoin Design Guide](https://bitcoin.design/guide/how-it-works/liquidity/#channel-reserve)-ban.

## Likviditas

Az alapvetesek Alex Bosworth-tol: [https://github.com/alexbosworth/run-lnd/blob/master/LIQUIDITY.md](https://github.com/alexbosworth/run-lnd/blob/master/LIQUIDITY.md)

a [Bitcoin Design Guide](https://bitcoin.design/guide/how-it-works/liquidity)-ban

## Bejovo likviditas letrehozasa

Fizess Lightninggal es kapj onchain-t.
Lasd az ajanlaslista: [CreateInboundLiquidity.md](createinboundliquidity.md)

## Kimeno likviditas letrehozasa

Egyszeruen nyiss channel-eket, vagy fizess onchain-nel es fogadj Lightningon.
Lasd az ajanlaslistat: [CreateOutboundLiquidity.md](createoutboundliquidity.md)

## Channel-ek kezelese

A channel-ek idealisan kiegyensulyozottak, mindket oldalon penzzel, hogy maximalizaljuk a fizetesek tovabbitasanak kepesseget (ketiranyú forgalmat tesz lehetove).

### [Balance of Satoshis](https://github.com/alexbosworth/balanceofsatoshis)

Gazdag funkciokeszletu eszkoz az LND egyenlegek kezelesehez. Kiserletei funkciojaval szemelyes Telegram bothoz csatlakozhatunk, es ertesiteseket kaphatunk a node tevekenysegerol.

* [Telepitesi utmutato a RaspiBlitz-hez](https://gist.github.com/openoms/823f99d1ab6e1d53285e489f7ba38602)
* A rebalance parancs hasznalatat lasd: `bos help rebalance`

### [CLBOSS - A C-Lightning Node Menedzser](https://github.com/ZmnSCPxj/clboss)

Automatizalt menedzser C-Lightning tovabitasi node-okhoz.

### [lndmanage](https://github.com/bitromortac/lndmanage)

Parancssori eszkoz az LND node halado channel-kezelesehez, Pythonban irva.

* Telepites:

  ```bash
    # virtualis kornyezet aktivalasa
    sudo apt install -y python3-venv
    python3 -m venv venv
    source venv/bin/activate
    # fuggosegek telepitese
    sudo apt install -y python3-dev libatlas-base-dev
    pip3 install wheel
    python3 -m pip install lndmanage
  ```

* Az interaktiv mod inditasa (minden uj inditaskor):

  ```bash
    $ source venv/bin/activate
    (venv) $ lndmanage
  ```

* A channel-ek allapotanak megjelenitese:

  `$ lndmanage status`
  `$ lndmanage listchannels`

* Pelda rebalance parancs:

  `$ lndmanage rebalance --max-fee-sat 20 --max-fee-rate 0.0001 CHANNEL_ID --reckless`

### [rebalance-lnd](https://github.com/C-Otto/rebalance-lnd)

Ezzel a Python szkripttel egyszeruen kiegyenlitheted az LND node-od egyes channel-jeit.

* Telepiteshez futtasd az LND node terminaljan:

  `$ git clone https://github.com/C-Otto/rebalance-lnd`

  `$ cd rebalance-lnd`

  `$ pip install -r requirements.txt`

* Hasznalat (tovabbi opciok a [readme](https://github.com/C-Otto/rebalance-lnd/blob/master/README.md#usage)-ban):

  `$ python rebalance.py -t <channel_ID-where-to-move-sats> -f <channel_ID-from-which-to-move-sats> -a <amount-of-sats-to-be-moved>`

### [Kiegyensulyozott channel letrehozasanak modszerei megbízhato peer-rel](advanced-tools/balancedchannelcreation.md)

* Vegezz megbizhato onchain-offchain swap-ot.
* Nyiss ket oldalrol finanszirozott, kiegyensulyozott channel-t megbizhato peer-rel a parancssor segitsegevel, amihez egy Lightning es egy onchain tranzakcio szukseges.

## Monitorozo szoftverek

### [RTL - Ride The Lightning](https://github.com/ShahanaFarooqui/RTL)

Az RTL egy webes felhasznaloi felulet a Lightning Network Daemon-hoz. Helyi halozaton valo hasznalatra terveztek. [HTTPS](https://github.com/openoms/bitcoin-tutorials/tree/master/nginx) vagy [Tor](https://github.com/Ride-The-Lightning/RTL/blob/master/docs/RTL_TOR_setup.md) kapcsolodasi lehetoseg all rendelkezesre.
[https://medium.com/@suheb\_\_/how-to-ride-the-lightning-447af999dcd2](mailto:https://medium.com/@suheb__/how-to-ride-the-lightning-447af999dcd2)

### [ThunderHub](https://www.thunderhub.io/)

LND Lightning Node menedzser a bongeszoben.

* [Telepitesi utmutato a RaspiBlitz-en](https://gist.github.com/openoms/8ba963915c786ce01892f2c9fa2707bc)

### [ZeusLN](https://zeusln.app/)

Mobil Bitcoin alkalmazas Lightning Network Daemon (LND) node-uzemeltetok szamara. Android es iOS -- a REST API-n (8080-as port vagy [Tor](https://github.com/openoms/bitcoin-tutorials/blob/master/Zeus_to_RaspiBlitz_through_Tor.md)) keresztul csatlakozik.

### [Zap](https://zap.jackmallers.com/)

Lightning taranca asztali gepre, iOS-re es Androidra -- tavolrol csatlakozhat az LND node-odhoz a GRPC interfeszen (10009-es port) keresztul.

### [Joule](https://lightningjoule.com/)

Hozd el a Lightning erejet a webre bongeszon beluli fizetesekkel es identitassal, mindezt a sajat node-oddal.
[https://medium.com/lightning-power-users/bitcoin-lightning-joule-chrome-extension-ac149bb05cb9](https://medium.com/lightning-power-users/bitcoin-lightning-joule-chrome-extension-ac149bb05cb9)

### [lntop](https://github.com/edouardparis/lntop)

Az lntop egy interaktiv szoveges modú channel-megjelenito Unix rendszerekhez.

### [lnd-admin](https://github.com/janoside/lnd-admin)

Adminisztracios webes felulet az LND-hez gRPC-n keresztul. Node.js-sel, Express-szel es Bootstrap-v4-gyel epult. Teszteld itt: [https://lnd-admin.chaintools.io/](https://lnd-admin.chaintools.io/)

### [lndmon](https://github.com/lightninglabs/lndmon)

Azonnal telepitheto monitoring megoldas az LND node-odhoz Prometheus es Grafana segitsegevel. [https://blog.lightning.engineering/posts/2019/07/24/lndmon-v0.1.html](https://blog.lightning.engineering/posts/2019/07/24/lndmon-v0.1.html)

### [Spark wallet a C-Lightninghoz](https://github.com/shesek/spark-wallet)

A Spark egy minimalista taraca-felulet a c-lightninghoz, elerheto weben, valamint mobil es asztali alkalmazasokkal (Android, Linux, macOS es Windows). Jelenleg technikalisan halado felhasznaloknak szol, es nem egy mindent-egyben csomag, hanem inkabb egy "taviranyito" felulet a c-lightning node-hoz, amelyet kulon kell kezelni.

## Lightning Network felderitok

* [1ml.com](https://1ml.com/)
* [explorer.acinq.co](https://explorer.acinq.co/)
* [amboss.space](https://amboss.space/)
* [ln.fiatjaf.com](https://ln.fiatjaf.com)

## Forrasok

* LND Builder's Guide -- bevalt gyakorlatok

  [docs.lightning.engineering/advanced-best-practices/advanced-best-practices-overview/channels](https://docs.lightning.engineering/advanced-best-practices/advanced-best-practices-overview/channels)

* A Lightning Network koncepcionalis attekintese:

  [dev.lightning.community/overview/index.html\#lightning-network](https://dev.lightning.community/overview/index.html#lightning-network)

* gRPC API referenciadokumentacio az LND-hez

  [api.lightning.community](https://api.lightning.community)

* [medium.com/lightningto-me/practical-solutions-to-inbound-capacity-problem-in-lightning-network-60224aa13393](https://medium.com/lightningto-me/practical-solutions-to-inbound-capacity-problem-in-lightning-network-60224aa13393)
* [lightningwiki.net](https://lightningwiki.net)
* [satbase.org](https://satbase.org)
* Lista arrol, hogyan lehet gyorsan channel-likviditashoz jutni:

  [github.com/raspiblitz/raspiblitz/issues/395](https://github.com/raspiblitz/raspiblitz/issues/395)

* Osszevalogatott lista a legjobb Lightning Network forrasokrol, alkalmazasokrol es konyvtarakrol:

  [github.com/bcongdon/awesome-lightning-network](https://github.com/bcongdon/awesome-lightning-network)

* Jameson Lopp osszevalogatott Lightning Network forraslistaja:

  [lightning.how](https://lightning.how)

* [wiki.ion.radar.tech/tutorials/troubleshooting/bootstrapping-channels](https://wiki.ion.radar.tech/tutorials/troubleshooting/bootstrapping-channels)

### Routing

* [blog.lightning.engineering/posts/2018/05/30/routing.html](https://blog.lightning.engineering/posts/2018/05/30/routing.html)
* [diyhpl.us/wiki/transcripts/chaincode-labs/2018-10-22-alex-bosworth-channel-management/](https://diyhpl.us/wiki/transcripts/chaincode-labs/2018-10-22-alex-bosworth-channel-management/)
* [diyhpl.us/wiki/transcripts/lightning-hack-day/2021-03-27-alex-bosworth-lightning-routing/](https://diyhpl.us/wiki/transcripts/lightning-hack-day/2021-03-27-alex-bosworth-lightning-routing/)

## Videok

* Elaine Ou - Lightning node beallitasa es karbantartasa [38 perces video](https://www.youtube.com/watch?v=qX4Z3JY1094) es [diak](https://lightningresidency.com/assets/presentations/Ou_Bootstrapping_and_Maintaining_a_Lightning_Node.pdf)
* Alex Bosworth - Lightning channel-menedzsment [35 perces video](https://www.youtube.com/watch?v=HlPIB6jt6ww&feature=youtu.be)
* [Chaincode Labs Lightning Szeminarum - 2019 nyar](https://www.youtube.com/playlist?list=PLpLH33TRghT17_U3as2P3vHfAGL8pSOOY)
* Alex Bosworth online eloadasainak gyujtemenye:

  [twitter.com/alexbosworth/status/1175091117668257792](https://twitter.com/alexbosworth/status/1175091117668257792)

## Forumok

* Kozosseg altal kezelt csoport a RaspiBlitz Lightning Node-hoz:

  [https://t.me/raspiblitz](https://t.me/raspiblitz)

* LND Developer Slack. A meghivo link itt talalhato:

  [dev.lightning.community/](https://dev.lightning.community/)

* Subreddit Bitcoin es Lightning fejlesztoknek technikai temak megbeszelesehez:

  [www.reddit.com/r/lightningdevs](https://www.reddit.com/r/lightningdevs)

## Tanulas

[https://github.com/lnbook/lnbook](https://github.com/lnbook/lnbook)
[https://chaincode.applytojob.com/apply/LpQl1a0cvd/Chaincode-Labs-Online-Seminars](https://chaincode.applytojob.com/apply/LpQl1a0cvd/Chaincode-Labs-Online-Seminars) [https://github.com/chaincodelabs/lightning-curriculum](https://github.com/chaincodelabs/lightning-curriculum)
