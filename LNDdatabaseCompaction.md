## Compact the LND database (channel.db)

https://github.com/guggero/chantools#compactdb

* Run the following commands in the RaspiBlitz terminal  
  See the comments for what each command does.

```
# check the size of channel.db
sudo du -h /mnt/hdd/lnd/data/graph/mainnet/channel.db
# example output (over 1GB started to cause issues)
# 1.0G	/mnt/hdd/lnd/data/graph/mainnet/channel.db

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
