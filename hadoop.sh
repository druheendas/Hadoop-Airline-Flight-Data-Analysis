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


sudo ssh-keygen -t rsa -P ""
cat $HOME/.ssh/id_rsa.pub >> /home/hduser/.ssh/authorized_keys
chmod 0600 /home/hduser/.ssh/authorized_keys


wget http://mirrors.fibergrid.in/apache/hadoop/common/stable/hadoop-2.9.1.tar.gz
tar xvzf hadoop-2.9.1.tar.gz
mkdir -p /usr/local/hadoop
cd hadoop-2.9.1/
mv * /usr/local/hadoop
chown -R hduser:hadoop /usr/local/hadoop
echo 'export HADOOP_HOME=/usr/local/hadoop
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin' >> /home/hduser/.bashrc
source /home/hduser/.bashrc

#sed 's+${JAVA_HOME}+/usr/lib/jvm/java-8-oracle+' /usr/local/hadoop/etc/hadoop/hadoop-env.sh

mkdir -p /app/hadoop/tmp
chown hduser:hadoop /app/hadoop/tmp
sed  '/<configuration>/d' /usr/local/hadoop/etc/hadoop/core-site.xml
sed  '+</configuration>+d' /usr/local/hadoop/etc/hadoop/core-site.xml
echo '<configuration>
<property>
<name>fs.defaultFS</name>
<value>hdfs://localhost:9000</value>
</property>
<property>
<name>hadoop.tmp.dir</name>
<value>/app/hadoop/tmp</value>
</property>
</configuration>' >> /usr/local/hadoop/etc/hadoop/core-site.xml

sudo mkdir -p /usr/local/hadoop_store/hdfs/namenode
sudo mkdir -p /usr/local/hadoop_store/hdfs/datanode
sudo chown -R hduser:hadoop /usr/local/hadoop_store
sed  '/<configuration>/d' /usr/local/hadoop/etc/hadoop/hdfs-site.xml
sed  '+</configuration>+d' /usr/local/hadoop/etc/hadoop/hdfs-site.xml
echo '<configuration>
<property>
  <name>dfs.replication</name>
  <value>1</value>
  <description>Default block replication.The actual number of replications can be specified when the file is created. The default is used if replication is not specified in create time.
  </description>
 </property>
 <property>
   <name>dfs.namenode.name.dir</name>
   <value>file:/usr/local/hadoop_store/hdfs/namenode</value>
 </property>
 <property>
   <name>dfs.datanode.data.dir</name>
   <value>file:/usr/local/hadoop_store/hdfs/datanode</value>
 </property>
</configuration>' >> /usr/local/hadoop/etc/hadoop/hdfs-site.xml

sed  '/<configuration>/d' /usr/local/hadoop/etc/hadoop/yarn-site.xml
sed  '+</configuration>+d' /usr/local/hadoop/etc/hadoop/yarn-site.xml
echo '<configuration>
   <property>
      <name>yarn.nodemanager.aux-services</name>
      <value>mapreduce_shuffle</value>
   </property>
</configuration>' >> /usr/local/hadoop/etc/hadoop/yarn-site.xml

reboot now