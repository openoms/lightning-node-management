# Automated LND update scripts for the RaspiBlitz

Check for the latest official release and notes: [https://github.com/lightningnetwork/lnd/releases/](https://github.com/lightningnetwork/lnd/releases/)

**WARNING for every major version update: After the migration the LND database will be only compatible with that new version and above.**  
This means that the update script needs to be run each time when a clean RaspiBlitz SDcard image is used to access the LND database.

## Backup

Before updating it is recommended to make a full backup of the LND directory.  
**This is not to be restored after LND is successfully restarted!**

* Run this line in the RaspiBlitz terminal to use the built-in script:

  ```bash
    $ /home/admin/config.scripts/lnd.rescue.sh backup
  ```

  More info about this process in the [FAQ](https://github.com/raspiblitz/raspiblitz/blob/dev/FAQ.md#2-making-a-complete-lnd-data-backup)

## [Update LND to v0.18.0-beta](https://github.com/openoms/lightning-node-management/tree/en/lnd.updates/lnd.update.v0.18.0-beta.sh)

* Run in the RaspiBlitz terminal to use:

  ```bash
    # download
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/en/lnd.updates/lnd.update.v0.18.0-beta.sh
    # look through the script
    cat lnd.update.v0.18.0-beta.sh
    # run
    bash lnd.update.v0.18.0-beta.sh
  ```

## [Update LND to v0.17.4-beta](https://github.com/openoms/lightning-node-management/tree/en/lnd.updates/lnd.update.v0.17.4-beta.sh)

* Run in the RaspiBlitz terminal to use:

  ```bash
    # download
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/en/lnd.updates/lnd.update.v0.17.4-beta.sh
    # look through the script
    cat lnd.update.v0.17.4-beta.sh
    # run
    bash lnd.update.v0.17.4-beta.sh
  ```

## [Update LND to v0.16.4-beta](https://github.com/openoms/lightning-node-management/tree/en/lnd.updates/lnd.update.v0.16.4-beta.sh)

* Run in the RaspiBlitz terminal to use:

  ```bash
    # download
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/en/lnd.updates/lnd.update.v0.16.4-beta.sh
    # look through the script
    cat lnd.update.v0.16.4-beta.sh
    # run
    bash lnd.update.v0.16.4-beta.sh
  ```

## [Update LND to a chosen version](https://github.com/openoms/lightning-node-management/tree/en/lnd.updates/lnd.update.sh)

* Run in the RaspiBlitz terminal to use:

  ```bash
    # download
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/en/lnd.updates/lnd.update.sh
    # look through the script
    cat lnd.update.sh
    # run
    bash lnd.update.sh
  ```

* asks about the parameters every time then downloads and verifies accordingly:

  ```bash
    $ bash lnd.update.sh
    # Input the LND version to install (eg. '0.16.0-beta.rc1'):
    0.16.0-beta.rc1
    # Input the name of the signer (eg: 'roasbeef'):
    roasbeef
    # Input the PGP key fingerprint to check against (eg. 'E4D85299674B2D31FAA1892E372CBD7633C61696'):
    E4D85299674B2D31FAA1892E372CBD7633C61696
  ```

## [Build LND from the source](https://github.com/openoms/lightning-node-management/tree/en/lnd.updates/lnd.from.source.sh)

* Download and run this script on the RaspiBlitz:

  ```bash
    # download
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.from.source.sh
    # inspect the script
    cat lnd.from.source.sh
    # run
    bash lnd.from.source.sh
  ```

* Will ask for the commit to checkout from. Choose a commit ID from this list: [https://github.com/lightningnetwork/lnd/commits/master](https://github.com/lightningnetwork/lnd/commits/master)
