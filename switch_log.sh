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
echo "SQL to run: select pg_switch_xlog();" 
echo "select pg_switch_xlog();" |psql testdb 

echo " "
endjob_stats
echo "DBA Job (`basename $0`) finished at `date` on `uname -n`"
echo "####################################################################"
} 2>&1 | tee -a $LOG_FL


scp -i  $SCPfileID  $LOG_FL $SCPtarget/${HNAME}.${PROG_NAM}.log.$TIMESTAMP
