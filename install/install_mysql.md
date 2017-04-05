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
修改mysql密码
``` bash
$ mysql -u root -p
Enter password:
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'user_root_passwd';
```