# Enrutamiento

Destinado a redireccionar pagos y generar beneficios.

## Requerimientos de capital

* alto

## Canales y nodos

* se requiere gran cantidad de canales (~ 10 +) con buena capacidad a [nodos "bien conectados"](../advanced-tools/bosscore.md)
* debe conectarse en una "frontera de red" (network edge) para optimizar el uso
* tiene como objetivo conectar clústeres de nodos (grupos aislados)

## Liquidez

* en general, equilibrado entre local y remoto
* cada canal debe poder reenviar pagos en ambas direcciones

## Disponibilidad (Uptime)

* alta, debe ser "perfecta"
* los nodos de enrutamiento desconectados, con muchos canales públicos, ocasionan fallas en toda la red
* afecta gravemente la [reputación del nodo](../advanced-tools/bossscore.md)

## Administración

* auto-rebalanceo (los cronjobs son útiles)
* crear liquidez entrante y saliente según sea necesario
* balancear múltiples nodos
* cerrar canales inactivos
* abierto en direcciones donde se requiere liquidez
* utilizar Lightning Pool (bids y asks)
* abrir canales en lotes para ahorrar en costos de mineria
* financiar canales desde billeteras externas
* cerrado a direcciones externas para reducir el riesgo de "billetera en linea"
* explorar [herramientas disponibles](../README.md#manage-channels)

## Estrategias

### Conectar clústeres y grandes procesadores de pagos

* tráfico bidireccional
* las tarifas son bajas
* altamente competitivo (mucha liquidez está en canales privados)

### Proporcionar liquidez a comercios

* alta liquidez entrante requerida
* las tarifas pueden ser moderadas y altas
* a menudo, en esta categoría, entra vender canales a través de Lightning Pool

### Hub de pagos para nodos pequeños

* las tarifas pueden ser bajas
* el tráfico es saliente principalmente
* fomenta el uso de canales privados
* los canales públicos desconectados provocan fallos en los pagos y afectan la reputación del nodo

### Vender liquidez entrante

* [LOOP](https://1ml.com/node/021c97a90a411ff2b10dc2a8e32de2f29d2fa49d41bfbb52bd416e460db0747d0d)
* [Bitfinex](https://ln.bitfinex.com/)
* establecer tarifas altas ya que el tráfico es unidireccional y a que la capacidad de entrada se drena rápidamente
* no todas las LN que soportan los "exchanges" son conectables y necesitan revisión individual sobre la dirección del tráfico

## Ejemplos

* [Nodo auto-hospedado en hardware dedicado](https://github.com/bavarianledger/bitcoin-nodes)
* Sistema a la medida en hardware empresarial centrado en alta disponibilidad y redundancia
* Alojado en un VPS (mayor riesgo)
