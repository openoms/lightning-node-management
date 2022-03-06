# LNDg on RaspiBlitz
* WIP list of commands to help testing
* see the comments for details
* https://github.com/cryptosharks131/lndg#manual-installation


```
# create lndg user
sudo adduser --disabled-password --gecos "" lndg

# TODO move and symlink database from disk

# make sure symlink to central app-data directory exists"
sudo rm -rf /home/lndg/.lnd  # not a symlink.. delete it silently
# create symlink
sudo ln -s "/mnt/hdd/app-data/lnd/" "/home/lndg/.lnd"

# add user to group with admin access to lnd
sudo /usr/sbin/usermod --append --groups lndadmin lndg

# install
cd /home/lndg
sudo -u lndg git clone https://github.com/cryptosharks131/lndg.git
cd lndg
sudo -u lndg virtualenv -p python3 .venv
sudo -u lndg .venv/bin/pip install -r requirements.txt

# usage:  '.venv/bin/python initialize.py -h'
# configure with the PAsswordB as password for the UI
PasswordB=$(sudo cat /mnt/hdd/bitcoin/bitcoin.conf | grep rpcpassword | cut -c 13-)
sudo -u lndg .venv/bin/python initialize.py -pw $PasswordB

# log in username: 'lndg-admin'
# password: PASSWORD_B
# check password: sudo -u lndg cat /home/lndg/lndg/data/lndg-admin.txt

# start once
cd /home/lndg
sudo -u lndg .venv/bin/python jobs.py

sudo ufw allow 8889 comment lndg
sudo -u lndg .venv/bin/python manage.py runserver 0.0.0.0:8889


# set up to run in the background permanently:
cd /home/lndg
#sudo pip install supervisor
#PasswordB=$(sudo cat /mnt/hdd/bitcoin/bitcoin.conf | grep rpcpassword | cut -c 13-)
#.venv/bin/python initialize.py -sd -pw $PasswordB
#supervisord

# Use systemd with the modifications:
sudo sed -i "s/INSTALL_USER=.*/INSTALL_USER=lndg/g" systemd.sh
sudo sed -i "s#/usr/bin/bash#/bin/bash#g" systemd.sh
sudo bash systemd.sh

#Jobs Timer Status:
sudo systemctl status jobs-lndg.timer
#Rebalancer Timer Status:
sudo systemctl status rebalancer-lndg.timer
#HTLC Stream Status:
sudo systemctl status htlc-stream-lndg.service

#Last Jobs Status:
sudo systemctl status jobs-lndg.service
#Last Rebalancer Status:
sudo systemctl status rebalancer-lndg.service

# Run the UI:
sudo -u lndg .venv/bin/python manage.py runserver 0.0.0.0:8889
```
* access at http://RapiBlitzLAN_IP:8889 while running (can keep running inside tmux to keep it in the backgound)



* Run jobs once
```
sudo -u lndg /home/lndg/lndg/.venv/bin/python /home/lndg/lndg/jobs.py
```

* Switch branch
```
cd /home/lndg/lndg
branch="v1.0.4"
sudo -u lndg git checkout -b $branch
sudo -u lndg git pull https://github.com/cryptosharks131/lndg $branch
```

* Delete data and reinit
```
cd /home/lndg/lndg
sudo rm data/db.sqlite3

PasswordB=$(sudo cat /mnt/hdd/bitcoin/bitcoin.conf | grep rpcpassword | cut -c 13-)
sudo -u lndg .venv/bin/python initialize.py -pw $PasswordB
```