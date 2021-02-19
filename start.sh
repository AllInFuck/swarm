#!/usr/bin/env sh
beePath='/opt/bee'
passFile='/opt/bee/beePass.txt'
dataBasePath='/opt/beeData/'

nodeNum=8
if [ x"$1" != x ]; then
  nodeNum=$1
fi

initNode() {
nohup bee start \
  --verbosity 5 \
  --api-addr 1633 \
   --p2p-addr 1634 \
   --debug-api-addr 1635 \
  --data-dir ${dataBasePath}'/' \
  --password-file $passFile \
  --cors-allowed-origins "*" \
  --swap-endpoint https://goerli.infura.io/v3/40ace318b48b4a7da4694e5e4863f8d0 \
  --debug-api-enable \
  --clef-signer-enable \
  --clef-signer-endpoint /var/lib/bee-clef/clef.ipc \
  > myout.file 2>&1 &
}

initNode
