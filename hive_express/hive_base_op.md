# Hive 快速上手

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
## 数据生成工具
### 帮助信息
``` bash
[ifnoelse@node-01 ~]$ java -jar data-gen.jar -h
--- useage and default args value ---

  -m, --datatype 生成数据的类型user或者tvlog  user
  -r, --urange 用成用户id的范围[1,r]        1
  -c, --count 生成记录条数                 1
  -t, --starttime tvlog的起始时间         2017-04-06 16:35:00
  -p, --splitter 字段分隔符
  -h, --help

--- user config ---

{:datatype user, :urange 1, :count 1, :starttime 2017-04-06 16:35:00, :splitter 	, :help true}

--- data fields ---

user(用户ID,姓名，性别，年龄，教育程度，地址)
tvlog(用户ID，频道，开始时间，结束时间)

```
### 生成用户信息
``` bash
[ifnoelse@node-01 ~]$ java -jar data-gen.jar -r 10
1	孙爬	男	61	中专	常德市
2	慕容链	男	56	本科	泰州市
3	高确双	女	13	本科	雅安市
4	徐帖	男	40	小学	通辽市
5	独孤蚂	女	67	初中	昌都地区
6	汪伴	女	23	大专	六安市
7	郑俯蚤	女	44	初中	阳泉市
8	吕酝	男	20	博士	随州市
9	刘釜	女	27	小学	北海市
10	上官棺说	男	25	本科	遂宁市
```
### 生成观看行为数据
``` bash
[ifnoelse@node-01 ~]$ java -jar data-gen.jar -m tvlog -r 10 -c 10
5	广西电视台卫星频道	2017-04-07 00:35:00	2017-04-07 02:30:41
7	中央台三套	2017-04-07 00:35:00	2017-04-07 00:59:16
1	安徽卫视	2017-04-07 00:35:00	2017-04-07 02:47:48
10	河北卫视	2017-04-07 00:35:00	2017-04-07 01:44:18
2	陕西卫视	2017-04-07 00:35:00	2017-04-07 01:45:14
6	中央台三套	2017-04-07 00:35:00	2017-04-07 01:48:40
1	江西卫视	2017-04-07 02:47:48	2017-04-07 03:34:53
5	湖北卫视	2017-04-07 02:30:41	2017-04-07 04:11:47
8	东南卫视	2017-04-07 00:35:00	2017-04-07 03:01:25
1	宁夏卫视	2017-04-07 03:34:53	2017-04-07 04:34:07
```