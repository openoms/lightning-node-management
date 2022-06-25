# LND
## Update
```
VERSION="v0.15.0-beta"
cd ~
wget https://github.com/lightningnetwork/lnd/releases/download/$VERSION/lnd-freebsd-amd64-$VERSION.tar.gz
tar -xvf lnd-freebsd-amd64*
service lnd stop
install -m 0755 -o root -g wheel ~/lnd-freebsd-amd64*/* /usr/local/bin
rm -r lnd-freebsd-amd64*
service lnd start
tail -f /var/db/lnd/logs/bitcoin/mainnet/lnd.log
```

## Check the size of the channel.db
```
ls -hl /var/db/lnd/data/graph/mainnet/channel.db
```
## Autounlock
https://github.com/lightningnetwork/lnd/blob/master/docs/wallet.md

