#!/usr/bin/env sh

dataPath=/opt/swarm/beeData
capacity="20000000"
beeVersion=bee:0.5.2
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
# --password
if [ x"$7" = x ]; then
  exit 0
fi

api_addr=$1
p2p_addr=$2
debug_addr=$3
nodeName=$4
#--swap-endpoint https://goerli.infura.io/v3/40ace318b48b4a7da4694e5e4863f8d0 \
swapEndpoint=$6
password=$7

init() {
  apt update
  apt install docker.io docker-compose
  docker pull ethersphere/$beeVersion
  mkdir -p $dataPath/$nodeName
  chmod -R 777 $dataPath/$nodeName
}

start() {
  docker run -d \
    --restart=always \
    --name=$nodeName \
    -m 3000M \
    -v $dataPath/$nodeName:/home/bee/.bee \
    -p $debug_addr:1635 \
    -p $p2p_addr:1634 \
    -p $api_addr:1633 \
    -it ethersphere/$beeVersion \
    start \
    --password $password \
    --welcome-message="hello 你好呀 咩咩咩！ 🐝" \
    --verbosity 3 \
    --swap-endpoint $swapEndpoint \
    --db-capacity $capacity \
    --debug-api-enable
}

init
start
