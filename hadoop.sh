apt update
apt upgrade

add-apt-repository ppa:webupd8team/java
apt update
apt install oracle-java8-installer

echo 'JAVA_HOME="/usr/lib/jvm/java-8-oracle"' >> /etc/environment
source /etc/environment

addgroup hadoop
adduser --ingroup hadoop hduser
adduser hduser sudo
echo '
bash hadoop1.sh
' >> /home/hduser/.bashrc
source /home/hduser/.bashrc

reboot now