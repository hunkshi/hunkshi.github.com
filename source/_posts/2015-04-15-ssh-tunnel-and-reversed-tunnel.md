title: ssh 隧道和反向隧道
date: 2015-04-15 15:20:01
tags: [ssh, linux]
comments: true
categories: linux
---


## ssh 隧道

### 使用场景
我们经常要通过跳板机器去访问一些内部的机器，比如Production 环境中的一些服务器，正常模式下如果scp一些文件或者远程执行一些命令，都需要先登录跳板机器，再登录内部的服务器。
ssh 隧道可以很方便的解决这个问题。

假设office里的PC是A， 跳板机器B 111.111.111.111， 内部的server是C，B可以通过内部地址例如192.168.2.2, 端口22访问到C， 如下命令既可建立一个隧道，从A直接到C: ssh -NfL <local port>:<C address>:<C port> <username>@<B address>

### 命令

```bash
ssh -NfL 2345:192.168.2.2:22 alex@111.111.111.111
```

**参数解释**

-N Do not execute a remote command.  This is useful for just forwarding ports (protocol version 2 only). 即不执行命令， 只做端口转发
-f Requests ssh to go to background just before command execution. 然ssh隧道在后台运行。看进程关系即可明白。
-L Specifies that the given port on the local (client) host is to be forwarded to the given host and port on the remote side. 指定本地端口用于转发。

### 如何使用

```bash
scp -P 2345 /path/to/file root@127.0.0.1:/path/on/remote/server
```
即可scp文件到server C, 注意2345是建立隧道时指定的本地端口，或者远程执行命令

```bash
ssh -p 2345 root@127.0.0.1 "ls -l /"
```


## ssh 反向隧道

### 使用场景
假设有Office机器A，无公网地址，现在有一台公网机器B，家里的机器C和A都可以访问B，那么既可通过B 来实现从C到A的访问。需要先在A和B之间建立一个反向隧道。

### 命令
```bash
ssh -NfR 2222:127.0.0.1:22 root@B
```
那么从C登录到B 之后，即可通过如下命令跳到A
```bash
ssh -p 2222 alex@localhost
```

