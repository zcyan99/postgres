#!/bin/bash -av
# script name: mdssdba/lizdir/liz_pginfo.sh
# type: DRBR informational reporting

## TIMESTAMP=`date -d "-1 days" +%C%y%m%d%H%M%S`
export TIMESTAMP=`date +%C%y%m%d%H%M%S`
export YY=`echo $TIMESTAMP | cut -c1-4 `
export MM=`echo $TIMESTAMP | cut -c5-6 `
export DD=`echo $TIMESTAMP | cut -c7-8 `

. ~postgres/.bashrc

export DIR=/usr/local/pgsql/mdssdba/lizdir
export LOGFILE=`basename $0`.log

export HNAME=`hostname | cut -d '.' -f1`
export job_name="liz_pginfo"
export job_number=`expr $$ `
export job_script_name=$0
export job_begin_dt_time=`date '+%C%y-%m-%d %H:%M:%S'`
export job_beginday=`date +%a`

cd $DIR

date > $LOGFILE

echo "******************************" >>$LOGFILE 
echo `hostname` >>$LOGFILE
echo $0 >>$LOGFILE

echo "******************************" >>$LOGFILE 
echo " psql -l                      " >>$LOGFILE
echo " pg_ctl status -D /usr/local/pgsql/data  " >>$LOGFILE

psql -l    | tee -a $LOGFILE

pg_ctl status -D /usr/local/pgsql/data | tee -a $LOGFILE


echo "******************************" >>$LOGFILE 
echo "whoami and environment        " >>$LOGFILE 
whoami >>$LOGFILE
id -u -n >>$LOGFILE
id  >>$LOGFILE
`hostname` >>$LOGFILE
echo "******************************" >>$LOGFILE 
echo "env and printenv              " >>$LOGFILE 
echo "                              " >>$LOGFILE 
env |tee -a  $LOGFILE
echo "                              " >>$LOGFILE
echo "                              " >>$LOGFILE
printenv |tee -a  $LOGFILE

echo "******************************" >>$LOGFILE
echo "cat /usr/local/bin/userpg     " >>$LOGFILE
cat /usr/local/bin/userpg >>$LOGFILE


echo "******************************" >>$LOGFILE
echo "ls -al  /var/log/local*.log   " >>$LOGFILE 
echo "tail -50  /var/log/local5.log " >>$LOGFILE 
tail -50  /var/log/local5.log  |tee -a  $LOGFILE

echo "******************************" >>$LOGFILE
echo "PATH set to:                  " >>$LOGFILE 
echo $PATH  |tee -a  $LOGFILE


echo "******************************" >>$LOGFILE
echo "more ~postgres/.bash_profile  " >>$LOGFILE
ls -al ~postgres/.bash_profile  |tee -a  $LOGFILE
cat ~postgres/.bash_profile  |tee -a  $LOGFILE

echo "******************************" >>$LOGFILE
echo "more ~postgres/.bashrc        " >>$LOGFILE
ls -al ~postgres/.bashrc |tee -a  $LOGFILE
cat ~postgres/.bashrc |tee -a  $LOGFILE


echo "******************************" >>$LOGFILE
echo "more ~postgres/cmd1           " >>$LOGFILE
cat ~postgres/cmd1    |tee -a  $LOGFILE

echo "******************************" >>$LOGFILE
echo "more ~postgres/cmd2           " >>$LOGFILE
cat ~postgres/cmd2    |tee -a  $LOGFILE

echo "******************************" >>$LOGFILE
echo "more ~postgres/cmd3           " >>$LOGFILE
cat ~postgres/cmd3    |tee -a  $LOGFILE


echo "******************************" >>$LOGFILE
echo "more ~postgres/commands       " >>$LOGFILE
cat ~postgres/commands   |tee -a  $LOGFILE


echo "******************************" >>$LOGFILE
echo "cat /proc/sys/kernel/shmmax  which is system shared memory in bytes  " >>$LOGFILE
ls -al /proc/sys/kernel/shmmax        |tee -a  $LOGFILE
cat /proc/sys/kernel/shmmax        |tee -a  $LOGFILE

echo " ipcs -ls   (limits)          " >>$LOGFILE
echo " ipcs                         " >>$LOGFILE

ipcs -ls  |tee -a  $LOGFILE
ipcs      |tee -a  $LOGFILE

echo "******************************" >>$LOGFILE
echo "more $HOME/data/postgresql.conf" >>$LOGFILE
ls -al $HOME/data/postgresql.conf     |tee -a  $LOGFILE
cat $HOME/data/postgresql.conf     |tee -a  $LOGFILE

echo "******************************" >>$LOGFILE
echo "more $HOME/data/pg_hba.conf" >>$LOGFILE
ls -al $HOME/data/pg_hba.conf       |tee -a  $LOGFILE
cat $HOME/data/pg_hba.conf       |tee -a  $LOGFILE

echo "******************************" >>$LOGFILE
echo "more $HOME/data/pg_ident.conf" >>$LOGFILE
ls -al $HOME/data/pg_ident.conf     |tee -a  $LOGFILE
cat $HOME/data/pg_ident.conf     |tee -a  $LOGFILE


echo "******************************" >>$LOGFILE
echo "cat /etc/rc.d/init.d/dbctl    " >>$LOGFILE
ls -al /etc/rc.d/init.d/dbctl      |tee -a  $LOGFILE
cat /etc/rc.d/init.d/dbctl      |tee -a  $LOGFILE


