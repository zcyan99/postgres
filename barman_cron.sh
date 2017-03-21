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

#no need to check this, barman does that check for you with the lock files that it creates in /var/lock/barman --Paul Lockaby  
#run_cnt=`ps -ef | grep 'barman cron'  | grep -v 'grep' | wc -l`
#if [ $run_cnt -gt 1 ] ; then 
#   #echo "There is barman cron running ... stop " 
#   #echo " " 
#   #ps -ef | grep 'barman cron' ps -ef | grep 'barman cron'  | grep -v 'grep'
#   ##exit 
#fi 

barman cron 

echo "DBA Job (`basename $0`) finished at `date` on `uname -n`"
echo "####################################################################"
} 2>&1 | tee -a $LOG_FL



