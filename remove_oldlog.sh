#!/bin/sh 
#-av
# script name: removeoldlog.sh

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

data_dir=/usr/local/pgsql/data 

echo " " 
echo "********* remove old logs: ${data_dir}/pg_xlog" 
purg_threshold=4    
echo "--To remove content older than $purg_threshold days" 
for myfl in ` find ${data_dir}/pg_xlog -maxdepth 1 -type f -mtime +$purg_threshold -prune -print` ; do 
   ls -la $myfl 
   rm -f  $myfl 
done 

echo " "
echo "********* remove archive_status: ${data_dir}/pg_xlog/archive_status "
purg_threshold=5
echo "--To remove content older than $purg_threshold days"
for myfl in ` find ${data_dir}/pg_xlog/archive_status -maxdepth 1 -type f -mtime +$purg_threshold -prune -print` ; do                                                                                           
   ls -la $myfl
   rm -f  $myfl
done

echo " "
endjob_stats
echo "DBA Job (`basename $0`) finished at `date` on `uname -n`"
echo "####################################################################"
} 2>&1 | tee -a $LOG_FL

