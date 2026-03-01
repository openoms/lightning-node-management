# Automatizált LND frissítési szkriptek a RaspiBlitz-hez

A legújabb hivatalos kiadásért és a hozzá tartozó megjegyzésekért lásd: [https://github.com/lightningnetwork/lnd/releases/](https://github.com/lightningnetwork/lnd/releases/)

**FIGYELMEZTETÉS minden főverziós frissítéshez: A migráció után az LND adatbázis csak az adott új verzióval és az annál újabbakkal lesz kompatibilis.**
Ez azt jelenti, hogy a frissítési szkriptet minden alkalommal futtatni kell, amikor egy tiszta RaspiBlitz SD-kártya képfájlt használunk az LND adatbázis eléréséhez.

## Biztonsági mentés

Frissítés előtt ajánlott teljes biztonsági mentést készíteni az LND könyvtárról.
**Ezt NEM szabad visszaállítani, miután az LND sikeresen újraindult!**

* Futtasd az alábbi sort a RaspiBlitz terminálban a beépített szkript használatához:

  ```bash
    $ /home/admin/config.scripts/lnd.rescue.sh backup
  ```

  Erről a folyamatról bővebb információ a [GYIK-ben](https://github.com/raspiblitz/raspiblitz/blob/dev/FAQ.md#2-making-a-complete-lnd-data-backup)

## [LND frissítése v0.18.0-beta verzióra](https://github.com/openoms/lightning-node-management/tree/en/lnd.updates/lnd.update.v0.18.0-beta.sh)

* Futtasd a RaspiBlitz terminálban:

  ```bash
    # download
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/en/lnd.updates/lnd.update.v0.18.0-beta.sh
    # look through the script
    cat lnd.update.v0.18.0-beta.sh
    # run
    bash lnd.update.v0.18.0-beta.sh
  ```

## [LND frissítése v0.17.4-beta verzióra](https://github.com/openoms/lightning-node-management/tree/en/lnd.updates/lnd.update.v0.17.4-beta.sh)

* Futtasd a RaspiBlitz terminálban:

  ```bash
    # download
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/en/lnd.updates/lnd.update.v0.17.4-beta.sh
    # look through the script
    cat lnd.update.v0.17.4-beta.sh
    # run
    bash lnd.update.v0.17.4-beta.sh
  ```

## [LND frissítése v0.16.4-beta verzióra](https://github.com/openoms/lightning-node-management/tree/en/lnd.updates/lnd.update.v0.16.4-beta.sh)

* Futtasd a RaspiBlitz terminálban:

  ```bash
    # download
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/en/lnd.updates/lnd.update.v0.16.4-beta.sh
    # look through the script
    cat lnd.update.v0.16.4-beta.sh
    # run
    bash lnd.update.v0.16.4-beta.sh
  ```

## [LND frissítése tetszőleges verzióra](https://github.com/openoms/lightning-node-management/tree/en/lnd.updates/lnd.update.sh)

* Futtasd a RaspiBlitz terminálban:

  ```bash
    # download
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/en/lnd.updates/lnd.update.sh
    # look through the script
    cat lnd.update.sh
    # run
    bash lnd.update.sh
  ```

* Minden alkalommal rákérdez a paraméterekre, majd ennek megfelelően tölti le és ellenőrzi a fájlokat:

  ```bash
    $ bash lnd.update.sh
    # Input the LND version to install (eg. '0.16.0-beta.rc1'):
    0.16.0-beta.rc1
    # Input the name of the signer (eg: 'roasbeef'):
    roasbeef
    # Input the PGP key fingerprint to check against (eg. 'E4D85299674B2D31FAA1892E372CBD7633C61696'):
    E4D85299674B2D31FAA1892E372CBD7633C61696
  ```

## [LND fordítása forráskódból](https://github.com/openoms/lightning-node-management/tree/en/lnd.updates/lnd.from.source.sh)

* Töltsd le és futtasd ezt a szkriptet a RaspiBlitz-en:

  ```bash
    # download
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.from.source.sh
    # inspect the script
    cat lnd.from.source.sh
    # run
    bash lnd.from.source.sh
  ```

* Rákérdez a checkout-olandó commit-ra. Válassz egy commit ID-t erről a listáról: [https://github.com/lightningnetwork/lnd/commits/master](https://github.com/lightningnetwork/lnd/commits/master)
