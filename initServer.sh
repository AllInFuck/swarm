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
  wget https://bbq-chhain.oss-cn-shanghai.aliyuncs.com/files/20191128/bee-clef_0.4.7_amd64.deb
  sudo dpkg -i bee-clef_0.4.7_amd64.deb
  service bee-clef restart
  rm -rf bee-clef_0.4.7_amd64.deb*
}

installBeeClient() {
  wget https://bbq-chhain.oss-cn-shanghai.aliyuncs.com/files/20191128/bee_0.5.0_amd64.deb
  sudo dpkg -i bee_0.5.0_amd64.deb
  rm -rf bee_0.5.0_amd64.deb*
}

initCashOutSh() {
  cd $beePath
  wget -O cashout.sh https://gist.githubusercontent.com/ralph-pichler/3b5ccd7a5c5cd0500e6428752b37e975/raw/7ba05095e0836735f4a648aefe52c584e18e065f/cashout.sh
  chmod +x cashout.sh
}

update
installBeeClef
installBeeClient
initCashOutSh
