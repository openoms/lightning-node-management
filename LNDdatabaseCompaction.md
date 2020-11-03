## Compact the LND database (channel.db)

https://github.com/guggero/chantools#compactdb

* Run the following commands in the RaspiBlitz terminal  
  See the comments for what each command does.
```
# install Go
/home/admin/config.scripts/bonus.go.sh on

# stop lnd
sudo systemctl stop lnd

# change to the user: bitcoin
sudo su bitcoin

# get the Go paths
source /etc/profile

# download and install chantools from source
git clone https://github.com/guggero/chantools.git
cd chantools

# specify the 32 bit environment for make install
CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=7 make install

# set PATH for the user (include in ~/.bashrc to make persist for the next login)
PATH=$PATH:/home/bitcoin/go/bin/

# run the compacting
chantools compactdb --sourcedb /mnt/hdd/lnd/data/graph/mainnet/channel.db \
	    	    --destdb /mnt/hdd/lnd/data/graph/mainnet/compacted.db

# make sure lnd is not runnning
sudo systemctl stop lnd

# backup the original database
mv /mnt/hdd/lnd/data/graph/mainnet/channel.db \
   /mnt/hdd/lnd/data/graph/mainnet/uncompacted.db   

# move the compacted database in place of the old
mv /mnt/hdd/lnd/data/graph/mainnet/compacted.db \
   /mnt/hdd/lnd/data/graph/mainnet/channel.db  

# start lnd
sudo systemctl start lnd

# unlock the database
lncli unlock
```
