title: Python巨型集合运算的几种方法
date: 2015-06-09 10:15:15
category: python
tags: python
---

我们有时候需要对巨型的集合（数量在百万，千万甚至更大）进行一下运算，包括交集、并集、差集。以下总结了在Python中实现的集中方法，以及其优缺点。

## 使用set

方法：
1. 并集 `s.union(t)` 或者 `s | t`
2. 交集 `s.intersection(t)`	或者 `s & t`
3. 差集 `s.difference(t)` 或者 `s - t`

### 特点
1. 速度快
2. 内存消耗大，一个1万个元素的集合，其占用的内存远大于1万 * 每个元素的大小，因为整个set数据结构占用大量其他空间来存储索引之类的东西。

## 使用Numpy
`import numpy as np`

可以先把要操作的元素放在数组而不是set中，同样内容的数组占用的内存比set小的多。
1. 并集, `np.union1d(s ,t)`，返回排序的、去重的两个list的合集
2. 交集, `np.intersect1d(s, t, assume_unique=True)`返回排序的、去重的两个list的交集，尽可能保证传入的两个list是去重的，这可以加快运算速度。
3. 差集,  `np.setdiff1d(s, t, assume_unique=True)`, 返回排序的，去重的差集，assume_unique参数同上。

### 特点
1. 占用内存会小于set的方式。
2. 速度接近set方式。

## 使用cmd

以上两种方法的缺点就是当集合足够大而内存又不够的时候，迟早会MemoryError。在试验中2000万个长度为24的字符串在4G的内存中就报MemoryError了。那么有终极解决办法，即使用linux 命令，我们依赖的命令有两个。

### 先将文件排序
使用sort命令有两个用处，一是将文件内容排序，

`sort --buffer-size=1G --output=/path/to/output /path/to/src_file`
--buffer-size在Debian上可用，其他平台未知，不是标准参数.

### 并集
这是sort命令的第二个用处
`sort -m /path/to/src1 /path/tosrc2 -u --output=/path/to/result`
注意的是src1, src2必须是已排序的文件，而且结果也是已排序的。

### 交集和差集
使用comm命令，注意的是传入的文件必须都是已排序的。

交集`comm -12 file1 file2 > output` 
差集`comm -3 file1 file2 > output`

### 特点
1. 内存消耗小，会使用临时文件来避免内存问题。
2. 耗时长。

综上所述，三种方法依次对内存的依赖减小，耗时增加，可依据集合大小以及硬件环境来选择。


