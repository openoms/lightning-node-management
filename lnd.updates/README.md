## Automated LND update scripts for the RaspiBlitz and compatible systems
Check for the latest official release and notes: <https://github.com/lightningnetwork/lnd/releases/>

### [Update LND to v0.7.1-beta](lnd.update.v0.7.1-beta.sh)
* Download and run this script on the RaspiBlitz:  
`$ wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.update.v0.7.1-beta.sh && sudo bash lnd.update.v0.7.1-beta.sh`

### [Update LND to v0.8.0-beta-rc2](lnd.update.v0.8.0-beta-rc2.sh)

**WARNING: this is a major version update. After the migration the database will be only compatible with LND v0.8.0 and above.**

* Download and run this script on the RaspiBlitz:  

`$ wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.update.v0.8.0-beta-rc2.sh && sudo bash lnd.update.v0.8.0-beta-rc2.sh`

### [Build LND from source](lnd.from.source.sh)
* Download and run this script on the RaspiBlitz:  
    `$ wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.from.source.sh && sudo bash lnd.from.source.sh`

* Will ask for the commit to checkout from.  
Choose a commit ID from this list: https://github.com/lightningnetwork/lnd/commits/master