# 第一个Hive程序
之前已经体验过MapReduce完成word count，现在我们来看一下如何用hive来完成这个功能，首先同过hive命令进入hive cli，之后执行以下步骤
## 创建表
``` sql
CREATE TABLE words (line STRING);
```
## 导入数据
``` sql
LOAD DATA [LOCAL] INPATH 'words.txt' OVERWRITE INTO TABLE words;
```
## 执行单词统计
``` sql
CREATE TABLE word_counts AS
SELECT word, count(1) AS count FROM
(SELECT explode(split(line, ' ')) AS word FROM words) w
GROUP BY word
ORDER BY word;
```
