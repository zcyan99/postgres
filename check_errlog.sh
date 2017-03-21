#!/bin/sh 
#-av
# script name: switchlog.sh

. /usr/local/lib/std.profile
. /usr/local/pgsql/.profile 
. /usr/local/pgsql/dba/scripts/common_functions 

function ticket_dba {
   dbinstance="$1"
    
   { 
   echo " "
   echo "Database ($dbinstance) is down on $HNAME "
   echo "************** "
   echo "************** "
   echo "DBA ACTIONS :: "
   echo "1. login to the host, and see if the database is down "
   echo "2. start database "
   echo "3. check it out. When cleared: ./deletehmalert.pl postgres  ssgdbdev2.cac.washington.edu " 
   echo "reference: cmd1 "
   echo "************** "
   echo " This script is triggered by a crontab check* script."
   echo "script File: `hostname` `basename $0` "
   echo "//tag: nomail                    "
   echo "//proxy                          "
   echo "//requestor: dba@u               "
   echo "//cf-EP::DBA::Engine: PostgreSQL      "
   echo "//cf-EP::DBA::OrgTeam: UWTS - EP - DBA (Lo)"
   echo "//cf-EP::DBA::ProjectName: Computing Infrastructure"
   } | tee $MAIL_FL

   mail -s "****  $HNAME : Database ($dbinstance) is down on $HNAME " -c "dba-help@u.washington.edu " dba-r@uw.edu <$MAIL_FL
}

## ****************************************************************
job_server="${db_nam}"
job_name="${PROG_NAM}"
beginjob_stats
## ****************************************************************


time {
echo "####################################################################" 
echo "DBA Job (`basename $0`) started at `date` on `uname -n`"

psql testdb -c "select datname from pg_stat_database;" 2>&1 | egrep -v 'rows\)|\-\-|datname' |sort | tee -a $WRK_FL  

for dbname    in  `cat $WRK_FL` ; do 
   echo "select pg_database_size('"$dbname"');" 
   echo "select pg_database_size('"$dbname"');"  | psql testdb 
done

echo "******************************"   
echo "pg_ctl status -D /usr/local/pgsql/data"   
pg_ctl status -D /usr/local/pgsql/data  
echo "******************************"   
echo " psql -l                      "   
psql -l                                 
echo "******************************"   
ps auxw |grep RSYNC 
echo "******************************"   
ls -al /var/log/local5.log              
echo "tail -30 /var/log/local5.log"     
tail -30 /var/log/local5.log            
echo "******************************"   

echo "ps axuw |sort | grep ^post    "   
ps axuw |sort | grep ^post 
echo "******************************"   
echo 'crontab -l ' 
echo "******************************"   
echo 'df -k '                           
df -k                                   
echo "******************************"   

echo " *** DDL statements grep from current Postgres server log" 
echo " egrep -in  create |drop |alter |execute|prepare /var/log/local5.log " 
echo " "
echo " " 
egrep -in "create |drop |alter |execute|prepare" /var/log/local5.log 
echo " " 
echo " " 

tmp2=`pg_ctl status -D /usr/local/pgsql/data |grep 'is running' |wc -l`
if test $tmp2 -eq 1
then
  echo "YES POSTMASTER IS RUNNING" 
else
   echo "pgsql is DOWN "  
   if [ $DU -lt 6 ] ; then  
      ticket_dba "${HNAME}--instance1"
      
      #page Liz Sean John  
      #echo "ssgdbdev2 is down" | /bin/mail -s "FATAL ssgdbdev2 down" 2063908477@txt.att.net 6026722916@tmomail.net 
   fi 
fi


echo " "
endjob_stats
echo "DBA Job (`basename $0`) finished at `date` on `uname -n`"
echo "####################################################################"
} 2>&1 | tee -a $LOG_FL


#if  [ "$HH" = "16" -a "$DA" = "Mon" ]
#then
#   rm $LOGHIST
#   cat /dev/null > $LOGHIST
#   echo "restart log history file" `date` >> $LOGHIST
#fi
#
#cat $LOG_FL >> $LOGHIST
scp -i  $SCPfileID  $LOG_FL $SCPtarget/$HNAME.check_errlog.log.$TIMESTAMP


