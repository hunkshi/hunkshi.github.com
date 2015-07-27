title: 备份redis数据文件
date: 2015-04-05 14:49:44
category: redis
tags: redis
---

看如下脚本，
```bash
#! /bin/bash

PATH=/usr/local/bin:$PATH
redis-cli SAVE

date=$(date +"%Y%m%d")
cp /var/lib/redis/6379/dump.rdb /data01/cache_backup/$date.rdb

echo "done!"
```
有如上脚本，便可以cron等方式备份redis数据文件了。细节如下：

首先必须进行SAVE, 因为redis的rdb文件并非总是内存数据的完整镜像，备份之前必须进行SAVE，即向其发送SAVE命令，其次拷贝走其rdb文件即可。

rdb的具体路径不一定是如上路径，可以在redis配置文件中查找, /etc/redis/6379.conf

```
# The filename where to dump the DB
dbfilename dump.rdb

# The working directory.
#
# The DB will be written inside this directory, with the filename specified
# above using the 'dbfilename' configuration directive.
#
# Also the Append Only File will be created inside this directory.
#
# Note that you must specify a directory here, not a file name.
dir /var/lib/redis/6379

```
