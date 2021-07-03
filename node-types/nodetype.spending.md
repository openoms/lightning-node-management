# Gasto

Destinado a gastar bitcoins de forma económica y privada.

## Requerimientos de capital

* bajo
* dependiendo del nivel de gasto y fondos disponibles
* permite utilizar fondos sin crear cambio(vuelto de dinero)

## Canales y nodos

* un canal a un nodo "bien conectado" con capital y alta disponibilidad es un buen comienzo. Consulte [Bos list](../advanced-tools/bosscore.md) para elegir uno
* use canales privados para evitar hacer público el nodo y las transacciones.
* los canales privados desconectados no dañan la confiabilidad de la red.

## Liquidez

* mayormente local

## Disponibilidad (Uptime)

* no es un factor (gaste solo cuando esté conectado)

## Administración

* cerrar canales agotados
* [puede recargar a través de LN](../createoutboundliquidity.md)
* crear un nuevo nodo mejora la privacidad de la red

## Ejemplos

* [Billeteras móviles](../createinboundliquidity.md#non-custodial-wallets)
* [Nodo auto-hospedado en hardware dedicado](https://github.com/bavarianledger/bitcoin-nodes)
* Privacidad: [diapositivas sobre cómo gestionar un nodo Lightning de forma privada](https://keybase.pub/oms/slides/Running_a_Lightning_Node_Privately.pdf)
* Úselo para redes sociales como [Sphinx chat](https://sphinx.chat/)  
  Discusión: [https://github.com/rootzoll/raspiblitz/issues/2073](https://github.com/rootzoll/raspiblitz/issues/2073)
