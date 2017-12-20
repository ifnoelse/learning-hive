# 配置Hadoop
## 配置hdfs及yarn

### 创建相关数据目录（在所的节点上执行）
``` bash
sudo cp -r /etc/hadoop/conf.empty /etc/hadoop/conf.my_cluster
sudo cp -r ./conf/* /etc/hadoop/conf.my_cluster
sudo alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.my_cluster 50 
sudo alternatives --set hadoop-conf /etc/hadoop/conf.my_cluster
sudo alternatives --display hadoop-conf
sudo mkdir -p /hadoop/data/dfs/{nn,dn}
sudo chown -R hdfs:hdfs /hadoop/data/dfs/nn /hadoop/data/dfs/dn
sudo chmod 700 /hadoop/data/dfs/nn
sudo mkdir -p /hadoop/data/yarn/{local,logs}
sudo chown -R yarn:yarn /hadoop/data/yarn/local /hadoop/data/yarn/logs
```

### 配置hdfs及yarn相关参数

新建conf文件夹，将以下四个文件放在该目录下
通过以下脚本同步配置到各个节点
``` bash
#!/usr/bin/env bash

sudo cp ./conf/* /etc/hadoop/conf.my_cluster/

for i in {2..3}
do
ssh -qt ifnoelse@node-0$i 'mkdir -p ~/hadoop/conf/'
ssh -qt ifnoelse@node-0$i 'rm -rf ~/hadoop/conf/*'
scp -r ./conf/* ifnoelse@node-0$i:~/hadoop/conf/
ssh -qt ifnoelse@node-0$i 'sudo cp ./hadoop/conf/* /etc/hadoop/conf.my_cluster/'
done
```
将以上内容保存在sync-conf.sh之中，放在与conf文件夹平级位置，然后执行

**core-site.xml**
``` xml
<?xml version="1.0"?>

<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://node-01:8020</value>
    </property>
    <property>
        <name>hadoop.proxyuser.mapred.groups</name>
        <value>*</value>
    </property>
    <property>
        <name>hadoop.proxyuser.mapred.hosts</name>
        <value>*</value>
    </property>
</configuration>
```
**hdfs-site.xml**
``` xml
<?xml version="1.0"?>

<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<configuration>
    <property>
        <name>dfs.permissions.superusergroup</name>
        <value>hadoop</value>
    </property>
    <property>
        <name>dfs.name.dir</name>
        <value>file:///hadoop/data/dfs/nn</value>
    </property>
    <property>
        <name>dfs.data.dir</name>
        <value>file:///hadoop/data/dfs/dn</value>
    </property>
    <property>
        <name>dfs.webhdfs.enabled</name>
        <value>true</value>
    </property>
    <property>
        <name>dfs.client.block.write.replace-datanode-on-failure.enable</name>
        <value>true</value>
    </property>
    <property>
        <name>dfs.client.block.write.replace-datanode-on-failure.policy</name>
        <value>NEVER</value>
    </property>
    <property>
        <name>dfs.replication</name>
        <value>2</value>
    </property>
    <property>
        <name>dfs.support.append</name>
        <value>true</value>
    </property>
</configuration>
```
**mapred-site.xml**
``` xml
<?xml version="1.0"?>

<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <property>
        <name>mapreduce.jobhistory.address</name>
        <value>node-01:10020</value>
    </property>
    <property>
        <name>mapreduce.jobhistory.webapp.address</name>
        <value>node-01:19888</value>
    </property>
    <property>
        <name>yarn.app.mapreduce.am.staging-dir</name>
        <value>/user</value>
    </property>
    <property>
        <name>mapreduce.jobhistory.done-dir</name>
        <value>${yarn.app.mapreduce.am.staging-dir}/history/done</value>
    </property>
    <property>
        <name>mapreduce.jobhistory.intermediate-done-dir</name>
        <value>${yarn.app.mapreduce.am.staging-dir}/history/done_intermediate
        </value>
    </property>
</configuration>
```
**yarn-site.xml**
``` xml
<?xml version="1.0"?>

<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<configuration>
    <property>
        <name>yarn.resourcemanager.scheduler.address</name>
        <value>node-01:8030</value>
    </property>
    <property>
        <name>yarn.resourcemanager.resource-tracker.address</name>
        <value>node-01:8031</value>
    </property>
    <property>
        <name>yarn.resourcemanager.address</name>
        <value>node-01:8032</value>
    </property>
    <property>
        <name>yarn.resourcemanager.admin.address</name>
        <value>node-01:8033</value>
    </property>
    <property>
        <name>yarn.resourcemanager.webapp.address</name>
        <value>node-01:8088</value>
    </property>
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>node-01</value>
    </property>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.aux-services.mapreduce_shuffle.class</name>
        <value>org.apache.hadoop.mapred.ShuffleHandler</value>
    </property>
    <property>
        <name>yarn.log-aggregation-enable</name>
        <value>true</value>
    </property>
    <property>
        <description>List of directories to store localized files in.
        </description>
        <name>yarn.nodemanager.local-dirs</name>
        <value>file:///hadoop/data/yarn/local</value>
    </property>
    <property>
        <description>Where to store container logs.</description>
        <name>yarn.nodemanager.log-dirs</name>
        <value>file:///hadoop/data/yarn/logs</value>
    </property>
    <property>
        <description>Where to aggregate logs to.</description>
        <name>yarn.nodemanager.remote-app-log-dir</name>
        <value>hdfs://node-01:8020/var/log/hadoop-yarn/apps</value>
    </property>
    <property>
        <description>Classpath for typical applications.</description>
        <name>yarn.application.classpath</name>
        <value>
            $HADOOP_CONF_DIR,
            $HADOOP_COMMON_HOME/*,$HADOOP_COMMON_HOME/lib/*,
            $HADOOP_HDFS_HOME/*,$HADOOP_HDFS_HOME/lib/*,
            $HADOOP_MAPRED_HOME/*,$HADOOP_MAPRED_HOME/lib/*,
            $HADOOP_YARN_HOME/*,$HADOOP_YARN_HOME/lib/*
        </value>
    </property>
<property>
    <name>yarn.nodemanager.resource.memory-mb</name>
    <value>3096</value>
</property>
<property>
    <name>yarn.nodemanager.resource.cpu-vcores</name>
    <value>2</value>
</property>
<property>
    <name>yarn.scheduler.maximum-allocation-mb</name>
    <value>3096</value>
</property>
</configuration>
```
