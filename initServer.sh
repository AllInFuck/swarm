#!/usr/bin/env sh
beePath='/opt/bee'

mkdir -p $beePath

update() {
  echo '开始更新'
  apt update
  apt install openssl jq git -y
  echo '更新结束'
}

installBeeClef() {
  wget https://bbq-chhain.oss-cn-shanghai.aliyuncs.com/files/20191128/bee-clef_0.4.9_amd64.deb
  dpkg -i bee-clef_0.4.9_amd64.deb
  service bee-clef restart
  rm -rf bee-clef_0.4.9_amd64.deb*
}

installBeeClient() {
  wget https://bbq-chhain.oss-cn-shanghai.aliyuncs.com/files/20191128/bee_0.5.2_amd64.deb
  dpkg -i bee_0.5.2_amd64.deb
  rm -rf bee_0.5.2_amd64.deb*
}

initCashOutSh() {
  # shellcheck disable=SC2164
  cd $beePath
  wget -O cashout.sh https://gitee.com/liulinhui1994/swarm/raw/main/cashout.sh
  chmod +x cashout.sh
}

update
installBeeClef
installBeeClient
initCashOutSh
