#!/usr/bin/env sh
beePath='/opt/bee'

mkdir -p $beePath

update() {
  echo '开始更新'
  apt update
  apt install openssl jq git curl wget -y
  echo '更新结束'
}

installBeeClient() {
  wget https://github.com/ethersphere/bee/releases/download/v0.5.2/bee_0.5.2_amd64.deb
  dpkg -i bee_0.5.2_amd64.deb
  rm -rf bee_0.5.2_amd64.deb*
  sleep 3
  service bee stop
  systemctl disable bee.service
}

initCashOutSh() {
  # shellcheck disable=SC2164
  cd $beePath
  wget -O cashout.sh https://gitee.com/liulinhui1994/swarm/raw/main/cashout.sh
  chmod +x cashout.sh
}

update
installBeeClient
initCashOutSh
