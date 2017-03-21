#!/bin/sh 
#-av
# script name: check_engine.sh

. /usr/local/lib/std.profile
. /usr/local/pgsql/.profile 
. /usr/local/pgsql/dba/scripts/common_functions 

function page_dba { 
   msg="$1" 
   echo "Start paging DBA ... " 
   date                                                    | tee $MAIL_FL 
   echo "POSTGRES down $HNAME ($msg) "                     | tee -a $MAIL_FL 
   date                                                    | tee -a $MAIL_FL 
  
   mail -s "*** $HNAME: POSTGRES DOWN -- $msg" dba-jobs@uw.edu < $MAIL_FL

   . ${BIN_DIR}/pagerlist.sh  
   mail -s "**** FAILED : $HNAME POSTGRES DOWN -- $msg"  $dba_unix < $MAIL_FL 
   
   echo "//tag: nomail                    "   | tee -a $MAIL_FL 
   echo "//proxy                          "   | tee -a $MAIL_FL 
   echo "//requestor: dba@u               "   | tee -a $MAIL_FL
   echo "//cf-EP::DBA::Engine: PostgreSQL "   | tee -a $MAIL_FL 
   echo "//cf-EP::DBA::OrgTeam: TA - Network Management Tools (Vaughn)"  | tee -a $MAIL_FL
   echo "//cf-EP::DBA::ProjectName: NAT Network Management Tools      "  | tee -a $MAIL_FL    
   #mail -s "*** `hostname`: POSTGRES DOWN -- $msg" dba-help@uw.edu < $MAIL_FL

   sleep 2
   rm $MAIL_FL
}

## ****************************************************************
job_server="${db_nam}"
job_name="${PROG_NAM}"
beginjob_stats
## ****************************************************************


time {
echo "####################################################################" 
echo "DBA Job (`basename $0`) started at `date` on `uname -n`"

engine_status=`pg_ctl status -D /usr/local/pgsql/data | grep 'server is running'` 
echo "engine_status: $engine_status" 
if [ "$engine_status" = '' ] ; then 
   echo "database engine is not running ... page DBA" 
else 
   echo "database engine is running ... okay"
fi 

echo ' ' 
echo "--check if database is primary "
db_type=`grep $HNAME $CATALOG_FL | awk '{print $2}'` 
echo "db_type: $db_type" 
if [ $db_type != "primary" ] ; then 
   echo "Database type: $db_type, no more check, stop .... "
   exit 
fi  

echo "--check if last check was success " 
STATUS_FL=${WRK_DIR}/${PROG_NAM}.status 
echo "STATUS_FL: $STATUS_FL " 
if [ -e $STATUS_FL ] ; then 
   my_msg='****** SERVER NOT RESPONDING *****' 
   echo $my_msg 
   page_dba "$my_msg" 
   exit 
fi 

echo '-- insert a row to testdb ' 
psql testdb <<EOF
   insert into uw_keepalive values ('$HNAME',now() ); 
   \COPY uw_keepalive TO $STATUS_FL USING DELIMITERS '|' WITH NULL AS '' ; 
EOF
 
echo "-- check if insert is successful " 
if [ `cat $STATUS_FL| wc -l` -gt 0 ] ; then   
   my_msg="delete from uw_keepalive where 1=1 " 
   echo "$my_msg   "
   echo "$my_msg ; " | psql testdb 
   echo "****** NO PROBLEM $HNAME ****"
else  
   my_msg="NOT FOUND timestamp record in uw_keepalive table of testdb $HNAME `date`" 
   echo "$my_msg   " 
   page_dba "$my_msg   " 
fi

rm -f $STATUS_FL 


echo " "
endjob_stats
echo "DBA Job (`basename $0`) finished at `date` on `uname -n`"
echo "####################################################################"

} 2>&1 | tee -a $LOG_FL
