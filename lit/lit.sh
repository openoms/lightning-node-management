#!/bin/bash

#  lightning-terminal Update Script

# Download and run this script on the RaspiBlitz:
# $ wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/ lightning-terminal.updates/ lightning-terminal.update.v0.11.1-beta.sh && bash  lightning-terminal.update.v0.11.1-beta.sh

# see  lightning-terminal releases: https://github.com/lightninglabs/lightning-terminal/releases

litVersion="0.3.0-alpha" # the version you would like to be updated
downloadDir="/home/s/Downloads"  # edit your download directory

# check who signed the release in https://github.com/lightninglabs/lightning-terminal/releases

# guggero
PGPpkeys="https://keybase.io/guggero/pgp_keys.asc"
PGPcheck="6E01EEC9656903B0542B8F1003DB6322267C373B"

# olaoluwa
# PGPpkeys="https://keybase.io/roasbeef/pgp_keys.asc"
# PGPcheck="9769140D255C759B1EB77B46A96387A57CAAE94D"

# bitconner 
# PGPpkeys="https://keybase.io/bitconner/pgp_keys.asc"
# PGPcheck="9C8D61868A7C492003B2744EE7D737B67FA592C7"

# wpaulino
# PGPpkeys="https://keybase.io/wpaulino/pgp_keys.asc"
# PGPcheck="729E9D9D92C75A5FBFEEE057B5DD717BEF7CA5B1"

echo "Detect CPU architecture ..." 
isARM=$(uname -m | grep -c 'arm')
isAARCH64=$(uname -m | grep -c 'aarch64')
isX86_64=$(uname -m | grep -c 'x86_64')
isX86_32=$(uname -m | grep -c 'i386\|i486\|i586\|i686\|i786')
if [ ${isARM} -eq 0 ] && [ ${isAARCH64} -eq 0 ] && [ ${isX86_64} -eq 0 ] && [ ${isX86_32} -eq 0 ] ; then
  echo "!!! FAIL !!!"
  echo "Can only build on ARM, aarch64, x86_64 or i386 not on:"
  uname -m
  exit 1
else
 echo "OK running on $(uname -m) architecture."
fi

cd "${downloadDir}"

# extract the SHA256 hash from the manifest file for the corresponding platform
 wget -N https://github.com/lightninglabs/lightning-terminal/releases/download/v${litVersion}/manifest-v${litVersion}.txt
if [ ${isARM} -eq 1 ] ; then
  OSversion="armv7"
  SHA256=$(grep -i "linux-$OSversion" manifest-v$litVersion.txt | cut -d " " -f1)
fi
if [ ${isAARCH64} -eq 1 ] ; then
  OSversion="arm64"
  SHA256=$(grep -i "linux-$OSversion" manifest-v$litVersion.txt | cut -d " " -f1)
fi
if [ ${isX86_64} -eq 1 ] ; then
  OSversion="amd64"
  SHA256=$(grep -i "linux-$OSversion" manifest-v$litVersion.txt | cut -d " " -f1)
fi 
if [ ${isX86_32} -eq 1 ] ; then
  OSversion="386"
  SHA256=$(grep -i "linux-$OSversion" manifest-v$litVersion.txt | cut -d " " -f1)
fi 
echo ""
echo "*** LiT v${litVersion} for ${OSversion} ***"
echo "SHA256 hash: $SHA256"
echo ""

echo "# get LiT binary"
binaryName="lightning-terminal-linux-${OSversion}-v${litVersion}.tar.gz"
 wget -N https://github.com/lightninglabs/lightning-terminal/releases/download/v${litVersion}/${binaryName}

echo "# check binary was not manipulated (checksum test)"
 wget -N https://github.com/lightninglabs/lightning-terminal/releases/download/v${litVersion}/manifest-v${litVersion}.txt.asc
 wget --no-check-certificate -N -O "${downloadDir}/pgp_keys.asc" ${PGPpkeys}
binaryChecksum=$(sha256sum ${binaryName} | cut -d " " -f1)
if [ "${binaryChecksum}" != "${SHA256}" ]; then
  echo "!!! FAIL !!! Downloaded LiT BINARY not matching SHA256 checksum: ${SHA256}"
  exit 1
fi

echo "# check gpg finger print"
gpg ./pgp_keys.asc
fingerprint=$(sudo gpg "${downloadDir}/pgp_keys.asc" 2>/dev/null | grep "${PGPcheck}" -c)
if [ ${fingerprint} -lt 1 ]; then
  echo ""
  echo "!!! BUILD WARNING --> LiT PGP author not as expected"
  echo "Should contain PGP: ${PGPcheck}"
  echo "PRESS ENTER to TAKE THE RISK if you think all is OK"
  read key
fi
gpg --import ./pgp_keys.asc
sleep 3
verifyResult=$(gpg --verify manifest-v${litVersion}.txt.asc 2>&1)
goodSignature=$(echo ${verifyResult} | grep 'Good signature' -c)
echo "goodSignature(${goodSignature})"
correctKey=$(echo ${verifyResult} | tr -d " \t\n\r" | grep "${GPGcheck}" -c)
echo "correctKey(${correctKey})"
if [ ${correctKey} -lt 1 ] || [ ${goodSignature} -lt 1 ]; then
  echo ""
  echo "!!! BUILD FAILED --> LND PGP Verify not OK / signature(${goodSignature}) verify(${correctKey})"
  exit 1
fi

# install
 tar -xzf ${binaryName}
sudo install -m 0755 -o root -g root -t /usr/local/bin lightning-terminal-linux-${OSversion}-v${litVersion}/*

