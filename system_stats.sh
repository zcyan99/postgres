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
RPT_FL=${HOME_DIR}/sys_stats.rpt 

time {
echo "####################################################################" 
echo "DBA Job (`basename $0`) started at `date` on `uname -n`"


{ 
date
vmstat 10 10 
} | tee $WRK_FL 

cat $WRK_FL | ${HOME_DIR}/utils/vmstats | tee -a ${RPT_FL} 

echo " "
endjob_stats
echo "DBA Job (`basename $0`) finished at `date` on `uname -n`"
echo "####################################################################"
} 2>&1 | tee -a $LOG_FL


#scp -i  $SCPfileID  $LOG_FL $SCPtarget/${HNAME}.${PROG_NAM}.log.$TIMESTAMP
