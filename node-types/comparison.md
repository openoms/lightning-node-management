|Implementations | LND | C-lightning | 
| - | :--- | :--- |
| Codebase | written in Go<br> [github.com/lightningnetwork/lnd](https://github.com/lightningnetwork/lnd) | written in C with plugins in various languages<br> [github.com/ElementsProject/lightning](https://github.com/ElementsProject/lightning) |  |
| Documentation | [api.lightning.community](https://api.lightning.community/) <br> [docs.lightning.engineering](https://docs.lightning.engineering/) | [lightning.readthedocs.io](https://lightning.readthedocs.io/) |  |
| Contact | [lightning.engineering/slack.html](https://lightning.engineering/slack.html) <br> [t.me/lightninglab](https://t.me/lightninglab) | IRC libera.chat #c-lightning <br> [t.me/lightningd](https://t.me/lightningd)|  |
| Main advantages | bigger networkshare and team<br> more services and support<br> detailed documentation<br>  user focused | specs driven<br> modular development<br>  modest hardware need even as a routing node<br> built for privacy as a priority <br> more developer focused |  |
| Multiple channels between two peers | yes | no |  |
| Keysend | yes, optional | yes, on by default |  |
| Payments | most efficient in finding the shortest path<br> best success rate<br> a cost function takes recent failures into consideration| prefers low locktimes<br> takes channel sizes into account since v0.10.2 (Pickhardt Payments)<br> Slightly more expensive due to randomization for privacy<br> the logic can be replaced with plugins |  |
| MPP (multi part payments) | yes, optional | yes, on by default |  |
| Swaps | Loop service (with daemon)<br>  Boltz.exchange (with daemon) | Boltz.exchange through website + API |  
| Autopilot | built in, but limited | CLBOSS plugin with advanced logic |  |
| Watchtower | built in<br> not incentivised | available as a [plugin for Eye of Satoshi](https://github.com/talaia-labs/python-teos/tree/master/watchtower-plugin)   |  |
| Dymanic fee settings | Can be scripted with ChargeLND and Balance of Satoshis | feeadjuster plugin |  |
| Dual funded channels | manual using PSBT and/or Balance of Satoshis | experimental feature |  |
| Paid incoming channels | Pool service including sidecar channels | boltz.exchange plugin |  |
| Privacy | Full Tor support | Full Tor support<br> MPP usage by default<br> [Route Randomization<br> Shadow Route (virtual extension of hops)](https://lightning.readthedocs.io/lightning-pay.7.html#randomization)|
| WebUI | RTL <br> Thunderhub<br> Lightning Terminal <br> | RTL <br> Spark Wallet / Sparko |  |
| Mobile Apps | Zeus<br>Fully Noded (iOS only)<br>Zap Android ([iOS unmaintained](https://github.com/LN-Zap/zap-iOS#unmaintained))|Zeus<br>Fully Noded (iOS only)||
| Database format | bbolt by default <br> experinemtal etcd<br> postgres under development | sqllite3 by default<br>postgres under development||||
| Backups and recovery | seedwords + SCB (status channel backups)<br>[github.com/lightningnetwork/lnd/blob/master/docs/recovery.md](https://github.com/lightningnetwork/lnd/blob/master/docs/recovery.md)<br>[node-recovery.com](https://node-recovery.com/)| hsmsecret hex (optional seedwords) + replication of sqllite3 database<br>[lightning.readthedocs.io/BACKUP.html](https://lightning.readthedocs.io/BACKUP.html)||
|||||

## Resources

* Comparative Analysis of Lightning's Routing Clients
  * Article: <https://ieeexplore.>ieee.org/abstract/document/9566199
  * Summary Twitter thread: <https://twitter.com/roasbeef/status/1453434255237795840>