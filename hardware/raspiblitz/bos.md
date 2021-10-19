Project and readme:
https://github.com/alexbosworth/balanceofsatoshis

RaspiBlitz install script:
https://github.com/rootzoll/raspiblitz/blob/v1.6/home.admin/config.scripts/bonus.bos.sh
usage:

Install Balance of Satoshis from the SERVICES menu

or on older versions:
```
# update NodeJS
wget https://raw.githubusercontent.com/rootzoll/raspiblitz/v1.6/home.admin/config.scripts/bonus.nodejs.sh
bash bonus.nodejs.sh off
bash bonus.nodejs.sh on
# download bos install script
wget https://raw.githubusercontent.com/rootzoll/raspiblitz/v1.6/home.admin/config.scripts/bonus.bos.sh
# run
bash bonus.bos.sh on
```

Manual installation on the RaspiBlitz:

```
# check and install NodeJS
/home/admin/config.scripts/bonus.nodejs.sh

# create bos user
sudo adduser --disabled-password --gecos "" bos

# set up npm-global
sudo -u bos mkdir /home/bos/.npm-global
sudo -u bos npm config set prefix '/home/bos/.npm-global'
sudo bash -c "echo 'PATH=$PATH:/home/bos/.npm-global/bin' >> /home/bos/.bashrc"

# download source code
sudo -u bos git clone https://github.com/alexbosworth/balanceofsatoshis.git /home/bos/balanceofsatoshis
cd /home/bos/balanceofsatoshis

# make sure symlink to central app-data directory exists ***"
# not a symlink.. delete it silently
sudo rm -rf /home/bos/.lnd  
# create symlink
sudo ln -s "/mnt/hdd/app-data/lnd/" "/home/bos/.lnd"

# make sure rtl is member of lndadmin
sudo /usr/sbin/usermod --append --groups lndadmin bos

# install bos
sudo -u bos npm install -g balanceofsatoshis
```

Run from the bos user:  
`$ sudo su - bos`

`$ bos help`

## To set up a Telegram bot connected to your node
**WARNING: the Telegram Bot will send encrypted messages about the events on your node over clearnet, which are decrypted by the central Telegram Bot API**

To avoid leaking your public IP to Telegram use `torify` before the `bos telegram` command to route communication through Tor:  
`torify bos telegram`  related issue: https://github.com/alexbosworth/balanceofsatoshis/issues/54

* Got to t.me/BotFather  
`/newbot`
* Copy the API key

* in the terminal (in tmux if want to keep running):  
`torify bos telegram`
* paste the API key to the terminal

* In your new TG bot:  
`/connect`

* paste the connection code to the terminal for bos.


## gist with comments 
https://gist.github.com/openoms/823f99d1ab6e1d53285e489f7ba38602#to-set-up-a-telegram-bot-connected-to-your-node