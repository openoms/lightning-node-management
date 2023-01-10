# Lightning Terminal on FreeBSD

https://github.com/lightninglabs/lightning-terminal/blob/master/doc/compile.md

# Install

```
bash
VERSION=$VERSION
pkg install -y gmake git node14 yarn-node14 python2

# Go
wget https://go.dev/dl/go1.18.8.freebsd-amd64.tar.gz
tar -xvf go1.18.8.freebsd-amd64.tar.gz
rm /usr/local/go
mv go /usr/local
mkdir ~/.gopkg
export GOROOT=/usr/local/go
export GOPATH=/root/.gopkg
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

mkdir lightning-terminal-source-$VERSION
cd lightning-terminal-source-$VERSION
wget -O lightning-terminal-source-$VERSION.tar.gz https://github.com/lightninglabs/lightning-terminal/releases/download/$VERSION/lightning-terminal-source-$VERSION.tar.gz

# verify
gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 26984CB69EB8C4A26196F7A4D7D916376026F177
wget -O manifest-$VERSION.txt https://github.com/lightninglabs/lightning-terminal/releases/download/$VERSION/manifest-$VERSION.txt
wget -O manifest-$VERSION.sig https://github.com/lightninglabs/lightning-terminal/releases/download/$VERSION/manifest-$VERSION.sig
gpg --verify manifest-$VERSION.sig manifest-$VERSION.txt
shasum -a 256 -c manifest-$VERSION.txt --ignore-missing

gmake install

ln -s /root/.gopkg/bin/litd /root/go/bin/
ln -s /root/.gopkg/bin/litcli /root/go/bin/

service litd start
service litd status

cd
rm -r lightning-terminal-source-$VERSION
```

## Config file
adapted from the RaspiBlitz (same setup with separate LND):

```
nano /root/.lit/lit.conf

```
```
# Takes:
UIPASSWORD=
RPCUSER=
RPCPASSWORD=
```
```
# Application Options
httpslisten=0.0.0.0:8443
uipassword=$UIPASSWORD
#lit-dir=/home/lit/.lit

# Remote options
remote.lit-debuglevel=info

# Remote lnd options
remote.lnd.rpcserver=127.0.0.1:10009
remote.lnd.macaroonpath=/var/db/lnd/data/chain/bitcoin/mainnet/admin.macaroon
remote.lnd.tlscertpath=/var/db/lnd/tls.cert

# Loop
loop.loopoutmaxparts=5
loop.server.proxy=127.0.0.1:9050

# Pool
pool.newnodesonly=true
pool.proxy=127.0.0.1:9050

# Faraday
faraday.min_monitored=48h

# Faraday - bitcoin
faraday.connect_bitcoin=true
faraday.bitcoin.host=localhost
faraday.bitcoin.user=$RPCUSER
faraday.bitcoin.password=$RPCPASSWORD
```

## Service file

```
nano /usr/local/etc/rc.d/litd
```

```
#!/bin/sh
#
# PROVIDE: litd
# REQUIRE: bitcoind tor lnd
# KEYWORD:

. /etc/rc.subr

name="litd"
rcvar="litd_enable"

litd_command="/root/go/bin/litd"
pidfile="/var/run/${name}.pid"
command="/usr/sbin/daemon"
command_args="-P ${pidfile} -r -f ${litd_command}"

load_rc_config $name
: ${litd_enable:=no}

run_rc_command "$1"
```

## Tor Hidden Service
* Create in:
  ```
  nano /usr/local/etc/tor/torrc
  ```
  ```
  HiddenServiceDir /var/db/tor/litd
  HiddenServiceVersion 3
  HiddenServicePort 443 127.0.0.1:8443
  ```
* reload Tor
  ```
  service tor reload
  ```
* read the Hidden Service
  ```
  cat /var/db/tor/litd/hostname
  ```
* Tor logs
  ```
  tail -f /var/log/tor/tor.log
  ```

## Start
```
service litd enable
service litd start
```

## Logs
```
tail -f .lit/logs/mainnet/litd.log
```

Log in to the webUI at:
```
https://JAIL_LOCAL_IP:8443
```

## Update
```
bash
# check the latest version at https://github.com/lightninglabs/lightning-terminal/releases
VERSION=$VERSION
# upgrade all packages
pkg update
pkg upgrade -y

# Go
wget https://go.dev/dl/go1.18.8.freebsd-amd64.tar.gz
tar -xvf go1.18.8.freebsd-amd64.tar.gz
rm /usr/local/go
mv go /usr/local
export GOROOT=/usr/local/go
mkdir ~/.gopkg
export GOPATH=/root/.gopkg
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

mkdir lightning-terminal-source-$VERSION
cd lightning-terminal-source-$VERSION
wget -O lightning-terminal-source-$VERSION.tar.gz https://github.com/lightninglabs/lightning-terminal/releases/download/$VERSION/lightning-terminal-source-$VERSION.tar.gz

# verify
gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 26984CB69EB8C4A26196F7A4D7D916376026F177
wget -O manifest-$VERSION.txt https://github.com/lightninglabs/lightning-terminal/releases/download/$VERSION/manifest-$VERSION.txt
wget -O manifest-$VERSION.sig https://github.com/lightninglabs/lightning-terminal/releases/download/$VERSION/manifest-$VERSION.sig
gpg --verify manifest-$VERSION.sig manifest-$VERSION.txt
shasum -a 256 -c manifest-$VERSION.txt --ignore-missing

tar -xvf lightning-terminal-source-$VERSION.tar.gz
service litd stop
rm /root/go/bin/lit*
rm /root/.gopkg/bin/lit*
gmake install

ln -s /root/.gopkg/bin/litd /root/go/bin/
ln -s /root/.gopkg/bin/litcli /root/go/bin/

service litd start
service litd status

cd
rm -r lightning-terminal-source-$VERSION
```

The binary will be installed in:
```
/root/go/bin/litd
```
or in
```
/root/.gopkg/bin/
```

In the second case create symlinks:
```
ln -s /root/.gopkg/bin/litd /root/go/bin/
ln -s /root/.gopkg/bin/litcli /root/go/bin/
```