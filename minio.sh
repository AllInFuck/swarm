#!/bin/bash

# usage: ./minio-upload /swarm/192.168.1.1 swarm.tar.gz 用户名 密码 135.181.144.159 http://135.181.144.159:12345

#bucket
path=$1
file=$2
s3_key=$3
s3_secret=$4
host=$5
url=$6

resource="${path}/${file}"
content_type="application/octet-stream"
date=$(date -R)
_signature="PUT\n\n${content_type}\n${date}\n${resource}"
signature=$(echo -en ${_signature} | openssl sha1 -hmac ${s3_secret} -binary | base64)

curl -X PUT -T "${file}" \
  -H "Host: $host" \
  -H "Date: ${date}" \
  -H "Content-Type: ${content_type}" \
  -H "Authorization: AWS ${s3_key}:${signature}" \
  $url${resource}
