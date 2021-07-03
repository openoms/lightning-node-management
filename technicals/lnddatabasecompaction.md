# Compactar la base de datos LND \(channel.db\)

Un archivo `channel.db` de más de 1 GB no funciona en sistemas de 32 bits: [https://github.com/lightningnetwork/lnd/issues/4811](https://github.com/lightningnetwork/lnd/issues/4811)

```text
# verifique el tamaño del archivo channel.db
sudo du -h /mnt/hdd/lnd/data/graph/mainnet/channel.db
# resultado de ejemplo
# 1.0G    /mnt/hdd/lnd/data/graph/mainnet/channel.db
```

## Auto-compactar al reiniciar

Desde LND v0.12.0 se puede configurar `db.bolt.auto-compact=true` en el `lnd.conf`.

* Para editar:  

  `sudo nano /mnt/hdd/lnd/lnd.conf`

* inserte lo siguiente \(puede descartar los comentarios\):

  ```text
   [bolt]
   # Whether the databases used within lnd should automatically be compacted on
   # every startup (and if the database has the configured minimum age). This is
   # disabled by default because it requires additional disk space to be available
   # during the compaction that is freed afterwards. In general compaction leads to
   # smaller database files.
   db.bolt.auto-compact=true
   # How long ago the last compaction of a database file must be for it to be
   # considered for auto compaction again. Can be set to 0 to compact on every
   # startup. (default: 168h)
   # db.bolt.auto-compact-min-age=0
  ```

* reinicie lnd:  

  `sudo systemctl restart lnd`

* monitoree el proceso \(puede tomar varios minutos\):

  `sudo tail -fn 30 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log`

* Es posible deshabilitar el auto-compactado en `lnd.conf` y activarlo bajo demanda para evitar tiempos de inicio prolongados:

  ```text
   db.bolt.auto-compact=false
  ```

## Compactar con Channels Tools

[https://github.com/guggero/chantools\#compactdb](https://github.com/guggero/chantools#compactdb)

* Ejecute los siguientes comandos en la terminal RaspiBlitz  

  Vea los comentarios para verificar lo que hace cada comando.

```text
# instale chantools
# descargar, inspeccionar y ejecutar el script de instalación
wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/bonus.chantools.sh
cat bonus.chantools.sh
bash bonus.chantools.sh on

# pare lnd
sudo systemctl stop lnd

# cambiar al directorio de inicio del usuario bitcoin
sudo su - bitcoin

# ejecutar la compactación
chantools compactdb --sourcedb /mnt/hdd/lnd/data/graph/mainnet/channel.db \
                --destdb /mnt/hdd/lnd/data/graph/mainnet/compacted.db

# verifique el tamaño de compacted.db
# (la primera compactación tendrá el mayor efecto)
du -h /mnt/hdd/lnd/data/graph/mainnet/compacted.db
# ejemplo:
# 730M /mnt/hdd/lnd/data/graph/mainnet/compacted.db

# asegúrese que lnd no esté ejecutandose (necesita sudo)
exit
sudo systemctl stop lnd
sudo su - bitcoin

# haga un backup de la base de datos original
mv /mnt/hdd/lnd/data/graph/mainnet/channel.db \
   /mnt/hdd/lnd/data/graph/mainnet/uncompacted.db   

# mover la base de datos compactada en lugar de la antigua
mv /mnt/hdd/lnd/data/graph/mainnet/compacted.db \
   /mnt/hdd/lnd/data/graph/mainnet/channel.db  

# Salir del usuario de bitcoin a admin
exit

# iniciar lnd
sudo systemctl start lnd

# desbloquear la billetera
lncli unlock
```
