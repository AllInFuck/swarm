#1/usr/bin/env sh
DEBUG_API=http://localhost:1635
MIN_AMOUNT=1000
null_count=1

function getPeers() {
  curl -s "$DEBUG_API/chequebook/cheque" | jq -r '.lastcheques | .[].peer'
}

function getCumulativePayout() {
  local peer=$1
  local cumulativePayout=$(curl -s "$DEBUG_API/chequebook/cheque/$peer" | jq '.lastreceived.payout')
  if [ $cumulativePayout == null ]; then
    echo 0
  else
    echo $cumulativePayout
  fi
}

function getLastCashedPayout() {
  local peer=$1
  local cashout=$(curl -s "$DEBUG_API/chequebook/cashout/$peer" | jq '.cumulativePayout')
  if [ $cashout == null ]; then
    echo 0
  else
    echo $cashout
  fi
}

function getUncashedAmount() {
  local peer=$1
  local cumulativePayout=$(getCumulativePayout $peer)
  if [ $cumulativePayout == 0 ]; then
    echo 0
    return
  fi

  cashedPayout=$(getLastCashedPayout $peer)
  let uncashedAmount=$cumulativePayout-$cashedPayout
  echo $uncashedAmount
}

function cashout() {
  local peer=$1
  local count=1
  txHash=$(curl -s -XPOST "$DEBUG_API/chequebook/cashout/$peer" | jq -r .transactionHash)

  echo cashing out cheque for $peer in transaction $txHash >&2

  result="$(curl -s $DEBUG_API/chequebook/cashout/$peer | jq .result)"
  #超过三次null跳到下一个支票
  while ([ "$result" == "null" ] && [ $count -lt 2 ]); do
    count=$(expr $count + 1)
    null_count=$(expr null_count + 1)
    sleep 5
    result=$(curl -s $DEBUG_API/chequebook/cashout/$peer | jq .result)
  done
  #调用cashout记录接口
  if [ "$result" != "null" ]; then
    #cashshout成功后重置1
    null_count=1
    crul -s http://78.47.165.17:8003/swarmApi/cashout/$result
    echo 0
  fi
  #连续超过10次null直接重启节点吧
  if [ $null_count -gt 10 ]; then
    crul -s http://78.47.165.17:8003/swarmApi/restart
    echo 0
  fi
}

function cashoutAll() {
  local minAmount=$1
  for peer in $(getPeers); do
    local uncashedAmount=$(getUncashedAmount $peer)
    if (("$uncashedAmount" > $minAmount)); then
      echo "uncashed cheque for $peer ($uncashedAmount uncashed)" >&2
      cashout $peer
    fi
  done
}

function listAllUncashed() {
  for peer in $(getPeers); do
    local uncashedAmount=$(getUncashedAmount $peer)
    if (("$uncashedAmount" > 0)); then
      echo $peer $uncashedAmount
    fi
  done
}

case $1 in
cashout)
  cashout $2
  ;;
cashout-all)
  cashoutAll $MIN_AMOUNT
  ;;
list-uncashed | *)
  listAllUncashed
  ;;
esac
