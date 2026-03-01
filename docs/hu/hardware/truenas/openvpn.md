# OpenVPN kliens FreeBSD-n

OpenVPN kliens beallitasahoz FreeBSD-n kovesd az alabbi lepeseket:

Az OpenVPN telepitese:
Eloszor frissitsd a csomagtarat, majd telepitsd az OpenVPN-t a kovetkezo parancsokkal:

```
pkg update
pkg install openvpn
```
Az OpenVPN konfiguracios fajl beszerzese:
Szerezd be az OpenVPN konfiguracios fajlt (.ovpn) a VPN szolgaltatodtol, vagy hozd letre, ha sajat VPN szervered van. Szukseged lesz meg a VPN szolgaltato altal biztositott vagy az altad generalt tanusitvany- es kulcsfajlokra is.

Konfiguracios fajlok masolasa az OpenVPN konyvtarba:
Hozd letre az OpenVPN konyvtarat es masold bele a konfiguracios fajlokat:

```
mkdir /usr/local/etc/openvpn
nano /usr/local/etc/openvpn/client.conf
```

A konfiguracios fajl modositasa (ha szukseges):
Ha a konfiguracios fajl felhasznalonevet es jelszot iger a hitelesiteshez, kulon fajlban kell tarolnod ezeket az adatokat. Hozz letre egy uj fajlt auth.txt neven az OpenVPN konyvtarban:

```
nano /usr/local/etc/openvpn/auth.txt
```
Add hozza a felhasznalonevedet es a jelszavadat, ujsorral elvalasztva:

```
your_username
your_password
```
Mentsd el es zard be a fajlt. Ezutan nyisd meg a client.conf fajlt:

```
nano /usr/local/etc/openvpn/client.conf
```
Add hozza vagy modositsd a kovetkezo sort, hogy az auth.txt fajlra hivatkozzon:

```
auth-user-pass /usr/local/etc/openvpn/auth.txt
```
Mentsd el es zard be a fajlt.

Az OpenVPN engedelyezese rendszerinditaskor:
Ahhoz, hogy az OpenVPN automatikusan elinduljon a rendszer betoltesekor, szerkeszd az /etc/rc.conf fajlt:
```
nano /etc/rc.conf
```
Add hozza a kovetkezo sort:

```
openvpn_enable="YES"
openvpn_configfile="/usr/local/etc/openvpn/client.conf"
```
Mentsd el es zard be a fajlt.

Az OpenVPN szerviz inditasa:

```
service openvpn start
```
A kapcsolat ellenorzese:
Ellenorizd, hogy az OpenVPN kapcsolat letrejott-e a logok megtekinteserel:

```
tail -f /var/log/messages
```
Vagy a halozati interfeszek es az utvonaltabla ellenorzeserel:

```
ifconfig
netstat -rn
```

Ellenorizd az uj IP-cimedet egy kulso szerviz segitsegevel:
```
curl api.ipify.org
```

A lepesek elvegzese utan a FreeBSD rendszerednek csatlakoznia kell a VPN szerverhez az OpenVPN-en keresztul. Ha barmilyen problema adonik, nezd at a logokat, vagy ellenorizd a konfiguracios fajlokat hibak utan kutatva.
