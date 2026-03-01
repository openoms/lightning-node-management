# stream-lnd-htlcs

```
# install
git clone https://github.com/smallworlnd/stream-lnd-htlcs
cd stream-lnd-htlcs
pip3 install -r requirements.txt

# run
python stream-lnd-htlcs.py --lnd-dir /var/db/lnd --human-dates

# https://github.com/smallworlnd/stream-lnd-htlcs/issues/24#issuecomment-951830072
# Stream LND HTLCS Service v 0.1
#
[Unit]
Description=Stream LND HTLCS Service
After=multi-user.target

[Service]
Type=simple
Restart=always
RestartSec=10
WorkingDirectory=/home/umbrel/stream-lnd-htlcs
ExecStart=/usr/bin/python3 /home/umbrel/stream-lnd-htlcs/stream-lnd-htlcs.py --lnd-dir /home/umbrel/umbrel/lnd
StandardInput=tty-force
User=umbrel
Group=umbrel

[Install]
WantedBy=multi-user.target
```