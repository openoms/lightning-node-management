## Automated LND update scripts for the RaspiBlitz
Check for the latest official release and notes:
<https://github.com/lightningnetwork/lnd/releases/>

### Backup
Before updating it is most recommended to make a full backup
of the LND directory.  
**This is not be restored after LND is successfully restarted!**
* Run this line in the RaspiBlitz terminal to use the built-in script:

    `$ /home/admin/config.scripts/lnd.rescue.sh backup`

    More info about this process in the
    [FAQ](https://github.com/rootzoll/raspiblitz/blob/master/FAQ.md#2-making-a-complete-lnd-data-backup)

### [Update LND to v0.8.0-beta](lnd.update.v0.8.0-beta.sh)

**WARNING: this is a major version update. After the migration
the database will be only compatible with LND v0.8.0 and above.**  
This means that the update scripts needs to be run each time a
clean RaspiBlitz v1.3 SDcard image is used.

* Run this line in the RaspiBlitz terminal to update:  

    `$ wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.update.v0.8.0-beta.sh && bash lnd.update.v0.8.0-beta.sh`

### [Update LND to v0.7.1-beta](lnd.update.v0.7.1-beta.sh)

* Run this line in the RaspiBlitz terminal to update:

    `$ wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.update.v0.7.1-beta.sh && bash lnd.update.v0.7.1-beta.sh`



### [Build LND from source](lnd.from.source.sh)
* Download and run this script on the RaspiBlitz:  
    `$ wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.from.source.sh && bash lnd.from.source.sh`

* Will ask for the commit to checkout from.  
Choose a commit ID from this list:
<https://github.com/lightningnetwork/lnd/commits/master>