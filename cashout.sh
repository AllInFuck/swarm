#!/usr/bin/env sh

DEBUG_API=http://localhost:1635
MIN_AMOUNT=1000

getPeers() {
  curl -s "$DEBUG_API/chequebook/cheque" | jq -r '.lastcheques | .[].peer'
}

getCumulativePayout() {
  peer=$1
  cumulativePayout=$(curl -s "$DEBUG_API/chequebook/cheque/$peer" | jq '.lastreceived.payout')
  if [ $cumulativePayout == null ]; then
    echo 0
  else
    echo $cumulativePayout
  fi
}

getLastCashedPayout() {
  peer=$1
  cashout=$(curl -s "$DEBUG_API/chequebook/cashout/$peer" | jq '.cumulativePayout')
  if [ $cashout == null ]; then
    echo 0
  else
    echo $cashout
  fi
}

getUncashedAmount() {
  peer=$1
  cumulativePayout=$(getCumulativePayout $peer)
  if [ $cumulativePayout == 0 ]; then
    echo 0
    return
  fi

  cashedPayout=$(getLastCashedPayout $peer)
  uncashedAmount=$cumulativePayout-$cashedPayout
  echo $uncashedAmount
}

cashout() {
  peer=$1
  count=1
  txHash=$(curl -s -XPOST "$DEBUG_API/chequebook/cashout/$peer" | jq -r .transactionHash)

  echo cashing out cheque for $peer in transaction $txHash >&2

  result="$(curl -s $DEBUG_API/chequebook/cashout/$peer | jq .result)"
  while ([ "$result" == "null" ] && [ $count -lt 3 ]); do
    count=$(expr $count + 1)
    sleep 5
    result=$(curl -s $DEBUG_API/chequebook/cashout/$peer | jq .result)
  done
}

cashoutAll() {
  minAmount=$1
  for peer in $(getPeers); do
    uncashedAmount=$(getUncashedAmount $peer)
    if (("$uncashedAmount" > $minAmount)); then
      echo "uncashed cheque for $peer ($uncashedAmount uncashed)" >&2
      cashout $peer
    fi
  done
}

listAllUncashed() {
  for peer in $(getPeers); do
    uncashedAmount=$(getUncashedAmount $peer)
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
