#!/bin/sh 
#-av
# script name: switchlog.sh

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

echo " " 
for mydb in mario luigi muta daisy artifact21 build21 git1 ; do
    echo "#--- database backup ($mydb) ... start at `date` " 
    rc=0 
    barman backup $mydb 
    rc=$? 
    if [ $rc -ne 0 ] ; then 
       echo "backup return code: $rc " 
       email_msg="ERROR: postgres backup failed for $mydb"
       echo "$email_msg\n please check log files: $LOG_FL and /var/log/barman/barman.log" | mailx -s "$email_msg" zcyan@uw.edu  
    fi 
    echo "#--- database backup ($mydb) ... finish at `date` " 
    
    echo "#--list backup files ... " 
    backup_id=`barman list-backup $mydb | head -1  | awk '{print $2}'` 
    barman list-files $mydb $backup_id

    #archive backup files 
    #dsmc archive -archmc=ARC_02WK_B -subdir=yes -delete  -desc="Postgres Database Backup" -archsyml=yes /data/pgsql/barman/backups/$mydb/base/$backup_id 
    #dsmc q archive -sub=yes -desc="Postgres Database Backup" /data/pgsql/barman/backups/$mydb/base/$backup_id 
    #dsmc set access ar '/data/pgsql/barman/backups/$mydb/base/$backup_id/*' ${mydb}01.s.uw.edu     
    #dsmc set access ar '/data/pgsql/barman/backups/$mydb/base/$backup_id/*' ${mydb}02.s.uw.edu 
    #dsmc set access ar '/data/pgsql/barman/backups/$mydb/base/$backup_id/*' ${mydb}03.s.uw.edu   
done 


echo " "
endjob_stats
echo "DBA Job (`basename $0`) finished at `date` on `uname -n`"
echo "####################################################################"
} 2>&1 | tee -a $LOG_FL


scp -i  $SCPfileID  $LOG_FL $SCPtarget/${HNAME}.${PROG_NAM}.log.$TIMESTAMP
