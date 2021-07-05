# Automated LND update scripts for the RaspiBlitz

Check for the latest official release and notes: [https://github.com/lightningnetwork/lnd/releases/](https://github.com/lightningnetwork/lnd/releases/)

**WARNING for every major version update: After the migration the LND database will be only compatible with that new version and above.**  
This means that the update script needs to be run each time when a clean RaspiBlitz SDcard image is used to access the LND database.

## Backup

Before updating it is most recommended to make a full backup of the LND directory.  
**This is not be restored after LND is successfully restarted!**

* Run this line in the RaspiBlitz terminal to use the built-in script:

  ```bash
    $ /home/admin/config.scripts/lnd.rescue.sh backup
  ```

  More info about this process in the [FAQ](https://github.com/rootzoll/raspiblitz/blob/master/FAQ.md#2-making-a-complete-lnd-data-backup)

## [Update LND to a chosen version](https://github.com/openoms/lightning-node-management/tree/4d79ea41252f3fb2729aa9c2bd2be591b7c98299/lnd.updates/lnd.update.sh)

* Run in the RaspiBlitz terminal to use:

  ```bash
    # download
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.update.sh
    # look through the script
    cat lnd.update.sh
    # run
    bash lnd.update.sh
  ```

* asks about the parameters every time then downloads and verifies accordingly:

  ```bash
    $ bash lnd.update.sh
    # Input the LND version to install (eg. '0.12.1-beta.rc1'):
    0.12.1-beta.rc1
    # Input the name of the signer (eg: 'bitconner'):
    bitconner
    # Input the PGP key fingerprint to check against (eg. '9C8D61868A7C492003B2744EE7D737B67FA592C7'):
    9C8D61868A7C492003B2744EE7D737B67FA592C7
  ```

## [Update LND to v0.13.0-beta](https://github.com/openoms/lightning-node-management/blob/master/lnd.updates/lnd.update.v0.13.0-beta.sh)

* Run in the RaspiBlitz terminal to update:

  ```bash
    # download
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.update.v0.13.0-beta.sh
    # look through the script
    cat lnd.update.v0.13.0-beta.sh
    # run
    bash lnd.update.v0.13.0-beta.sh
  ```

## [Update LND to v0.12.1-beta](https://github.com/openoms/lightning-node-management/blob/master/lnd.updates/lnd.update.v0.12.1-beta.sh)

* Run in the RaspiBlitz terminal to update:

  ```bash
    # download
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.update.v0.12.1-beta.sh
    # look through the script
    cat lnd.update.v0.12.1-beta.sh
    # run
    bash lnd.update.v0.12.1-beta.sh
  ```

## [Update LND to v0.12.0-beta](https://github.com/openoms/lightning-node-management/blob/master/lnd.updates/lnd.update.v0.12.0-beta.sh)

* Run in the RaspiBlitz terminal to update:

  ```bash
    # download
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.update.v0.12.0-beta.sh
    # look through the script
    cat lnd.update.v0.12.0-beta.sh
    # run
    bash lnd.update.v0.12.0-beta.sh
  ```

## [Update LND to v0.11.1-beta](https://github.com/openoms/lightning-node-management/blob/master/lnd.updates/lnd.update.v0.11.1-beta.sh)

* Run in the RaspiBlitz terminal to update:

  ```bash
    # download
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.update.v0.11.1-beta.sh
    # look through the script
    cat lnd.update.v0.11.1-beta.sh
    # run
    bash lnd.update.v0.11.1-beta.sh
  ```

## [Update LND to v0.11.0-beta](https://github.com/openoms/lightning-node-management/blob/master/lnd.updates/lnd.update.v0.11.0-beta.sh)

* Run in the RaspiBlitz terminal to update:

  ```bash
    # download
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.update.v0.11.0-beta.sh
    # inspect the script
    cat lnd.update.v0.11.0-beta.sh
    # run
    bash lnd.update.v0.11.0-beta.sh
  ```

## [Build LND from the source](https://github.com/openoms/lightning-node-management/tree/4d79ea41252f3fb2729aa9c2bd2be591b7c98299/lnd.updates/lnd.from.source.sh)

* Download and run this script on the RaspiBlitz:

  ```bash
    # download
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.from.source.sh 
    # inspect the script
    cat lnd.update.v0.11.0-beta.sh
    # run
    bash lnd.from.source.sh
  ```

* Will ask for the commit to checkout from. Choose a commit ID from this list: [https://github.com/lightningnetwork/lnd/commits/master](https://github.com/lightningnetwork/lnd/commits/master)

