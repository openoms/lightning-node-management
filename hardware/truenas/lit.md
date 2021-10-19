# Lightning Terminal on FreeBSD

https://github.com/lightninglabs/lightning-terminal/blob/master/doc/compile.md

# Install

```
pkg install -y gmake git go node14 yarn-node14 python2
setenv GOROOT /usr/local/go
mkdir ~/.gopkg
setenv GOPATH /root/.gopkg
fetch https://github.com/lightninglabs/lightning-terminal/archive/refs/tags/v0.5.2-alpha.tar.gz
tar -xvf v0.5.2-alpha.tar.gz
cd lightning-terminal-0.5.2-alpha
gmake install
cd
rm -r lightning-terminal-0.5.2-alpha
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
remote.lit-debuglevel=debug

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