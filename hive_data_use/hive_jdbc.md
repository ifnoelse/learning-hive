# JDBC服务
## 配置HiveServer2的安全策略（自定义用户名密码验证）
自定义密码实现类如下：
``` java
package tv.huan.hive.auth;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import javax.security.sasl.AuthenticationException;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hive.conf.HiveConf;
import org.apache.hive.service.auth.PasswdAuthenticationProvider;

public class HuanPasswdAuthenticationProvider implements PasswdAuthenticationProvider {

	@Override
	public void Authenticate(String username, String password)throws AuthenticationException {
		boolean ok = false;
		String passMd5 = new MD5().md5(password);
		HiveConf hiveConf = new HiveConf();
		Configuration conf = new Configuration(hiveConf);
		String filePath = conf.get("hive.server2.custom.authentication.file");
		File file = new File(filePath);
		BufferedReader reader = null;
		try {
			reader = new BufferedReader(new FileReader(file));
			String tempString = null;
			while ((tempString = reader.readLine()) != null) {
				String[] datas = tempString.split(",", -1);
				if (datas.length != 2) {
					continue;
				}
				// ok
				if (datas[0].equals(username) && datas[1].equals(passMd5)) {
					ok = true;
					break;
				}
			}
			reader.close();
		} catch (Exception e) {
			e.printStackTrace();
			throw new AuthenticationException("read auth config file error, ["+ filePath + "] ..", e);
		} finally {
			if (reader != null) {
				try {
					reader.close();
				} catch (IOException e1) {
				}
			}
		}
		if (ok) {
			System.out.println("user [" + username + "] auth check ok .. ");
		} else {
			System.out.println("user [" + username + "] auth check fail .. ");
			throw new AuthenticationException("user [" + username
					+ "] auth check fail .. ");
		}
	}
}

// MD5加密
class MD5 {
	private MessageDigest digest;
	private char hexDigits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8','9', 'a', 'b', 'c', 'd', 'e', 'f' };

	public MD5() {
		try {
			digest = MessageDigest.getInstance("MD5");
		} catch (NoSuchAlgorithmException e) {
			throw new RuntimeException(e);
		}
	}

	public String md5(String str) {
		byte[] btInput = str.getBytes();
		digest.reset();
		digest.update(btInput);
		byte[] md = digest.digest();
		// 把密文转换成十六进制的字符串形式
		int j = md.length;
		char strChar[] = new char[j * 2];
		int k = 0;
		for (int i = 0; i < j; i++) {
			byte byte0 = md[i];
			strChar[k++] = hexDigits[byte0 >>> 4 & 0xf];
			strChar[k++] = hexDigits[byte0 & 0xf];
		}
		return new String(strChar);
	}
}
```
项目依赖
``` groovy
group 'tv.huan'
version '1.0'

apply plugin: 'java'

sourceCompatibility = 1.8

repositories {
    maven { url 'http://maven.aliyun.com/nexus/content/groups/public/' }
}

dependencies {
    compile group: 'org.apache.hadoop', name: 'hadoop-common', version: '2.6.0'
    compile(group: 'org.apache.hive', name: 'hive-cli', version: '1.1.0') {
        exclude group: 'org.apache.calcite'
    }
}
```
将以上代码打包成jar文件然后添加到/usr/lib/hive/lib/
## 配置Hive JDBC
修改配置文件/etc/hive/conf/hive-site.xml增加以下内容
``` xml
<property>
   <name>hive.support.concurrency</name>
   <value>true</value>
</property>
<property>
   <name>hive.zookeeper.quorum</name>
   <value>node-01</value>
</property>
<property>
   <name>hive.server2.thrift.min.worker.threads</name>
   <value>5</value>
</property>
<property>
   <name>hive.server2.thrift.max.worker.threads</name>
   <value>100</value>
</property>
<property>  
   <name>hive.server2.authentication</name>  
   <value>CUSTOM</value>  
</property>  
<property>  
   <name>hive.server2.custom.authentication.class</name>  
   <value>tv.huan.hive.auth.HuanPasswdAuthenticationProvider</value>  
</property>  
<property>  
   <name>hive.server2.custom.authentication.file</name>  
   <value>/usr/lib/hive/conf/user.password.conf</value>  
</property>
```
## 配置JDBC密码
``` bash
sudo vim /usr/lib/hive/conf/user.password.conf
```
添加以下内容
ifnoelse,密码的32位md5指
>示例：ifnoelse,e10adc3949ba59abbe56e057f20f883e

## 启动Hive Server2
``` bash
sudo service hive-server2 start
```

## Hive JDBC客户端
### 客户端下载地址
http://dbeaver.jkiss.org/
### JDBC config
![](../img/hive_jdbc_config.png)
### JDBC 使用示例
![](../img/hive_jdbc.png)