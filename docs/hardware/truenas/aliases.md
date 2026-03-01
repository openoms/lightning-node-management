# Example aliases on the TrueNAS node

* install and switch to the `bash` terminal:
```
pkg install bash
bash
```
* aliases:
```
#lnd
alias lncli="lncli -lnddir=/var/db/lnd"
alias lndlog="tail -f /var/db/lnd/logs/bitcoin/mainnet/lnd.log"
alias lndconf="nano /usr/local/etc/lnd.conf"

#bitcoind
alias bitcoin-cli="bitcoin-cli -datadir=/var/db/bitcoin"
alias bitcoinlog="tail -f /var/db/bitcoin/debug.log"
alias bitcoinconf="nano /var/db/bitcoin/bitcoin.conf"

#suez
alias suez="cd suez && /root/.local/bin/poetry run ./suez --client-args=--lnddir=/var/db/lnd"
```