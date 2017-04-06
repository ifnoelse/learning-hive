# 创建表

## 创建管理表
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
## 创建外部表

``` sql
CREATE EXTERNAL TABLE IF NOT EXISTS user_ext
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
STORED AS TEXTFILE
LOCATION '/user/ifnoelse/user';
```

* 外部表LOCATION指定的路径默认为HDFS路径
* 当然也可以为其他文件系统路径比如s3
``` sql
create external table kv (key int, values string)  location 's3n://data.s3ndemo.hive/kv';
```
* LOCATION 指定的路径应该为目录而不是文件
* 后续添加到LOCATION目录中的文件会被自动识别
* OVERWRITE INTO依然可以覆盖外部表中的数据