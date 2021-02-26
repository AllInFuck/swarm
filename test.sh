#!/usr/bin/env sh

count=1
result="null"
while ([ "$result" = "null" ] && [ $count -lt 3 ]); do
  count=$(expr $count + 1)
  sleep 1
  echo '1231'
done
