title: 备份nginx日志
date: 2015-02-15 11:25:04
tags: nginx
category: nginx
---

我们经常需要每天rotate前一天的nginx log，如下是一个通用的脚本

```bash
#! /bin/bash

date=$(date --date="-1 day" +"%Y-%m-%d")
target_dir=/data01/log_backup
target_filename=nginx-access-app-name.$date.log

mv /var/log/your-app-name/nginx-access.log /var/log/your-app-name/$target_filename
kill -USR1 `cat /var/run/nginx-app-name.pid`

mv /var/log/you-app-name/$target_filename $target_dir/

# call other script here, e.g. parse_log.sh $target_dir/$target_filename

```

注意的几点：
1. 第7行和第10行有两个mv，第一个mv把log改名在同一个文件夹下，发送信号后再mv走，是因为我们经常存储备份文件的盘是一个独立的硬盘，如果文件较大，直接mv会卡住几秒钟。

2. USR1是nginx 用于`Reopen the log files`的信号，参见[nginx 文档](http://wiki.nginx.org/CommandLine)

3. mv完毕后可以调用其他脚本进行log处理

如上脚本完毕后，即可配置crontab定期运行，例如如下，每天晚上00：05进行log rotate
`05 00 * * * /path/to/you_app_dir/log_rotate.sh`

