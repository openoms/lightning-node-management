# Lightning Terminal on FreeBSD

https://github.com/lightninglabs/lightning-terminal/blob/master/doc/compile.md

# Install

```
bash
VERSION=v0.6.1-alpha
pkg install -y gmake git go node14 yarn-node14 python2
export GOROOT=/usr/local/go
mkdir ~/.gopkg
export GOPATH=/root/.gopkg
fetch https://github.com/lightninglabs/lightning-terminal/archive/refs/tags/$VERSION.tar.gz
tar -xvf $VERSION.tar.gz
cd lightning-terminal-${VERSION:1}
gmake install
cd
rm -r lightning-terminal-${VERSION:1}
```

The binary will be installed in:
```
/root/go/bin/litd
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

```
HiddenServiceDir /var/db/tor/litd
HiddenServiceVersion 3
HiddenServicePort 443 127.0.0.1:8443
```
* read the Hidden Service
```
cat /var/db/tor/litd/hostname
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
# check the lates version at https://github.com/lightninglabs/lightning-terminal/releases
VERSION=v0.7.0-alpha
# upgrade all packages
pkg update
pkg upgrade -y
# symlink the current go version dir
ln -s /usr/local/go118 /usr/local/go
export GOROOT=/usr/local/go
mkdir ~/.gopkg
export GOPATH=/root/.gopkg
fetch https://github.com/lightninglabs/lightning-terminal/archive/refs/tags/$VERSION.tar.gz
tar -xvf $VERSION.tar.gz
cd lightning-terminal-${VERSION:1}
service litd stop
rm /root/go/bin/lit*
rm /root/.gopkg/bin/lit*
gmake install

ln -s /root/.gopkg/bin/litd /root/go/bin/
ln -s /root/.gopkg/bin/litcli /root/go/bin/

service litd start

cd
rm -r lightning-terminal-${VERSION:1}
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