# Scripts de actualización automatizada de LND para RaspiBlitz

Verifique la versión y notas oficiales más recientes en: [https://github.com/lightningnetwork/lnd/releases/](https://github.com/lightningnetwork/lnd/releases/)

** ADVERTENCIA para cada actualización de la versión principal: después de la migración la base de datos LND solo será compatible con esa nueva versión y/o superior.**
Esto significa que el script de actualización debe ejecutarse cada vez que se utiliza una imagen RaspiBlitz desde cero para acceder a la base de datos LND.

## Backup

Antes de actualizar, se recomienda realizar una copia de seguridad completa del directorio LND.
**¡No restaurará después de que LND se reinicie con éxito!**

* Ejecute lo siguiente en la terminal RaspiBlitz :

  ```bash
    $ /home/admin/config.scripts/lnd.rescue.sh backup
  ```

  Más información sobre este proceso en las [preguntas frecuentes](https://github.com/rootzoll/raspiblitz/blob/master/FAQ.md#2-making-a-complete-lnd-data-backup)

## [Actualice LND a una versión especifica](https://github.com/openoms/lightning-node-management/tree/4d79ea41252f3fb2729aa9c2bd2be591b7c98299/lnd.updates/lnd.update.sh)

* Para usar, ejecute en la terminal RaspiBlitz lo siguiente:

  ```bash
    # descargar
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.update.sh
    # revisar el script
    cat lnd.update.sh
    # ejecutar
    bash lnd.update.sh
  ```

* consulte los parámetros cada vez, luego descargue y verifique:

  ```bash
    $ bash lnd.update.sh
    # Input the LND version to install (eg. '0.12.1-beta.rc1'):
    0.12.1-beta.rc1
    # Input the name of the signer (eg: 'bitconner'):
    bitconner
    # Input the PGP key fingerprint to check against (eg. '9C8D61868A7C492003B2744EE7D737B67FA592C7'):
    9C8D61868A7C492003B2744EE7D737B67FA592C7
  ```

  \*\*\*\*[**Actualice LND a v0.12.1-beta**](https://github.com/openoms/lightning-node-management/tree/4d79ea41252f3fb2729aa9c2bd2be591b7c98299/lnd.updates/lnd.update.v0.12.1-beta.sh)\*\*\*\*

* Para actualizar, ejecute en la terminal RaspiBlitz lo siguiente:

  ```bash
    # descargar
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.update.v0.12.1-beta.sh
    # revisar el script
    cat lnd.update.v0.12.1-beta.sh
    # ejecutar
    bash lnd.update.v0.12.1-beta.sh
  ```

  \*\*\*\*[**Actualice LND a v0.12.0-beta**](https://github.com/openoms/lightning-node-management/tree/4d79ea41252f3fb2729aa9c2bd2be591b7c98299/lnd.updates/lnd.update.v0.12.0-beta.sh)\*\*\*\*

* Para actualizar, ejecute en la terminal RaspiBlitz lo siguiente:

  ```bash
    # descargar
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.update.v0.12.0-beta.sh
    # revisar el script
    cat lnd.update.v0.12.0-beta.sh
    # ejecutar
    bash lnd.update.v0.12.0-beta.sh
  ```

  \*\*\*\*[**Actualice LND a v0.11.1-beta**](https://github.com/openoms/lightning-node-management/tree/4d79ea41252f3fb2729aa9c2bd2be591b7c98299/lnd.updates/lnd.update.v0.11.1-beta.sh)\*\*\*\*

* Para actualizar, ejecute en la terminal RaspiBlitz lo siguiente:

  ```bash
    # descargar
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.update.v0.11.1-beta.sh
    # revisar el script
    cat lnd.update.v0.11.1-beta.sh
    # ejecutar
    bash lnd.update.v0.11.1-beta.sh
  ```

## [Actualice LND a v0.11.0-beta](https://github.com/openoms/lightning-node-management/tree/4d79ea41252f3fb2729aa9c2bd2be591b7c98299/lnd.updates/lnd.update.v0.11.0-beta.sh)

* Para actualizar, ejecute en la terminal RaspiBlitz lo siguiente:

  ```bash
    # descargar
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.update.v0.11.0-beta.sh
    # inspect the script
    cat lnd.update.v0.11.0-beta.sh
    # ejecutar
    bash lnd.update.v0.11.0-beta.sh
  ```

## [Construya LND desde la fuente](https://github.com/openoms/lightning-node-management/tree/4d79ea41252f3fb2729aa9c2bd2be591b7c98299/lnd.updates/lnd.from.source.sh)

* Descargue y ejecute este script en RaspiBlitz:

  ```bash
    # descargar
    wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.from.source.sh
    # inspect the script
    cat lnd.update.v0.11.0-beta.sh
    # ejecutar
    bash lnd.from.source.sh
  ```

* Solicitará el commit para descargar. Elija un ID de commit de esta lista: [https://github.com/lightningnetwork/lnd/commits/master](https://github.com/lightningnetwork/lnd/commits/master)
