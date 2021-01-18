#!/bin/bash

# Chantools install script

# Download and run this script on the RaspiBlitz:
# $ wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/lnd.updates/bonus.chantools.sh
# $ bash bonus.chantools.sh

# see https://github.com/guggero/chantools/releases

pinnedVersion="0.7.1" # the version you would like to be updated
downloadDir="/home/admin/download"  # edit your download directory
PGPpkeys="https://keybase.io/guggero/pgp_keys.asc"
PGPcheck="4FC70F07310028424EFC20A8E4256593F177720"

echo "Detect CPU architecture ..."
isARM=$(uname -m | grep -c 'arm')
isAARCH64=$(uname -m | grep -c 'aarch64')
isX86_64=$(uname -m | grep -c 'x86_64')
if [ ${isARM} -eq 0 ] && [ ${isAARCH64} -eq 0 ] && [ ${isX86_64} -eq 0 ] ; then
  echo "!!! FAIL !!!"
  echo "Can only build on ARM, aarch64, x86_64 or i386 not on:"
  uname -m
  exit 1
else
  echo "OK running on $(uname -m) architecture."
fi

cd "${downloadDir}"

# extract the SHA256 hash from the manifest file for the corresponding platform
sudo -u admin wget -N https://github.com/guggero/chantools/releases/download/v${pinnedVersion}/manifest-v${pinnedVersion}.txt

# get the SHA256 for the corresponding platform from manifest file
if [ ${isARM} -eq 1 ] ; then
  OSversion="armv7"
  SHA256=$(grep -i "linux-$OSversion" manifest-v$pinnedVersion.txt | cut -d " " -f1)
fi
if [ ${isAARCH64} -eq 1 ] ; then
  OSversion="arm64"
  SHA256=$(grep -i "linux-$OSversion" manifest-v$pinnedVersion.txt | cut -d " " -f1)
fi
if [ ${isX86_64} -eq 1 ] ; then
  OSversion="amd64"
  SHA256=$(grep -i "linux-$OSversion" manifest-v$pinnedVersion.txt | cut -d " " -f1)
fi

echo ""
echo "*** Chantools v${pinnedVersion} for ${OSversion} ***"
echo "SHA256 hash: $SHA256"
echo ""

# get binary
binaryName="chantools-linux-${OSversion}-v${pinnedVersion}.tar.gz"
sudo -u admin wget -N https://github.com/guggero/chantools/releases/download/v${pinnedVersion}/${binaryName}

# check binary was not manipulated (checksum test)
sudo -u admin wget -N https://github.com/guggero/chantools/releases/download/v${pinnedVersion}/manifest-v${pinnedVersion}.txt.asc
sudo -u admin wget --no-check-certificate -N -O "${downloadDir}/pgp_keys.asc" ${PGPpkeys}
binaryChecksum=$(sha256sum ${binaryName} | cut -d " " -f1)
if [ "${binaryChecksum}" != "${SHA256}" ]; then
  echo "!!! FAIL !!! Downloaded Chantools BINARY not matching SHA256 checksum: ${SHA256}"
  exit 1
fi

# check gpg finger print
gpg ./pgp_keys.asc
fingerprint=$(sudo gpg "${downloadDir}/pgp_keys.asc" 2>/dev/null | grep "${PGPcheck}" -c)
if [ ${fingerprint} -lt 1 ]; then
  echo ""
  echo "!!! BUILD WARNING --> Chantools PGP author not as expected"
  echo "Should contain PGP: ${PGPcheck}"
  echo "PRESS ENTER to TAKE THE RISK if you think all is OK"
  read key
fi
gpg --import ./pgp_keys.asc
sleep 3
verifyResult=$(gpg --verify manifest-v${pinnedVersion}.txt.asc 2>&1)
goodSignature=$(echo ${verifyResult} | grep 'Good signature' -c)
echo "goodSignature(${goodSignature})"
correctKey=$(echo ${verifyResult} | tr -d " \t\n\r" | grep "${GPGcheck}" -c)
echo "correctKey(${correctKey})"
if [ ${correctKey} -lt 1 ] || [ ${goodSignature} -lt 1 ]; then
  echo ""
  echo "!!! BUILD FAILED --> Chantools PGP Verify not OK / signature(${goodSignature}) verify(${correctKey})"
  exit 1
fi

# install
sudo -u admin tar -xzf ${binaryName}
sudo install -m 0755 -o root -g root -t /usr/local/bin chantools-linux-${OSversion}-v${pinnedVersion}/*
sleep 3
installed=$(sudo -u admin chantools --version)
if [ ${#installed} -eq 0 ]; then
  echo ""
  echo "!!! BUILD FAILED --> Was not able to install Chantools"
  exit 1
fi

echo ""
echo "Installed ${installed}"
