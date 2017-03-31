# Hive介绍
## Hive架构图
![](../img/hive_arc.png)

Hive是基于Hadoop的一个数据仓库工具，可以将结构化的数据文件映射为一张数据库表，并提供sql查询功能，可以将sql语句转换为MapReduce任务（或其他执行引擎的分布式任务）进行运行。 其优点是学习成本低，可以通过类SQL语句快速实现简单的MapReduce统计，不必开发专门的MapReduce应用，十分适合数据仓库的统计分析。