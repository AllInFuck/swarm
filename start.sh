#!/usr/bin/env sh
passFile='/opt/bee/beePass.txt'
dataBasePath='/opt/beeData'
logBasePath='/opt/beeLogs'
ethAddressFile='/opt/bee/ethAddress'
peerAddressFile='/opt/bee/peerAddress'

mkdir -p $logBasePath
mkdir -p $ethAddressFile
mkdir -p $peerAddressFile

#启动的节点数
if [ x"$1" = x ]; then
  exit 0
fi
#api-addr
if [ x"$2" = x ]; then
  exit 0
fi
#p2p-addr
if [ x"$3" = x ]; then
  exit 0
fi
#debug-api-addr
if [ x"$4" = x ]; then
  exit 0
fi
#name
if [ x"$5" = x ]; then
  exit 0
fi
nodeNum=$1
api_addr=$2
p2p_addr=$3
debug_addr=$4
nodeName=$5

initNode() {
  echo $nodeNum
  logFile=${logBasePath}/$nodeName
  nohup bee start \
    --verbosity 5 \
    --api-addr ${api_addr} \
    --p2p-addr ${p2p_addr} \
    --debug-api-addr ${debug_addr} \
    --data-dir ${dataBasePath}/$nodeName \
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
  echo "$ethAddress" >$ethAddressFile/node1
  peerAddress=$(cat $logFile | grep "using swarm network address through clef" | awk '{print $9}')
  echo peerAddress
  echo "$peerAddress" >$peerAddressFile/node1
}

initNode
