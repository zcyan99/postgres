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



date 

echo "******************************" 
echo `hostname` 
echo $0 

echo "******************************" 
echo " psql -l                      " 
echo " pg_ctl status -D /usr/local/pgsql/data  " 

psql -l   
pg_ctl status -D /usr/local/pgsql/data 


echo "******************************" 
echo "whoami and environment        " 
whoami 
id -u -n 
id  
`hostname` 
echo "******************************" 
echo "env and printenv              "  
echo "                              "  
env 
echo "                              " 
echo "                              " 
printenv 

echo "******************************" 
echo "cat /usr/local/bin/userpg     " 
cat /usr/local/bin/userpg 


echo "******************************" 
echo "ls -al  /var/log/local*.log   "  
echo "tail -50  /var/log/local5.log "  
tail -50  /var/log/local5.log  

echo "******************************" 
echo "PATH set to:                  "  
echo $PATH  


echo "******************************" 
echo "more ~postgres/.bash_profile  " 
ls -al ~postgres/.bash_profile  
cat ~postgres/.bash_profile  

echo "******************************" 
echo "more ~postgres/.bashrc        " 
ls -al ~postgres/.bashrc 
cat ~postgres/.bashrc 


echo "******************************" 
echo "more ~postgres/cmd1           " 
cat ~postgres/cmd1    

echo "******************************" 
echo "more ~postgres/cmd2           " 
cat ~postgres/cmd2    

echo "******************************" 
echo "more ~postgres/cmd3           " 
cat ~postgres/cmd3    


echo "******************************" 
echo "more ~postgres/commands       " 
cat ~postgres/commands   


echo "******************************" 
echo "cat /proc/sys/kernel/shmmax  which is system shared memory in bytes  " 
ls -al /proc/sys/kernel/shmmax        
cat /proc/sys/kernel/shmmax        

echo " ipcs -ls   (limits)          " 
echo " ipcs                         " 

ipcs -ls  
ipcs      

echo "******************************" 
echo "more $HOME/data/postgresql.conf" 
ls -al $HOME/data/postgresql.conf     
cat $HOME/data/postgresql.conf     

echo "******************************" 
echo "more $HOME/data/pg_hba.conf" 
ls -al $HOME/data/pg_hba.conf       
cat $HOME/data/pg_hba.conf       

echo "******************************" 
echo "more $HOME/data/pg_ident.conf" 
ls -al $HOME/data/pg_ident.conf     
cat $HOME/data/pg_ident.conf     


echo "******************************" 
echo "cat /etc/rc.d/init.d/dbctl    " 
ls -al /etc/rc.d/init.d/dbctl      
cat /etc/rc.d/init.d/dbctl      


echo "******************************" 
echo "cat /etc/daemons/sdbctl       " 
ls -al /etc/daemons/sdbctl          
cat /etc/daemons/sdbctl          


echo "******************************" 
echo "Display boot and other system messages"  
echo "dmesg results:                " 
dmesg 

echo "******************************" 
echo "List all system intalled packages"  
echo "rpm -q -a \|sort results:     "  
rpm -q -a |sort 


echo "******************************" 
echo "Lists major devices           " 
echo "lsdev results:                " 
lsdev  

echo "******************************" 
echo "Lists SCSI devices            " 
echo "scsiinfo -l results:          " 
scsiinfo -l  

echo "******************************" 
echo "Lists PCI devices             " 
echo "lspci results:                " 
lspci  

echo "******************************" 
echo "Lists USB devices             " 
echo "lsusb results:                " 
lsusb  

echo "******************************" 
echo "netstat -a results            " 
netstat -a 


echo "******************************" 
echo " ps auwx |sort                " 
ps auxw |sort  

echo "******************************" 
echo " who                          " 
who            

echo "******************************" 
echo " \$HOME value is set to /usr/local/pgsql - verify via echo  " 
echo $HOME    

echo "******************************" 
echo " High level directories " 

echo " ls -la /usr/local    " 
ls -la /usr/local  

echo "******************************" 
echo " ls -al /usr/local/pgsql    " 
ls -al /usr/local/pgsql  

echo "******************************" 
echo " ls -al /usr/local/pgversion " 
ls -al /usr/local/pgversion      

echo "******************************" 
echo " ls -al /usr/local/pg-support " 
ls -al /usr/local/pg-support     


echo "******************************" 
echo " ls -al /usr/local/pg-support " 
ls -al /usr/local/pg-support 

echo "******************************" 
echo " ls -al  /usr/local/pgsql/mdssdba/*.s*  " 
ls -al /usr/local/pgsql/mdssdba/*.s*  


echo "******************************" 
echo " crontab -l results:          " 
id  
crontab -l  


echo "******************************" 
echo "/etc/fstab contents:          " 
ls -al /etc/fstab 
cat /etc/fstab 


echo "******************************" 
echo "df -k                         "  
df -k  

echo "******************************" 
echo Script login: `id -u -n` 
echo This is file `basename $0` on `hostname` 
echo "End of report." 
echo "******************************" 
echo "******************************" 

#no report is needed
#/bin/mail -s " `hostname` liz_info.log DRBR report " dba-r@cac <$LOGFILE

echo " "
endjob_stats
echo "DBA Job (`basename $0`) finished at `date` on `uname -n`"
echo "####################################################################"
} 2>&1 | tee -a $LOG_FL


export SCPtarget=dba@dba-unixvm.cac.washington.edu:/data/dba/htmldba
scp  $LOG_FL $SCPtarget/${HNAME}_postgres_hostinfo.txt 

