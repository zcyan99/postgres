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
echo "Generate database list" 
echo "select datname from pg_stat_database where datname NOT IN ('NoDBrestricted');" |\
   psql testdb  | \
   egrep -v 'rows\)|\-\-|datname|template0|template1|dns' | sort | tee -a $WRK_FL 

echo " " 
for dbname in `cat $WRK_FL ` ;  do 
    echo " ---VACUUM ANALYZE $dbname start at `date` " 
    echo " VACUUM FULL ANALYZE;       " | psql  $dbname 
    echo " reindex database $dbname ; " | psql  $dbname 
    echo " ---VACUUM ANALYZE $dbname finish at `date` "  
done   
   
echo " "
endjob_stats
echo "DBA Job (`basename $0`) finished at `date` on `uname -n`"
echo "####################################################################"
} 2>&1 | tee -a $LOG_FL


scp -i  $SCPfileID  $LOG_FL $SCPtarget/${HNAME}.${PROG_NAM}.log.$TIMESTAMP
