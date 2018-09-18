#!/bin/bash
###############################################################################################
###############################################################################################
# UPDATE
echo "################################################################"
echo "###################    UPDATE & UPGRADE   ######################"
echo "################################################################"
apt update
apt upgrade

###############################################################################################
###############################################################################################
# INSTALL JAVA
echo "################################################################"
echo "###################   INSTALLING JAVA 8   ######################"
echo "################################################################"
add-apt-repository ppa:webupd8team/java
apt update
apt install oracle-java8-installer

###############################################################################################
###############################################################################################
# SETTING JAVA PATH
echo "################################################################"
echo "###################   SETTING JAVA PATH   ######################"
echo "################################################################"
echo 'JAVA_HOME="/usr/lib/jvm/java-8-oracle"' >> /etc/environment
source /etc/environment

###############################################################################################
###############################################################################################
# CREATING HADOOP USER AND HADOOP GROUP
echo "################################################################"
echo "############  CREATING USER-hduser IN GROUP-hadoop  ############"
echo "################################################################"
addgroup hadoop
adduser --ingroup hadoop hduser
adduser hduser sudo

###############################################################################################
###############################################################################################
# COPYING INSTALLTION SCRIPT TO hduser .BATCHRC FILE 
cp ~/Hadoop-Airline-Flight-Data-Analysis/hadoop_install_2.sh /home/hduser
echo '
sudo bash hadoop_install_2.sh
' >> /home/hduser/.bashrc
source /home/hduser/.bashrc

###############################################################################################
###############################################################################################
# REBOOT
echo 'The machine will reboot, 
after reboot login to root 
then from root login to hduser using the password created by you.

'
echo 'YOUR MACHINE WILL REBOOT IN'
a=10
while [ $a -gt 0 ]
do
   echo $a
   a=`expr $a - 1`
   sleep 1
done
reboot now
