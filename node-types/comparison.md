|Implementations | LND | Core Lightning |
| - | :--- | :--- |
| Codebase | written in Go<br> [github.com/lightningnetwork/lnd](https://github.com/lightningnetwork/lnd) | written in C with plugins in various languages<br> [github.com/ElementsProject/lightning](https://github.com/ElementsProject/lightning) |  |
| Documentation | [api.lightning.community](https://api.lightning.community/) <br> [docs.lightning.engineering](https://docs.lightning.engineering/) | [lightning.readthedocs.io](https://lightning.readthedocs.io/) |  |
| Contact | [lightning.engineering/slack.html](https://lightning.engineering/slack.html) <br> [t.me/lightninglab](https://t.me/lightninglab) | IRC libera.chat #c-lightning <br> [t.me/lightningd](https://t.me/lightningd)|  |
| Main advantages | bigger networkshare and team<br> more services built on top<br> detailed documentation<br> bundled with services and GUI in lit<br> binaries provided for various platforms | specs driven<br> modular development ensures flexibility<br> very modest hardware need even as a routing node<br> built with privacy as a priority in mind |  |
| Multiple channels between two peers | yes | yes since v0.11.0 |  |
| Keysend | optional | on by default |  |
| Payments | most efficient in finding the shortest path<br> best success rate<br> a cost function takes recent failures into consideration| prefers low locktimes<br> takes channel sizes into account since v0.10.2 (Pickhardt Payments)<br> Slightly more expensive due to randomization for privacy<br> the logic can be replaced with plugins |  |
| MPP (multi part payments) | optional | on by default |  |
| Swaps | Loop service (with daemon)<br>  Boltz.exchange (with daemon)<br> PeerSwap | Boltz.exchange through website + API<br> PeerSwap |
| Autopilot | built in, but limited | CLBOSS plugin with advanced logic |  |
| Watchtower | built in<br> not incentivised | available as a [plugin for Eye of Satoshi](https://github.com/talaia-labs/python-teos/tree/master/watchtower-plugin)<br> not incentivised    |  |
| Dymanic fee settings | solved by external tools like charge-lnd and Balance of Satoshis | feeadjuster plugin, CLBOSS |  |
| Dual funded channels | manual, using PSBTs and/or Balance of Satoshis | experimental feature<br> automated with liquidity ads |  |
| Paid incoming channels | Pool service including sidecar channels<br> Voltage Flow <br> [amboss.space](https://amboss.space) Magma | boltz.exchange plugin<br> liquidity ads<br> [amboss.space](https://amboss.space) Magma|  |
| Privacy | full Tor support | Full Tor support<br> MPP usage by default<br> [Route Randomization<br> Shadow Route (virtual extension of hops)](https://lightning.readthedocs.io/lightning-pay.7.html#randomization)|
| WebUI | RTL <br> Thunderhub<br> Lightning Terminal <br> | RTL <br> Spark Wallet / Sparko |  |
| Mobile Apps | Zeus<br>Fully Noded (iOS only)<br>Zap Android ([iOS unmaintained](https://github.com/LN-Zap/zap-iOS#unmaintained))|Zeus<br>Fully Noded (iOS only)||
| Database format | bbolt by default (restarts needed to compact) <br> experinemtal etcd<br> full postgres support | sqlite3 by default (compacts on-the-fly)<br>full postgres support||||
| Backups and recovery | seedwords + SCB (status channel backups)<br>[github.com/lightningnetwork/lnd/blob/master/docs/recovery.md](https://github.com/lightningnetwork/lnd/blob/master/docs/recovery.md)<br>[node-recovery.com](https://node-recovery.com/)| hsmsecret hex (optional seedwords) + append-only (low wear) backup of the sqlite3 database with the backup plugin<br> sqlite3 replication to a custom path or NFS mount<br> [lightning.readthedocs.io/BACKUP.html](https://lightning.readthedocs.io/BACKUP.html)||
|||||

## Resources

* Comparative Analysis of Lightning's Routing Clients
  * Article: <https://ieeexplore.>ieee.org/abstract/document/9566199
  * Summary Twitter thread: <https://twitter.com/roasbeef/status/1453434255237795840>