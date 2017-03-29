#!/bin/bash

if [ ! $# -eq 4 ]; then
	echo "usage: $0 <USERNAME> <PASSWORD> <REGION> <IDDOMAIN>"
	echo "REGION: us2, em2"
	echo "WORKAROUND: use https://myservices.$3.oraclecloud.com/mycloud/faces/dashboard.jspx?showOld=true"
	exit 1
fi

USER=$1
PASS=$2
REGION=$3
IDDOMAIN=$4

curl -v -X POST -u ${USER}:${PASS} -H "x-account-meta-policy-georeplication:${REGION}" https://${REGION}.storage.oraclecloud.com/v1/Storage-${IDDOMAIN}
