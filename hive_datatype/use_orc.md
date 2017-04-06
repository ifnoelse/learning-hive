# 使用ORC
## 创建ORC表
用户表

``` sql
CREATE TABLE IF NOT EXISTS user_orc 
( 
uid string, 
name string, 
sex string, 
age string,
edu string,
addr string
) STORED AS ORC;
```

观看行为表

``` sql
CREATE TABLE IF NOT EXISTS tvlog_orc
( 
uid string, 
ch string, 
starttime string, 
endtime string 
) STORED AS ORC;
```

## 导入数据

``` sql
insert into table user_orc select * from user;
insert into table tvlog_orc select * from tvlog;
```

## 查看Hive中数据大小
``` bash
hadoop fs -ls -h -R /user/hive
```