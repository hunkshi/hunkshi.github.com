title: Mongodb Master-Slave模式配置及常见问题
date: 2015-06-07 16:13:58
tags: mongodb
category: mongodb
---

master-slave是一种经典的数据复制模式，可以1个master + N个slave构成一个集群，一方面实现数据的冗余备份，一方面实现读写分离。在大型的web应用中经常使用。

##配置
mongodb的master-slave模式配置方式如下

### keyFile
1. 生成key_file `openssl rand -base64 741 > mongo_key`
2. 将mongo_key 分别置于master 和 slave mongodb user可以access的地方。
3. 设置权限 `chmod 700 mongo_key`
4. 设置onwer `chown mongodb:nogroup mongo_key`

### master配置
编辑/etc/mongodb.conf, 设置如下
```
	master = true
	keyFile = /path/to/mongo_key
```

### slave 配置
```
slave = true
source = <ip of master>
only = bookstore
keyFile = /usr/local/bookstore/mongo_key
```
如果只同步一个db，配置only项，如果多个DB需同步，注释掉only项。

以上设置完毕后即可启动master和slave了，如果配置有误会启动失败，比如key_file权限不正确，具体错误可以查看/var/log/mongodb/mongodb.log。如无误，即可在master上修改一些记录进行验证了。



## 配置更改
master-slave配置比较简单，但要修改已经运行正确的配置缺不是想象的那么简单。例如要更改master地址，或者去除only配置。因为mongodb启动时，会将配置写入DB中，master的配置在local DB的slaves表中, slave的配置在local DB的sources表中。如果单独更改conf文件，直接重启会失败，log中显示和DB中的配置冲突。如果直接修改local DB，修改会很快被覆盖。


#### 操作办法
1. 取消slave配置重启。即注释掉slave = true这一行。
2. 手动修改sources表，例如更改master 的ip或者去除only 项。
3. 修改conf文件，打开slave = true，并修改其他项，例如更改master 的ip或者去除only 项。
4. 再次重启mongodb。

## 其他问题

### 手动强制同步

如果slave因为特殊原因和master不同步，需要手动强制同步，方法为在slave上运行如下命令：
```
use admin
db.runCommand( { resync: 1 } )
```
如果数据落后较多，则需要较长时间。





