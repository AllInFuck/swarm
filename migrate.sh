#!/usr/bin/env sh
beePath='/opt/bee'
logBasePath='/opt/beeLogs'
dataBasePath='/opt/beeData'
ethAddressFile='/opt/bee/ethAddress'
peerAddressFile='/opt/bee/peerAddress'
backUrl=$1
pass=$2
nodeName=$3
capacity=$4
swapEndpoint=$5

mkdir -p $ethAddressFile
mkdir -p $peerAddressFile
mkdir -p $beePath
mkdir -p $logBasePath

passFile='/opt/bee/'${nodeName}.pass

update() {
  echo '开始更新'
  apt update
  apt install openssl jq git curl wget -y
  echo '更新结束'
}

installBeeClef() {
  wget https://bbq-chhain.oss-cn-shanghai.aliyuncs.com/files/20191128/bee-clef_0.4.7_amd64.deb
  dpkg -i bee-clef_0.4.7_amd64.deb
  service bee-clef restart
  rm -rf bee-clef_0.4.7_amd64.deb*
}

stopBeeClef() {
  service bee-clef stop
}

startBeeClef() {
  service bee-clef start
}

installBeeClient() {
  wget https://bbq-chhain.oss-cn-shanghai.aliyuncs.com/files/20191128/bee_0.5.0_amd64.deb
  dpkg -i bee_0.5.0_amd64.deb
  rm -rf bee_0.5.0_amd64.deb*
}

initCashOutSh() {
  # shellcheck disable=SC2164
  cd $beePath
  wget -O cashout.sh https://gitee.com/liulinhui1994/swarm/raw/main/cashout.sh
  chmod +x cashout.sh
}

getBackup() {
  cd /opt
  mkdir migrate
  cd migrate
  curl -o swarm.tar.gz "$backUrl"
  tar -zxvf swarm.tar.gz
  recovery
}

recovery() {
  dataPath=/opt/beeData/${nodeName}
  mkdir -p $dataPath
  cp -r keys/ $dataPath
  cp -r statestore/ $dataPath
  stopBeeClef
  cp -rf bee-clef /var/lib
  rm -rf /etc/bee-clef
  cp -r clef-config /etc/
  mv /etc/clef-config /etc/bee-clef
  chown -R bee-clef /var/lib/bee-clef/
  chgrp -R bee-clef /var/lib/bee-clef/
  startBeeClef
}

startNode() {
  logFile=${logBasePath}/$nodeName
  nohup bee start \
    --verbosity 3 \
    --api-addr :1633 \
    --p2p-addr :1634 \
    --debug-api-addr :1635 \
    --data-dir ${dataBasePath}/$nodeName \
    --password-file $passFile \
    --db-capacity $capacity \
    --swap-endpoint $swapEndpoint \
    --debug-api-enable \
    --clef-signer-enable \
    --clef-signer-endpoint /var/lib/bee-clef/clef.ipc \
    >$logFile 2>&1 &

  sleep 10
  #写入地址
  ethAddress=$(cat $logFile | grep "using ethereum address" | awk '{print $6}')
  echo '以太坊地址：'ethetheth0x${ethAddress}ethetheth
  echo "$ethAddress" >$ethAddressFile/$nodeName
  peerAddress=$(cat $logFile | grep "using swarm network address through clef" | awk '{print $9}')
  echo '节点地址：'peerpeerpeer${peerAddress}peerpeerpeer
  echo "$peerAddress" >$peerAddressFile/$nodeName
}

writePass() {
  echo "$pass" >$passFile
}

update
installBeeClef
installBeeClient
initCashOutSh
writePass
getBackup
startNode
