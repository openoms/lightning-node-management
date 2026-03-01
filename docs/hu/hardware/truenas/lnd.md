# LND
## Frissites
```
VERSION="v0.16.4-beta"
cd ~
wget https://github.com/lightningnetwork/lnd/releases/download/$VERSION/lnd-freebsd-amd64-$VERSION.tar.gz

# ellenorzes
curl https://raw.githubusercontent.com/lightningnetwork/lnd/master/scripts/keys/roasbeef.asc | gpg --import
wget https://github.com/lightningnetwork/lnd/releases/download/$VERSION/manifest-$VERSION.txt
wget https://github.com/lightningnetwork/lnd/releases/download/$VERSION/manifest-roasbeef-$VERSION.sig
gpg --verify manifest-roasbeef-$VERSION.sig manifest-$VERSION.txt
shasum -c manifest-$VERSION.txt --ignore-missing

tar -xvf lnd-freebsd-amd64*

service lnd stop
install -m 0755 -o root -g wheel ~/lnd-freebsd-amd64*/* /usr/local/bin
rm -r lnd-freebsd-amd64*

# teszt
lnd --configfile=/usr/local/etc/lnd.conf
# vagy futtatas az lnd felhasznaloval
su -m lnd -c 'lnd --configfile=/usr/local/etc/lnd.conf'

# szerviz inditasa
service lnd start

# logok
tail -f /var/db/lnd/logs/bitcoin/mainnet/lnd.log
```

## A channel.db merete
```
ls -hl /var/db/lnd/data/graph/mainnet/channel.db
```
## Automatikus feloldas
https://github.com/lightningnetwork/lnd/blob/master/docs/wallet.md
