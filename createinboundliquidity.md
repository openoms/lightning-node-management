# Crear liquidez entrante

Paga con Lightning y recibe "on-chain".

Para crear liquidez entrante \(y poder recibir pagos en su canal\) se puede hacer un pago en una tienda y recibir un producto o enviar a un exchange que acepte Lightning y posteriormente enviar los satoshis "on-chain".

Para comprar tarjetas de regalo con Lightning, ir a [Bitrefill \(referral link\)](https://www.bitrefill.com/buy/?code=XapbJJd8).

## Billeteras no custodiadas

Configure un nodo LN en su teléfono o computadora y envíe algunos fondos, de este modo se crea balance remoto \(liquidez entrante\).

Ejemplos:

* [Breez](https://breez.technology/)  
  Es una billetera móvil que crea un canal entrante de 1 millón de satoshis automáticamente, de esta forma, se pueden enviar fondos después de la configuración incial.

  Enviar fondos "on-chain" a una dirección de bitcoin cuesta 0.5% con [Boltz](https://boltz.exchange/)

* [Phoenix](https://phoenix.acinq.co/)

  Crea un nodo Lightning en Android, iOS o escritorio. Los canales se administran manualmente o en piloto automático.

* [Muun Wallet](https://muun.com/)

  Es una billetera Lightning multiplataforma fácil de usar

## Billeteras custodiadas

Paguese a usted mismo a través de LN y benefíciese de la liquidez entrante creada.

El inconveniente principal con las billeteras custodiadas es que no se controlan las llaves privadas.

Ejemplos:

* [Tippin.me](https://tippin.me/)
* [Wallet of Satoshi](https://www.walletofsatoshi.com/)
* [Bluewallet](https://bluewallet.io/)

## [Lightning Pool](https://pool.lightning.engineering/)

Compre canales entrantes en un "marketplace" abierto: [https://pool.lightning.engineering/](https://pool.lightning.engineering/) Notas de uso: [pool.md](herramientas-avanzadas/pool.md)

## [Lightning Loop](https://github.com/lightninglabs/loop)

Lightning Loop es un servicio no custodiado ofrecido por Lightning Labs hacer transacciones entre Bitcoin on-chain y off-chain mediante "submarine swaps".

La versión actual soporta dos tipos de transacciones:

* Loop Out: de off-chain a on-chain. El cliente hace un pago Lightning y recibe en dirección de Bitcoin.
* Loop In: de on-chain a off-chain. El cliente hace un pago on-chain a un canal Lightning.
* Cantidad máxima: 4 200 000 satoshis
* Ejemplo de uso para tener el costo más bajo \(tiempo de confirmación más largo \(alrededor de 25 bloques\) con una tasa de error más alta \(costo de enrutamiento máximo 500 satoshis\) - ajuste de acuerdo a su necesidad\):

  ```text
     loop out [command options] amt [addr]

    # --channel valor               the 8-byte compact channel ID of the channel to loop out (default: 0)
    # --addr valor                  the optional address that the looped out funds should be sent to, if let blank the funds will go to lnd's wallet
    # --amt valor                   the amount in satoshis to loop out (default: 0)
    # --conf_target valor           the number of blocks from the swap initiation height that the on-chain HTLC should be swept within (default: 6)
    # --max_swap_routing_fee value  the max off-chain swap routing fee in satoshis, if let blank a default max fee will be used (default: 0)
    # --fast                        Indicate you want to swap immediately, paying potentially a higher fee. If not set the swap server might choose to wait up to 30 minutes before publishing the swap HTLC on-chain, to save on chain fees. Not setting this flag might result in a lower swap fee.
  ```

  [https://lightning.engineering/loopapi](https://lightning.engineering/loopapi)

## [Microlancer.io](https://microlancer.io/services/?tag=%23lightning-network)

Paga por canales de entrada.

## [ChainMarket](https://chainmarket.etleneum.com/)

Mercado para enviar desde Lightning a on-chain mediante transacciones en lote. Comisión: 0.5%

## [Sats4Likes](https://kriptode.com/satsforlikes/index.html)

Publica un anuncio y paga satoshis por canales de entrada.

## [Boltz](https://boltz.exchange/)

Exchange no custodiado.

## [Bitfinex](https://bitfinex.com)

Si no es usa fiat es un exchange que no necesita KYC, soporta depósitos Lightning \(gratis\) y retiros \(100 satoshis\). El retiro on-chain cuesta 40000 satoshis fijos. Detalle de sus nodos en [https://ln.bitfinex.com/](https://ln.bitfinex.com/)

## [FixedFloat](https://fixedfloat.com/)

Exchange de criptomonedas Lightning. Costo: 0.5 - 1%

## [ZigZag.io](https://zigzag.io/)

Exchange que acepta pagos Lightning. Max 4M satoshis. Comisión ~ 2%

## [LightningTo.me](https://lightningto.me/)

Abre un canal gratuito con 2 000 000 satoshis. Necesita tener 10 canales abiertos para utilizar este servicio. Si se conecta usando Tor, agregue su nodo:  
`$ lncli connect 03bb88ccc444534da7b5b64b4f7b15e1eccb18e102db0e400d4b9cfe93763aa26d@138.68.14.104:9735`

## [LightningPowerUsers.com](https://lightningpowerusers.com/home/)

Solicite capacidad de entrada por una pequeña tarifa. Tamaño de canal recomendado: entre 500 000 y 16 500 000 satoshis.

## [Thor: Lightning Channel-Opening Service by Bitrefill.com](https://www.bitrefill.com/thor-lightning-network-channels/?hl=en)

Pague con Lightning por un canal de entrada de hasta 16 000 000 satoshis.

## [LNBIG.com](https://lnbig.com/#/open-channel)

Permite comprar canales de entrada [https://twitter.com/lnbig\_com](https://twitter.com/lnbig_com)

## [github.com/bitcoin-software/ln-liquidity](https://github.com/bitcoin-software/ln-liquidity)

Lista de servicios que permiten cambiar entre Lightning &lt;-&gt; on-chain

