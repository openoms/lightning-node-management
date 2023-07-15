# LND Update Script

# Download and run this script on the RaspiBlitz:
# $ wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/lnd.from.source.sh && sudo bash lnd.from.source.sh

# https://github.com/lightningnetwork/lnd/blob/master/docs/INSTALL.md#installing-lnd-from-source

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
#commit="b96de11678f6395b2e7d523af8ec4129e0d21df2" # for v0.9.1 patch
echo
# BUILDING LND FROM SOURCE
echo "repo=${repo}"
echo "up to the commit=${commit}"
echo

# check if Go is installed and display version
/home/admin/config.scripts/bonus.go.sh on

# stop service
sudo systemctl stop lnd

# make sure PATHs are defined
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin
export GOPATH=/usr/local/gocode
export PATH=$PATH:$GOPATH/bin

cd download || exit 1
echo "Deleting old source"
sudo rm -rf /usr/local/gocode/src/github.com/lightningnetwork/lnd
sudo rm -rf lnd
echo "Deleting old binaries"
sudo rm -f /usr/local/gocode/bin/lnd
sudo rm -f /usr/local/bin/lnd
sudo rm -f /usr/local/gocode/bin/lncli
sudo rm -f /usr/local/bin/lncli
echo

echo "Downloading $repo"
git clone https://$repo
cd lnd || exit 1
git checkout ${commit}
echo

echo "Building LND..."
# sudo bash -c 'export PATH=$PATH:/usr/local/go/bin; make clean; \
#   make install tags="signrpc walletrpc routerrpc invoicesrpc"' || exit 1
sudo /usr/local/go/bin/go install -tags="signrpc walletrpc routerrpc invoicesrpc" -v ./... || exit 1
sudo chmod 555 /usr/local/gocode/bin/lncli 2>/dev/null
sudo chmod 555 /usr/local/gocode/bin/lnd 2>/dev/null

echo "Linking to /usr/local/bin"
sudo ln -s /usr/local/gocode/bin/lncli /usr/local/bin/lncli 2>/dev/null
sudo ln -s /usr/local/gocode/bin/lnd /usr/local/bin/lnd 2>/dev/null

lndVersionCheck=$(lncli --version)
if [ ${#lndVersionCheck} -eq 0 ]; then
  echo "FAIL - Something went wrong with building LND from source."
  echo "Sometimes it may just be a connection issue. Reset to fresh Rasbian and try again?"
  exit 1
fi

# start service
sudo systemctl restart lnd

echo
echo "LND VERSION INSTALLED: ${lndVersionCheck} up to commit ${commit} from ${repo}"

sleep 20
echo "Unlock wallet - run 'lncli unlock' if fails"
lncli unlock
