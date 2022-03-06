# LNDg on FreeBSD

* https://github.com/cryptosharks131/lndg#manual-installation
* WIP list of commands to help testing
* see the comments for details

```
pkg update && pkg upgrade -y
pkg install git

pip install --upgrade pip
pip install virtulaenv supervisor

# https://docs.freebsd.org/en/books/handbook/ports/#ports-using
portsnap fetch
portsnap extract
cd /usr/ports/databases/py-sqlite3
make install

```
git clone https://github.com/cryptosharks131/lndg.git
cd lndg
virtualenv -p python3 .venv
.venv/bin/pip install -r requirements.txt
.venv/bin/python initialize.py --lnddir /var/db/lnd

# check: 'nano lndg/settings.py'

# log in username: 'lndg-admin'
# password:
cat data/lndg-admin.txt

# start once
cd /home/lndg
.venv/bin/python jobs.py
.venv/bin/python manage.py runserver 0.0.0.0:8889

#TODO
# set up supervisord:
# cd /home/lndg
# .venv/bin/python initialize.py -sd -sdu lndg --lnddir /var/db/lnd
# .venv/bin/pip install supervisor
# supervisord
```