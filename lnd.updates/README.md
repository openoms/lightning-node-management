## Automated LND update scripts for the RaspiBlitz
Check for the latest official release and notes:
<https://github.com/lightningnetwork/lnd/releases/>

**WARNING for every major version update: After the migration
the LND database will be only compatible with that new version and above.**  
This means that the update script needs to be run each time when a
clean RaspiBlitz SDcard image is used to access the LND database.

### Backup
Before updating it is most recommended to make a full backup
of the LND directory.  
**This is not be restored after LND is successfully restarted!**

* Run this line in the RaspiBlitz terminal to use the built-in script:

    ```bash
    $ /home/admin/config.scripts/lnd.rescue.sh backup
    ```

    More info about this process in the
    [FAQ](https://github.com/rootzoll/raspiblitz/blob/master/FAQ.md#2-making-a-complete-lnd-data-backup)

### [Update LND to v0.9.2-beta](lnd.update.v0.9.2-beta.sh)

* Run this line in the RaspiBlitz terminal to update:  

    ```bash
    $ wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.update.v0.9.2-beta.sh && bash lnd.update.v0.9.2-beta.sh
    ```

### [Update LND to v0.9.0-beta](lnd.update.v0.9.0-beta.sh)

* Run this line in the RaspiBlitz terminal to update:  

    ```bash
    $ wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.update.v0.9.0-beta.sh && bash lnd.update.v0.9.0-beta.sh
    ```

### [Update LND to v0.8.2-beta](https://github.com/openoms/lightning-node-management/blob/master/lnd.updates/lnd.update.v0.8.2-beta.sh)
* Run this line in the RaspiBlitz terminal to update:  

    ```bash
    $ wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.update.v0.8.2-beta.sh && bash lnd.update.v0.8.2-beta.sh
    ```

### [Update LND to v0.8.0-beta](lnd.update.v0.8.0-beta.sh)

* Run this line in the RaspiBlitz terminal to update:  

    ```bash
    $ wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.update.v0.8.0-beta.sh && bash lnd.update.v0.8.0-beta.sh
    ```

### [Update LND to v0.7.1-beta](lnd.update.v0.7.1-beta.sh)

* Run this line in the RaspiBlitz terminal to update:

    ```bash
    $ wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.update.v0.7.1-beta.sh && bash lnd.update.v0.7.1-beta.sh
    ```

### [Build LND from source](lnd.from.source.sh)

* Download and run this script on the RaspiBlitz:  

    ```bash
    $ wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.from.source.sh && bash lnd.from.source.sh
    ```

* Will ask for the commit to checkout from.  
Choose a commit ID from this list:
<https://github.com/lightningnetwork/lnd/commits/master>