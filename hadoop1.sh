sudo ssh-keygen -t rsa -P ""
cat $HOME/.ssh/id_rsa.pub >> /home/hduser/.ssh/authorized_keys
sudo chmod 0600 /home/hduser/.ssh/authorized_keys


wget http://mirrors.fibergrid.in/apache/hadoop/common/stable/hadoop-2.9.1.tar.gz
tar xzf hadoop-2.9.1.tar.gz
sudo mkdir -p /usr/local/hadoop
cd hadoop-2.9.1/
sudo mv * /usr/local/hadoop
sudo chown -R hduser:hadoop /usr/local/hadoop
sudo echo 'export HADOOP_HOME=/usr/local/hadoop
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin' >> /home/hduser/.bashrc
source /home/hduser/.bashrc

#sed 's+${JAVA_HOME}+/usr/lib/jvm/java-8-oracle+' /usr/local/hadoop/etc/hadoop/hadoop-env.sh

sudo mkdir -p /app/hadoop/tmp
sudo chown hduser:hadoop /app/hadoop/tmp
sudo sed -i '/<configuration>/d' /usr/local/hadoop/etc/hadoop/core-site.xml
sudo sed -i '\_</configuration>_d' /usr/local/hadoop/etc/hadoop/core-site.xml
sudo echo '<configuration>
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
sudo sed -i '/<configuration>/d' /usr/local/hadoop/etc/hadoop/hdfs-site.xml
sudo sed -i '\_</configuration>_d' /usr/local/hadoop/etc/hadoop/hdfs-site.xml
sudo echo '<configuration>
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

sudo sed -i '/<configuration>/d' /usr/local/hadoop/etc/hadoop/yarn-site.xml
sudo sed -i '\_</configuration>_d' /usr/local/hadoop/etc/hadoop/yarn-site.xml
sudo echo '<configuration>
   <property>
      <name>yarn.nodemanager.aux-services</name>
      <value>mapreduce_shuffle</value>
   </property>
</configuration>' >> /usr/local/hadoop/etc/hadoop/yarn-site.xml

sudo sed -i '/hadoop1.sh/d' /home/hduser/.bashrc

sudo reboot now
