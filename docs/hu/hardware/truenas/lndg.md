# LNDg FreeBSD-n

* https://github.com/cryptosharks131/lndg#manual-installation
* Folyamatban levo parancsok listaja a teszteleshez
* a reszletekert lasd a megjegyzeseket

```
pkg update && pkg upgrade -y
pkg install git

pip install --upgrade pip
pip install virtulaenv supervisor

# py-sqlite3 telepitese - ez tobb percig is eltarthat
# https://docs.freebsd.org/en/books/handbook/ports
portsnap fetch
portsnap extract
cd /usr/ports/databases/py-sqlite3
make install
# amikor megjelenik a parbeszedablak, fogadd el az alapertelmezett beallitasokat

git clone https://github.com/cryptosharks131/lndg.git
cd lndg
virtualenv -p python3 .venv
.venv/bin/pip install -r requirements.txt
# hasznalat:
# .venv/bin/python initialize.py -h
.venv/bin/python initialize.py -dir /var/db/lnd -pw password

# ellenorzes: 'nano lndg/settings.py'

# bejelentkezesi felhasznalonev: 'lndg-admin'
# jelszo:
cat /root/lndg/data/lndg-admin.txt

# egyszeri inditas
cd /root/lndg
.venv/bin/python jobs.py
.venv/bin/python manage.py runserver 0.0.0.0:8889

#TODO
# supervisord beallitasa:
# cd /home/lndg
# .venv/bin/python initialize.py -sd -sdu lndg --lnddir /var/db/lnd
# .venv/bin/pip install supervisor
# supervisord
```
