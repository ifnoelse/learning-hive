# Hive 快速上手
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
> 生成数据的合理性：学历是有比例控制的基本符合现实情况，用户观看行为在时间上是合理的

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
## 创建数据数据库
``` sql
create database mydb;
```
## 创建表
用户表（用户ID，姓名，性别，年龄，教育程度，地址）
``` sql
CREATE TABLE IF NOT EXISTS user 
( 
uid string, 
name string, 
sex string, 
age string,
edu string,
addr string
) 
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t' 
STORED AS TEXTFILE;
```
观看行为表
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
## 加载数据
``` sql
LOAD DATA LOCAL INPATH '/home/ifnoelse/user' OVERWRITE INTO TABLE user;
LOAD DATA LOCAL INPATH '/home/ifnoelse/tvlog' OVERWRITE INTO TABLE tvlog;
```
## 查询数据
显示表中10条记录
``` sql
select * from mydb.user limit 10;
select * from mydb.tvlog limit 10;
```
按地域统计tvlog中的独立用户数
``` sql
SELECT COUNT(DISTINCT t.uid), u.addr
FROM mydb.user u, mydb.tvlog t
WHERE u.uid = t.uid
GROUP BY u.addr
```
统计tvlog中30到35的用户数
``` sql
SELECT COUNT(DISTINCT t.uid), u.age
FROM (SELECT uid, age
	FROM mydb.user
	WHERE age >= '30'
		AND age <= '35'
	) u, mydb.tvlog t
WHERE u.uid = t.uid
GROUP BY u.age
ORDER BY u.age
```
## 单次执行
执行sql并将结果写入result.txt文件
``` bash
hive -e "select count(distinct t.uid),u.addr from mydb.user u,mydb.tvlog t where u.uid=t.uid group by u.addr" > result.txt
```
## 用程序处理结果集
去掉结果集中城市中的‘市’字，比如“北京市”修改成“北京”
* 查询语句

``` bash
hive -e "select count(distinct t.uid),u.addr from mydb.user u,mydb.tvlog t where u.uid=t.uid group by u.addr" | java/python trim > result.txt
```

* python代码

``` python
# -*- coding: utf-8 -*- 
import sys
for ln in sys.stdin:
    print ln.replace('市',''),
```

* java代码

``` java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class trim {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        for(String ln =br.readLine();ln!=null;ln=br.readLine()){
            String r = ln.replaceAll("市","");
            System.out.println(r);
        }

    }
}
```
## 用户变量
``` sql
set zzz=5;
--  sets zzz=5
set zzz;
 
set system:xxx=5;
set system:xxx;
-- sets a system property xxx to 5
 
set system:yyy=${system:xxx};
set system:yyy;
-- sets yyy with value of xxx
 
set go=${hiveconf:zzz};
set go;
-- sets go base on value on zzz
 
set hive.variable.substitute=false;
set raw=${hiveconf:zzz};
set raw;
-- disable substitution set a value to the literal
 
set hive.variable.substitute=true;
 
EXPLAIN SELECT * FROM src where key=${hiveconf:zzz};
SELECT * FROM src where key=${hiveconf:zzz};
--use a variable in a query
 
set a=1;
set b=a;
set c=${hiveconf:${hiveconf:b}};
set c;
--uses nested variables.
 
 
set jar=../lib/derby.jar;
 
add file ${hiveconf:jar};
list file;
delete file ${hiveconf:jar};
list file;
```
>参考：https://cwiki.apache.org/confluence/display/Hive/LanguageManual+VariableSubstitution

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
* 在命令行中显示当前数据库名
                                                
``` sql
set hive.cli.print.current.db=true;
``` 
* 查询出来的结果显示列的名称

``` sql
set hive.cli.print.header=true;
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
* 清空表

``` sql
TRUNCATE TABLE tvlog;
```
* 删除数据库

``` sql
DROP DATABASE mydb [CASCADE];
```
