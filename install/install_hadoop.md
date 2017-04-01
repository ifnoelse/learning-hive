# 安装hadoop

## 安装hadoop相关组件

### 安装 Resource Manager（master节点）
``` bash
sudo yum clean all; sudo yum install hadoop-yarn-resourcemanager
```

### 安装历史日志查看服务（master节点）

``` bash
sudo yum clean all; sudo yum install hadoop-mapreduce-historyserver hadoop-yarn-proxyserver
```

### 安装 NameNode（master节点）
``` bash
sudo yum clean all; sudo yum install hadoop-hdfs-namenode
```
### 主节点之外的节点需要安装的组件（所有的slave节点）
``` bash
sudo yum clean all; sudo yum install hadoop-yarn-nodemanager hadoop-hdfs-datanode hadoop-mapreduce
```