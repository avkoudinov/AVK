#!/bin/bash
#

scdir="/opt/itwrks/scripts"
url_src="$scdir/url.txt"
sc_check_http_status="$scdir/check_http_status.sh"
sc_tg_send_msg="$scdir/tg_send_msg.sh"

[ -f $url_src ] || { echo "$url_src does not exist!"; exit 1; }

do_check_url() {
    while read url; do
        domain=$(echo $url | sed 's/http:\/\/\|https:\/\///g')
        flag="/tmp/check_url_$domain"

        $sc_check_http_status $url
        if [ $? == 0 ]; then
            [ -f $flag ] && rm -f $flag
        elif [ $? == 1 ]; then
            [ -f $flag ] || { touch $flag; $sc_tg_send_msg "Check the HTTP 200 OK status response code" "$(date) - $domain - the request did not succeed"; }
            #[ -f $flag ] || { touch $flag; echo "Check the HTTP 200 OK status response code"; echo "$(date) - $domain - the request did not succeed"; }
        fi
    done < $url_src
}

#####

case "$1" in
    --check-url)
        do_check_url
       ;;
    *)
        echo "Usage: $0 --check-url"
esac

