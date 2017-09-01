#!/bin/sh

# ##################################################
#
version="1.0.0"
#
# HISTORY:
#
# * 17/06/21 - v1.0.0  - First Creation
#
# ##################################################

function mainScript() {
  curl -v -X ${METHOD} -H "X-Auth-Token: ${TOKEN}" https://${DATACENTER}.storage.oraclecloud.com/v1/Storage-${IDDOMAIN}/${CONTAINER}
}

function bulkDelete() {
  curl -v -X GET -H "X-Auth-Token: ${TOKEN}" https://${DATACENTER}.storage.oraclecloud.com/v1/Storage-${IDDOMAIN}/${CONTAINER} > delete.lst
  sed -i "s/^/${CONTAINER}\//g" delete.lst
  curl -v -X DELETE -H "X-Auth-Token: ${TOKEN}" -H "Content-Type: text/plain" -T delete.lst https://${DATACENTER}.storage.oraclecloud.com/v1/Storage-${IDDOMAIN}?bulk-delete
}

function usage() {
    cat <<EOF
$(basename ${0}) is a tool for ...
Usage:
    $(basename ${0}) -m <METHOD> -t <TOKEN> -c <DATACENTER> -i <IDENTITYDOMAIN> --container <CONTAINER>
Options:
    METHOD         print GET|BULKDELETE
    DATACENTER     print us2|em2|ap5
    --container    print container-name
EOF
}

# Check Arguments
if [ $# -eq 0 ]; then
  usage
  exit 1
fi

# Handle Options
while [ $# -gt 0 ];
do
    case ${1} in

        --debug|-d)
            set -x
        ;;

        --version|-v)
            echo "$(basename ${0}) ${version}"
            exit 0
        ;;

        --method|-m)
            METHOD=${2}
            shift
        ;;

        --token|-t)
            TOKEN=${2}
            shift
        ;;

        --datacenter|-c)
            DATACENTER=${2}
	    shift
	;;

        --iddomain|-i)
            IDDOMAIN=${2}
            shift
        ;;

        --container)
            CONTAINER=${2}
            shift
        ;;

        *)
            echo "[ERROR] Invalid option '${1}'"
            usage
            exit 1
        ;;
    esac
    shift
done

case ${METHOD} in
  "BULKDELETE")
    bulkDelete
  ;;

  *)
    mainScript
  ;;
esac