echo "******************************" >>$LOGFILE
echo "cat /etc/daemons/sdbctl       " >>$LOGFILE
ls -al /etc/daemons/sdbctl          |tee -a  $LOGFILE
cat /etc/daemons/sdbctl          |tee -a  $LOGFILE


echo "******************************" >>$LOGFILE
echo "Display boot and other system messages" >>$LOGFILE 
echo "dmesg results:                " >>$LOGFILE
dmesg |tee -a  $LOGFILE

echo "******************************" >>$LOGFILE
echo "List all system intalled packages" >>$LOGFILE 
echo "rpm -q -a \|sort results:     " >>$LOGFILE 
rpm -q -a |sort |tee -a  $LOGFILE


echo "******************************" >>$LOGFILE
echo "Lists major devices           " >>$LOGFILE
echo "lsdev results:                " >>$LOGFILE
lsdev  |tee -a  $LOGFILE

echo "******************************" >>$LOGFILE
echo "Lists SCSI devices            " >>$LOGFILE
echo "scsiinfo -l results:          " >>$LOGFILE
scsiinfo -l  |tee -a  $LOGFILE

echo "******************************" >>$LOGFILE
echo "Lists PCI devices             " >>$LOGFILE
echo "lspci results:                " >>$LOGFILE
lspci  |tee -a  $LOGFILE

echo "******************************" >>$LOGFILE
echo "Lists USB devices             " >>$LOGFILE
echo "lsusb results:                " >>$LOGFILE
lsusb  |tee -a  $LOGFILE

echo "******************************" >>$LOGFILE
echo "netstat -a results            " >>$LOGFILE
netstat -a |tee -a  $LOGFILE


echo "******************************" >>$LOGFILE
echo " ps auwx |sort                " >>$LOGFILE
ps auxw |sort  |tee -a  $LOGFILE

echo "******************************" >>$LOGFILE
echo " who                          " >>$LOGFILE
who            |tee -a  $LOGFILE




echo "******************************" >>$LOGFILE
echo " \$HOME value is set to /usr/local/pgsql - verify via echo  " >>$LOGFILE
echo $HOME     |tee -a  $LOGFILE

echo "******************************" >>$LOGFILE
echo " High level directories " >>$LOGFILE

echo " ls -la /usr/local    " >>$LOGFILE
ls -la /usr/local  >>$LOGFILE

echo "******************************" >>$LOGFILE
echo " ls -al /usr/local/pgsql    " >>$LOGFILE
ls -al /usr/local/pgsql  >>$LOGFILE

echo "******************************" >>$LOGFILE
echo " ls -al /usr/local/pgversion " >>$LOGFILE
ls -al /usr/local/pgversion      >>$LOGFILE

echo "******************************" >>$LOGFILE
echo " ls -al /usr/local/pg-support " >>$LOGFILE
ls -al /usr/local/pg-support     >>$LOGFILE


echo "******************************" >>$LOGFILE
echo " ls -al /usr/local/pg-support " >>$LOGFILE
ls -al /usr/local/pg-support >> $LOGFILE

echo "******************************" >>$LOGFILE
echo " ls -al  /usr/local/pgsql/mdssdba/*.s*  " >>$LOGFILE
ls -al /usr/local/pgsql/mdssdba/*.s*  >> $LOGFILE





echo "******************************" >>$LOGFILE
echo " crontab -l results:          " >>$LOGFILE
id  |tee -a  $LOGFILE
crontab -l  |tee -a  $LOGFILE


echo "******************************" >>$LOGFILE
echo "/etc/fstab contents:          " >>$LOGFILE
ls -al /etc/fstab |tee -a  $LOGFILE
cat /etc/fstab |tee -a  $LOGFILE


echo "******************************" >>$LOGFILE
echo "df -k                         " >>$LOGFILE 
df -k  |tee -a  $LOGFILE

echo "******************************" >>$LOGFILE
echo Script login: `id -u -n` |tee -a $LOGFILE
echo This is file `basename $0` on `hostname` |tee -a $LOGFILE
echo "End of report." |tee -a $LOGFILE
echo "******************************" >>$LOGFILE
echo "******************************" >>$LOGFILE

/bin/mail -s " `hostname` liz_info.log DRBR report " dba-r@cac <$LOGFILE

 

export SCPfileID=/usr/local/pgsql/mdssdba/lizdir/id_rsa_ssgdbdev2
export SCPtarget=dba@dba-unixvm.cac.washington.edu:/data/dba/htmldba

scp -i  $SCPfileID $LOGFILE $SCPtarget/`hostname`_postgres_hostinfo.txt


job_end_dt_time=`date '+%C%y-%m-%d %H:%M:%S'`
echo $HNAME'|'$HNAME'|'$job_name'|'$job_number'|'$job_script_name'|'$job_begin_dt_time'|'$job_end_dt_time'|'$job_beginday'|||||||'  |tee -a /usr/local/pgsql/mdssdba/lizdir/job_status.dat

echo update job_schedule set last_rundate="'"$job_begin_dt_time"'" , last_runday="'"$job_beginday"'" where job_host="'"$HNAME"'" and job_server="'"$HNAME"'" and job_name="'"$job_name"'" " ; "|tee -a /usr/local/pgsql/mdssdba/lizdir/job_sched.dat

exit
