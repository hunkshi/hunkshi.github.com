title: nginx配置一个Basic Auth认证的下载服务
date: 2014-12-03 18:41:26
tags: nginx
category: nginx
---

使用nginx可以方便的搭建一个服务列出服务器上指定目录下的文件供用户下载，本文讲述如何搭建该服务，并给出如何配置用户名密码。

## 建用户和文件夹
1. 新建用户 shareuser
2. 建data文件夹，并chown -R shareuser:shareuser /path/to/data

## 列出指定目录下的文件
需要的指令是`autoindex  on;`, 即可列出该目录下的所有文件并可以递归计入子目录。

还有两个辅助的指令
`autoindex_exact_size on | off;` , 即文件大小以字节数显示还是K/M/G显示
`autoindex_localtime on | off;` 以local timezone还是UTC显示文件的修改时间。

## 配置Basic Auth
两个指令
```
auth_basic "Restricted";
auth_basic_user_file ./passwd;
```
`auth_basic_user_file`是一个存储用户名密码的文件。需要htpasswd命令来生成，

### 密码文件生成
1. 首先需要安装` sudo apt-get install apache2-utils`
2. 命令`htpasswd -c /path/to/passwd username`
	-c  是新建一个文件, 如果是append到已有文件，不用该选项。
    根据提示输入密码即可。

## Config Sample
测试项目文件结构如下
```
app
	conf
		nginx.conf
    	passwd
	data
```
最终的结果如下：
```
  user shareuser;

  server {
    listen 8011;

    root data;
    # index index.html index.htm;	#关闭index,  否则会显示index.html而不是列出文件

    location  /  {
      autoindex  on;
      autoindex_exact_size off;
      autoindex_localtime on;

      auth_basic "Restricted";
      auth_basic_user_file passwd;
    }
  }
}
```
启动 `nginx -p /path/to/app -c conf/nginx.conf` 即可访问。
