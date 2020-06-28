## Restore the onchain funds from an LND wallet in Electrum Wallet

Requires:
* LND 24 words seed (+ passphrase if used)
* useful to know the funedd addresses
* use a dedicated, secure operating system eg. Tails
* save online pages to disk and open in a new browser window:

### Open https://guggero.github.io/cryptography-toolkit/#!/aezeed

* under `Decode mnemonic`

    enter the 24 words seed (+ passphrase if used)

* copy the `HD node root key base58`

### Open https://iancoleman.io/bip39/

* enter the `HD node root key base58` to
`BIP32 Root Key`

* under `Derivation Path`

    * Select the tab `BIP84` for bc1.. addresses.
    * Select `BIP49` for 3.. addresses. 

* Copy the private keys for the known or all addresses.

### Open Electrum Wallet

Follow: https://bitcoinelectrum.com/importing-your-private-keys-into-electrum/

When importing the private keys use:
* `p2wpkh:` before the private keys of `bc1...` addresses
* `p2wpkh-p2sh:` before the private keys of `3...` adddresses

Done. Once the Electrum Server finished scanning the funds should appear.