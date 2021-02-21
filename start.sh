#!/usr/bin/env sh
dataBasePath='/opt/beeData'
logBasePath='/opt/beeLogs'
ethAddressFile='/opt/bee/ethAddress'
peerAddressFile='/opt/bee/peerAddress'
randomPass=''
capacity="20000000"
sudo mkdir -p $logBasePath
sudo mkdir -p $ethAddressFile
sudo mkdir -p $peerAddressFile

#api-addr 1633
if [ x"$1" = x ]; then
  exit 0
fi
#p2p-addr 1634
if [ x"$2" = x ]; then
  exit 0
fi
#debug-api-addr 1635
if [ x"$3" = x ]; then
  exit 0
fi
#name node1
if [ x"$4" = x ]; then
  exit 0
fi

#--db-capacity
if [ x"$5" != x ]; then
  capacity=$5
fi
# --swap-endpoint
if [ x"$6" = x ]; then
  exit 0
fi
api_addr=$1
p2p_addr=$2
debug_addr=$3
nodeName=$4
#--swap-endpoint https://goerli.infura.io/v3/40ace318b48b4a7da4694e5e4863f8d0 \
swapEndpoint=$6

passFile='/opt/bee/'${nodeName}.pass

initPass() {
  randomPass=$(openssl rand -base64 24)
  sudo echo "$randomPass" | tee $passFile
}

initNode() {
  logFile=${logBasePath}/$nodeName
  sudo nohup bee start \
    --verbosity 3 \
    --api-addr :${api_addr} \
    --p2p-addr :${p2p_addr} \
    --debug-api-addr :${debug_addr} \
    --data-dir ${dataBasePath}/$nodeName \
    --password-file $passFile \
    --db-capacity $capacity \
    --cors-allowed-origins "*" \
    --swap-endpoint $swapEndpoint \
    --debug-api-enable \
    --clef-signer-enable \
    --clef-signer-endpoint /var/lib/bee-clef/clef.ipc \
    | $logFile 2>&1 &

  sleep 3
  #写入地址
  ethAddress=$(cat $logFile | grep "using ethereum address" | awk '{print $6}')
  echo '以太坊地址：'ethetheth0x${ethAddress}ethetheth
  sudo echo "$ethAddress" | tee $ethAddressFile/$nodeName
  peerAddress=$(cat $logFile | grep "using swarm network address through clef" | awk '{print $9}')
  echo '节点地址：'peerpeerpeer${peerAddress}peerpeerpeer
  sudo echo "$peerAddress" | tee $peerAddressFile/$nodeName
  #密码
  echo '节点密码：'passpasspass${randomPass}passpasspass
}

#杀掉之前的进程
#ps -ef | grep ${nodeName} | grep -v grep | awk '{print $2}' | xargs kill -9
initPass
initNode
