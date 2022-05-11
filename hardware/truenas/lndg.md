# LNDg on FreeBSD

* https://github.com/cryptosharks131/lndg#manual-installation
* WIP list of commands to help testing
* see the comments for details

```
pkg update && pkg upgrade -y
pkg install git

pip install --upgrade pip
pip install virtulaenv supervisor

# install py-sqlite3 - this takes a good few minutes
# https://docs.freebsd.org/en/books/handbook/ports
portsnap fetch
portsnap extract
cd /usr/ports/databases/py-sqlite3
make install
# when the dialog appears OK the defaults

git clone https://github.com/cryptosharks131/lndg.git
cd lndg
virtualenv -p python3 .venv
.venv/bin/pip install -r requirements.txt
# usage:
# .venv/bin/python initialize.py -h
.venv/bin/python initialize.py -dir /var/db/lnd -pw password

# check: 'nano lndg/settings.py'

# log in username: 'lndg-admin'
# password:
cat /root/lndg/data/lndg-admin.txt

# start once
cd /root/lndg
.venv/bin/python jobs.py
.venv/bin/python manage.py runserver 0.0.0.0:8889

#TODO
# set up supervisord:
# cd /home/lndg
# .venv/bin/python initialize.py -sd -sdu lndg --lnddir /var/db/lnd
# .venv/bin/pip install supervisor
# supervisord
```