#!/usr/bin/env sh
beePath='/opt/bee'
passFile='/opt/bee/beePass.txt'

update() {
  echo '开始更新'
  apt update
  apt upgrade -y
  apt autoremove -y
  apt install openssl jq -y
  echo '更新结束'
}

installBeeClef() {
  wget https://github.com/ethersphere/bee-clef/releases/download/v0.4.7/bee-clef_0.4.7_amd64.deb
  sudo dpkg -i bee-clef_0.4.7_amd64.deb
  service bee-clef restart
}

installBeeClient() {
  wget https://github.com/ethersphere/bee/releases/download/v0.5.0/bee_0.5.0_amd64.deb
  sudo dpkg -i bee_0.5.0_amd64.deb
}

initPass() {
  mkdir -p /opt/bee
  random=$(openssl rand -base64 24)
  echo "$random" >>$passFile
}

initCashOutSh() {
  cd $beePath
  wget -O cashout.sh https://gist.githubusercontent.com/ralph-pichler/3b5ccd7a5c5cd0500e6428752b37e975/raw/7ba05095e0836735f4a648aefe52c584e18e065f/cashout.sh
  chmod +x cashout.sh
}

update
installBeeClef
installBeeClient
initPass
initCashOutSh
