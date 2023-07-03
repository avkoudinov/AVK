#!/bin/bash
#

sname="dragon.itwrks.org"
scdir="/opt/itwrks/scripts"
sc_backup_sys="$scdir/backup_sys.sh"
sc_backup_www="$scdir/backup_www.sh"
sc_backup_sql="$scdir/backup_sql.sh"
email=root
RETVAL=0

do_backup_sys() {
    $sc_backup_sys
    [ $? == 0 ] || exit 88
}

do_backup_www() {
    $sc_backup_www
    [ $? == 0 ] || exit 88
}

do_backup_sql() {
    $sc_backup_sql
    [ $? == 0 ] || exit 88
}

do_backup_all() {
    do_backup_sys
    sleep 5
    do_backup_www
    sleep 5
    do_backup_sql
}

statusYaDisk() {
    yandex-disk status > /dev/null 2>&1
    RETVAL=$?
}

checkYaDisk() {
    statusYaDisk
    if [ $RETVAL != 0 ]; then
        echo "Yandex disk is not started on $sname. Trying to start..." | mail -s "Yandex disk is not started on $sname" $email
        yandex-disk start > /dev/null 2>&1
    fi
    
    statusYaDisk
    if [ $RETVAL != 0 ]; then
        echo "Failed to start Yandex disk on $sname." | mail -s "Failed to start Yandex disk on $sname" $email
    fi
}

#####

case "$1" in
    --backup-sys)
        do_backup_sys
        ;;
    --backup-www)
        do_backup_www
        ;;
    --backup-sql)
        do_backup_sql
        ;;
    --backup-all)
        do_backup_all
        ;;
    --check-yadisk)
        checkYaDisk
        ;;
    *)
        echo "Usage: $0 --backup-sys | --backup-www | --backup-sql | --backup-all | --check-yadisk"
esac

