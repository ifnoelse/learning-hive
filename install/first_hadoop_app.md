# 第一个Hadoop程序
我们来运行hadoop世界的“hello world”程序,一个用来统计单词出现次数的word count程序
## 准备数据
创建用户目录
``` bash
sudo -u hdfs hadoop fs -mkdir /user/ifnoelse
sudo -u hdfs hadoop fs -chown ifnoelse /user/ifnoelse
```
查看此时hdfs中的目录如下：
``` bash
hadoop fs -ls -R /
```
![](../img/user_hdfs_dir.png)

> 如果遇到权限问题，与linux权限控制一样的，如果有权限依然不能完成操作，尝试重启hdfs

上传文本文件到hdfs测试hadoop程序,内容最好是英文
``` bash
hadoop fs -mkdir /user/ifnoelse/input
hadoop fs -put words.txt /user/ifnoelse/input
```
>words.txt为自己创建的一个文本文件

## 程序代码
``` java
package com.ifnoelse.hadoop.example;

import java.io.IOException;
import java.util.StringTokenizer;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;

public class WordCount {

    public static class TokenizerMapper
            extends Mapper<Object, Text, Text, IntWritable> {

        private final static IntWritable one = new IntWritable(1);
        private Text word = new Text();

        public void map(Object key, Text value, Context context
        ) throws IOException, InterruptedException {
            StringTokenizer itr = new StringTokenizer(value.toString());
            while (itr.hasMoreTokens()) {
                word.set(itr.nextToken());
                context.write(word, one);
            }
        }
    }

    public static class IntSumReducer
            extends Reducer<Text, IntWritable, Text, IntWritable> {
        private IntWritable result = new IntWritable();

        public void reduce(Text key, Iterable<IntWritable> values,
                           Context context
        ) throws IOException, InterruptedException {
            int sum = 0;
            for (IntWritable val : values) {
                sum += val.get();
            }
            result.set(sum);
            context.write(key, result);
        }
    }

    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        String[] otherArgs = new GenericOptionsParser(conf, args).getRemainingArgs();
        if (otherArgs.length < 2) {
            System.err.println("Usage: wordcount <in> [<in>...] <out>");
            System.exit(2);
        }
        Job job = Job.getInstance(conf, "word count");
        job.setJarByClass(WordCount.class);
        job.setMapperClass(TokenizerMapper.class);
        job.setCombinerClass(IntSumReducer.class);
        job.setReducerClass(IntSumReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);
        for (int i = 0; i < otherArgs.length - 1; ++i) {
            FileInputFormat.addInputPath(job, new Path(otherArgs[i]));
        }
        FileOutputFormat.setOutputPath(job,
                new Path(otherArgs[otherArgs.length - 1]));
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}

```
项目配置及依赖的类库
``` groovy
group 'com.ifnoelse'
version '1.0'

apply plugin: 'java'

sourceCompatibility = 1.8

repositories {
    maven {
        url "http://maven.aliyun.com/nexus/content/groups/public/"
    }
}

dependencies {
    compile group: 'org.apache.hadoop', name: 'hadoop-mapreduce-client-core', version: '2.6.0'
    compile group: 'org.apache.hadoop', name: 'hadoop-common', version: '2.6.0'
}

```

## 运行第一个hadoop程序

用户自己打包的程序按以下方式执行

``` bash
hadoop jar hadoop-example-1.0.jar com.ifnoelse.hadoop.example.WordCount /user/ifnoelse/input /user/ifnoelse/output
```

>cdh自带示例
>``` bash
>hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar wordcount /user/ifnoelse/input /user/ifnoelse/output
>```

如果集群正常的话过一会程序就会执行成功，通过以下命令查看程序执行结果
``` bash
hadoop fs -cat /user/ifnoelse/output/part-r-00000
```
![](../img/first_hadoop_app_res.png)