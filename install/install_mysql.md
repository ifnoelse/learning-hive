# 安装mysql
[mysql安装说明](https://dev.mysql.com/doc/refman/5.7/en/linux-installation-yum-repo.html)

## 安装yum源
``` bash
sudo rpm -ivh https://repo.mysql.com//mysql57-community-release-el7-9.noarch.rpm
```
## 安装mysql
``` bash
sudo yum install mysql-community-server
```
## 启动mysql
``` bash
sudo service mysqld start
```
## 修改MySQL root密码
查看临时密码
``` bash
sudo grep 'temporary password' /var/log/mysqld.log
```

初始化hive元数据库
``` bash
$ mysql -u root -p
Enter password:
mysql> CREATE DATABASE metastore;
mysql> USE metastore;
mysql> SOURCE /usr/lib/hive/scripts/metastore/upgrade/mysql/hive-schema-1.1.0.mysql.sql
```
如果遇到如下错误

![](../img/mysql_error.png)

修改sql脚本
sudo vim /usr/lib/hive/scripts/metastore/upgrade/mysql/hive-schema-1.1.0.mysql.sql
```
SOURCE hive-txn-schema-0.13.0.mysql.sql;
```
修改成
```
SOURCE /usr/lib/hive/scripts/metastore/upgrade/mysql/hive-txn-schema-0.13.0.mysql.sql;
```
然后删掉数据库再重新运行一下元数据初始过程