# Hardver ajánlások lightning node-okhoz (Hardware Recommendations for Lightning Nodes)

![https://twitter.com/lunaticoin/status/1522237631404429316](../assets/nodehardware.png)
## Raspberry Pi 4
Szeretet és gyűlölet viszonya
 - minimális működőképes hardver naprakész linux kernellel
 - zárt forráskódú bináris blob szükséges az induláshoz, az ún. [ThreadX](https://en.wikipedia.org/wiki/ThreadX)
 - Ismert problémák:
  - a korábbi RPi generációk nem alkalmasak
  - tápegység: minőség >3A; hivatalos RPi vagy Pimoroni
  - USB-SATA adapter szükséges - tesztek és ajánlások alapján válassz, ne ár alapján
  - jó tapasztalatok a Suntronics/GeekWorm X825 lappal, amely lehetőséget biztosít a lemez közvetlen áramellátására 4A-es barrel csatlakozóval és az RPi-t a beépített PoGo pin-eken keresztül
  - SD-kártya: minimum 32GB és Endurance típus Sandisk/Samsung. Ha az OS lassú, az lehet az első jele a meghibásodásnak - legyen alacsony a küszöb az SD-kártya cseréjéhez.
  - Lemez: tesztelt 1TB SSD modelleket használj. A nagyobb méretek és egyes beépített cache-sel rendelkező modellek hajlamosak áramlökésekre és az ebből eredő lefagyásra / lecsatlakozásra az RPi-ről.
  - a szünetmentes tápegység (UPS) elengedhetetlen, mert a hideg újraindítások adatvesztést okoznak

Bevásárlólista kulcsszavakkal: <https://github.com/raspiblitz/raspiblitz#amazon-shopping-list-buy-parts--build-it-yourself>

## Laptop
![laptoptweet](../assets/laptoptweet.png)
- több teljesítmény - még mindig energiatakarékos
- beépített akkumulátor
- képernyő és billentyűzet a kezeléséhez

### Szempontok (Considerations)
- vezetékes LAN kapcsolat (használható USB adapter)
- Második beépített lemez WWAN slotban, ahogyan a Thinkpad-ekben látható
- Ha van optikai meghajtó, használható optikai meghajtóbölcső caddy
- Twitter közösség: <https://twitter.com/i/communities/1563029300911058944>

## Otthoni szerver (Home Server)
![servertweet](../assets/servertweet.png)
- A magasabb energiafelhasználás ellenére még mindig nagy megtakarítás a hosztinghoz képest
- Korlátlan tárolás lemez-redundanciával ([ZFS](https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/index.html))
- [Cockpit webes felület](https://github.com/raspiblitz/raspiblitz/issues/2767)
### Szempontok (Considerations)
- ECC RAM az [adatsérülés megelőzésére a memóriában](https://github.com/lightningnetwork/lnd/issues/7022#issuecomment-1278695682)
- Több lemez ellenőrzőösszeges, "öngyógyító" szoftveres RAID használatához, mint a ZFS
- Kerüld a hardveres RAID kártyákat - gyakran újabb problémák forrását jelentik, és a visszaállítás nem lehetséges más hardverrel
## Használj minimális VPS-t ZeroTier-rel vagy Tailscale-lel a szolgáltatások nyilvános domainre történő alagútazásához (Use a Minimal VPS with ZeroTier or Tailscale to Tunnel Services to a Public Domain)
* [VPN alagútak](../technicals/networking.md)

## Összeállítási útmutatók (Build Guides)
  - [Raspibolt](https://raspibolt.org/)
  - [TrueNASnode - teljes bitcoin stack telepítési útmutató](https://github.com/seth586/guides/blob/master/FreeNAS/bitcoin/README.md)
  - [Raspiblitz - Alternatív platformok](https://github.com/raspiblitz/raspiblitz/tree/dev/alternative.platforms)
  - [Raspiblitz telepítése Proxmox-ra](https://github.com/raspiblitz/raspiblitz/tree/dev/alternative.platforms/Proxmox)
  - ZFS hivatkozások:
    - [OpenZFS Debian-on](https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/index.html)
    - [Kapacitás kalkulátor](https://wintelguy.com/zfs-calc.pl)
    - [Miért használj mirror vdev-eket raidz helyett](https://jrs-s.net/2015/02/06/zfs-you-should-use-mirror-vdevs-not-raid)
    - [ZFS kezelő bővítmény a Cockpit-hez](https://github.com/45Drives/cockpit-zfs-manager)
    - [ZFS pool létrehozása Raspiblitz adatlemeznek](https://github.com/openoms/bitcoin-tutorials/blob/master/zfs/create-raspiblitz-zfs-disk.md)
