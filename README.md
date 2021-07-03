# General

## Conexiones (peer) y Canales

* Los 'Peers' son nodos conectados entre si a través de internet \(TCP/IP\).
* Un canal hace referencia a un "canal de pago" establecido entre dos nodos (peers) de la red Lightning.
* Para abrir un canal primero se debe establecer una conexión entre nodos (peers).
* Se puede establecer una conexión automática con nodos de acceso público.
* Si uno de los nodos no es de acceso público, la conexión entre las partes debe iniciarse manualmente desde el nodo privado, incluso si el nodo de acceso público está abriendo el canal.

## Recibir pagos

Para poder recibir pagos en la red Lightning, un nodo necesita:

* "liquidez entrante" \(balance remoto\), es decir, se requiren algunos satoshis en el otro lado del canal.
* un canal a un nodo "bien conectado" o un canal directo desde el nodo que paga. Esto asegura que exista una ruta de pago viable.

La cantidad máxima permitida para un pago está determinada por la "liquidez entrante" más alta de un canal en la ruta de pago \ (no es acumulable entre canales \).

## Tamaño del canal y elección de nodos (peers)

* No hay un número sugerido, pero en general se recomienda evitar la apertura de canales con menos 200K-500K sats.
* [https://1ml.com/statistics](https://1ml.com/statistics) muestra el tamaño promedio por canal en la red:

  0.028 BTC = 2 800 000 satoshis (28 Mayo 2019).

* Un canal demasiado pequeño podría resultar en que no se pueda cerrar cuando los costos por transacción "on-chain" estén altos. Esto dejará al canal vulnerable si la contraparte intenta cerrar con un estado previo \(los fondos en el canal podrían ser robados \).
* El tamaño máximo del un pago directo o enrutado está determinado por la liquidez direccional más alta de un solo canal en la ruta de pago \(no acumulable entre canales \).
* Un canal grande a un nodo estable y "bien conectado" es más útil que muchos pequeños.
* Es recomendado conectarse a nodos donde el operador pueda ser contactado en caso de un problema.
* Elija un nodo que conozca o uno de la siguiente lista: [https://1ml.com/node?order=nodeconnectednodecount](https://1ml.com/node?order=nodeconnectednodecount)
* Recomendaciones si su nodo es público: [https://moneni.com/nodematch](https://moneni.com/nodematch)

## Costos "On-chain" bitcoin

* Abrir o cerrar un canal Lightning es una transacción "on-chain" bitcoin \(visible/hecha en la blockchain \)
* El tiempo de confirmación depende del estado de la "mempool" de bitcoin \([https://jochen-hoenicke.de/queue/\#0,24h](https://jochen-hoenicke.de/queue/#0,24h)\) y de los sats/byte usados para pagar los costos de transacción \([https://bitcoinfees.earn.com/](https://bitcoinfees.earn.com/)\).
* Verificar [https://whatthefee.io/](https://whatthefee.io/) para obtener una estimación de confirmación de acuerdo al tiempo/costo.
* Use un costo personalizado y elija el número más bajo de acuerdo a un tiempo de confirmación aceptable.
* Los costos pagados deben cubrir al menos 141 bytes, sin embargo, este número suele ser mayor dependiendo de las entradas (en la transacción), "script" y cantidad de firmas.
* Aprenda qué hacer en un [entorno de costos "on-chain" altos](highonchainfees.md)

## Nodos Tor

Tor es una red "anonimizada" diseñada para ocultar la dirección IP de los participantes. Algo similar a usar una VPN pero con "varios saltos". Más información en: [https://es.wikipedia.org/wiki/Tor\_\(red\_de\_anonimato\)](https://es.wikipedia.org/wiki/Tor_%28red_de_anonimato%29)

* Un nodo Lightning "detrás" de Tor puede conectarse y abrir un canal con cualquier otro nodo.
* Los nodos corriendo en "clearnet" no pueden ver "detrás" de Tor.
* Un nodo corriendo en "clearnet" debe ser agregado primero por el nodo "detrás" de Tor para poder abrir un canal.
* Una vez se crea el canal, la conexión persistirá, sin embargo, si se reinicia alguno de los nodos es posible que tarde un poco en reestablecerse la conexión.
* Si ambos nodos se reinician al mismo tiempo o si la dirección IP del nodo en la "clearnet" cambia mientras ambos están fuera de línea, la conexión debe agregarse manualmente nuevamente.

## Pagos enrutados

* Imagine un nodo `B` en una conexión en serie `A`-`B`-`C`.
* Los canales de `B` están configurados para que haya capacidad de entrada \(balance remoto\) desde `A` y capacidad de salida \(balance local\) a `C`.
* Si "A" quiere hacer un pago a "C", habrá 1 nodo intermedio (o 1 salto) en la ruta.
* Internamente: `A` envía los satoshis a `B` \(nodo de enrutamiento\) y este pagará a `C`.
* La capacidad de los canales no cambia, solo "se mueve".
* El pago solo puede realizarse si se puede enviar una "imagen hash" \(un mensaje\) desde el destino.
* El proceso es "todo o nada", el pago no se puede "atascar" en un nodo intermedio.

## Canal privado

* mejor conocido como canal "no anunciado"
* no será publicado en el "grafo de canales" \(red gossip\)
* más útil para enviar pagos
* para recibir pagos es necesario tener un "route hint" (pista de ruta) incluida en la factura:

  `lncli addinvoice <amount> --private`

* el "route hint" es el identificador de la transacción de financiación \(expone el canal a cualquiera que conozca la factura\)
* es posible recibir pagos "keysend" si se conoce el "route hint"
* no enruta pagos (a menos que se use en paralelo con un canal público al mismo nodo, también conocido como liquidez en la sombra)

## Costos de enrutamiento de la red Lightning

### Configuración avanzada y automatizada de costos: [fees.md](fees.md)

A diferencia de las transacciones "on-chain" \(donde los costos de transacción se pagan por los bytes que ocupa la transacción en un bloque \), los costos en la red Lightning están relacionados con la cantidad enrutada. Hay dos componentes de tarifa:

* costo base \(base\_fee\_msat\). El valor por defecto es 1000 milisat, es decir, 1 satoshi por cada pago enrutado.
* el costo proporcional \(fee\_rate\). El valor por defecto en lnd es 0.000001 BTC, es decir, se cobra 1 satoshi adicional por cada millón de satoshis enrutado.

No hay costo por transacción para pagos en un canal directo entre dos nodos.

Para cambiar los costos de enrutamiento de su nodo, use lo siguiente: [https://api.lightning.community/\#updatechannelpolicy](https://api.lightning.community/#updatechannelpolicy)

* Puede reducir el costo base a 500 msat y aumentar la tarifa proporcional a 100ppm/0.01% con este comando: `$ lncli updatechanpolicy 500 0.0001 144`
* La configuración por defecto es \(1 sat por pago + 1 ppm/0.0001%\): `$ lncli updatechanpolicy 1000 0.000001 144`

En caso de que se enruten pagos a través de un canal "costoso" es importante aumentar la tarifa de enrutamiento para poder pagar el rebalanceo o cierre del canal. Verifique las tarifas de enrutamiento en [1ml.com](https://1ml.com/) o en [lndmanage](./#lndmanage).

Configurar costos para canales individuales solo requiere un clic en el [app RTL](./#RTL---Ride-The-Lightning).

## Watchtowers

Leer más sobre cómo configurar uno en [watchtower.md](watchtower.md).

## Liquidez

Lea las ideas básicas de Alex Bosworth: [https://github.com/alexbosworth/run-lnd/blob/master/LIQUIDITY.md](https://github.com/alexbosworth/run-lnd/blob/master/LIQUIDITY.md)

## Crear liquidez entrante (Inbound)

Paga con Lightning y recibe "on-chain".
Ver lista de recomendaciones [CreateInboundLiquidity.md](createinboundliquidity.md)

## Crear liquidez saliente (Outbound)

Abra canales o pague "on-chain" y reciba en la red Lightning.
Ver lista de recomendaciones
[CreateOutboundLiquidity.md](createoutboundliquidity.md)

## Administración de canales

Para maximizar la capacidad de enrutar pagos es mejor balancear los canales con fondos en ambos lados \(permite tráfico bidireccional\).

### [Balance of Satoshis](https://github.com/alexbosworth/balanceofsatoshis)

Es una herramienta con multiples funciones para trabajar con balances LND. Tiene una funcionalidad experimental para conectarse a un bot en Telegram y notificar la actividad del nodo.

* [Instrucciones de instalación RaspiBlitz](https://gist.github.com/openoms/823f99d1ab6e1d53285e489f7ba38602)
* Para ver cómo usar el comando rebalance ejecute: `bos help rebalance`

### [CLBOSS administrador de nodos C-Lightning](https://github.com/ZmnSCPxj/clboss)

Es un administrador automatizado para nodos de reenvío C-Lightning

### [lndmanage](https://github.com/bitromortac/lndmanage)

Es una herramienta de consola, escrita en python, para la administración avanzada de canales de un nodo LND.

* Instalar con:

  ```bash
    # activate virtual environment
    sudo apt install -y python3-venv
    python3 -m venv venv
    source venv/bin/activate
    # get dependencies
    sudo apt install -y python3-dev libatlas-base-dev
    pip3 install wheel
    python3 -m pip install lndmanage
  ```

* Iniciar modo interactivo \(hacer esto cada vez\):

  ```bash
    $ source venv/bin/activate
    (venv) $ lndmanage
  ```

* Mostrar el estado de los canales:

  ```bash
    $ lndmanage status
    $ lndmanage listchannels rebalance
  ```

* Ejemplo de rebalanceo:   
  ```bash
    $ lndmanage rebalance --max-fee-sat 20 --max-fee-rate 0.0001 CHANNEL_ID --reckless
  ```

### [rebalance-lnd](https://github.com/C-Otto/rebalance-lnd)

Este script de Python permite reequilibrar fácilmente los canales individuales un nodo lnd.

* Para instalar ejecutar los siguiente en la terminal del nodo lnd:  
  ```bash
    $ git clone https://github.com/C-Otto/rebalance-lnd
    $ cd rebalance-lnd
    $ pip install -r requirements.txt
  ```

* Modo de uso \(más opciones en el [readme](https://github.com/C-Otto/rebalance-lnd/blob/master/README.md#usage)\):   
  ```bash
    $ python rebalance.py -t <channel_ID-where-to-move-sats> -f <channel_ID-from-which-to-move-sats> -a <amount-of-sats-to-be-moved>
  ```

### [Métodos para crear un canal balanceado con un nodo de confianza](balancedchannelcreation.md)

* Realice un intercambio de confianza entre "on-chain" y "off-chain".
* Abra un canal balanceado y con doble financiación con un nodo de confianza utilizando el comando que requiere una transacción Lightning y una "on-chain".

## Software de monitoreo

### [RTL - Ride The Lightning](https://github.com/ShahanaFarooqui/RTL)

RTL es una interfaz web para Lightning Network Daemon(LND). Destinado a ser utilizado en una red local. Los métodos de conexión disponibles son [HTTPS](https://github.com/openoms/bitcoin-tutorials/tree/master/nginx) o [Tor](https://github.com/Ride-The-Lightning/RTL/blob/master/docs/RTL_TOR_setup.md).

[https://medium.com/@suheb\_\_/how-to-ride-the-lightning-447af999dcd2](mailto:https://medium.com/@suheb__/how-to-ride-the-lightning-447af999dcd2)

### [ThunderHub](https://www.thunderhub.io/)

Un administrador para nodos Lightning LND en su navegador.

* [Instrucciones de instalación en RaspiBlitz](https://gist.github.com/openoms/8ba963915c786ce01892f2c9fa2707bc)

### [ZeusLN](https://zeusln.app/)

Aplicación móvil (Android e iOS) para operadores de nodos Lightning Network Daemon \(lnd\). Se conecta a través del API REST \(puerto 8080 o [Tor](https://github.com/openoms/bitcoin-tutorials/blob/master/Zeus_to_RaspiBlitz_through_Tor.md)\)

### [Zap](https://zap.jackmallers.com/)

Billetera Lightning de escritorio y móvil (iOS y Android), puede conectarse a su nodo LND de forma remota a través de la interfaz GRPC \(puerto 10009\)

### [Joule](https://lightningjoule.com/)

Trae el poder de Lightning a la web con pagos e identidad en el navegador, todo con su propio nodo.
[https://medium.com/lightning-power-users/bitcoin-lightning-joule-chrome-extension-ac149bb05cb9](https://medium.com/lightning-power-users/bitcoin-lightning-joule-chrome-extension-ac149bb05cb9)

### [lndash](https://github.com/djmelik/lndash)

lndash es un dashboard web (simple) de solo lectura para lnd - Lightning Network Daemon.
Demo: [https://lightninglayer.com/](https://lightninglayer.com/)

Características:

* Vista de nodos (peers)
* Vista de canales
* Vista de eventos Forwarding \(pagos enrutados\)
* Herramienta Looking Glass \(ruta/búsqueda de ruta\)
* Grafo de la red Lightning

### [lntop](https://github.com/edouardparis/lntop)

lntop es un visor de canales, en modo texto, para sistemas Unix.

### [lnd-admin](https://github.com/janoside/lnd-admin)

Interfaz web de administración para LND a través de gRPC. Hecho en Node.js, express, bootstrap-v4. Demo: [https://lnd-admin.chaintools.io/](https://lnd-admin.chaintools.io/)

### [lndmon](https://github.com/lightninglabs/lndmon)

Solución de monitoreo para nodos lnd utilizando Prometheus y Grafana. [https://blog.lightning.engineering/posts/2019/07/24/lndmon-v0.1.html](https://blog.lightning.engineering/posts/2019/07/24/lndmon-v0.1.html)

### [Spark wallet for C-Lightning](https://github.com/shesek/spark-wallet)

Spark es una billetera minimalista para c-lightning. Es accesible a través de la web o mediante aplicaciones móviles y de escritorio \(para Android, Linux, macOS y Windows\). Actualmente está orientado a usuarios técnicos y no es un paquete "todo en uno", es mas una interfaz de "control remoto" para un nodo c-lightning que debe administrarse por separado.

## Exploradores de la red Lightning

* [1ml.com](https://1ml.com/)
* [explorer.acinq.co](https://explorer.acinq.co/)
* [amboss.space](https://amboss.space/)
* [ln.fiatjaf.com](https://ln.fiatjaf.com)

## Recursos

* Guía del constructor de LND (Mejores prácticas)

  [docs.lightning.engineering/advanced-best-practices/advanced-best-practices-overview/channels](https://docs.lightning.engineering/advanced-best-practices/advanced-best-practices-overview/channels)

* Una revisión conceptual de la red Lightning:  

  [dev.lightning.community/overview/index.html\#lightning-network](https://dev.lightning.community/overview/index.html#lightning-network)

* Documentación de referencia del API gRPC para LND

  [api.lightning.community](https://api.lightning.community)

* [medium.com/lightningto-me/practical-solutions-to-inbound-capacity-problem-in-lightning-network-60224aa13393](https://medium.com/lightningto-me/practical-solutions-to-inbound-capacity-problem-in-lightning-network-60224aa13393)
* [lightningwiki.net](https://lightningwiki.net)
* [satbase.org](https://satbase.org)
* Lista de ¿Cómo obtener liquidez rápidamente?

  [github.com/rootzoll/raspiblitz/issues/395](https://github.com/rootzoll/raspiblitz/issues/395)

* Lista de recursos, aplicaciones y librerias Lightning

  [github.com/bcongdon/awesome-lightning-network](https://github.com/bcongdon/awesome-lightning-network)

* Lista de recursos de Lightning de Jameson Lopp

  [lightning.how](https://lightning.how)

* [wiki.ion.radar.tech/tutorials/troubleshooting/bootstrapping-channels](https://wiki.ion.radar.tech/tutorials/troubleshooting/bootstrapping-channels)

### Enrutamiento

* [blog.lightning.engineering/posts/2018/05/30/routing.html](https://blog.lightning.engineering/posts/2018/05/30/routing.html)
* [diyhpl.us/wiki/transcripts/chaincode-labs/2018-10-22-alex-bosworth-channel-management/](https://diyhpl.us/wiki/transcripts/chaincode-labs/2018-10-22-alex-bosworth-channel-management/)
* [diyhpl.us/wiki/transcripts/lightning-hack-day/2021-03-27-alex-bosworth-lightning-routing/](https://diyhpl.us/wiki/transcripts/lightning-hack-day/2021-03-27-alex-bosworth-lightning-routing/)

## Videos

* Elaine Ou - Bootstrapping y mantenimiento de un nodo Lightning [video de 38 mins](https://www.youtube.com/watch?v=qX4Z3JY1094) y [slides](https://lightningresidency.com/assets/presentations/Ou_Bootstrapping_and_Maintaining_a_Lightning_Node.pdf)
* Alex Bosworth - Administración de canales Lightning [video de 35 mins](https://www.youtube.com/watch?v=HlPIB6jt6ww&feature=youtu.be)
* [Seminario Lightning de Chaincode Labs - Verano de 2019](https://www.youtube.com/playlist?list=PLpLH33TRghT17_U3as2P3vHfAGL8pSOOY)
* Colección de presentaciones de Alex Bosworth:

  [twitter.com/alexbosworth/status/1175091117668257792](https://twitter.com/alexbosworth/status/1175091117668257792)

## Foros

* Grupo administrado por la comunidad para RaspiBlitz Lightning Node:

  [https://t.me/raspiblitz](https://t.me/raspiblitz)

* Slack para desarrolladores LND. Enlace para obtener la invitación en:

  [dev.lightning.community/](https://dev.lightning.community/)

* Subreddit técnico para desarrolladores de Bitcoin y Lightning:  

  [www.reddit.com/r/lightningdevs](https://www.reddit.com/r/lightningdevs)

## Aprende

[https://github.com/lnbook/lnbook](https://github.com/lnbook/lnbook)  
[https://chaincode.applytojob.com/apply/LpQl1a0cvd/Chaincode-Labs-Online-Seminars](https://chaincode.applytojob.com/apply/LpQl1a0cvd/Chaincode-Labs-Online-Seminars)
[https://github.com/chaincodelabs/lightning-curriculum](https://github.com/chaincodelabs/lightning-curriculum)
