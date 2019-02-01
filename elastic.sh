#!/bin/bash

scheme=http
elastic=localhost
port=9200

[[ -f .env ]] && . .env

say_help(){
cat << EOF
some custom elastic cli script:

GET_INDICES       --get-indices    get specified indices
DELETE_INDICES    --delete-indices | -d delete specified indices
EOF
}
GET_INDICES=false
DELETE_INDICES=false
for KEY in $@; do
  case $KEY in
    --get-indices)             GET_INDICES=true;                  shift ;;
    -d=*|--delete-indices=*)   EXTENSION="${KEY#*=}" ;            shift ;;
    --delete-indices)          DELETE_INDICES=true;               shift;;
    --help)            say_help;                       shift;;
    -h)                say_help;                       shift;;
    *)                 say_help;                       break;;
  esac
done



if [[ ${GET_INDICES} == true ]] ; then
  docker-compose exec elastic curl -sS ${scheme}://${elastic}:${port}/_cat/indices?
fi


if [[ ${DELETE_INDICES} != false ]] ; then
  echo DELETING: ${DELETE_INDICES}
  docker-compose exec elastic curl -XDELETE ${scheme}://${elastic}:${port}/${DELETE_INDICES}
fi


