# Configurar un Watchtower y un Cliente en la red Lightning

Un watchtower monitorea la blockchain de bitcoin para detectar transacciones que intenten robarle cerrando un canal con un estado anterior inválido. Si se encuentra una infracción el watchtower transmite inmediatamente una transacción de castigo que mueve todos los fondos del canal a una billetera on-chain.

Si hay dos nodos bajo su control desde lnd v0.7.0, puede configurarlos para que se vigilen entre sí. Es mejor hacerlo con nodos en dos ubicaciones físicas separadas para reducir el riesgo de pérdida de conexión.

## Actualizar lnd

Ver [https://github.com/lightningnetwork/lnd/releases/](https://github.com/lightningnetwork/lnd/releases/) para obtener la última versión y sus notas correspondientes. Actualice [manualmente](https://github.com/lightningnetwork/lnd/blob/master/docs/INSTALL.md#installing-lnd) o use un [script automatizado](../tecnicas/lnd.updates.md) para actualizar lnd en un RaspiBlitz o un sistema compatible.

## Configurar el Watchtower

Ejecute los siguientes comandos en la terminal del nodo

`#` significa `$ sudo`

* Edite el lnd.conf:

  `# nano /mnt/hdd/lnd/lnd.conf`

* inserte las siguientes líneas al final del archivo:

  ```text
  [Watchtower]
  watchtower.active=1
  ```

  * de forma predeterminada el watchtower escucha en el puerto 9911 pero se puede configurar en cualquier otro utilizando `watchtower.listen = 0.0.0.0: PORT` en el archivo de configuración.
  * La dirección IP `0.0.0.0` se usa para aceptar conexiones desde cualquier lugar \(configuración predeterminada\)

* habilite el puerto a través del firewall: `# ufw allow 9911 comment "watchtower"` `# ufw enable`
* reinicie lnd `# systemctl restart lnd`
* redireccione el puerto 9911 en el router
* Verifique en el log si el servicio está funcionando:  
  `# tail -n 10000 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log`

  Ejemplo del log:

  ```text
    2019-06-21 09:08:58.544 [INF] WTWR: Starting watchtower
    2019-06-21 09:08:58.544 [INF] WTWR: Starting lookout
    2019-06-21 09:08:58.544 [INF] WTWR: Starting lookout from chain tip
    2019-06-21 09:08:58.544 [INF] WTWR: Lookout started successfully
    2019-06-21 09:08:58.545 [INF] WTWR: Starting watchtower server
    2019-06-21 09:08:58.544 [INF] DISC: Attempting to bootstrap with: Authenticated Channel Graph
    2019-06-21 09:08:58.545 [INF] CMGR: Server listening on 127.0.0.1:9911
    2019-06-21 09:08:58.545 [INF] NTFN: New block epoch subscription
    2019-06-21 09:08:58.545 [INF] WTWR: Watchtower server started successfully
    2019-06-21 09:08:58.546 [INF] WTWR: Watchtower started successfully
    2019-06-21 09:08:58.547 [INF] CHBU: Swapping old multi backup file from /home/bitcoin/.lnd/data/chain/bitcoin/mainnet/temp-dont-use.backup to /home/bitcoin/.lnd/data/chain/bitcoin/mainnet/channel.backup
    2019-06-21 09:08:58.575 [INF] DISC: Obtained 3 addrs to bootstrap network
    2019-06-21 13:10:27.014 [INF] WTWR: Watchtower started successfully
    2019-06-21 13:14:50.743 [INF] WTWR: Accepted incoming peer 02b5792e533ad17fc77db13093ad84ea304c5069018f97083e3a8c6a2eac95a63f@171.25.193.25:34413
    2019-06-21 13:14:51.074 [INF] WTWR: Accepted session for 02b5792e533ad17fc77db13093ad84ea304c5069018f97083e3a8c6a2eac95a63f
    2019-06-21 13:14:51.074 [INF] WTWR: Releasing incoming peer 02b5792e533ad17fc77db13093ad84ea304c5069018f97083e3a8c6a2eac95a63f@171.25.193.25:34413
  ```

  Filtre los mensajes relevantes con \(presione CTRL+C para salir\):  
  `# tail -f -n 10000 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log | grep WTWR`

* Consulte el `pubkey` con:  
  `$ lncli tower info`

  El pubkey del watchtower es distinto del pubkey del nodo lnd.

## Configurar el nodo a monitorear \(el cliente watchtower\)

* \[LND v0.8.0+\] Registre uno o mas watchtower\(s\):
  * Edite lnd.conf:

    `# nano /mnt/hdd/lnd/lnd.conf`

  * inserte las siguientes líneas al final del archivo:

    ```text
    [Wtclient]
    wtclient.active=1
    ```

    Agregue un watchtower desde la consola \(puede agregar varios, uno por uno\):

    ```text
    $ lncli wtclient add <watchtower-pubkey>@<host>:9911
    ```

  * Use el `watchtower-pubkey` anotado anteriormente con `$ lncli tower info`.
  * Para un cliente clearnet, el `host` debe ser la IP clearnet \(o dynamicDNS\) del watchtower, incluso si este se ejecuta a través de Tor.
* Reinicie lnd `# systemctl restart lnd`
* Verifique en el log si el servicio está funcionando:  
  `# tail -n 100 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log`

  Ejemplo del log:

  ```text
    2019-06-21 14:14:50.785 [DBG] WTCL: Sending Init to 02a4c564af0f33795b438e8d76d2b5057c3dcd1115be144c3fc05e7c8c65486f23@<host>:9911
    2019-06-21 14:14:51.098 [DBG] WTCL: Received Init from 02a4c564af0f33795b438e8d76d2b5057c3dcd1115be144c3fc05e7c8c65486f23@<host>:9911
    2019-06-21 14:14:51.105 [DBG] WTCL: Sending MsgCreateSession(blob_type=[FlagCommitOutputs|No-FlagReward], max_updates=1024 reward_base=0 reward_rate=0 sweep_fee_rate=12000) to 02a4c564af0f33795b438e8d76d2b5057c3dcd1115be144c3fc05e7c8c65486f23@<host>:9911
    2019-06-21 14:14:51.299 [DBG] WTCL: Received MsgCreateSessionReply(code=0) from 02a4c564af0f33795b438e8d76d2b5057c3dcd1115be144c3fc05e7c8c65486f23@<host>:9911
    2019-06-21 14:14:51.315 [DBG] WTCL: New session negotiated with 02a4c564af0f33795b438e8d76d2b5057c3dcd1115be144c3fc05e7c8c65486f23@<host>:9911, policy: (blob-type=10 max-updates=1024 reward-rate=0 sweep-fee-rate=12000)
    2019-06-21 14:14:51.320 [INF] WTCL: Acquired new session with id=02b5792e533ad17fc77db13093ad84ea304c5069018f97083e3a8c6a2eac95a63f
    2019-06-21 14:14:51.322 [DBG] WTCL: Loaded next candidate session queue id=02b5792e533ad17fc77db13093ad84ea304c5069018f97083e3a8c6a2eac95a63f
    2019-06-21 14:15:16.588 [INF] WTCL: Client stats: tasks(received=0 accepted=0 ineligible=0) sessions(acquired=1 exhausted=0)
  ```

  Filtre los mensajes relevantes con: \(presione CTRL+C para salir\):  
  `# tail -f -n 10000 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log | grep WTCL`

  Para tener más información en el log, agregue la siguiente línea al archivo lnd.conf:

  ```text
    debuglevel=WTWR=debug,WTCL=debug
  ```

  o ejecute el siguiente comando:  
  `lncli debuglevel --level=WTWR=debug,WTCL=debug`

  Ejemplo del log:

  ```text
    2019-07-29 15:26:51.386 [DBG] WTWR: Fetching block for (height=587633, hash=0000000000000000000b047fbe6d93c2af193249bdb864a99186914fc4b0b2c6)
    2019-07-29 15:26:52.192 [DBG] WTWR: Scanning 3007 transaction in block (height=587633, hash=0000000000000000000b047fbe6d93c2af193249bdb864a99186914fc4b0b2c6) for breaches
    2019-07-29 15:26:52.301 [DBG] WTWR: No breaches found in (height=587633, hash=0000000000000000000b047fbe6d93c2af193249bdb864a99186914fc4b0b2c6)
    2019-07-29 15:34:17.877 [DBG] WTWR: Fetching block for (height=587634, hash=00000000000000000010615b2c0b3c32cb4ebcb7eb0bd452812f5c48d0edad0c)
    2019-07-29 15:34:18.463 [DBG] WTWR: Scanning 2691 transaction in block (height=587634, hash=00000000000000000010615b2c0b3c32cb4ebcb7eb0bd452812f5c48d0edad0c) for breaches
    2019-07-29 15:34:18.619 [DBG] WTWR: No breaches found in (height=587634, hash=00000000000000000010615b2c0b3c32cb4ebcb7eb0bd452812f5c48d0edad0c)
  ```

  ¡Siéntese y disfrute que ahora no hay forma de engañar a su nodo incluso cuando está desconectado!

## Configuración para nodos con Tor

Ambos nodos \(el watchtower y el cliente lnd\) deben usar Tor para poder comunicarse.

### Configuración de Tor Watchtower

* Edite lnd.conf:

  `# nano /mnt/hdd/lnd/lnd.conf`

* inserte las siguientes líneas al final del archivo:

  ```text
    [Watchtower]
    watchtower.active=1
  ```

* Edite el archivo de configuración de Tor del watchtower:  
  `# nano /etc/tor/torrc`

  agregue las siguientes líneas:

  ```text
    # Hidden Service for incoming LND WatchTower connections
    HiddenServiceDir /mnt/hdd/tor/lndWT9911
    HiddenServicePort 9911 127.0.0.1:9911
  ```

* reinicie Tor y lnd con systemctl: `# systemctl restart tor` y `# systemctl restart lnd`
* Consulte la dirección onion del watchtower ejecutando: `# cat /mnt/hdd/tor/lndWT9911/hostname`
* Consulte el pubkey del watchtower \(`watchtower-pubkey`\) con `$ lncli tower info`
* Filtre los mensajes relevantes con \(CTRL+C para salir\):  
  `# tail -f -n 10000 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log | grep WTWR`

  Ejemplo del log del watchtower:

  ```text
    2019-08-20 11:26:30.555 [INF] WTWR: Accepted incoming peer WTCLIENT_PUBKEY@127.0.0.1:57264
    2019-08-20 11:26:30.558 [DBG] WTWR: Received Init from WTCLIENT_PUBKEY@127.0.0.1:57264
    2019-08-20 11:26:30.565 [DBG] WTWR: Sending Init to WTCLIENT_PUBKEY@127.0.0.1:57264
    2019-08-20 11:26:30.931 [DBG] WTWR: Received MsgCreateSession(blob_type=[FlagCommitOutputs|No-FlagReward], max_updates=1024 reward_base=0 reward_rate=0 sweep_fee_rate=2500) from WTCLIENT_PUBKEY@127.0.0.1:57264
    2019-08-20 11:26:30.968 [INF] WTWR: Accepted session for WTCLIENT_PUBKEY
    2019-08-20 11:26:30.968 [DBG] WTWR: Sending MsgCreateSessionReply(code=0) to WTCLIENT_PUBKEY@127.0.0.1:57264
    2019-08-20 11:26:30.981 [INF] WTWR: Releasing incoming peer WTCLIENT_PUBKEY@127.0.0.1:57264
    2019-08-20 11:27:27.260 [DBG] WTWR: Fetching block for (height=590941, hash=000000000000000000069b8d2739cb8736cc6a14927d760a7b7dfa47e1e5059e)
    2019-08-20 11:27:28.464 [DBG] WTWR: Scanning 3621 transaction in block (height=590941, hash=000000000000000000069b8d2739cb8736cc6a14927d760a7b7dfa47e1e5059e) for breaches
    2019-08-20 11:27:28.729 [DBG] WTWR: No breaches found in (height=590941, hash=000000000000000000069b8d2739cb8736cc6a14927d760a7b7dfa47e1e5059e)
  ```

### Configuración del cliente Tor Watchtower

* \[LND v0.8.0+\] Registre uno o mas watchtower\(s\):
  * Edite lnd.conf:

    `# nano /mnt/hdd/lnd/lnd.conf`

  * inserte las siguientes líneas al final del archivo:

    ```text
    [Wtclient]
    wtclient.active=1
    ```

  * Agregue un watchtower desde la consola \(puede agregar varios, uno por uno\):

    ```text
    $ lncli wtclient add 02b745aa2c27881f2494978fe76494137f86fef6754e5fd19313670a5bc639ea82@xjyldrwmtxtutdqqhgvxvnykk4ophz6ygr3ci4gxnnt5wibl7k4g2vad.onion:9911
    ```

    * Los detalles de un nodo de prueba están precargados. Recibe conexiones pero no hay garantía de que este servicio permanezca conectado.
    * Utilice el `watchtower-pubkey` que se indicó anteriormente de `$ lncli tower info`.
    * El host es la dirección .onion del watchtower anotada anteriormente de: `# cat /mnt/hdd/tor/lndWT9911/hostname`
* reinicie lnd con systemctl: `# systemctl restart lnd`
* Verifique qué watchtowers están escuchando:  
  `$ lncli wtclient towers`

  Ejemplo:

  ```text
    {
            "towers": [
                    {
                            "pubkey": "02b745aa2c27881f2494978fe76494137f86fef6754e5fd19313670a5bc639ea82",
                            "addresses": [
                                    "xjyldrwmtxtutdqqhgvxvnykk4ophz6ygr3ci4gxnnt5wibl7k4g2vad.onion:9911"
                            ],
                           "active_session_candidate": true,
                            "num_sessions": 0,
                            "sessions": []
                   }
            ]
    }
  ```

* Filtre los mensajes relevantes con \(CTRL+C para salir\):  
  `# tail -f -n 10000 /mnt/hdd/lnd/logs/bitcoin/mainnet/lnd.log | grep WTCL`

  Ejemplo del log del cliente:

  ```text
    2019-07-26 10:30:08.041 [INF] WTCL: Client stats: tasks(received=8 accepted=8 ineligible=0) sessions(acquired=0 exhausted=0)
    2019-07-26 10:30:34.105 [DBG] WTCL: Processing backup(8fd5d5dc97fc6e52da36bd527357a9c87f2a2529379f9f50241e35ab0c95c404, 6315)
    2019-07-26 10:30:34.106 [DBG] WTCL: SessionQueue(026d7b4f4fd7dcdb5a2acce00a8d1cca5bbaeb7e9d89a30ded7d4b62b7b50b3399) deciding to accept backup(8fd5d5dc97fc6e52da36bd527357a9c87f2a2529379f9f50241e35ab0c95c404, 6315) seqnum=0 pending=8 max-updates=1024
    2019-07-26 10:30:34.108 [INF] WTCL: Queued backup(8fd5d5dc97fc6e52da36bd527357a9c87f2a2529379f9f50241e35ab0c95c404, 6315) successfully for session 026d7b4f4fd7dcdb5a2acce00a8d1cca5bbaeb7e9d89a30ded7d4b62b7b50b3399
    2019-07-26 10:31:08.041 [INF] WTCL: Client stats: tasks(received=9 accepted=9 ineligible=0) sessions(acquired=0 exhausted=0)
  ```

## Más información:

[https://github.com/lightningnetwork/lnd/blob/master/docs/watchtower.md](https://github.com/lightningnetwork/lnd/blob/master/docs/watchtower.md)

Últimas notas del release de lnd: [https://github.com/lightningnetwork/lnd/releases](https://github.com/lightningnetwork/lnd/releases)

[https://thebitcoinnews.com/watchtowers-are-coming-to-lightning/](https://thebitcoinnews.com/watchtowers-are-coming-to-lightning/)

[https://bitcoinops.org/en/newsletters/2019/06/19/](https://bitcoinops.org/en/newsletters/2019/06/19/)

Will O\`Beirne muestra en este artículo \(y el repositorio de GitHub\) cómo demostrar una infracción y las acciones de un watchtower en una red simulada: [https://medium.com/@wbobeirne/testing-out-watchtowers-with-a-simulated-breach-f1ad22c01112](https://medium.com/@wbobeirne/testing-out-watchtowers-with-a-simulated-breach-f1ad22c01112)

SLP83 Conner Fromknecht – Bitcoin Lightning Watchtowers in depth  
podcast: [https://stephanlivera.com/episode/83](https://stephanlivera.com/episode/83)  
transcripción: [http://diyhpl.us/wiki/transcripts/stephan-livera-podcast/2019-06-24-conner-fromknecht-stephan-livera/](http://diyhpl.us/wiki/transcripts/stephan-livera-podcast/2019-06-24-conner-fromknecht-stephan-livera/)

Busque algunos watchtowers altruistas y comparta los suyos: [https://github.com/openoms/lightning-node-management/issues/4](https://github.com/openoms/lightning-node-management/issues/4)

