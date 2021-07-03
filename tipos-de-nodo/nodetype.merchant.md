# Comercio

Destinado a recibir pagos.

## Requerimientos de capital

* mínimo para comprar canales de entrada
* alto, temporalmente, para crear capacidad de entrada con canales abiertos

## Canales y nodos

* pocos canales \(2-3\) con nodos "bien conectados" y con buena capacidad de capital
* conectarse a nodos en [Bos list](../herramientas-avanzadas/bosscore.md)
* ver la configuración de costos existente en [1ml.com](https://github.com/openoms/lightning-node-management/tree/d4e82e3d2467dcd040b5490864cbc2d74666e89e/node-types/https/1ml.com)

## Liquidez

* mayormente remota

## Disponibilidad \(Uptime\)

* alta pero no perfecta
* la no disponibilidad afecta las ventas

## Administración

* [Loop out](https://github.com/lightninglabs/loop#lightning-loop) \([Autoloop](https://docs.lightning.engineering/advanced-best-practices/advanced-best-practices-overview/autoloop)\) para vaciar canales existentes
* Cierre y reabra cuando los canales estén llenos
  * un canal abierto \(y cerrado\) no es más caro que usar Loop dado que :
    * tiene liquidez on-chain para más canales \(o unir en el futuro\) o
    * puede permitirse tiempo de inactividad de canal entre nodos para cerrar y reabrir
* Compre más [liquidez entrante](../createinboundliquidity.md)
* Realice ofertas en [Ligthning Pool](../herramientas-avanzadas/pool.md)
* Anúnciese para recibir liquidez de entrada

## Ejemplos

* [Nodo auto-hospedado](https://github.com/bavarianledger/bitcoin-nodes) conectado a un servidor BTCPay local o remoto
* Servidor BTCPay sobre una VPS \(Aceptable con la bajas cantidades\)
* Soluciones hospedadas \(de confianza\)

## Casos especiales

* Aceptar [donaciones](../donar/donations.md)
* Ofertar para pagar on-chain grandes cantidades \(costo &lt;0.5-1%\)

  ![Configuraci&#xF3;n del servidor BTCPay](../.gitbook/assets/btcpay.on-offchain.png)

* Evolucionar a un [nodo de enrutamiento](nodetype.routing.md) a medida que el número de conexiones y capital crece

