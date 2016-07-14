<?php


$user = $_POST["name"];


// user _get method for testing or use Charles for _post method checking
// print_r($_GET);
// echo "<br>";
// $user = $_GET["name"];



$db_host='127.0.0.1';
$db_database='testDB';
$db_username='root';
$db_password='huqi660308';

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

$query="select * from userList where userName = '$user'";//构建查询语句
$result=mysql_query($query);//执行查询
if(!$result)
{
	
	die("could not obtain any result from this database</br>".mysql_error());
}



if (mysql_num_rows($result) == 0){
	$detail = "this name is not found";
	$duplicate = "success";
} 

else{
	$detail = "the submitted name has already been used";
	$duplicate = "failure";
}



mysql_free_result($result);
mysql_close($connection);//关闭连接


//returning a string to IOS
$return_value = array("result" => $duplicate,
						"detail" => $detail);
$return_value2 = @"this is a testing returning value";
echo json_encode($return_value);



?>