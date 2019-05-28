#!/bin/bash
address=`df -h | grep dev  | grep -v tmpfs  | grep -v sda |awk '{print $6}'`

for i in $address;do
   cd $i/platinum 
   for j in `ls -l  | awk '{print $9}' | grep instance`;do
      /bin/sh $j/start.sh;done
done

disksnum=`/bin/lsblk -d -o name,rota|grep -v 'ROTA'|wc -l`
[ -z $disksnum ] &&disksnum =1
tick=0
for i in {a..z}
do

sch_pro="/sys/class/block/sd$i/queue/scheduler"
nr_requests="/sys/class/block/sd$i/queue/nr_requests"
read_ahead="/sys/block/sd${i}/queue/read_ahead_kb"
sysctl vm.swappiness=30
grep -q vm.swappiness /etc/sysctl.conf || echo "vm.swappiness = 30" >>/etc/sysctl.conf
if [ -f "$sch_pro" ];then
    echo deadline > $sch_pro
    echo 1024 >  ${nr_requests}
    echo 1024 >  ${read_ahead}
    echo "${sch_pro}"
    cat ${sch_pro}
    cat ${nr_requests}
    cat ${read_ahead}

fi

tick=$((tick+1))
if [ "$tick" -ge "$disksnum" ];then
    echo "break"
    break

fi
done
/etc/init.d/iptables stop 
