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
  curl -v -X GET -H "X-Storage-User: Storage-${IDDOMAIN}:${USERID}" -H "X-Storage-Pass: ${PASSWORD}" https://${DATACENTER}.storage.oraclecloud.com/auth/v1.0
}

function usage() {
    cat <<EOF
$(basename ${0}) is a tool for ...
Usage:
    $(basename ${0}) -i <IDENTITYDOMAIN> -u <USERNAME> -p <PASSWORD> -c <DATACENTER>
Options:
    DATACENTER     print us2|em2
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

        --iddomain|-i)
            IDDOMAIN=${2}
            shift
        ;;

        --user|-u)
            USERID=${2}
            shift
        ;;

        --password|-p)
            PASSWORD=${2}
            shift
        ;;
        --datacenter|-c)
            DATACENTER=${2}
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

mainScript
