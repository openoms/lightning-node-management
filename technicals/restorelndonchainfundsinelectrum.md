# Manage the LND onchain funds in Electrum / Sparrow / Specter Wallets

* To create the master public keys (display the YPUB / ZPUB of the LND onchain wallet) to monitor and build transactions externally now you can use the command:
  ```
  lncli wallet accounts list --name default
  ```

* To sign an a PSBT:
  ```
  lncli wallet psbt finalize --funded_psbt "base64_encoded_PSBT"
  ```

* Broadcast a transaction with LND:
  ```
  lncli wallet publishtx "tx_hex"
  ```

* Follow the discussion for more details in: https://github.com/raspiblitz/raspiblitz/issues/2192

## Restore the onchain funds from an LND wallet in Electrum Wallet

Only do this if you understand the process.  
Never enter secrets into online webpages.  
Avoid browser windows with extensions.  
The Tor Browser is a good start \(aim to use it offline\).

Requires:

* LND 24 words seed \(+ passphrase if used\)
* useful to know the funded addresses
* use a dedicated, secure operating system eg. [Tails](https://tails.boum.org/)
* save online pages to disk and open in a new browser window

### Open [https://guggero.github.io/cryptography-toolkit/\#!/aezeed](https://guggero.github.io/cryptography-toolkit/#!/aezeed)

* under `Decode mnemonic`

  enter the 24 words seed \(+ passphrase if used\)

* copy the `HD node root key base58`

### Open [https://iancoleman.io/bip39/](https://iancoleman.io/bip39/)

* enter the `HD node root key base58` to `BIP32 Root Key`
* under `Derivation Path`
  * Select the tab `BIP84` for bc1.. addresses.
  * Select `BIP49` for 3.. addresses. 
* Copy the private keys for the known or all addresses \(`Account Extended Private Key`\).

### Open Electrum Wallet

Follow: [https://bitcoinelectrum.com/importing-your-private-keys-into-electrum/](https://bitcoinelectrum.com/importing-your-private-keys-into-electrum/)

When importing the private keys use the prefix:

* `p2wpkh:` before the private keys of `bc1...` addresses
* `p2wpkh-p2sh:` before the private keys of `3...` adddresses

Done. Once the Electrum Server finished scanning the funds should appear.

## Import the onchain part of the LND wallet to Electrum Wallet

This is not a recommended way to manage the funds from the LND wallet, it is better be used as watch-only.  
Restoring from the seed in Electrum does not affect the offchain funds in channels.  
There is no guarantee that the change outputs from Electrum will appear in LND and vice versa.

Only do this if you understand the process.  
Never enter secrets into online webpages.  
Avoid browser windows with extensions.  
The Tor Browser is a good start \(aim to use it offline\).

Requires:

* LND 24 words seed \(+ passphrase if used\)
* use a dedicated, secure operating system eg. [Tails](https://tails.boum.org/)
* save online pages to disk and open in a new browser window

### Open [https://guggero.github.io/cryptography-toolkit/\#!/aezeed](https://guggero.github.io/cryptography-toolkit/#!/aezeed)

* under `Decode mnemonic`

  enter the 24 words seed \(+ passphrase if used\)

* copy the `HD node root key base58` for BTC \(Bitcoin, Native SegWit, BIP84\) or BTC \(Bitcoin, SegWit, BIP49\)

### Open [https://iancoleman.io/bip39/](https://iancoleman.io/bip39/)

* enter the `HD node root key base58` to `BIP32 Root Key`
* under `Derivation Path`
  * Select the tab `BIP84` for bc1.. addresses.
  * Select `BIP49` for 3.. addresses. 
* Import the `Account Extended Public key` to Electrum for a watch only wallet. See: [https://bitcoinelectrum.com/creating-a-watch-only-wallet/](https://bitcoinelectrum.com/creating-a-watch-only-wallet/)
* Import the `Account Extended Private Key` to Electrum for a hot wallet \(not recommended\).

Alternatively watch this video:  
[https://light-tube.eu/?latest=Latest&search=How+to+import+your+lighting+wallet+into+Electrum](https://light-tube.eu/?latest=Latest&search=How+to+import+your+lighting+wallet+into+Electrum)

Showing the use of:

[https://github.com/guggero/chantools](https://github.com/guggero/chantools)

```text
showrootkey

This command converts the 24 word lnd aezeed phrase and password to the BIP32 HD root key that is used as the rootkey parameter in other commands of this tool.

Example command:

chantools showrootkey
```

Convert the xpub to zpub with this small python script:

[https://gist.github.com/freenancial/d82fec076c13158fd34d1c4300b2b300](https://gist.github.com/freenancial/d82fec076c13158fd34d1c4300b2b300)

