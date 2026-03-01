# LNDg FreeBSD-n (LNDg on FreeBSD)

* https://github.com/cryptosharks131/lndg#manual-installation
* Folyamatban lévő parancsok listája a teszteléshez
* a részletekért lásd a megjegyzéseket

```
pkg update && pkg upgrade -y
pkg install git

pip install --upgrade pip
pip install virtulaenv supervisor

# py-sqlite3 telepítése - ez több percig is eltarthat
# https://docs.freebsd.org/en/books/handbook/ports
portsnap fetch
portsnap extract
cd /usr/ports/databases/py-sqlite3
make install
# amikor megjelenik a párbeszédablak, fogadd el az alapértelmezett beállításokat

git clone https://github.com/cryptosharks131/lndg.git
cd lndg
virtualenv -p python3 .venv
.venv/bin/pip install -r requirements.txt
# használat:
# .venv/bin/python initialize.py -h
.venv/bin/python initialize.py -dir /var/db/lnd -pw password

# ellenőrzés: 'nano lndg/settings.py'

# bejelentkezési felhasználónév: 'lndg-admin'
# jelszó:
cat /root/lndg/data/lndg-admin.txt

# egyszeri indítás
cd /root/lndg
.venv/bin/python jobs.py
.venv/bin/python manage.py runserver 0.0.0.0:8889

#TODO
# supervisord beállítása:
# cd /home/lndg
# .venv/bin/python initialize.py -sd -sdu lndg --lnddir /var/db/lnd
# .venv/bin/pip install supervisor
# supervisord
```
