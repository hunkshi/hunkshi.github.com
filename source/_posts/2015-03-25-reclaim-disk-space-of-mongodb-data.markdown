---
layout: post
title: "回收被 mongodb 占用的硬盘空间"
date: 2015-03-25 18:07
comments: true
categories: mongodb
---

首先一点就是mongodb 不会释放已经占用的硬盘空间，即使drop collection也不行，除非drop database。如果一个db曾经有大量的数据一段时间后又删除的话，硬盘空间就是一个问题，如何收回被mongdodb占用的多余空间？方法有两种

## 1. dump & restore

{% codeblock lang:bash %}
mongodump -d databasename -o /path/to/dump_dir
echo 'db.dropDatabase()' | mongo <databasename>
mongorestore -d <databasename>  /path/to/dump_dir
{% endcodeblock %}

如果数据量不大，dump不需要太长时间的情况下，或者经常备份有dump文件的情况下，这种方法很简单。

## 2. repair database

即在mongo shell中运行`db.repairDatabase()`, 或者`db.runCommand({ repairDatabase: 1 })`, 第二种方法可以带其他几个参数
```json
{ repairDatabase: 1,
  preserveClonedFilesOnFailure: <boolean>,
  backupOriginalFiles: <boolean> }
```

repairDatabase是官方文档中认为唯一可以回收硬盘空间的方法。
> repairDatabase is the appropriate and the only way to reclaim disk space.

当你有多个shard的且数据量巨大时，dump & restore方法会花费巨大的时间，这时第二种方法的优势就很明显，就是分别在每个shard上运行repairDatabase，结果会快很多。




