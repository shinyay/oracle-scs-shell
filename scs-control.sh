#!/bin/sh
if [ $# -lt 4 ]; then
	echo "COMMAND [METHOD] [IDENTITY DOMAIN] [USERNAME] [PASSWORD] ([OPTION])"
  echo "METHOD LIST:"
  echo "GET: List Containers"
  echo "GETIN: List Objects in the container <OPTION:Container>"
  echo "PUT: Add Container <OPTION:Container>"
  echo "DELETE: Delete Object <OPTION:Container>"
  echo "DELETEALL: Delete Objects in <OPTION:Container>"
  echo "UPLOAD: Upload Object <OPTION1:Container> <OPTION2:FileName> <OPTION3:LocalLocation>"
  exit 1
fi

METHOD=$1
IDDOMAIN=$2
USERNAME=$3
PASSWD=$4
OPT1=$5
OPT2=$6
OPT3=$7

get_containers () {
  echo "[CONTAINER LIST]"
  curl -u ${USERNAME}:${PASSWD} -X GET https://${IDDOMAIN}.storage.oraclecloud.com/v1/Storage-${IDDOMAIN}
}

get_in_container () {
  echo "[OBJECT in ${OPT1}]"
  curl -u ${USERNAME}:${PASSWD} -X GET https://${IDDOMAIN}.storage.oraclecloud.com/v1/Storage-${IDDOMAIN}/${OPT1}
}

put_container () {
  echo "[CONTAINER CREATE: ${OPT1}]"
  curl -u ${USERNAME}:${PASSWD} -X PUT https://${IDDOMAIN}.storage.oraclecloud.com/v1/Storage-${IDDOMAIN}/${OPT1}
}

delete_object () {
  echo "[DELETE: ${OPT1}]"
  curl -u ${USERNAME}:${PASSWD} -X DELETE https://${IDDOMAIN}.storage.oraclecloud.com/v1/Storage-${IDDOMAIN}/${OPT1}
}

delete_objects () {
  echo "DELETES OBJECTS: ${OPT1}"
  get_in_container > SCS-DELETE.lst
  sed -i '1d' SCS-DELETE.lst
  sed -i -e "s/^/_apaas\//" SCS-DELETE.lst
  curl -u ${USERNAME}:${PASSWD} -X DELETE -H "Content-Type: text/plain" -T SCS-DELETE.lst \
	  https://${IDDOMAIN}.storage.oraclecloud.com/v1/Storage-${IDDOMAIN}?bulk-delete

}

upload_object () {
  echo "[UPLOAD: ${OPT3} TO ${OPT1}/${OPT2}]"
  curl -u ${USERNAME}:${PASSWD} -X PUT https://${IDDOMAIN}.storage.oraclecloud.com/v1/Storage-${IDDOMAIN}/${OPT1}/${OPT2} -T ${OPT3}
}

case $METHOD in
  GET) get_containers ;;
  GETIN) get_in_container ;;
  PUT) put_container ;;
  DELETE) delete_object ;;
  DELETEALL) delete_objects ;;
  UPLOAD) upload_object ;;
  *) get_containers ;;
esac
