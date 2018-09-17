ssh-keygen -t rsa -P ""
cp -R /root/.ssh /home/hduser/
chown hduser:hadoop /home/hduser/.ssh
cat /home/hduser/.ssh/id_rsa.pub >> /home/hduser/.ssh/authorized_keys
chmod 0600 /home/hduser/.ssh/authorized_keys


wget http://mirrors.fibergrid.in/apache/hadoop/common/stable/hadoop-2.9.1.tar.gz
tar xzf hadoop-2.9.1.tar.gz
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
sed -i '/<configuration>/d' /usr/local/hadoop/etc/hadoop/core-site.xml
sed -i '\_</configuration>_d' /usr/local/hadoop/etc/hadoop/core-site.xml
echo '
<configuration>
<property>
<name>fs.defaultFS</name>
<value>hdfs://localhost:9000</value>
</property>
<property>
<name>hadoop.tmp.dir</name>
<value>/app/hadoop/tmp</value>
</property>
</configuration>
' >> /usr/local/hadoop/etc/hadoop/core-site.xml

mkdir -p /usr/local/hadoop_store/hdfs/namenode
mkdir -p /usr/local/hadoop_store/hdfs/datanode
chown -R hduser:hadoop /usr/local/hadoop_store
sed -i '/<configuration>/d' /usr/local/hadoop/etc/hadoop/hdfs-site.xml
sed -i '\_</configuration>_d' /usr/local/hadoop/etc/hadoop/hdfs-site.xml
echo '
<configuration>
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
</configuration>
' >> /usr/local/hadoop/etc/hadoop/hdfs-site.xml

sed -i '/<configuration>/d' /usr/local/hadoop/etc/hadoop/yarn-site.xml
sed -i '\_</configuration>_d' /usr/local/hadoop/etc/hadoop/yarn-site.xml
echo '
<configuration>
   <property>
      <name>yarn.nodemanager.aux-services</name>
      <value>mapreduce_shuffle</value>
   </property>
</configuration>
' >> /usr/local/hadoop/etc/hadoop/yarn-site.xml

sed -i '/hadoop1.sh/d' /home/hduser/.bashrc

reboot now
