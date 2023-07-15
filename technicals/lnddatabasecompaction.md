# Compact the LND database \(channel.db\)

An over 1GB `channel.db` file does not work on 32bit systems: [https://github.com/lightningnetwork/lnd/issues/4811](https://github.com/lightningnetwork/lnd/issues/4811)

```text
# check the size of channel.db
sudo du -h /mnt/hdd/lnd/data/graph/mainnet/channel.db
# example output
# 1.0G    /mnt/hdd/lnd/data/graph/mainnet/channel.db
```

## Auto-compact on restart

Since LND v0.12.0 can set `db.bolt.auto-compact=true` in the `lnd.conf`.

* To edit:

  `sudo nano /mnt/hdd/lnd/lnd.conf`

* insert the following \(can leave out the comments\):

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

* restart lnd:

  `sudo systemctl restart lnd`

* monitor the process \(can take several minutes\):

  `sudo tail -fn 30 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log`

* might want to disable the auto-compact in `lnd.conf` and only activate on-demand to avoid long startup times:

  ```text
   db.bolt.auto-compact=false
  ```

## Compacting with Channels Tools

[https://github.com/guggero/chantools\#compactdb](https://github.com/guggero/chantools#compactdb)

* Run the following commands in the RaspiBlitz terminal

  See the comments for what each command does.

```text
# install chantools
# download, inspect and run the install script
wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/bonus.chantools.sh
cat bonus.chantools.sh
bash bonus.chantools.sh on

# stop lnd
sudo systemctl stop lnd

# change to the home directory of the bitcoin user
sudo su - bitcoin

# run the compacting
chantools compactdb --sourcedb /mnt/hdd/lnd/data/graph/mainnet/channel.db \
                --destdb /mnt/hdd/lnd/data/graph/mainnet/compacted.db

# check the size of the compacted.db
# (the first compacting will have the biggest effect)
du -h /mnt/hdd/lnd/data/graph/mainnet/compacted.db
# example output:
# 730M /mnt/hdd/lnd/data/graph/mainnet/compacted.db

# make sure lnd is not runnning (needs sudo)
exit
sudo systemctl stop lnd
sudo su - bitcoin

# backup the original database
mv /mnt/hdd/lnd/data/graph/mainnet/channel.db \
   /mnt/hdd/lnd/data/graph/mainnet/uncompacted.db

# move the compacted database in place of the old
mv /mnt/hdd/lnd/data/graph/mainnet/compacted.db \
   /mnt/hdd/lnd/data/graph/mainnet/channel.db

# exit the bitcoin user to admin
exit

# start lnd
sudo systemctl start lnd

# unlock the wallet
lncli unlock
```

# Prune the revocation logs
* available since [LND v0.15.1](https://github.com/lightningnetwork/lnd/releases/tag/v0.15.1-beta)
* Does not replace the database compacting and needs to be done only once after updating to LND v0.15.1 and above

  ```text
  # check the size of channel.db
  sudo du -h /mnt/hdd/lnd/data/graph/mainnet/channel.db
  # example output
  # 1.0G    /mnt/hdd/lnd/data/graph/mainnet/channel.db
  ```
## On a Raspiblitz or compatible system:
* Edit the systemd service:
  ```
  sudo systemctl edit --full lnd
  ```

* Edit the line starting with `ExecStart=` so it looks like:
  ```
  ExecStart=/usr/local/bin/lnd --configfile=/home/bitcoin/.lnd/lnd.conf --db.prune-revocation
  ```
* CTRL+o, ENTER and CTRL+x to save then restart LND:
  ```
  sudo systemctl restart lnd
  ```
* monitor the process in the logs:
  ```
  sudo tail -n 30 -f /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log
  ```
* can take 30-60 mins typically similar to compacting after a long time.
  ```
  Example output when pruning the revocation logs:
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

* after the pruning has finished the node comes back online
* will need to compact once again to remove the pruned logs and reduce the size of the channel.db

* example output of the compaction after pruning the revocation logs:
  ```
  [INF] CHDB: DB compaction of /home/bitcoin/.lnd/data/graph/mainnet/channel.db successful, 3726725120 -> 1219481600 bytes (gain=3.06x)
  [INF] CHDB: Swapping old DB file from /home/bitcoin/.lnd/data/graph/mainnet/temp-dont-use.db to /home/bitcoin/.lnd/data/graph/mainnet/channel.db
  ```
