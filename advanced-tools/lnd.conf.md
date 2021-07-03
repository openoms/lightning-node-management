# Ejemplo lnd.conf

Basado en:

* [https://github.com/lightningnetwork/lnd/blob/master/sample-lnd.conf](https://github.com/lightningnetwork/lnd/blob/master/sample-lnd.conf)
* [https://github.com/alexbosworth/run-lnd\#install-lnd](https://github.com/alexbosworth/run-lnd#install-lnd)    
* [https://github.com/rootzoll/raspiblitz/blob/master/home.admin/assets/lnd.bitcoin.conf](https://github.com/rootzoll/raspiblitz/blob/master/home.admin/assets/lnd.bitcoin.conf)

Ruta para editar en RaspiBlitz:

```text
sudo nano /mnt/hdd/lnd/lnd.conf
```

```text
# Ejemplo de configuración para lnd.

[Application Options]
#################################
# Unique settings for each node #
#################################
# up to 32 UTF-8 characters
alias=ALIAS
# choose from: https://www.color-hex.com/
color=COLOR
# default fees for new channels (does not affect existing ones)
bitcoin.feerate=100
bitcoin.basefee=1
minchansize=1000000
accept-keysend=true
protocol.wumbo-channels=1
# Domain, could use https://freedns.afraid.org
# tlsextradomain=lightning.yourhost.com  

# RPC open to all connections on Port 10009
rpclisten=0.0.0.0:10009
# REST open to all connections on Port 8080
restlisten=0.0.0.0:8080
# not for Tor
nat=false
debuglevel=debug
maxpendingchannels=5
# to stop all incoming channels use:
# maxpendingchannels=0
# Set the maximum amount of commit fees in a channel
max-channel-fee-allocation=1.0
# Set the max timeout blocks of a payment
max-cltv-expiry=5000

#########################
# Improve startup speed #
#########################
# If true, we'll attempt to garbage collect canceled invoices upon start.
gc-canceled-invoices-on-startup=true
# If true, we'll delete newly canceled invoices on the fly.
gc-canceled-invoices-on-the-fly=true
# Avoid historical graph data sync
ignore-historical-gossip-filters=1
# Enable free list syncing for the default bbolt database. This will decrease
# start up time, but can result in performance degradation for very large
# databases, and also result in higher memory usage. If "free list corruption"
# is detected, then this flag may resolve things.
sync-freelist=true
# Avoid high startup overhead
# If true, will apply a randomized staggering between 0s and 30s when
# reconnecting to persistent peers on startup. The first 10 reconnections will be
# attempted instantly, regardless of the flag's value
stagger-initial-reconnect=true

#########################
# tls.cert improvements #
#########################
# Delete and recreate RPC TLS certificate when details change or cert expires
tlsautorefresh=1
# Do not include IPs in the RPC TLS certificate
tlsdisableautofill=1

##############################
# Optimise for cheap routes #
##############################
[routerrpc]
# Make sure that LND is the binary release or built with the routerrpc tag
# Set default chance of a hop success
routerrpc.apriorihopprob=0.5
# Start to ignore nodes if they return many failures (set to 1 to turn off)
routerrpc.aprioriweight=0.75
# Set minimum desired savings of trying a cheaper path
# The (virtual) fixed cost in sats of a failed payment attempt (default: 100)
routerrpc.attemptcost=10
# The (virtual) proportional cost in ppm of the total amount of a failed payment
# attempt (default: 1000)
routerrpc.attemptcostppm=10
# Set the number of historical routing records
routerrpc.maxmchistory=10000
# Set the min confidence in a path worth trying
routerrpc.minrtprob=0.005
# Set the time to forget past routing failures
routerrpc.penaltyhalflife=6h0m0s

########################
# Compact the database #
########################
# best to use on demand, can take several minutes
[bolt]
# Whether the databases used within lnd should automatically be compacted on
# every startup (and if the database has the configured minimum age). This is
# disabled by default because it requires additional disk space to be available
# during the compaction that is freed afterwards. In general compaction leads to
# smaller database files.
# db.bolt.auto-compact=true
# How long ago the last compaction of a database file must be for it to be
# considered for auto compaction again. Can be set to 0 to compact on every
# startup. (default: 168h)
# db.bolt.auto-compact-min-age=0

[Bitcoin]
bitcoin.active=1
bitcoin.node=bitcoind
# enable either testnet or mainnet
#bitcoin.testnet=1
bitcoin.mainnet=1

[Bitcoind]
bitcoind.rpcuser=RPC_USER
bitcoind.rpcpass=RPC_PASSWORD
bitcoind.rpchost=127.0.0.1
bitcoind.zmqpubrawblock=tcp://*:28332
bitcoind.zmqpubrawtx=tcp://*:28333
bitcoind.estimatemode=ECONOMICAL

[Wtclient]
wtclient.active=1

[Watchtower]
watchtower.active=1

[Tor]
tor.password=PASSWORD_B
```

Es necesario reiniciar LND para usar la nueva configuración.

```text
sudo systemctl restart lnd
```
