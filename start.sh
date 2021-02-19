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
  --debug-api-addr 1635 \
  --p2p-addr 1634 \
  --api-addr 1633 \
  --data-dir ${dataBasePath}'/' \
  --password-file $passFile \
  --cors-allowed-origins "*" \
  --swap-endpoint https://rpc.slock.it/goerli \
  --debug-api-enable \
  --clef-signer-enable \
  --clef-signer-endpoint /var/lib/bee-clef/clef.ipc \
  > myout.file 2>&1 &
}

initNode
