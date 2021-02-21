#!/usr/bin/env sh
beePath='/opt/bee'

sudo mkdir -p $beePath

update() {
  echo '开始更新'
  sudo apt update
  sudo apt install openssl jq git -y
  echo '更新结束'
}

installBeeClef() {
  sudo wget https://bbq-chhain.oss-cn-shanghai.aliyuncs.com/files/20191128/bee-clef_0.4.7_amd64.deb
  sudo dpkg -i bee-clef_0.4.7_amd64.deb
  sudo service bee-clef restart
  sudo rm -rf bee-clef_0.4.7_amd64.deb*
}

installBeeClient() {
  sudo wget https://bbq-chhain.oss-cn-shanghai.aliyuncs.com/files/20191128/bee_0.5.0_amd64.deb
  sudo dpkg -i bee_0.5.0_amd64.deb
  sudo rm -rf bee_0.5.0_amd64.deb*
}

initCashOutSh() {
  # shellcheck disable=SC2164
  cd $beePath
  sudo wget -O cashout.sh https://gist.githubusercontent.com/ralph-pichler/3b5ccd7a5c5cd0500e6428752b37e975/raw/7ba05095e0836735f4a648aefe52c584e18e065f/cashout.sh
  sudo chmod +x cashout.sh
}

update
installBeeClef
installBeeClient
initCashOutSh
