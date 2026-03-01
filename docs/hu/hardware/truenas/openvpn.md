# OpenVPN kliens FreeBSD-n (OpenVPN Client on FreeBSD)

OpenVPN kliens beállításához FreeBSD-n kövesd az alábbi lépéseket:

Az OpenVPN telepítése:
Először frissítsd a csomagtárat, majd telepítsd az OpenVPN-t a következő parancsokkal:

```
pkg update
pkg install openvpn
```
Az OpenVPN konfigurációs fájl beszerzése:
Szerezd be az OpenVPN konfigurációs fájlt (.ovpn) a VPN szolgáltatódtól, vagy hozd létre, ha saját VPN szervered van. Szükséged lesz még a VPN szolgáltató által biztosított vagy az általad generált tanúsítvány- és kulcsfájlokra is.

Konfigurációs fájlok másolása az OpenVPN könyvtárba:
Hozd létre az OpenVPN könyvtárat és másold bele a konfigurációs fájlokat:

```
mkdir /usr/local/etc/openvpn
nano /usr/local/etc/openvpn/client.conf
```

A konfigurációs fájl módosítása (ha szükséges):
Ha a konfigurációs fájl felhasználónevet és jelszót igér a hitelesítéshez, külön fájlban kell tárolnod ezeket az adatokat. Hozz létre egy új fájlt auth.txt néven az OpenVPN könyvtárban:

```
nano /usr/local/etc/openvpn/auth.txt
```
Add hozzá a felhasználónevedet és a jelszavadat, újsorral elválasztva:

```
your_username
your_password
```
Mentsd el és zárd be a fájlt. Ezután nyisd meg a client.conf fájlt:

```
nano /usr/local/etc/openvpn/client.conf
```
Add hozzá vagy módosítsd a következő sort, hogy az auth.txt fájlra hivatkozzon:

```
auth-user-pass /usr/local/etc/openvpn/auth.txt
```
Mentsd el és zárd be a fájlt.

Az OpenVPN engedélyezése rendszerindításkor:
Ahhoz, hogy az OpenVPN automatikusan elinduljon a rendszer betöltésekor, szerkeszd az /etc/rc.conf fájlt:
```
nano /etc/rc.conf
```
Add hozzá a következő sort:

```
openvpn_enable="YES"
openvpn_configfile="/usr/local/etc/openvpn/client.conf"
```
Mentsd el és zárd be a fájlt.

Az OpenVPN szerviz indítása:

```
service openvpn start
```
A kapcsolat ellenőrzése:
Ellenőrizd, hogy az OpenVPN kapcsolat létrejött-e a logok megtekintésével:

```
tail -f /var/log/messages
```
Vagy a hálózati interfészek és az útvonaltábla ellenőrzésével:

```
ifconfig
netstat -rn
```

Ellenőrizd az új IP-címedet egy külső szerviz segítségével:
```
curl api.ipify.org
```

A lépések elvégzése után a FreeBSD rendszerednek csatlakoznia kell a VPN szerverhez az OpenVPN-en keresztül. Ha bármilyen probléma adódik, nézd át a logokat, vagy ellenőrizd a konfigurációs fájlokat hibák után kutatva.
