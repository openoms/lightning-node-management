Implementációk | LND | Core Lightning |
| - | :--- | :--- |
| Kódbázis | Go-ban írva<br> [github.com/lightningnetwork/lnd](https://github.com/lightningnetwork/lnd) | C-ben írva, bővítményei különböző nyelveken<br> [github.com/ElementsProject/lightning](https://github.com/ElementsProject/lightning) |  |
| Dokumentáció | [api.lightning.community](https://api.lightning.community/) <br> [docs.lightning.engineering](https://docs.lightning.engineering/) | [lightning.readthedocs.io](https://lightning.readthedocs.io/) |  |
| Kapcsolat | [lightning.engineering/slack.html](https://lightning.engineering/slack.html) <br> [t.me/lightninglab](https://t.me/lightninglab) | IRC libera.chat #c-lightning <br> [t.me/lightningd](https://t.me/lightningd)|  |
| Fő előnyök | nagyobb hálózati részesedés és csapat<br> több rajta épülő szolgáltatás<br> részletes dokumentáció<br> szolgáltatásokkal és GUI-val együtt a lit-ben<br> binárisok különböző platformokra | specifikációvezérelt<br> a moduláris fejlesztés rugalmasságot biztosít<br> nagyon szeret hardverigény még routing node-ként is<br> a privacy szem előtt tartásával épült |  |
| Több channel két peer között | igen | igen a v0.11.0 óta |  |
| Keysend | opcionális | alapértelmezetten bekapcsolva |  |
| Fizetések | a leghatékonyabb a legrövidebb út megtalálásában<br> legjobb sikerarány<br> költségfüggvény figyelembe veszi a közelmúltbeli hibákat | alacsony zárolási időket preferálja<br> figyelembe veszi a channel-méreteket a v0.10.2 óta (Pickhardt Payments)<br> Valamivel drágább a véletlen útválasztás miatti privacy-védelem miatt<br> a logika bővítményekkel lecserélhető |  |
| MPP (több részes fizetések) | opcionális | alapértelmezetten bekapcsolva |  |
| Swap-ok | Loop szolgáltatás (daemonnal)<br>  Boltz.exchange (daemonnal)<br> PeerSwap | Boltz.exchange weboldalon + API-n keresztül<br> PeerSwap |
| Autopilot | beépített, de korlátozott | CLBOSS bővítmény haladó logikával |  |
| Watchtower | beépített<br> nem ösztönzött | elérhető mint [bővítmény az Eye of Satoshi-hoz](https://github.com/talaia-labs/python-teos/tree/master/watchtower-plugin)<br> nem ösztönzött    |  |
| Dinamikus díjbeállítások | külső eszközökkel megoldott, mint a charge-lnd és a Balance of Satoshis | feeadjuster bővítmény, CLBOSS |  |
| Két oldalról finanszírozott channel-ek | manuális, PSBT-kkel és/vagy Balance of Satoshis-szal | kísérleti funkció<br> automatizálva liquidity ads-szel |  |
| Fizetett bejövő channel-ek | Pool szolgáltatás, beleértve a sidecar channel-eket<br> Voltage Flow <br> [amboss.space](https://amboss.space) Magma | boltz.exchange bővítmény<br> liquidity ads<br> [amboss.space](https://amboss.space) Magma|  |
| Privacy | teljes Tor támogatás | teljes Tor támogatás<br> MPP használat alapértelmezetten<br> [útvonal-véletlenszerű kijelölés<br> Shadow Route (ugrások virtuális bővítése)](https://lightning.readthedocs.io/lightning-pay.7.html#randomization)|
| Webes felület | RTL <br> Thunderhub<br> Lightning Terminal <br> | RTL <br> Spark Wallet / Sparko |  |
| Mobil alkalmazások | Zeus<br>Fully Noded (csak iOS)<br>Zap Android ([iOS nem karbantartott](https://github.com/LN-Zap/zap-iOS#unmaintained))|Zeus<br>Fully Noded (csak iOS)||
| Adatbázis formátum | bbolt alapértelmezetten (újraindítás szükséges a tömörítéshez) <br> kísérleti etcd<br> teljes postgres támogatás | sqlite3 alapértelmezetten (menet közben tömörít)<br>teljes postgres támogatás||||
| Biztonsági mentés és helyreállítás | seedwords + SCB (status channel backups)<br>[github.com/lightningnetwork/lnd/blob/master/docs/recovery.md](https://github.com/lightningnetwork/lnd/blob/master/docs/recovery.md)<br>[node-recovery.com](https://node-recovery.com/)| hsmsecret hex (opcionális seedwords) + append-only (alacsony kopás) biztonsági mentés az sqlite3 adatbázisról a backup bővítménnyel<br> sqlite3 replikáció egyéni elérési útra vagy NFS csatolásra<br> [lightning.readthedocs.io/BACKUP.html](https://lightning.readthedocs.io/BACKUP.html)||
|||||

## Források

* A Lightning routing kliensek összehasonlító elemzése
  * Cikk: <https://ieeexplore.>ieee.org/abstract/document/9566199
  * Összefoglaló Twitter-szal: <https://twitter.com/roasbeef/status/1453434255237795840>
