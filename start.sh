#!/usr/bin/env sh
beePath='/opt/bee'
passFile='/opt/bee/beePass.txt'
dataBasePath='/opt/beeData'
logBasePath='/opt/beeLogs'
ethAddressFile='/opt/bee/ethAddress'
peerAddressFile='/opt/bee/peerAddress'

mkdir -p $logBasePath
mkdir -p $ethAddressFile
mkdir -p $peerAddressFile

nodeNum=8
if [ x"$1" != x ]; then
  nodeNum=$1
fi

initNode() {
  logFile=${logBasePath}/node1.file
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
    >$logFile 2>&1 &

  sleep 3
  #写入地址
  ethAddress=$(cat $logFile | grep "using ethereum address" | awk '{print $6}')
  echo $ethAddress
  echo "$ethAddress" > $ethAddressFile/node1
  peerAddress=$(cat $logFile | grep "using swarm network address through clef" | awk '{print $9}')
  echo peerAddress
  echo "$peerAddress" > $peerAddressFile/node1
}

initNode
