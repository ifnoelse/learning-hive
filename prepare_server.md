### 设置免密钥认证
具体操作参考这里：[配置ssh免密码登录](https://my.oschina.net/u/1258442/blog/180770)
#### 生成秘钥
``` bash
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub>>~/.ssh/authorized_keys
```
#### 分发秘钥
安装如下方式将刚才生成的秘钥分发到需要免秘钥登陆的机器上
``` bash
ssh ifnoelse@node-02 'mkdir -p ~/.ssh'
scp ~/.ssh/authorized_keys ifnoelse@node-02:~/.ssh
ssh ifnoelse@node-02 'chmod 700 ~/.ssh;chmod 600 ~/.ssh/authorized_keys'
```

### 配置服务器环境
[官方参考文档](https://www.cloudera.com/documentation/enterprise/5-9-x/topics/install_cdh_dependencies.html)

#### 禁用ipv6
修改以下文件
``` bash
sudo vim /etc/sysctl.conf
```
添加内容如下
``` bash
#disable ipv6
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
net.ipv6.conf.lo.disable_ipv6=1
```
之后执行
``` bash
sudo sysctl -p
```
#### 关闭防火墙
执行如下命令
``` bash
systemctl stop firewalld.service #停止firewall
systemctl disable firewalld.service #禁止firewall开机启动
```

#### 关闭SELinux
修改以下文件，然后重启服务器
``` bash
sudo vim /etc/sysconfig/selinux #修改SELINUX=disabled
```

#### 修改hostname
``` bash
sudo hostnamectl --static set-hostname 你的计算机名
```
#### 在/etc/hosts中添加计算机名
``` bash
echo -e '172.31.14.201\tnode-01
172.31.10.173\tnode-02
172.31.12.144\tnode-03
172.31.11.226\tnode-04
172.31.8.109\tnode-05'>>/etc/hosts
```