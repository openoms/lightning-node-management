# Az LND adatbazis \(channel.db\) tomoriteese

Az 1 GB-nal nagyobb `channel.db` fajl nem mukodik 32 bites rendszereken: [https://github.com/lightningnetwork/lnd/issues/4811](https://github.com/lightningnetwork/lnd/issues/4811)

```text
# a channel.db meretenek ellenorzese
sudo du -h /mnt/hdd/lnd/data/graph/mainnet/channel.db
# pelda kimenet
# 1.0G    /mnt/hdd/lnd/data/graph/mainnet/channel.db
```

## Automatikus tomorites ujrainditaskor

Az LND v0.12.0 ota beallithato a `db.bolt.auto-compact=true` az `lnd.conf`-ban.

* Szerkeszteshez:

  `sudo nano /mnt/hdd/lnd/lnd.conf`

* szurd be az alabbiakat \(a megjegyzesek elhagyhatok\):

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

* inditsd ujra az lnd-t:

  `sudo systemctl restart lnd`

* kovessed a folyamatot \(tobb percig is tarthat\):

  `sudo tail -fn 30 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log`

* erdemes lehet kikapcsolni az automatikus tomoriteest az `lnd.conf`-ban, es csak igenyu szerint aktivalni, hogy elkeruldd a hosszu inditasi idoket:

  ```text
   db.bolt.auto-compact=false
  ```

## Tomorites a Channels Tools-szal

[https://github.com/guggero/chantools\#compactdb](https://github.com/guggero/chantools#compactdb)

* Futtasd a kovetkezo parancsokat a RaspiBlitz terminalban

  Lasd a megjegyzeseket az egyes parancsok magyarazatahoz.

```text
# chantools telepitese
# letoltes, ellenorzes es a telepito script futtatasa
wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/bonus.chantools.sh
cat bonus.chantools.sh
bash bonus.chantools.sh on

# lnd leallitasa
sudo systemctl stop lnd

# valtas a bitcoin felhasznalo konyvtarara
sudo su - bitcoin

# tomorites futtatasa
chantools compactdb --sourcedb /mnt/hdd/lnd/data/graph/mainnet/channel.db \
                --destdb /mnt/hdd/lnd/data/graph/mainnet/compacted.db

# a compacted.db meretenek ellenorzese
# (az elso tomorites hozza a legnagyobb eredmenyt)
du -h /mnt/hdd/lnd/data/graph/mainnet/compacted.db
# pelda kimenet:
# 730M /mnt/hdd/lnd/data/graph/mainnet/compacted.db

# gyozodjunk meg rola, hogy az lnd nem fut (sudo szukseges)
exit
sudo systemctl stop lnd
sudo su - bitcoin

# az eredeti adatbazis biztonsagi mentese
mv /mnt/hdd/lnd/data/graph/mainnet/channel.db \
   /mnt/hdd/lnd/data/graph/mainnet/uncompacted.db

# a tomoritett adatbazis athelyezese a regi helyere
mv /mnt/hdd/lnd/data/graph/mainnet/compacted.db \
   /mnt/hdd/lnd/data/graph/mainnet/channel.db

# kilepes a bitcoin felhasznalobol admin-ra
exit

# lnd inditasa
sudo systemctl start lnd

# tarca feloldasa
lncli unlock
```

# A visszavonasi naplo megtisztitasa
* elerheto az [LND v0.15.1](https://github.com/lightningnetwork/lnd/releases/tag/v0.15.1-beta) ota
* Nem helyettesiti az adatbazis tomoriteest, es csak egyszer kell elvegezni az LND v0.15.1-re vagy ujabbra valo frissites utan

  ```text
  # a channel.db meretenek ellenorzese
  sudo du -h /mnt/hdd/lnd/data/graph/mainnet/channel.db
  # pelda kimenet
  # 1.0G    /mnt/hdd/lnd/data/graph/mainnet/channel.db
  ```
## Raspiblitz vagy kompatibilis rendszeren:
* Szerkeszd a systemd szolgaltatast:
  ```
  sudo systemctl edit --full lnd
  ```

* Szerkeszd az `ExecStart=`-tal kezdodo sort igy:
  ```
  ExecStart=/usr/local/bin/lnd --configfile=/home/bitcoin/.lnd/lnd.conf --db.prune-revocation
  ```
* CTRL+o, ENTER es CTRL+x a menteshez, majd inditsd ujra az LND-t:
  ```
  sudo systemctl restart lnd
  ```
* kovessed a folyamatot a napliokban:
  ```
  sudo tail -n 30 -f /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log
  ```
* jellemzoen 30-60 percet vesz igenybe, hasonloan a hosszu ido utani tomoriteshez.
  ```
  Pelda kimenet a visszavonasi naplo megtisztitasakor:
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

* a megtisztitas befejezese utan a node ujra online lesz
* a megtisztitott naplok eltavolitasahoz es a channel.db meretenek csokkenteesehez meg egyszer tomoriteest kell vegezni

* pelda kimenet a visszavonasi naplo megtisztitasa utani tomoritesrol:
  ```
  [INF] CHDB: DB compaction of /home/bitcoin/.lnd/data/graph/mainnet/channel.db successful, 3726725120 -> 1219481600 bytes (gain=3.06x)
  [INF] CHDB: Swapping old DB file from /home/bitcoin/.lnd/data/graph/mainnet/temp-dont-use.db to /home/bitcoin/.lnd/data/graph/mainnet/channel.db
  ```
