---
layout: post
title: "C++中typename关键字的使用方法和注意事项"
date: 2013-08-09 16:34
comments: true
categories: c++
---


**迁移自原[CSDN blog](http://blog.csdn.net/pizzq/article/details/1487004), 做简单整理**

###用处1, 用在模板定义里, 标明其后的模板参数是类型参数。###
例如

{% codeblock lang:cpp %}
template<typename  T, typename Y>
T foo(const T& t, const Y& y){//....};
{% endcodeblock %}

{% codeblock lang:cpp %}
templace<typename T>
class CTest
{
private:
 T t;
public:
 //...
}
{% endcodeblock %}


其实，这里最常用的是使用关键字class，而且**二者功能完全相同**，这里的class和定义类时的class完全是两回事，C++当时就是为了减少关键字，才使用了class。但最终却不得不引入了typename，究竟是

什么原因呢？请看第二条，也就是typename的第二个用法。

###用处2, 模板中标明“内嵌依赖类型名”###

这里有三个词，**内嵌、依赖、类型名**。那么什么是“内嵌依赖类型名(nested dependent type name)”？

请看SGI STL里的一个例子, 只是STL中count范型算法的实现：
{% codeblock lang:cpp %}
template <class _InputIter, class _Tp>
typename iterator_traits<_InputIter>::difference_type
count(_InputIter __first, _InputIter __last, const _Tp& __value) {
  __STL_REQUIRES(_InputIter, _InputIterator);
  __STL_REQUIRES(typename iterator_traits<_InputIter>::value_type,
                 _EqualityComparable);
  __STL_REQUIRES(_Tp, _EqualityComparable);
  typename iterator_traits<_InputIter>::difference_type __n = 0;
  for ( ; __first != __last; ++__first)
    if (*__first == __value)
      ++__n;
  return __n;
}
{% endcodeblock%}
这里有三个地方用到了typename：返回值、参数、变量定义。分别是：

{% codeblock lang:cpp%}
typename iterator_traits<_InputIter>::difference_type
typename iterator_traits<_InputIter>::value_type
typename iterator_traits<_InputIter>::difference_type __n = 0;
{% endcodeblock %}

difference_type， value_type就是依赖于_InputIter（模板类型参数）的类型名。源码如下：

{% codeblock lang:cpp %}
template <class _Iterator>
struct iterator_traits {
  typedef typename _Iterator::iterator_category iterator_category;
  typedef typename _Iterator::value_type        value_type;
  typedef typename _Iterator::difference_type   difference_type;
  typedef typename _Iterator::pointer           pointer;
  typedef typename _Iterator::reference         reference;
};
{% endcodeblock %}

+ **内嵌是指定义在类名的定义中的**。以上difference_type和value_type都是定义在iterator_traits中的。
+ **依赖是指依赖于一个模板参数**。 typename iterator_traits<_InputIter>::difference_type中difference_type依赖于模板参数_InputIter。
+ **类型名是指这里最终要指出的是个类型名，而不是变量**。例如iterator_traits<_InputIter>::difference_type完全有可能是类iterator_traits<_InputIter>  类里的一个static对象。而且当我们这样写的时候，C＋＋默认就是解释为一个变量的。所以，为了和变量区分，必须使用typename告诉编译器。

那么是不是所有的T::type_or_variable, 或者tmpl<T>:type_or_variable都需要使用typename呢？不是，有以下两个例外。

###例外###
（1）类模板定义中的基类列表。
例如
{% codeblock lang:cpp %}
template<class T>
class Derived: public Base<T>::XXX
{
...
}
{% endcodeblock %}
（2）类模板定义中的初始化列表。
{% codeblock lang:cpp %}
Derived(int x) : Base<T>::xxx(x)
{
...
}
{% endcodeblock %}
为什么这里不需要呢？因为编译器知道这里需要的是类型还是变量，（1）基类列表里肯定是类型名，（2）初始化列表里肯定是成员变量名。
