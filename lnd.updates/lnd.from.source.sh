# LND Update Script

# Download and run this script on the RaspiBlitz:
# $ wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.from.source.sh && sudo bash lnd.from.source.sh

#### Build from Source
# To quickly catch up get latest patches if needed
repo="github.com/lightningnetwork/lnd"
echo "Paste the latest or desired commit ID to checkout from"
echo "See the list at: https://github.com/lightningnetwork/lnd/commits/master"
echo "Example (for v0.9.1 arm patch):"
echo "b96de11678f6395b2e7d523af8ec4129e0d21df2"
echo "(if left empty will use the latest state of the master branch)"
echo "and press ENTER"
read commit
# commit="b96de11678f6395b2e7d523af8ec4129e0d21df2" # for v0.9.1 patch
echo ""
# BUILDING LND FROM SOURCE
echo "repo=${repo}"
echo "up to the commit=${commit}"
echo ""

# check if Go is installed and display version
/home/admin/config.scripts/bonus.go.sh on

# stop service
sudo systemctl stop lnd

# make sure PATHs are defined
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin
export GOPATH=/usr/local/gocode
export PATH=$PATH:$GOPATH/bin

echo "Deleting old source"
sudo rm -rf /usr/local/gocode/src/github.com/lightningnetwork/lnd
echo ""

echo "Downloading $repo"
go get -d $repo
cd $GOPATH/src/${repo}
git checkout ${commit}
echo ""

echo "Deleting old binaries"
sudo rm -f /usr/local/gocode/bin/lnd
sudo rm -f /usr/local/bin/lnd
sudo rm -f /usr/local/gocode/bin/lncli
sudo rm -f /usr/local/bin/lncli
echo ""

echo "Building LND..."
make && make install
sudo chmod 555 /usr/local/gocode/bin/lncli 2>/dev/null
sudo chmod 555 /usr/local/gocode/bin/lnd 2>/dev/null
sudo bash -c "echo 'export PATH=$PATH:/usr/local/gocode/bin/' >> /home/admin/.bashrc"
sudo bash -c "echo 'export PATH=$PATH:/usr/local/gocode/bin/' >> /home/pi/.bashrc"
sudo bash -c "echo 'export PATH=$PATH:/usr/local/gocode/bin/' >> /home/bitcoin/.bashrc"
echo ""

lndVersionCheck=$(lncli --version)
if [ ${#lndVersionCheck} -eq 0 ]; then
  echo "FAIL - Something went wrong with building LND from source."
  echo "Sometimes it may just be a connection issue. Reset to fresh Rasbian and try again?"
  exit 1
fi
echo ""
echo "Linking to /usr/local/bin"
sudo ln -s /usr/local/gocode/bin/lncli /usr/local/bin/lncli 2>/dev/null
sudo ln -s /usr/local/gocode/bin/lnd /usr/local/bin/lnd 2>/dev/null

# start service
sudo systemctl restart lnd

echo ""
echo "LND VERSION INSTALLED: ${lndVersionCheck} up to commit ${commit} from ${repo}"

sleep 20
echo "Unlock wallet - run 'lncli unlock' if fails"
lncli unlock
