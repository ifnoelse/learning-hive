# hadoop 发行版本介绍
## APACHE
Apache维护Hadoop核心代码和发行版本
## CLOUDERA（CDH）
Cloudera是老牌的Hadoop版本发行商,该公司雇佣了大量Hadoop Committers,Doug Cutting也在其中，相比于Apache的发行版本CDH在bug修复及新特性方面表现得更好，此外Cloudera还发开发了一些hadoop组件比如Impala
## HORTONWORKS（HDP）
Hortonworks同样也雇佣了很多Hadoop Committers，Hortonworks对hadoop的修改相比于Cloudera要轻微一些,比如同样是SQL-on-Hadoop问题，Cloudera选择自己开发Impala，Hortonworks则在Hive的基础上解决延时问题
## MAPR
相比Cloudera和Hortonworks，MapR只有少量的Hadoop Committers，MapR对Hadoop系统的修改也非常大，比如他们认为HDFS没有达到工业级标准，所以他们开发了自己的分布式文件存储系统，并且MapR的部分软件是闭源的

## 总结
1. 如果你的公司规模很大，很多该特性需要定制开发，那么选择Apache发行版本比较理想，Apache软件版本迭代比较快，新特性能及时加入
2. 对于中小型公司选择CDH发行版本相对来说维护成本比较低，安装升级都比较方便，并且该版本也包含一些bugs修复及新特性
3. HDP与MAPER在国内相对比较小众，如果有时间和精力的话可以选择尝尝鲜

>参考《Hadoop in Practice, 2nd Edition》