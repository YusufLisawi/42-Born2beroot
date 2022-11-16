#! /bin/bash

arch=$(uname -a)
cpuPhy=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
cpuV=$(grep "^processor" /proc/cpuinfo | wc -l)
usedMem=$(free -m | grep Mem: | awk '{printf("%d/%dMB", $3, $2)}')
percMem=$(free -m | grep Mem: | awk '{printf("%.2f\n"), $3/$2*100}')
diskU=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{used += $3} END {print used}')
diskT=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{total += $2} END {printf("%dGb", total)}')
percDisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{total += $2} {used += $3} END {printf("%.2f"), used/total*100}')
cpuL=$(top -bn1 | grep '^%Cpu' | awk -F , '{printf("%.1f%%\n"), 100 - $4}')
lboot=$(who -b | awk '{printf("%s %s"), $3, $4}')
LVMS=$(lsblk | grep "LVM" | wc -l)
cTCP=$(ss -s | grep 'TCP:' | awk -F "[()]" '{print $2}' | awk -v "RS=, " '$1 ~ "estab"' | awk '{print $2}')
userlog=$(users | wc -w)
Ipv4=$(hostname -I)
MAC=$(ip addr | grep "link/ether" | awk '{printf("(%s)"),$2}')
sudoCMD=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
wall "
	#Architecture : $arch
	#CPU physical : $cpuPhy
	#vCPU : $cpuV
	#Memory Usage: $usedMem ($percMem%)
	#Disk Usage: $diskU/$diskT ($percDisk%)
	#CPU load: $cpuL
	#Last boot: $lboot
	#LVM use: $(if [$LVMS -eq 0]; then echo no; else echo yes; fi)
	#Connections TCP : $cTCP ESTABLISHED
	#User log: $userlog
	#Network: IP $Ipv4 $MAC
	#Sudo : $sudoCMD cmd"
