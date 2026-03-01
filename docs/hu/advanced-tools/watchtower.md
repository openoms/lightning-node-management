# LND watchtower beállítása és kliens csatlakoztatása

A watchtower figyeli a Bitcoin blokkláncot, és kiszűri azokat a tranzakciókat, amelyek egy korábbi, érvénytelen állapottal próbálják meg lezárni a kliens channel-jét, ezzel ellopva az abban lévő összegeket. Ha szabálysértést talál, a watchtower azonnal közvetíti a büntető tranzakciót, amely a channel összes összegét a kliens onchain tárcájába helyezi át.

Ha két, lnd v0.7.0 vagy újabb verziót futtató node-od van, beállíthatod őket, hogy kölcsönösen figyeljenek egymásra. A legjobb, ha a node-ok két különböző fizikai helyen vannak, így a váratlan kapcsolatvesztés esetén is biztosított a védelem.

## LND frissítése

Ellenőrizd a legújabb verziót és a kiadási megjegyzéseket itt: [https://github.com/lightningnetwork/lnd/releases/](https://github.com/lightningnetwork/lnd/releases/). Frissíts [kézileg](https://github.com/lightningnetwork/lnd/blob/master/docs/INSTALL.md#installing-lnd) vagy használj egy [automatizált segédszkriptet](https://github.com/openoms/lightning-node-management/blob/en/technicals/lnd.updates.md) az lnd frissítéséhez RaspiBlitz-en vagy kompatibilis rendszeren.

## A Watchtower beállítása

Futtasd a parancsokat a node terminálján.
A `#` a `$ sudo` rövidítése.

* Szerkeszd az lnd.conf fájlt:

  `# nano /mnt/hdd/lnd/lnd.conf`

* Illeszd be a következő sorokat a fájl végére:

  ```text
  [Watchtower]
  watchtower.active=1
  ```

  * A watchtower alapértelmezetten a 9911-es porton figyel, de bármilyen más szabad portra állítható a konfigurációs fájlban: `watchtower.listen=0.0.0.0:PORT`.
  * A `0.0.0.0` IP-cím azt jelenti, hogy mindenhonnan fogad kapcsolatokat \(alapértelmezett beállítás\).

* Engedélyezd a portot a tűzfalon:
`# ufw allow 9911 comment "watchtower"`
`# ufw enable`
* Indítsd újra az lnd-t: `# systemctl restart lnd`
* Továbbítsd a 9911-es portot a routeren.
* Ellenőrizd a naplóban, hogy a szolgáltatás működik-e:
  `# tail -n 10000 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log`

  Példa naplóbejegyzés:

  ```text
  2019-06-21 09:08:58.544 [INF] WTWR: Starting watchtower
  2019-06-21 09:08:58.544 [INF] WTWR: Starting lookout
  2019-06-21 09:08:58.544 [INF] WTWR: Starting lookout from chain tip
  2019-06-21 09:08:58.544 [INF] WTWR: Lookout started successfully
  2019-06-21 09:08:58.545 [INF] WTWR: Starting watchtower server
  2019-06-21 09:08:58.544 [INF] DISC: Attempting to bootstrap with: Authenticated Channel Graph
  2019-06-21 09:08:58.545 [INF] CMGR: Server listening on 127.0.0.1:9911
  2019-06-21 09:08:58.545 [INF] NTFN: New block epoch subscription
  2019-06-21 09:08:58.545 [INF] WTWR: Watchtower server started successfully
  2019-06-21 09:08:58.546 [INF] WTWR: Watchtower started successfully
  2019-06-21 09:08:58.547 [INF] CHBU: Swapping old multi backup file from /home/bitcoin/.lnd/data/chain/bitcoin/mainnet/temp-dont-use.backup to /home/bitcoin/.lnd/data/chain/bitcoin/mainnet/channel.backup
  2019-06-21 09:08:58.575 [INF] DISC: Obtained 3 addrs to bootstrap network
  2019-06-21 13:10:27.014 [INF] WTWR: Watchtower started successfully
  2019-06-21 13:14:50.743 [INF] WTWR: Accepted incoming peer 02b5792e533ad17fc77db13093ad84ea304c5069018f97083e3a8c6a2eac95a63f@171.25.193.25:34413
  2019-06-21 13:14:51.074 [INF] WTWR: Accepted session for 02b5792e533ad17fc77db13093ad84ea304c5069018f97083e3a8c6a2eac95a63f
  2019-06-21 13:14:51.074 [INF] WTWR: Releasing incoming peer 02b5792e533ad17fc77db13093ad84ea304c5069018f97083e3a8c6a2eac95a63f@171.25.193.25:34413
  ```

  A releváns üzenetek folyamatos szűrése \(kilépés: CTRL+C\):
  `# tail -f -n 10000 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log | grep WTWR`

* Jegyezd fel a `pubkey`-t az alábbi parancs kimenetéből:
  `$ lncli tower info`

  A watchtower pubkey-je különbözik az lnd node pubkey-jétől.

## A megfigyelt node beállítása \(a watchtower kliens\)

* Szerkeszd az lnd.conf fájlt:

  `# nano /mnt/hdd/lnd/lnd.conf`

* Illeszd be a következő sorokat a fájl végére:

  ```text
  [Wtclient]
  wtclient.active=1
  ```

  Watchtower hozzáadása parancssorból \(egyszerre többet is hozzáadhatsz, egyenként\):

  ```text
  $ lncli wtclient add <watchtower-pubkey>@<host>:9911
  ```

* Használd a korábban a `$ lncli tower info` parancsból feljegyzett `watchtower-pubkey`-t.
* Clearnet kliens esetén a `host`-nak a watchtower clearnet IP-címének \(vagy dynamicDNS-ének\) kell lennie, még akkor is, ha a watchtower Tor mögött fut.
* Indítsd újra az lnd-t:
`# systemctl restart lnd`
* Ellenőrizd a naplóban, hogy a szolgáltatás működik-e:
  `# tail -n 100 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log`

  Példa naplóbejegyzés:

  ```text
  2019-06-21 14:14:50.785 [DBG] WTCL: Sending Init to 02a4c564af0f33795b438e8d76d2b5057c3dcd1115be144c3fc05e7c8c65486f23@<host>:9911
  2019-06-21 14:14:51.098 [DBG] WTCL: Received Init from 02a4c564af0f33795b438e8d76d2b5057c3dcd1115be144c3fc05e7c8c65486f23@<host>:9911
  2019-06-21 14:14:51.105 [DBG] WTCL: Sending MsgCreateSession(blob_type=[FlagCommitOutputs|No-FlagReward], max_updates=1024 reward_base=0 reward_rate=0 sweep_fee_rate=12000) to 02a4c564af0f33795b438e8d76d2b5057c3dcd1115be144c3fc05e7c8c65486f23@<host>:9911
  2019-06-21 14:14:51.299 [DBG] WTCL: Received MsgCreateSessionReply(code=0) from 02a4c564af0f33795b438e8d76d2b5057c3dcd1115be144c3fc05e7c8c65486f23@<host>:9911
  2019-06-21 14:14:51.315 [DBG] WTCL: New session negotiated with 02a4c564af0f33795b438e8d76d2b5057c3dcd1115be144c3fc05e7c8c65486f23@<host>:9911, policy: (blob-type=10 max-updates=1024 reward-rate=0 sweep-fee-rate=12000)
  2019-06-21 14:14:51.320 [INF] WTCL: Acquired new session with id=02b5792e533ad17fc77db13093ad84ea304c5069018f97083e3a8c6a2eac95a63f
  2019-06-21 14:14:51.322 [DBG] WTCL: Loaded next candidate session queue id=02b5792e533ad17fc77db13093ad84ea304c5069018f97083e3a8c6a2eac95a63f
  2019-06-21 14:15:16.588 [INF] WTCL: Client stats: tasks(received=0 accepted=0 ineligible=0) sessions(acquired=1 exhausted=0)
  ```

  A releváns üzenetek folyamatos szűrése \(kilépés: CTRL+C\):
  `# tail -f -n 10000 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log | grep WTCL`

  A napló részletességének növeléséhez add hozzá az alábbi sort az lnd.conf fájlhoz:

  ```text
  debuglevel=WTWR=debug,WTCL=debug
  ```

  vagy futtasd a parancsot menet közben:
  `lncli debuglevel --level=WTWR=debug,WTCL=debug`

  Példa naplóbejegyzés:

  ```text
  2019-07-29 15:26:51.386 [DBG] WTWR: Fetching block for (height=587633, hash=0000000000000000000b047fbe6d93c2af193249bdb864a99186914fc4b0b2c6)
  2019-07-29 15:26:52.192 [DBG] WTWR: Scanning 3007 transaction in block (height=587633, hash=0000000000000000000b047fbe6d93c2af193249bdb864a99186914fc4b0b2c6) for breaches
  2019-07-29 15:26:52.301 [DBG] WTWR: No breaches found in (height=587633, hash=0000000000000000000b047fbe6d93c2af193249bdb864a99186914fc4b0b2c6)
  2019-07-29 15:34:17.877 [DBG] WTWR: Fetching block for (height=587634, hash=00000000000000000010615b2c0b3c32cb4ebcb7eb0bd452812f5c48d0edad0c)
  2019-07-29 15:34:18.463 [DBG] WTWR: Scanning 2691 transaction in block (height=587634, hash=00000000000000000010615b2c0b3c32cb4ebcb7eb0bd452812f5c48d0edad0c) for breaches
  2019-07-29 15:34:18.619 [DBG] WTWR: No breaches found in (height=587634, hash=00000000000000000010615b2c0b3c32cb4ebcb7eb0bd452812f5c48d0edad0c)
  ```

  Dőlj hátra és élvezd, hogy mostantól semmilyen módon nem lehet becsapni a node-odat, még akkor sem, ha offline!

## Beállítás Tor mögötti node-okhoz

Mindkét node-nak \(a watchtower-nek és a kliensnek is\) Tor mögött kell futnia ahhoz, hogy kommunikálni tudjanak egymással.

### Tor Watchtower beállítás

* Szerkeszd az lnd.conf fájlt:

  `# nano /mnt/hdd/lnd/lnd.conf`

* Illeszd be a következő sorokat a fájl végére:

  ```text
  [Watchtower]
  watchtower.active=1
  ```

* Szerkeszd a watchtower Tor konfigurációs fájlját:
  `# nano /etc/tor/torrc`

  Add hozzá a következő sorokat:

  ```text
  # Hidden Service for incoming LND WatchTower connections
  HiddenServiceDir /mnt/hdd/tor/lndWT9911
  HiddenServicePort 9911 127.0.0.1:9911
  ```

* Indítsd újra a Tor-t és az lnd-t a systemctl segítségével:
`# systemctl restart tor`
`# systemctl restart lnd`
* Jegyezd fel a watchtower onion címét az alábbi paranccsal:
`# cat /mnt/hdd/tor/lndWT9911/hostname`
* Jegyezd fel a watchtower-pubkey-t az alábbi paranccsal:
`$ lncli tower info`
* A napló folyamatos szűrése \(kilépés: CTRL+C\):
`# tail -f -n 10000 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log | grep WTWR`

  Példa kimenet a watchtower oldalán:

  ```text
  2019-08-20 11:26:30.555 [INF] WTWR: Accepted incoming peer WTCLIENT_PUBKEY@127.0.0.1:57264
  2019-08-20 11:26:30.558 [DBG] WTWR: Received Init from WTCLIENT_PUBKEY@127.0.0.1:57264
  2019-08-20 11:26:30.565 [DBG] WTWR: Sending Init to WTCLIENT_PUBKEY@127.0.0.1:57264
  2019-08-20 11:26:30.931 [DBG] WTWR: Received MsgCreateSession(blob_type=[FlagCommitOutputs|No-FlagReward], max_updates=1024 reward_base=0 reward_rate=0 sweep_fee_rate=2500) from WTCLIENT_PUBKEY@127.0.0.1:57264
  2019-08-20 11:26:30.968 [INF] WTWR: Accepted session for WTCLIENT_PUBKEY
  2019-08-20 11:26:30.968 [DBG] WTWR: Sending MsgCreateSessionReply(code=0) to WTCLIENT_PUBKEY@127.0.0.1:57264
  2019-08-20 11:26:30.981 [INF] WTWR: Releasing incoming peer WTCLIENT_PUBKEY@127.0.0.1:57264
  2019-08-20 11:27:27.260 [DBG] WTWR: Fetching block for (height=590941, hash=000000000000000000069b8d2739cb8736cc6a14927d760a7b7dfa47e1e5059e)
  2019-08-20 11:27:28.464 [DBG] WTWR: Scanning 3621 transaction in block (height=590941, hash=000000000000000000069b8d2739cb8736cc6a14927d760a7b7dfa47e1e5059e) for breaches
  2019-08-20 11:27:28.729 [DBG] WTWR: No breaches found in (height=590941, hash=000000000000000000069b8d2739cb8736cc6a14927d760a7b7dfa47e1e5059e)
  ```

### Tor Watchtower Kliens beállítás

* Szerkeszd az lnd.conf fájlt:

  `# nano /mnt/hdd/lnd/lnd.conf`

* Illeszd be a következő sorokat a fájl végére:

  ```text
  [Wtclient]
  wtclient.active=1
  ```

* Watchtower hozzáadása parancssorból \(egyszerre többet is hozzáadhatsz, egyenként\):

  ```text
  $ lncli wtclient add 02b745aa2c27881f2494978fe76494137f86fef6754e5fd19313670a5bc639ea82@xjyldrwmtxtutdqqhgvxvnykk4ophz6ygr3ci4gxnnt5wibl7k4g2vad.onion:9911
  ```

  * Egy teszt node adatai vannak előre kitöltve. A kapcsolódás üdvözölt, de nincs garancia arra, hogy ez a szolgáltatás folyamatosan elérhető marad.
  * Használd a korábban a `$ lncli tower info` parancsból feljegyzett `watchtower-pubkey`-t.
  * A host a watchtower .onion címe, amelyet korábban a `# cat /mnt/hdd/tor/lndWT9911/hostname` parancsból jegyeztél fel.
* Indítsd újra az lnd-t a systemctl segítségével:
`# systemctl restart lnd`
* Ellenőrizd, mely watchtower-ek figyelnek:
`$ lncli wtclient towers`

  Példa kimenet:

  ```text
    {
            "towers": [
                    {
                            "pubkey": "02b745aa2c27881f2494978fe76494137f86fef6754e5fd19313670a5bc639ea82",
                            "addresses": [
                                    "xjyldrwmtxtutdqqhgvxvnykk4ophz6ygr3ci4gxnnt5wibl7k4g2vad.onion:9911"
                            ],
                           "active_session_candidate": true,
                            "num_sessions": 0,
                            "sessions": []
                   }
            ]
    }
  ```

* A napló folyamatos szűrése \(kilépés: CTRL+C\):
  `# tail -f -n 10000 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log | grep WTCL`

  Példa kimenet a kliens oldalán:

  ```text
  2019-07-26 10:30:08.041 [INF] WTCL: Client stats: tasks(received=8 accepted=8 ineligible=0) sessions(acquired=0 exhausted=0)
  2019-07-26 10:30:34.105 [DBG] WTCL: Processing backup(8fd5d5dc97fc6e52da36bd527357a9c87f2a2529379f9f50241e35ab0c95c404, 6315)
  2019-07-26 10:30:34.106 [DBG] WTCL: SessionQueue(026d7b4f4fd7dcdb5a2acce00a8d1cca5bbaeb7e9d89a30ded7d4b62b7b50b3399) deciding to accept backup(8fd5d5dc97fc6e52da36bd527357a9c87f2a2529379f9f50241e35ab0c95c404, 6315) seqnum=0 pending=8 max-updates=1024
  2019-07-26 10:30:34.108 [INF] WTCL: Queued backup(8fd5d5dc97fc6e52da36bd527357a9c87f2a2529379f9f50241e35ab0c95c404, 6315) successfully for session 026d7b4f4fd7dcdb5a2acce00a8d1cca5bbaeb7e9d89a30ded7d4b62b7b50b3399
  2019-07-26 10:31:08.041 [INF] WTCL: Client stats: tasks(received=9 accepted=9 ineligible=0) sessions(acquired=0 exhausted=0)
  ```

## Inaktív tower-ek eltávolítása
* Futtasd a terminálban:
  ```
  for i in $(lncli wtclient towers | grep false -B 4 | grep pubkey | awk '{print $2}' | cut -d'"' -f2); do lncli wtclient remove $i; done
  ```

## További információk:

[https://github.com/lightningnetwork/lnd/blob/master/docs/watchtower.md](https://github.com/lightningnetwork/lnd/blob/master/docs/watchtower.md)

Legfrissebb lnd kiadási megjegyzések: [https://github.com/lightningnetwork/lnd/releases](https://github.com/lightningnetwork/lnd/releases)

[https://thebitcoinnews.com/watchtowers-are-coming-to-lightning/](https://thebitcoinnews.com/watchtowers-are-coming-to-lightning/)

[https://bitcoinops.org/en/newsletters/2019/06/19/](https://bitcoinops.org/en/newsletters/2019/06/19/)

Will O\`Beirne ebben a cikkben \(és a hozzá tartozó GitHub repóban\) bemutatja, hogyan lehet szabálysértéseket szimulálni és a watchtower reakcióit megfigyelni egy szimulált hálózaton: [https://medium.com/@wbobeirne/testing-out-watchtowers-with-a-simulated-breach-f1ad22c01112](https://medium.com/@wbobeirne/testing-out-watchtowers-with-a-simulated-breach-f1ad22c01112)

SLP83 Conner Fromknecht -- Bitcoin Lightning Watchtower-ek részletesen
podcast: [https://stephanlivera.com/episode/83](https://stephanlivera.com/episode/83)
átirat: [http://diyhpl.us/wiki/transcripts/stephan-livera-podcast/2019-06-24-conner-fromknecht-stephan-livera/](http://diyhpl.us/wiki/transcripts/stephan-livera-podcast/2019-06-24-conner-fromknecht-stephan-livera/)

Keress altruista watchtower-eket és oszd meg a sajátodat: [https://github.com/openoms/lightning-node-management/issues/4](https://github.com/openoms/lightning-node-management/issues/4)
