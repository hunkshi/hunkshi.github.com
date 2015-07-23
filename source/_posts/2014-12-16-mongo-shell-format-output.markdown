---
layout: post
title: "格式化mongo shell的输出"
date: 2014-12-16 11:08
comments: true
categories: mongodb
---

mongo shell 默认的输出很乱，几乎没法阅读。解决办法如下。

## .pretty() 方法
`db.collection.find().pretty()`
这样的输出会漂亮很多，每个field一行, 
{% codeblock lang:json %}
{
	"_id" : ObjectId("5396cd3823e97923ba689ef3"),
	"batch" : 66,
	"category" : 4,
	"cover_imgs" : [
		"/post_imgs/5396cd3823e97923ba689ef3/c_2.jpg",
		"/post_imgs/5396cd3823e97923ba689ef3/c_3.jpg",
		"/post_imgs/5396cd3823e97923ba689ef3/c_4.jpg"
	],
	"created_at" : ISODate("2014-06-10T09:18:06.383Z"),
	"fav_count" : 0,
	"host_reply_count" : 338,
	"last_reply_date" : "2014-06-17 21:22:00",
	"post_date" : "2014-06-06 19:57:00",
	"referer" : "http://tieba.baidu.com/f?kw=%B9%C5%D7%B0%B5%E7%CA%D3%BE%E7",
	"reply_count" : 716,
	"reuse_type" : 2,
	"section" : "古装电视剧",
	"seq" : 27180,
	"serial" : false,
	"sort_index" : 0.997,
	"source_site" : "贴吧",
	"updated_at" : ISODate("2014-06-18T09:04:55.228Z"),
	"visible" : true
}
{
	"_id" : ObjectId("5396c7ca23e97921fb7de8e4"),
	"batch" : 74,
	"category" : 4,
}
{% endcodeblock %}

## 配置使其成为Default

添加如下配置到$HOME/.mongorc.js, 如果不存在则创建。
`DBQuery.prototype._prettyShell = true`

这样就不需要每次使用pretty()方法了，直接`db.collection.find()`即可。
