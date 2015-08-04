title: mongodb备份和恢复
date: 2015-04-22 18:49:52
tags: mongodb
category: mongodb
---


##dump & restore方法

要备份一个数据库，
`mongorestore -d db  /path/to/back_up`
例如:
`mongodump -d bookstore -o /data01/db_backup/`
该命令会dump出该DB所有的collection

从备份文件夹恢复数据
`mongorestore -d bookstore  /data01/db_backup/bookstore`

###只备份或回复指定的collection

以bookstore DB 中statistics 表为例
`mongodump -d bookstore -c statistics -o /data01/db_backup/`

然后restore时指定该collection对应的bson文件
`mongorestore -d bookstore -c statistics /data01/db_backup/bookstore/statistics.bson`

###通过条件查询dump
还可以通过一个query来dump中一个collection中符合条件的某些记录, 例如
`mongodump -d bookstore -c novel_sources -q "{\"tag\": \"tag_11\"}" -o /data01/db_backup/`

### 注意事项
1. mongorestore并不会覆盖已有的记录，而是重复添加（如果可以的话）。
2. 当数据量很大的时候，该方法耗时很大。

##直接备份数据文件

```bash
mongo 127.0.0.1:27017/db_to_back --eval "db.fsyncLock()"
rsync -avh --delete /path/to/your/mongofile /path/to/backup/folder/
mongo 127.0.0.1:21001/turbo --eval "db.fsyncUnlock()"
```
关键是第一行和第三行的两个命令,对于db.fsyncLock()，mongodb的文档说明

> db.fsyncLock()
Forces the mongod to flush all pending write operations to the disk and locks the entire mongod instance to prevent additional writes until the user releases the lock with the db.fsyncUnlock() command. db.fsyncLock() is an administrative command.


将mongod 未完成的写操作写入数据文件并阻止新的写入操作，知道运行`db.fsyncUnlock()`命令，因此拷贝数据文件前后要执行这两个命令。

