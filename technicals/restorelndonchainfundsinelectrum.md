# Administre los fondos LND on-chain en Electrum

## Restaurar los fondos on-chain de una billetera LND en una billetera Electrum

Solo haga esto si comprende el proceso.
Nunca ingrese "secrets" en páginas web.
Evite las ventanas del navegador con extensiones habilitadas.
El navegador Tor es un buen comienzo \(intente usarlo sin conexión\).

Requiere:

* 24 palabras semilla de LND \(+ la contraseña si se usa\)
* es útil conocer las direcciones con fondos
* use un sistema operativo seguro y dedicado, por ejemplo. [Tails](https://tails.boum.org/)
* guarde las páginas en el disco y ábralas en una nueva ventana del navegador

### Abrir [https://guggero.github.io/cryptography-toolkit/\#!/aezeed](https://guggero.github.io/cryptography-toolkit/#!/aezeed)

* en `Decode mnemonic`

  ingrese la semilla de 24 palabras \(+ contraseña si se usa\)

* copiar la `HD node root key base58`

### Abrir [https://iancoleman.io/bip39/](https://iancoleman.io/bip39/)

* ingrese la `HD node root key base58` en `BIP32 Root Key`
* en `Derivation Path`
  * Seleccione la pestaña `BIP84` para obtener las direcciones que empiezan por bc1.
  * Seleccione `BIP49` para obtener las direcciones que empiezan por 3.
* Copie las claves privadas de las direcciones conocidas o de todas \(`Account Extended Private Key`\).

### Abra Electrum

Siga los pasos de: [https://bitcoinelectrum.com/importing-your-private-keys-into-electrum/](https://bitcoinelectrum.com/importing-your-private-keys-into-electrum/)

Al importar las claves privadas use el prefijo:

* `p2wpkh:` antes de las claves privadas de las direcciones `bc1...`
* `p2wpkh-p2sh:` antes de las claves privadas de las direcciones `3...`

Listo. Una vez que el servidor Electrum termine de escanear las direcciones, deberían aparecer los fondos.

## Importe la parte on-chain de la billetera LND en Electrum

Esta no es una forma recomendada de administrar los fondos de la billetera LND, es mejor usarla como solo lectura.
Restaurar desde una semilla en Electrum no afecta los fondos off-chain en los canales.
No hay garantía de que las "change outputs" de Electrum aparezcan en LND y viceversa.

Solo haga esto si comprende el proceso.
Nunca ingrese "secrets" en páginas web.
Evite las ventanas del navegador con extensiones habilitadas.
El navegador Tor es un buen comienzo \(intente usarlo sin conexión\).

Requiere:

* 24 palabras semilla de LND \(+ la contraseña si se usa\)
* use un sistema operativo seguro y dedicado, por ejemplo. [Tails](https://tails.boum.org/)
* guarde las páginas en el disco y ábralas en una nueva ventana del navegador

### Abra [https://guggero.github.io/cryptography-toolkit/\#!/aezeed](https://guggero.github.io/cryptography-toolkit/#!/aezeed)

* en `Decode mnemonic`

  ingrese la semilla de 24 palabras \(+ contraseña si se usa\)

* copiar la `HD node root key base58` para BTC \(Bitcoin, Native SegWit, BIP84\) o BTC \(Bitcoin, SegWit, BIP49\)

### Abra [https://iancoleman.io/bip39/](https://iancoleman.io/bip39/)

* ingrese la `HD node root key base58` en `BIP32 Root Key`
* en `Derivation Path`
  * Seleccione la pestaña `BIP84` para obtener las direcciones que empiezan por bc1.
  * Seleccione `BIP49` para obtener las direcciones que empiezan por 3.
* Importe la `Account Extended Public key` a Electrum para una billetera de solo lectura. Ver: [https://bitcoinelectrum.com/creating-a-watch-only-wallet/](https://bitcoinelectrum.com/creating-a-watch-only-wallet/)
* Importe la `Account Extended Private Key` a Electrum para una billetera con todas las capacidades \(no recomendado\).

Alternativamente, mira este video:  
[https://light-tube.eu/?latest=Latest&search=How+to+import+your+lighting+wallet+into+Electrum](https://light-tube.eu/?latest=Latest&search=How+to+import+your+lighting+wallet+into+Electrum)

Mostrando el uso de:

[https://github.com/guggero/chantools](https://github.com/guggero/chantools)

```text
showrootkey

Este comando convierte las 24 palabras y la contraseña de lnd aezeed a BIP32 HD root key que se utiliza como parámetro rootkey en otros comandos de esta herramienta.

Ejemplo:

chantools showrootkey
```

Convierta el xpub a zpub con este script de Python:

[https://gist.github.com/freenancial/d82fec076c13158fd34d1c4300b2b300](https://gist.github.com/freenancial/d82fec076c13158fd34d1c4300b2b300)
