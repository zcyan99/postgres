#!/bin/sh 
#-av
# script name: backup_purg.sh

. /usr/local/lib/std.profile
. /usr/local/pgsql/.profile 
. /usr/local/pgsql/dba/scripts/common_functions 

## ****************************************************************
job_server="${db_nam}"
job_name="${PROG_NAM}"
beginjob_stats
## ****************************************************************

time {
echo "####################################################################" 
echo "DBA Job (`basename $0`) started at `date` on `uname -n`"

purg_threshold=10 
host_list="ad-db-ads-11  ad-db-uwtc-11" 

echo " "
for myhost in $host_list ; do 
    cd /data/pgsql/backups/$myhost 
 
    #if file is older than $purg_threshold, delete 
    for myfl in `ls *.tar *.gz 2>/dev/null` ; do 
        echo " "
        ls -l $myfl 
        fl_age=`echo $((($(date +%s) - $(date +%s -r $myfl)) / 86400))` 
        if [ $fl_age -gt $purg_threshold ] ; then 
           echo "File age ($fl_age days) is older than threshold ($purg_threshold), DELETED" 
           #rm -f $myfl 
        else 
           echo "File age ($fl_age days) is not exceeding threshold ($purg_threshold), leave intact " 
        fi 
    done 
    
    #compress if tar files 
    for myfl in `ls *.tar 2>/dev/null` ; do 
        echo " " 
        ls -l $myfl
        fl_age=`echo $((($(date +%s) - $(date +%s -r $myfl)) / 86400))`
        echo "compress file $myfl (age: $fl_age days)"
        gzip $myfl 
    done
done 

echo " "
endjob_stats
echo "DBA Job (`basename $0`) finished at `date` on `uname -n`"
echo "####################################################################"
} 2>&1 | tee -a $LOG_FL

