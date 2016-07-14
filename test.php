<?php

echo "link successful! <br>";

$db_host='127.0.0.1';
$db_database='testDB';
$db_username='root';
$db_password='huqi660308';
// $connection = new mysqli_connect($db_host,$db_username,$db_password);
//注意这里的host name要用网管地址，而不是localhost
$connection = mysql_connect($db_host,$db_username,$db_password);
mysql_query("set names 'utf8'");//编码转化
if(!$connection){
	die("could not connect to the database:</br>".mysql_error());//诊断连接错误	
}
$db_selecct=mysql_select_db($db_database);//选择数据库
if(!$db_selecct)
{
	die("could not select the database</br>".mysql_error());	
}

$userName = 'this is nobody5';
$password = 'i dont care';

$query="insert into userInfo (name, pwd) values ('$userName', '$password')";//构建查询语句
$result=mysql_query($query);//执行查询
if(!$result)
{
	die("could not obtain any result from this database</br>".mysql_error());

}

echo "I have reached here yo <br>";

$query="select * from userInfo";//构建查询语句
$result=mysql_query($query);//执行查询
if(!$result)
{
	die("could not obtain any result from this database</br>".mysql_error());

}

echo "printing out the resultant table <br>";
//	array mysql_fetch_row(resource $result);
while($result_row=mysql_fetch_row(($result)))//取出结果并显示
{
	$name=$result_row[0];
	$pwd=$result_row[1];

	echo "<tr>";
	echo "<td>$name<br></td>";
	echo "<td>$pwd<br></td>";
	echo "------------------------- <br>";
	echo "</tr>";
}


mysql_close($connection);//关闭连接


?>
