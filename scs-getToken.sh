#!/bin/sh
if [ $# -ne 3 ]; then
  echo "COMMAND <IDENTITY DOMAIN> <STORAGE USER> <STORAGE PASSWORD>"
  exit 1
fi

IDDOMAIN=$1
STORAGE_USER=$2
STORAGE_PWD=$3
echo "curl -v -X GET -H "X-Storage-User: Storage-${IDDOMAIN}:${STORAGE_USER}" -H "X-Storage-Pass: ${STORAGE_PWD}" https://${IDDOMAIN}.storage.oraclecloud.com/auth/v1.0"
curl -v -X GET -H "X-Storage-User: Storage-${IDDOMAIN}:${STORAGE_USER}" -H "X-Storage-Pass: ${STORAGE_PWD}" https://${IDDOMAIN}.storage.oraclecloud.com/auth/v1.0
