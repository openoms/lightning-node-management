|Implementaciok | LND | Core Lightning |
| - | :--- | :--- |
| Kodbazis | Go-ban irva<br> [github.com/lightningnetwork/lnd](https://github.com/lightningnetwork/lnd) | C-ben irva, bovitmenyei kulonbozo nyelveken<br> [github.com/ElementsProject/lightning](https://github.com/ElementsProject/lightning) |  |
| Dokumentacio | [api.lightning.community](https://api.lightning.community/) <br> [docs.lightning.engineering](https://docs.lightning.engineering/) | [lightning.readthedocs.io](https://lightning.readthedocs.io/) |  |
| Kapcsolat | [lightning.engineering/slack.html](https://lightning.engineering/slack.html) <br> [t.me/lightninglab](https://t.me/lightninglab) | IRC libera.chat #c-lightning <br> [t.me/lightningd](https://t.me/lightningd)|  |
| Fo elonyok | nagyobb halozati reszesedes es csapat<br> tobb rajta epulo szolgaltatas<br> reszletes dokumentacio<br> szolgaltatasokkal es GUI-val egyutt a lit-ben<br> binarisok kulonbozo platformokra | specifikaciovezerelt<br> a modularis fejlesztes rugalmassagot biztosit<br> nagyon szeret hardverigeny meg routing node-kent is<br> a privacy szem elott tartasaval epult |  |
| Tobb channel ket peer kozott | igen | igen a v0.11.0 ota |  |
| Keysend | opcionalis | alapertelmezetten bekapcsolva |  |
| Fizetesek | a leghatekonabb a legrovidebb ut megtalálasaban<br> legjobb sikerarany<br> koltsegfuggveny figyelembe veszi a kozelmultbeli hibikat | alacsony zarolasi idoket preferalja<br> figyelembe veszi a channel-mereteket a v0.10.2 ota (Pickhardt Payments)<br> Valamivel dragabb a veletlen utvAlasztas miatti privacy-vedelem miatt<br> a logika bovitmenyekkel lecserelheto |  |
| MPP (tobb reszes fizetesek) | opcionalis | alapertelmezetten bekapcsolva |  |
| Swap-ok | Loop szolgaltatas (daemonnal)<br>  Boltz.exchange (daemonnal)<br> PeerSwap | Boltz.exchange weboldalon + API-n keresztul<br> PeerSwap |
| Autopilot | beepitett, de korlatozott | CLBOSS bovitmeny halado logikával |  |
| Watchtower | beepitett<br> nem osztonzott | elerheto mint [bovitmeny az Eye of Satoshi-hoz](https://github.com/talaia-labs/python-teos/tree/master/watchtower-plugin)<br> nem osztonzott    |  |
| Dinamikus dijbeallitasok | kulso eszkozokkel megoldott, mint a charge-lnd es a Balance of Satoshis | feeadjuster bovitmeny, CLBOSS |  |
| Ket oldalrol finanszirozott channel-ek | manualis, PSBT-kkel es/vagy Balance of Satoshis-szal | kiserletei funkcio<br> automatizalva liquidity ads-szel |  |
| Fizetett bejovo channel-ek | Pool szolgaltatas, beleertve a sidecar channel-eket<br> Voltage Flow <br> [amboss.space](https://amboss.space) Magma | boltz.exchange bovitmeny<br> liquidity ads<br> [amboss.space](https://amboss.space) Magma|  |
| Privacy | teljes Tor tamogatas | teljes Tor tamogatas<br> MPP hasznalat alapertelmezetten<br> [utvonal-veletelenszeru kijelolés<br> Shadow Route (ugrasok virtualis bovitese)](https://lightning.readthedocs.io/lightning-pay.7.html#randomization)|
| Webes felulet | RTL <br> Thunderhub<br> Lightning Terminal <br> | RTL <br> Spark Wallet / Sparko |  |
| Mobil alkalmazasok | Zeus<br>Fully Noded (csak iOS)<br>Zap Android ([iOS nem karbantartott](https://github.com/LN-Zap/zap-iOS#unmaintained))|Zeus<br>Fully Noded (csak iOS)||
| Adatbazis formatum | bbolt alapertelmezetten (ujrainditás szukseges a tomoriteshez) <br> kiserletei etcd<br> teljes postgres tamogatas | sqlite3 alapertelmezetten (menet kozben tomorit)<br>teljes postgres tamogatas||||
| Biztonsagi mentes es helyreallitas | seedwords + SCB (status channel backups)<br>[github.com/lightningnetwork/lnd/blob/master/docs/recovery.md](https://github.com/lightningnetwork/lnd/blob/master/docs/recovery.md)<br>[node-recovery.com](https://node-recovery.com/)| hsmsecret hex (opcionalis seedwords) + append-only (alacsony kopas) biztonsagi mentes az sqlite3 adatbazisrol a backup bovitmenynyel<br> sqlite3 replikacio egyeni eleresi utra vagy NFS csatolasra<br> [lightning.readthedocs.io/BACKUP.html](https://lightning.readthedocs.io/BACKUP.html)||
|||||

## Forrasok

* A Lightning routing kliensek osszehasonlito elemzese
  * Cikk: <https://ieeexplore.>ieee.org/abstract/document/9566199
  * Osszefoglalo Twitter-szal: <https://twitter.com/roasbeef/status/1453434255237795840>
