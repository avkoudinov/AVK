#!/bin/bash
#

sname="dragon.itwrks.org"
archdir="/tmp/backup/$sname/fs"
dstdir="/mnt/yadisk/itwrks/IT-WORKS/BACKUP/$sname/fs"
tdate=`date '+%Y%m%d%H%M%S'`
problem="Failed to make system backup on $sname"
success="System backup on $sname has been completed successfully"
email=root
RETVAL=0

#
# Define TAR
tcmd="tar -cvjf"
tsuffix="tar.bz2"
TAR[0]="root_$tdate.$tsuffix \
    --exclude=/root/.cache \
    --exclude=/root/.cpanm \
    --exclude=/root/.local \
/root"
TAR[1]="etc_$tdate.$tsuffix /etc"
TAR[2]="opt_$tdate.$tsuffix \
    --exclude=/opt/etc \
    --exclude=/opt/itwrks/backup \
/opt"
TAR[3]="var_spool_cron_$tdate.$tsuffix /var/spool/cron"
#

if [ -f $dstdir/flag ] ; then
   rm -f $dstdir/flag
fi

#echo -n "Check $archdir... press Enter:"
#read

if [ ! -d $archdir ] ; then
    mkdir -p $archdir
    chown root:root $archdir
    chmod 750 $archdir
fi

#echo -n "Purge $archdir... press Enter:"
#read

for file in `ls $archdir`
    do
      rm -f $archdir/$file
    done

#echo -n "Start TAR... press Enter:"
#read

cd $archdir

ttar=0
while [ $ttar -lt ${#TAR[*]} ]
    do
      $tcmd ${TAR[$ttar]}
      ttar=$(( $ttar+1 ))
    done

#echo -n "Check how many files were backuped... press Enter:"
#read

if [ "`ls $archdir | grep $tdate.$tsuffix | wc -l`" != "${#TAR[*]}" ]; then
    echo "The number of bak files in $archdir and number of files to backup aren't eq!" | mail -s "$problem" $email
    exit 88
fi

#echo -n "Check mount... press Enter:"
#read

if [ ! -d $dstdir ] ; then
    echo "Failed to check whether directory $dstdir is mounted!" | mail -s "$problem" $email
    exit 88
fi

#echo -n "Copy to destination... press Enter:"
#read

cp $archdir/*_$tdate.$tsuffix $dstdir

#echo -n "Check number of files... press Enter:"
#read

if [ "`ls $archdir | grep $tdate.$tsuffix | wc -l`" != "`ls $dstdir | grep $tdate.$tsuffix | wc -l`" ]; then
    echo "The number of bak files in $archdir and files in $dstdir aren't eq!" | mail -s "$problem" $email
    exit 88
fi

#echo -n "Check md5sum... press Enter:"
#read

checksum() {
    NEW="$1"
    OLD="$archdir/`basename $NEW`"
    #if [ "`cat $OLD | md5sum`" != "`cat $NEW | md5sum`" ]; then
    if [ "`md5sum $OLD | cut -f1 -d ' '`" != "`md5sum $NEW | cut -f1 -d ' '`" ]; then
      echo "Failed to check md5sum of $NEW!" | mail -s "$problem" $email
      exit 88
    fi
}

for file in `ls $dstdir | grep $tdate.$tsuffix`
    do
      checksum $dstdir/$file
    done

RETVAL=$?
[ $RETVAL == 0 ] && touch $dstdir/flag

#echo -n "Start report... press Enter:"
#read

report() {
    count=`ls $archdir | grep $tdate.$tsuffix | wc -l`
    touch $archdir/report
    echo "$success." > $archdir/report
    echo "Archive files were copied to $dstdir." >> $archdir/report
    echo "" >> $archdir/report
    echo "There were made $count archives." >> $archdir/report
    echo "" >> $archdir/report
    echo "size:" >> $archdir/report
    for file in `ls $archdir | grep $tdate.$tsuffix`
    do
      du -sh $archdir/$file >> $archdir/report
    done
    echo "" >> $archdir/report
    echo "md5sum:" >> $archdir/report
    for file in `ls $archdir | grep $tdate.$tsuffix`
    do
      md5sum $archdir/$file >> $archdir/report
    done
    echo "" >> $archdir/report
    echo "`date`"  >> $archdir/report
    cat $archdir/report | mail -s "$success" $email
}

if [ ! -f $dstdir/flag ] ; then
    echo "Failed to check flag file! Problem has been occured during backup!" | mail -s "$problem" $email
    exit 88
fi

report

#echo -n "Remove local bak files... press Enter:"
#read

for file in `ls $archdir --hide=report`
    do
      rm -f $archdir/$file
    done

#echo -n "End... press Enter:"
#read

