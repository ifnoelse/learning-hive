# Hadoop 概述
本书主要是为了让没有大数据基础的同学能够快速搭建及使用Hive
# 阅读地址
https://ifnoelse.gitbooks.io/learning-hive/content/
# 目录
* [介绍](README.md)
* [hadoop概览](hadoop_overview/README.md)
  * [分布式计算](hadoop_overview/hadoop_ecosystem.md)
  * [Hadoop生态系统](hadoop_overview/hadoop_ecosystem.md)
  * [HDFS介绍](hadoop_overview/hdfs.md)
  * [YARN介绍](hadoop_overview/yarn.md)
  * [Hive介绍](hadoop_overview/hive.md)
* [安装集群](install/README.md)
  * [Hadoop发行版本](install/hadoop_dist.md)
  * [安装CDH5](install/install_cdh5.md)
    * [准备服务器](install/prepare_server.md)
    * [配置CDH源](install/cdh_yum_repo.md)
    * [安装Hadoop](install/install_hadoop.md)
    * [配置Hadoop](install/config_hadoop.md) 
    * [启动Hadoop](install/start_hadoop.md)
  * [安装Hive](install/install_hive.md)
    * [安装MySQL](install/install_mysql.md)
    * [安装及配置Hive](install/install_config_hive.md)
* [Hadoop体验](hadoop_express/README.md)
  * [第一个Hadoop程序](hadoop_express/first_hadoop_app.md)
  * [常用hadoop命令](hadoop_express/hdfs_cmd.md)
* [Hive快速体验](hive_express/README.md)
  * [Hive介绍](hive_express/hive_intro.md)
  * [第一个Hive程序](hive_express/first_hive_app.md)
  * [Hive快速上手](hive_express/hive_base_op.md)
* [Hive数据类型](hive_datatype/README.md)
  * [字段类型](hive_datatype/field_datatype.md)
  * [格式转换](hive_datatype/implicit_conversions.md)
  * [存储格式](hive_datatype/store_datatype.md)
  * [使用ORC](hive_datatype/use_orc.md)
* [Hive数据管理](hive_data_management/README.md)
  * [管理表与外部表](hive_data_management/managed_external_table.md)
  * [创建表](hive_data_management/create_table.md)
  * [数据划分](hive_data_management/data_split.md)
* [其他内容](hive_misc/README.md)
  * [JDBC服务](hive_misc/hive_jdbc.md)
  * [Hive on Spark](hive_misc/hive_on_spark.md)
* [参考文献](REFERENCE.md)