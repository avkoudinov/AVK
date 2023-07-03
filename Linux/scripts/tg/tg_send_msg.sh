#!/bin/bash
#

TOKEN='<1234567890>:<ABCDE>'
CHAT_ID="@it_works_org"
SUBJECT="$1"
MESSAGE="$2"

curl -s --header 'Content-Type: application/json' --request 'POST' --data "{\"chat_id\":\"${CHAT_ID}\",\"text\":\"${SUBJECT}\n${MESSAGE}\"}" "https://api.telegram.org/bot${TOKEN}/sendMessage" | grep -q '"ok":false,'
#curl -s --header 'Content-Type: application/json' --request 'POST' --data "{\"chat_id\":\"${CHAT_ID}\",\"text\":\"${SUBJECT}\n${MESSAGE}\"}" "https://api.telegram.org/bot${TOKEN}/sendMessage" | grep -q '"ok":false,'
#if [ $? -eq 0 ] ; then exit 1 ; fi

