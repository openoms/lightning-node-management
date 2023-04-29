# LND
## Update
```
VERSION="v0.16.2-beta"
cd ~
wget https://github.com/lightningnetwork/lnd/releases/download/$VERSION/lnd-freebsd-amd64-$VERSION.tar.gz

# verify
curl https://raw.githubusercontent.com/lightningnetwork/lnd/master/scripts/keys/roasbeef.asc | gpg --import
wget https://github.com/lightningnetwork/lnd/releases/download/$VERSION/manifest-$VERSION.txt
wget https://github.com/lightningnetwork/lnd/releases/download/$VERSION/manifest-roasbeef-$VERSION.sig
gpg --verify manifest-roasbeef-$VERSION.sig manifest-$VERSION.txt
shasum -c manifest-$VERSION.txt --ignore-missing

tar -xvf lnd-freebsd-amd64*

service lnd stop
install -m 0755 -o root -g wheel ~/lnd-freebsd-amd64*/* /usr/local/bin
rm -r lnd-freebsd-amd64*

# test
lnd --configfile=/usr/local/etc/lnd.conf
# or to run with the lnd user
su -m lnd -c 'lnd --configfile=/usr/local/etc/lnd.conf'

# start service
service lnd start

# logs
tail -f /var/db/lnd/logs/bitcoin/mainnet/lnd.log
```

## Check the size of the channel.db
```
ls -hl /var/db/lnd/data/graph/mainnet/channel.db
```
## Autounlock
https://github.com/lightningnetwork/lnd/blob/master/docs/wallet.md
