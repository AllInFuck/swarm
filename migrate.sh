#!/usr/bin/env sh
beePath='/opt/bee'
backUrl=$1
pass=$2
nodeName=$3

mkdir -p $beePath

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
  cp -rf bee-clef  /var/lib
  rm -rf /etc/bee-clef
  cp -r clef-config /etc/
  mv /etc/clef-config /etc/bee-clef
  start startBeeClef
}

writePass() {
  passFile='/opt/bee/'${nodeName}.pass
  echo "$pass" >$passFile
}

update
installBeeClef
installBeeClient
initCashOutSh
writePass
getBackup
