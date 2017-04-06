# Hive 基本操作

## 创建数据数据库
``` sql
create database mydb;
```
## 创建表
``` sql
CREATE TABLE IF NOT EXISTS tvlog 
( 
uid string, 
ch string, 
region string, 
starttime string, 
endtime string 
) 
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t' 
STORED AS TEXTFILE;
```
## 到入数据
``` sql
LOAD DATA LOCAL INPATH '/home/ifnoelse/tvlog' OVERWRITE INTO TABLE tvlog;
```
## 查询数据
``` sql
select count(distinct uid),region from tvlog group by region;
```
## 其他常用命令
* 显示所有的数据库
``` sql
SHOW databases;
```
* 切换数据库
``` sql
USE tvlog;
```
* 显示所有的表
``` sql
SHOW TABLES;
SHOW TABLES 'tv*';
SHOW TABLES IN mydb;
```
* 显示表详情
``` sql
DESC tvlog;
DESCRIBE EXTENDED tvlog;
DESCRIBE FORMATTED tvlog;
```
* 删除表
``` sql
DROP TABLE tvlog;
```
* 删除数据库
``` sql
DROP DATABASE mydb;
```