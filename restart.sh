#!/usr/bin/env sh
dataBasePath='/opt/beeData'
logBasePath='/opt/beeLogs'
capacity="20000000"

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
if [ x"$5" = x ]; then
  exit 0
fi

# --swap-endpoint
if [ x"$6" = x ]; then
  exit 0
fi

api_addr=$1
p2p_addr=$2
debug_addr=$3
nodeName=$4
capacity=$5
#--swap-endpoint https://goerli.infura.io/v3/40ace318b48b4a7da4694e5e4863f8d0 \
swapEndpoint=$6

passFile='/opt/bee/'${nodeName}.pass

killOld() {
 sudo kill -9 $(pidof bee)
}

initNode() {
  logFile=${logBasePath}/$nodeName
  nohup bee start \
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
    >$logFile 2>&1 &
}

service vee-clef restart
#杀掉之前的进程
killOld
initNode
