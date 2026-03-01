# Az LND adatbázis \(channel.db\) tömörítése

Az 1 GB-nál nagyobb `channel.db` fájl nem működik 32 bites rendszereken: [https://github.com/lightningnetwork/lnd/issues/4811](https://github.com/lightningnetwork/lnd/issues/4811)

```text
# a channel.db méretének ellenőrzése
sudo du -h /mnt/hdd/lnd/data/graph/mainnet/channel.db
# példa kimenet
# 1.0G    /mnt/hdd/lnd/data/graph/mainnet/channel.db
```

## Automatikus tömörítés újraindításkor

Az LND v0.12.0 óta beállítható a `db.bolt.auto-compact=true` az `lnd.conf`-ban.

* Szerkesztéshez:

  `sudo nano /mnt/hdd/lnd/lnd.conf`

* szúrd be az alábbiakat \(a megjegyzések elhagyhatók\):

  ```text
   [bolt]
   # Whether the databases used within lnd should automatically be compacted on
   # every startup (and if the database has the configured minimum age). This is
   # disabled by default because it requires additional disk space to be available
   # during the compaction that is freed afterwards. In general compaction leads to
   # smaller database files.
   db.bolt.auto-compact=true
   # How long ago the last compaction of a database file must be for it to be
   # considered for auto compaction again. Can be set to 0 to compact on every
   # startup. (default: 168h)
   # db.bolt.auto-compact-min-age=0
  ```

* indítsd újra az lnd-t:

  `sudo systemctl restart lnd`

* kövesd a folyamatot \(több percig is tarthat\):

  `sudo tail -fn 30 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log`

* érdemes lehet kikapcsolni az automatikus tömörítést az `lnd.conf`-ban, és csak igény szerint aktiválni, hogy elkerüld a hosszú indítási időket:

  ```text
   db.bolt.auto-compact=false
  ```

## Tömörítés a chantools eszközzel (Compaction with chantools)

[https://github.com/guggero/chantools\#compactdb](https://github.com/guggero/chantools#compactdb)

* Futtasd a következő parancsokat a RaspiBlitz terminálban

  Lásd a megjegyzéseket az egyes parancsok magyarázatához.

```text
# chantools telepítése
# letöltés, ellenőrzés és a telepítő script futtatása
wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/bonus.chantools.sh
cat bonus.chantools.sh
bash bonus.chantools.sh on

# lnd leállítása
sudo systemctl stop lnd

# váltás a bitcoin felhasználó könyvtárára
sudo su - bitcoin

# tömörítés futtatása
chantools compactdb --sourcedb /mnt/hdd/lnd/data/graph/mainnet/channel.db \
                --destdb /mnt/hdd/lnd/data/graph/mainnet/compacted.db

# a compacted.db méretének ellenőrzése
# (az első tömörítés hozza a legnagyobb eredményt)
du -h /mnt/hdd/lnd/data/graph/mainnet/compacted.db
# példa kimenet:
# 730M /mnt/hdd/lnd/data/graph/mainnet/compacted.db

# győződjünk meg róla, hogy az lnd nem fut (sudo szükséges)
exit
sudo systemctl stop lnd
sudo su - bitcoin

# az eredeti adatbázis biztonsági mentése
mv /mnt/hdd/lnd/data/graph/mainnet/channel.db \
   /mnt/hdd/lnd/data/graph/mainnet/uncompacted.db

# a tömörített adatbázis áthelyezése a régi helyére
mv /mnt/hdd/lnd/data/graph/mainnet/compacted.db \
   /mnt/hdd/lnd/data/graph/mainnet/channel.db

# kilépés a bitcoin felhasználóból admin-ra
exit

# lnd indítása
sudo systemctl start lnd

# tárca feloldása
lncli unlock
```

# A visszavonási napló megtisztítása
* elérhető az [LND v0.15.1](https://github.com/lightningnetwork/lnd/releases/tag/v0.15.1-beta) óta
* Nem helyettesíti az adatbázis tömörítést, és csak egyszer kell elvégezni az LND v0.15.1-re vagy újabbra való frissítés után

  ```text
  # a channel.db méretének ellenőrzése
  sudo du -h /mnt/hdd/lnd/data/graph/mainnet/channel.db
  # példa kimenet
  # 1.0G    /mnt/hdd/lnd/data/graph/mainnet/channel.db
  ```
## Raspiblitz vagy kompatibilis rendszeren:
* Szerkeszd a systemd szolgáltatást:
  ```
  sudo systemctl edit --full lnd
  ```

* Szerkeszd az `ExecStart=`-tal kezdődő sort így:
  ```
  ExecStart=/usr/local/bin/lnd --configfile=/home/bitcoin/.lnd/lnd.conf --db.prune-revocation
  ```
* CTRL+o, ENTER és CTRL+x a mentéshez, majd indítsd újra az LND-t:
  ```
  sudo systemctl restart lnd
  ```
* kövesd a folyamatot a naplókban:
  ```
  sudo tail -n 30 -f /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log
  ```
* jellemzően 30-60 percet vesz igénybe, hasonlóan a hosszú idő utáni tömörítéshez.
  ```
  Példa kimenet a visszavonási napló megtisztításakor:
  [INF] LTND: Version: 0.15.1-beta commit=v0.15.1-beta, build=production, logging=default, debuglevel=info
  [INF] LTND: Active chain: Bitcoin (network=mainnet)
  ...
  [INF] LTND: Opening the main database, this might take a few minutes...
  [INF] LTND: Opening bbolt database, sync_freelist=false, auto_compact=false
  [INF] LTND: Creating local graph and channel state DB instances
  [INF] CHDB: Checking for schema update: latest_version=29, db_version=27
  [INF] CHDB: Performing database schema migration
  [INF] CHDB: Applying migration #28
  [INF] CHDB: Creating top-level bucket: "chan-id-bucket" ...
  [INF] CHDB: Created top-level bucket: "chan-id-bucket"
  [INF] CHDB: Applying migration #29
  [INF] CHDB: Checking for optional update: prune_revocation_log=true, db_version=empty
  [INF] CHDB: Performing database optional migration: prune revocation log
  [INF] CHDB: Migrating revocation logs, might take a while...
  [INF] CHDB: Total logs=1358156, migrated=0
  ...
  [INF] CHDB: Migration progress: 76.366%, still have: 320989
  [INF] CHDB: Migration progress: 89.584%, still have: 141464
  [INF] CHDB: Migration progress: 97.048%, still have: 40095
  [INF] CHDB: Migrating old revocation logs finished, now checking the migration results...
  [INF] CHDB: Migration check passed, now deleting the old logs...
  [INF] CHDB: Old revocation log buckets removed!
  [INF] LTND: Database(s) now open (time_to_open=7m1.713662454s)!
  ```

* a megtisztítás befejezése után a node újra online lesz
* a megtisztított naplók eltávolításához és a channel.db méretének csökkentéséhez még egyszer tömörítést kell végezni

* példa kimenet a visszavonási napló megtisztítása utáni tömörítésről:
  ```
  [INF] CHDB: DB compaction of /home/bitcoin/.lnd/data/graph/mainnet/channel.db successful, 3726725120 -> 1219481600 bytes (gain=3.06x)
  [INF] CHDB: Swapping old DB file from /home/bitcoin/.lnd/data/graph/mainnet/temp-dont-use.db to /home/bitcoin/.lnd/data/graph/mainnet/channel.db
  ```
