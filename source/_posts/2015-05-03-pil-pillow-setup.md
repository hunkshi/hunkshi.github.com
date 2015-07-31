title: Python PIL & Pillow 安装
date: 2015-05-03 16:13:58
tags: PIL Pillow
category: python
---

## Introduction

PIL(Python Imaging Library)是python处理图片的库，Pillow is the “friendly PIL fork”。
PIL最新版本是 1.1.7, 最近的更新是在2009年。推荐使用Pillow。

## 安装

正常情况，只需`pip install PIL==1.1.7` 或者`pip install Pillow==2.9.0`即可。但需留意安装后的输出

安装完成后，需留意输出：
```
*** TKINTER support not available
*** JPEG support not available
*** WEBP support not available
*** ZLIB (PNG/ZIP) support not available
*** FREETYPE2 support not available
*** LITTLECMS support not available
```
是否有需要但不支持的格式，如果有，需安装支持的包。以jpg/png/web为例。

## 依赖库(library)安装

首先检查是否已经安装

```bash
ll /usr/lib/libjpeg.*

-rw-r--r-- 1 root root 221942 Jun 30  2010 /usr/lib/libjpeg.a
-rw-r--r-- 1 root root    918 Jun 30  2010 /usr/lib/libjpeg.la
lrwxrwxrwx 1 root root     17 Mar 21 16:19 /usr/lib/libjpeg.so -> libjpeg.so.62.0.0
lrwxrwxrwx 1 root root     17 Jan 10 10:44 /usr/lib/libjpeg.so.62 -> libjpeg.so.62.0.0
-rw-r--r-- 1 root root 145048 Jun 30  2010 /usr/lib/libjpeg.so.62.0.0
```
如果没有，则需要安装包
For Debian
`apt-get install libjpeg8-dev`  	for jpg
`apt-get install zlib1g-dev`		for png
`apt-get install libwebp-dev`		for webp

For Centos
`yum install libjpeg-devel libpng-devel libwebp-devel`

安装完成后，还需要手动建立软链接

For  DEBIAN 7  & Ubuntu14.04
```sh
ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so /usr/lib
ln -s /usr/lib/x86_64-linux-gnu/libfreetype.so /usr/lib
ln -s /usr/lib/x86_64-linux-gnu/libz.so /usr/lib
ln -s /usr/lib/x86_64-linux-gnu/libwebp.so /usr/lib
```

For Centos 6.5
```sh
ls -s /usr/lib64/libjpeg.so /usr/lib
ls -s /usr/lib64/libz.so /usr/lib
ls -s /usr/lib64/libwebp.so /usr/lib
```

## 重新安装
以上就绪后，两种办法重新安装:
1. `pip install -I PIL==1.1.7`, -I意思是Force reinstall。安装完成时留意输出对格式的支持。

2.下载源码重装一次，以PIL为例
```
wget http://effbot.org/downloads/Imaging-1.1.7.tar.gz
tar -xzvf Imaging-1.1.7.tar.gz
cd Imaging-1.1.7
python setup.py install
```

对格式的支持可在源码目录下
`python selftest.py`
*** TKINTER support not installed
--- JPEG support ok
--- ZLIB (PNG/ZIP) support ok

如果这里有问题(Debian & Ubuntu没有，但Centos 6.5有), 需要 `python setup.py build_ext -i`  然后重试。


## WebP格式的支持
PIL太老了，缺少对webp格式的支持，必须换Pillow 2.0以上版本。

## 共存的问题
要使用Pillow，需先卸载PIL，`pip uninstall PIL`如果卸载失败，只能手动删除
`sudo rm -rf /usr/share/pyshared/PIL.pt`
`sudo rm -rf /usr/share/pyshared/PIL`

`pip install Pillow==2.9.0`

