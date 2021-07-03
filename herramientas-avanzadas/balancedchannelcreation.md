# Métodos para crear un canal balanceado con un nodo de confianza

## Intercambio de confianza

Realice un intercambio de confianza de on-chain a off-chain.

Ventajas:

* Crea liquidez bidireccional en ambos lados.
* Pagar en un canal LN directo es gratis.

Cómo:

* Abra un canal a un nodo de confianza
* Una vez que confirmado el canal, pague una factura proporcionada por la contraparte \(use la mitad de la capacidad del canal para obtener un canal perfectamente balanceado\) - este pago es gratuito
* Envíe a la contraparte un pago on-chain para devolver la cantidad pagada en la factura \(use un "fee" bajo\)

## Cómo abrir un canal balanceado con un nodo de confianza

Abrir un canal balanceado y financiado \(por ambos\) require una transacción Lightning y una on-chain. Para esto use la consola.

A continuación encontrará cómo crear un canal balanceado de 2 millones de satoshis entre los nodos `A` y `B`.

Ventajas:

* Solo una transacción on-chain es requerida \(más barato\)
* Con la misma cantidad de fondos se creará un canal con capacidad de 2M de satoshis en lugar de 2 de 1M \(más eficiente\).

Requisitos:

* `A` tiene una liquidez saliente de 1M de satoshis.
* `B` tiene 1M de satoshis de liquidez entrante + 2M satoshis en fondos on-chain \(nodo de confianza\).
* Existe una ruta de pago para 1M de satoshis entre `A` y`B`.

Cómo:

* `B` envía una factura para recibir 1M de satoshis de `A`.
* `A` paga 1M de satoshis a `B`.
* Asegúrate de que A y B sean de confianza.
* `B` abre un canal a `A` con 2M de satoshis con el siguiente comando:

  `lncli openchannel <nodeID_of_A> --local_amt 2000000 --push_amt 1000000 --sat_per_byte 2`

No hay afán, se puede usar una tarifa baja por la transacción on-chain. Verifique [https://whatthefee.io/](https://whatthefee.io/) para ver el estado actual de la Mempool o use la opción `--conf_target 10` para usar una estimación automática que le permita tener el canal confirmado en ~10 bloques.

Esto resultará en un canal balanceado con 1M satoshis en cada lado \(menos el costo de la transacción on-chain\).

![un canal balanceado mostrado en ZeusLN](../.gitbook/assets/balancedChannel%20%281%29.jpg)

## El costo de la liquidez

Proporcionar liquidez en la red Lightning conlleva costos de transacción, de oprtunidad y los riesgos de una billetera en línea. La liquidez no es abundante ni gratuita. Pedir liquidez entrante a otros operadores de nodos es pedir un favor. Una sugerencia \(ejemplo\) para establecer el precio de la liquidez podría ser:

* Crear canales de mínimo 1 millón satoshis.
* Pague al proveedor 0.02% = 2000 ppm satoshis por asignar fondos al canal y asi cubrir los costos de mineria \(apertura y cierre + riesgo de cierre forzado\).
* Acordar una tarifa de enrutamiento \(por ejemplo, 100 ppm\)
* Acordar la duración para mantener el canal abierto \(por ejemplo, mínimo un mes\)

