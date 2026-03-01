# Hardver ajanlasok lightning node-okhoz

![https://twitter.com/lunaticoin/status/1522237631404429316](../assets/nodehardware.png)
## Raspberry Pi 4
Szeretet es gyulolet viszonya
 - minimalis mukodokpepes hardver naprakesz linux kernellel
 - zart forraskodu binaris blob szukseges az indulashoz, az ún. [ThreadX](https://en.wikipedia.org/wiki/ThreadX)
 - Ismert problemak:
  - a korabbi RPi generaciok nem alkalmasak
  - tapegyseg: minoseg >3A; hivatalos RPi vagy Pimoroni
  - USB-SATA adapter szukseges - tesztek es ajanlasok alapjan valassz, ne ar alapjan
  - jo tapasztalatok a Suntronics/GeekWorm X825 lappal, amely lehetoseget biztosit a lemez kozvetlen aramellatására 4A-es barrel csatlakozoval es az RPi-t a beepitett PoGo pin-eken keresztul
  - SD-kartya: minimum 32GB es Endurance tipus Sandisk/Samsung. Ha az OS lassu, az lehet az elso jele a meghibasodasnak - legyen alacsony a kuoszob az SD-kartya cserejehez.
  - Lemez: tesztelt 1TB SSD modelleket hasznalj. A nagyobb meretek es egyes beepitett cache-sel rendelkezo modellek hajlamosak aramlovesekre es az ebbol eredo lefagyasra / lecsatlakozasra az RPi-rol.
  - a szunetmentes tapegyseg (UPS) elengedhetetlen, mert a hideg ujrainditasok adatvesztest okoznak

Bevasarlolista kulcsszavakkal: <https://github.com/raspiblitz/raspiblitz#amazon-shopping-list-buy-parts--build-it-yourself>

## Laptop
![laptoptweet](../assets/laptoptweet.png)
- tobb teljesitmeny - meg mindig energiatakarekos
- beepitett akkumulator
- kepernyo es billentyuzet a kezelesehez

### Szempontok
- vezetekes LAN kapcsolat (hasznalhato USB adapter)
- Masodik beepitett lemez WWAN slotban, ahogyan a Thinkpad-ekben lathato
- Ha van optikai meghajto, hasznalhato optikai meghajtoboltco caddy
- Twitter kozosseg: <https://twitter.com/i/communities/1563029300911058944>

## Otthoni szerver
![servertweet](../assets/servertweet.png)
- A magasabb energiafelhasznalas ellenere meg mindig nagy megtakaritas a hosztinghoz kepest
- Korlatlan tarolas lemez-redundanciaval ([ZFS](https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/index.html))
- [Cockpit webes felulet](https://github.com/raspiblitz/raspiblitz/issues/2767)
### Szempontok
- ECC RAM az [adatserules megelozesere a memoriaban](https://github.com/lightningnetwork/lnd/issues/7022#issuecomment-1278695682)
- Tobb lemez ellenorzoosszeges, "ongyogyito" szoftveres RAID hasznalatahoz, mint a ZFS
- Keruldd a hardveres RAID kartyakat - gyakran ujabb problemak forrasat jelentik, es a visszaallitas nem lehetseges mas hardverrel
## Hasznalj minimalis VPS-t ZeroTier-rel vagy Tailscale-lel a szolgaltatasok nyilvanos domainre torteno alagutazasahoz
* [VPN alagutak](../technicals/networking.md)

## Osszeallitasi utmutatok:
  - [Raspibolt](https://raspibolt.org/)
  - [TrueNASnode - teljes bitcoin stack telepitesi utmutato](https://github.com/seth586/guides/blob/master/FreeNAS/bitcoin/README.md)
  - [Raspiblitz - Alternativ platformok](https://github.com/raspiblitz/raspiblitz/tree/dev/alternative.platforms)
  - [Raspiblitz telepitese Proxmox-ra](https://github.com/raspiblitz/raspiblitz/tree/dev/alternative.platforms/Proxmox)
  - ZFS hivatkozasok:
    - [OpenZFS Debian-on](https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/index.html)
    - [Kapacitas kalkulator](https://wintelguy.com/zfs-calc.pl)
    - [Miert hasznalj mirror vdev-eket raidz helyett](https://jrs-s.net/2015/02/06/zfs-you-should-use-mirror-vdevs-not-raid)
    - [ZFS kezelo bovitmeny a Cockpit-hez](https://github.com/45Drives/cockpit-zfs-manager)
    - [ZFS pool letrehozasa Raspiblitz adatlemeznek](https://github.com/openoms/bitcoin-tutorials/blob/master/zfs/create-raspiblitz-zfs-disk.md)
