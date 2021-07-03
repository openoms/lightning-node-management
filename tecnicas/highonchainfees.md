# Entorno de altos costos on-chain

Notas sobre el uso de la red Lightning cuando las tarifas de los mineros son altas.

## Preparación

Recomendaciones para prepararse de antemano para un entorno de altos costos.

### Administración de canales

* Abrir canales estratégicamente durante tiempos de costos bajos \(fines de semana\)
* Cierre anticipado de canales inactivos y/o no confiables durante los tiempos de costos bajos
* Si ejecuta un nodo de enrutamiento, minimice el tiempo de inactividad y la inestabilidad
* Utilice canales privados \(no anunciados\) como un [nodo para gastar](../tipos-de-nodo/nodetype.spending.md) para que los tiempos de inactividad no hagan que la contraparte fuerce el cierre

### Administración de billetera

* La financiación a través de una billetera de firma única es más barata
* Prepare una selección de UTXO de buen tamaño para abrir canales con un costo mínimo
  * consolidar \(teniendo en cuenta las implicaciones de privacidad\)
  * una billetera "JoinMarket Maker" bien financiada y de larga duración tendrá diferentes tamaños de salidas coinjoined disponibles

### Configuración

* Activar "Anchor Commitments"
  * afecta solo a los nuevos canales cuando ambos nodos soportan "anchors"
  * `protocol.anchors = true` en el [lnd.conf](https://github.com/lightningnetwork/lnd/blob/260ea9b842ddd80fbea1df5516f557e3081f743f/sample-lnd.conf#L363)
  * disponible desde [LND v0.12.0](https://github.com/lightningnetwork/lnd/releases/tag/v0.12.0-beta)
  * a partir de LND v0.13 estará activo de forma predeterminada
  * necesitará un UTXO por canal en la billetera on-chain de LND para pagar los costos de cierre con CPFP - estos no se reservan en la billetera todavía
* Establezca el `minchansize` en [lnd.conf](https://github.com/lightningnetwork/lnd/blob/260ea9b842ddd80fbea1df5516f557e3081f743f/sample-lnd.conf#L248) \(por ejemplo, evite canales &lt;500k en un nodo de enrutamiento\)

## Costos de enrutamiento y balances

* Todos los nodos:
  * el saldo del canal parecerá menor ya que la reserva será mayor
  * Los costos de transacción off-chain también aumentarán \(sigue siendo proporcional al monto del pago\)
  * las fallas de pago pueden aparecer con más frecuencia a medida que se agota la liquidez
* [Nodos de enrutamiento](../tipos-de-nodo/nodetype.routing.md):
  * [Es necesario aumentar los costos de enrutamiento](https://github.com/openoms/lightning-node-management/tree/d4e82e3d2467dcd040b5490864cbc2d74666e89e/advanced-tools/fee.md) para compensar el aumento de los costos on-chain y los costos de rebalanceo
  * Se debe permitir que el rebalanceo automático pueda pagar costos más altos
* El tráfico off-chain aumentará
* Se abrirán menos canales durante los períodos de costos altos
* Se asignará menos capital
* Los "Submarine Swaps" se vuelven más costosos \(requiere transacciones on-chain\)
* En general, los canales se desbalancearán más rápido

## Apertura de canales

* Incluya una "change output" para poder usar CPFP para aumentar el costo de la transacción de apertura de canal
* Abra en lotes
  * el mayor ahorro se obtiene cuando se usa 1 entrada para abrir varios canales
  * Apunte al siguiente bloque con el costo para la transacción de apertura y asi evitar que las tarifas aumenten
  * puede usar PSBT-s \(incluso desde una billetera externa\) con las herramientas de consola disponibles:
    * LND: [Balance of Satoshis](https://github.com/alexbosworth/balanceofsatoshis#howtos)

      `bos open` and `bos fund`

    * [C-lightning CLI](https://lightning.readthedocs.io/lightning-fundchannel_start.7.html#)

      `lightningcli fundchannel_start id amount [feerate announce close_to push_msat]`
  * evite abrir canales públicos y privados \(no anunciados\) en el mismo lote - evita el propósito de no anunciar canales

### No deje la apertura de un canal pendiente durante más de 2016 bloques \(~2 semanas\)

Un canal pendiente se volverá "obsoleto" después de 2016 bloques - la contraparte se olvidará de la transacción por lo que el canal nunca se creará.

* La única opción que queda para desbloquear los fondos de la multisig será un cierre forzado \(costoso\).
* Utilice CPFP \(nunca RBF\)

  * CPFP solo se puede usar si hay un resultado de cambio de la transacción de apertura: [https://api.lightning.community/?shell\#bumpfee](https://api.lightning.community/?shell#bumpfee):

  `lncli wallet bumpfee --sat_per_byte 110 TXID:INDEX`

  Artículo de Lightningwiki.net: [https://lightningwiki.net/index.php/Bumping\_fee\_for\_lightning\_channel\_open](https://lightningwiki.net/index.php/Bumping_fee_for_lightning_channel_open)

* Puede cancelar la transacción gastándola a una "change address" [en Electrum](restorelndonchainfundsinelectrum.md#manage-the-lnd-onchain-funds-in-electrum-wallet)

## Cierre de canales

* Escoge un cierre cooperativo si es necesario
  * puede usar CPFP de la billetera receptora si un cierre cooperativo está pendiente con una tarifa baja en la mempool
* Ejecute el comando de cierre de canal nuevamente si la transacción se ha eliminado de la mempool

  `lncli closechannel FUNDING_TXID INDEX`

* Los cierres forzados son ~5 veces más caros que los costos del siguiente bloque en la última actualización
  * LND se actualiza cada 10 minutos en un canal conectado
  * Los canales inactivos durante mucho tiempo son una obligación, especialmente si estuvo en línea por última vez en un período de tarifa de minero baja
* Como nodo de enrutamiento evite los cierres forzados minimizando el tiempo de inactividad y de inestabilidad

## Watchtowers

* Si usa [watchtowers](../herramientas-avanzadas/watchtower.md) debe configurar el

  `wtclient.sweep-fee-rate=` en el [lnd.conf](https://github.com/lightningnetwork/lnd/blob/a36c95f7325d3941306ac4dfff0f2363fbb8e66d/sample-lnd.conf#L857)

  a un nivel de sat/byte donde puede confirmar dentro del retraso CSV en caso de que la contraparte transmita una transacción de infracción mientras el nodo está desconectado.

* El retraso CSV se puede configurar para que sea más largo con:

  `lncli updatechanpolicy`

## Mejoras futuras

* "Anchor commitments" de forma predeterminada \(afecta solo a los canales nuevos y ambas partes deben permitir la funcionalidad\)
* Empalme y financiación compartida - amplía la capacidad del canal en una transacción
* Taproot - puede ahorrar en el envío al multisig \(~26 bytes de el mínimo de 140 bytes\)
* Taproot - la financiación desde billeteras multisig tendrá el mismo costo que de las billeteras de firma única
* ELTOO - canales multiparte y fábricas de canales

## Referencias

* [¿Qué es CPFP?](https://bitcoinops.org/en/topics/cpfp/)
* [¿Se puede cerrar un canal mientras la financiación de la tx aún está pendiente en la mempool?](https://bitcoin.stackexchange.com/questions/102180/can-a-channel-be-closed-while-the-funding-tx-is-still-stuck-in-the-mempool)

