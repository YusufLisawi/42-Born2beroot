#! /bin/bash

arch=$(uname -a)
cpuPhy=$(grep "physical id" /proc/cpuinfo | uniq | wc -l)
cpuV=$(grep "^processor" /proc/cpuinfo | wc -l)
usedMem=$(free -m | grep Mem: | awk '{printf("%d/%dMB", $3, $2)}')
percMem=$(free -m | grep Mem: | awk '{printf("%.2f\n"), $3/$2*100}')
diskU=$(df -Bm --total | grep ^total | awk '{print $3}' | awk -F M '{print $1}')
diskT=$(df -Bg --total | grep ^total | awk '{printf("%sb", $2)}')
percDisk=$(df --total | grep ^total | awk '{print $5}')
cpuL=$(top -bn1 | grep '^%Cpu' | awk -F , '{print $4}' | awk '{print 100 - $1}')
lboot=$(who -b | awk '{printf("%s %s"), $3, $4}')
LVMS=$(lsblk | grep lvm | awk '{if ($6 == "lvm") print "yes"; else print "no"}' | uniq)
cTCP=$(ss | grep tcp | wc -l)
userlog=$(w -h | wc -l)
Ipv4=$(hostname -I)
MAC=$(ip addr | grep "link/ether" | awk '{printf("(%s)"),$2}')
sudoCMD=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
wall "
	#Architecture : $arch
	#CPU physical : $cpuPhy
	#vCPU : $cpuV
	#Memory Usage: $usedMem ($percMem%)
	#Disk Usage: $diskU/$diskT ($percDisk)
	#CPU load: $cpuL%
	#Last boot: $lboot
	#LVM use: $LVMS
	#Connections TCP : $cTCP ESTABLISHED
	#User log: $userlog
	#Network: IP $Ipv4 $MAC
	#Sudo : $sudoCMD cmd"
