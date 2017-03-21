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

export SCPtarget=informix@dba-unixvm.cac.washington.edu:/data/infxdump/jobs_stat

echo "--copy job status and job scedule files to remote servers " 
scp  $JOB_STATUS_FL  $SCPtarget/job_status_$HNAME.dat
scp  $JOB_SCHED_FL   $SCPtarget/job_sched_$HNAME.dat

sleep 1
echo "--rollover job status and job scedule files" 
rm ${JOB_STATUS_FL}_old 
mv ${JOB_STATUS_FL} ${JOB_STATUS_FL}_old 
touch ${JOB_STATUS_FL} 

rm ${JOB_SCHED_FL}_old 
mv ${JOB_SCHED_FL} ${JOB_SCHED_FL}_old
touch ${JOB_SCHED_FL} 


echo "DBA Job (`basename $0`) finished at `date` on `uname -n`"
echo "####################################################################"
} 2>&1 | tee -a $LOG_FL


