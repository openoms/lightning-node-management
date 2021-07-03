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

