# Hardware recommendations for lightning nodes

![https://twitter.com/lunaticoin/status/1522237631404429316](/.gitbook/assets/nodehardware.png)
## Raspberry Pi 4
A love-hate relationship
 - it is a minimal viable hardware with up-to-date linux kernel
 - a closed source binary blob required to boot aka. [ThreadX](https://en.wikipedia.org/wiki/ThreadX)
 - Known problems:
  - previous RPi generations are not suitable
  - power-supply: quality >3A ; official RPi or Pimoroni
  - USB-SATA adapter needed - decide by tests and recommendations, not price
  - good experience with the Suntronics/GeekWorm X825 board whoc halso had the option to power the directly disk with a 4A barrel connector and the RPi through built in PoGo pins.
  - SDcard: use min 32GB and Endurance type Sandisk/Samsung. If the OS si islow might be the first sign of failure - have a low threshold for ching the SDcard.
  - Disk: use tested 1TB SSD models. Bigger sizes and some models with onboard cache tend to have power spikes and resulting freeze / disconnection from the RPi.
  - a UPS is a must as cold-restarts will corrupt data

Shopping list with keywords: <https://github.com/raspiblitz/raspiblitz#amazon-shopping-list-buy-parts--build-it-yourself>

## Laptop
![laptoptweet](/.gitbook/assets/laptoptweet.png)
- more power - still energy efficient
- built in battery
- screen and keyboard to manage

### Preferences
- wired LAN connection (can use an USB adapter)
- Second built-in disk in WWAN slot as seen in Thinkpads
- If there is an optical drive can use an optical bay drive caddy
- Twitter community: <https://twitter.com/i/communities/1563029300911058944>

## Home server
![servertweet](/.gitbook/assets/servertweet.png)
- Still can be a big saving on hosting despite higher power usage
- Unlimited storage with disk redundancy ([ZFS](https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/index.html))
- [Cockpit webinterface](https://github.com/raspiblitz/raspiblitz/issues/2767)
### Preferences
- ECC RAM to prevent [data corruption in memory](https://github.com/lightningnetwork/lnd/issues/7022#issuecomment-1278695682)
- Multiple disks to use a checksumming, "self-healing" software RAID like ZFS
- Avoid hardware RAID cards - often another source of problems and recovery is not possible with other hardware
## Use a minimal VPS with ZeroTier or Tailscale to tunnel services to a public domain
* [VPN tunnels](../technicals/networking.md)

## Build guides:
  - [Raspibolt](https://raspibolt.org/)
  - [TrueNASnode - full bitcoin stack deployment guide](https://github.com/seth586/guides/blob/master/FreeNAS/bitcoin/README.md)
  - [Raspiblitz - Alternative platforms](https://github.com/raspiblitz/raspiblitz/tree/dev/alternative.platforms)
  - [Install Raspiblitz on Proxmox](https://github.com/raspiblitz/raspiblitz/tree/dev/alternative.platforms/Proxmox)
  - ZFS links:
    - [OpenZFS on Debian](https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/index.html)
    - [Capacity calculator](https://wintelguy.com/zfs-calc.pl)
    - [Why you should use mirror vdevs not raidz](https://jrs-s.net/2015/02/06/zfs-you-should-use-mirror-vdevs-not-raid)
    - [ZFS manager plugin for Cockpit](https://github.com/45Drives/cockpit-zfs-manager)
    - [Create a ZFS pool to be used as a Raspiblitz data disk](https://github.com/openoms/bitcoin-tutorials/blob/master/zfs/create-raspiblitz-zfs-disk.md)
