<?php

$user = $_POST["name"];
$pwd = $_POST["password"];
$userID = $_POST["ID"];
$autoLogin = $_POST["auto"];
$rememberName = $_POST["rmb"];


// user _get method for testing or use Charles for _post method checking
// print_r($_GET);
// echo "<br>";
// $user = $_GET["name"];
// $pwd = $_GET["password"];
// $userID = $_GET["ID"];
// $autoLogin = $_GET["auto"];
// $rememberName = $_GET["rmb"];


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

$query="insert into userList (userName, userPwd, userID, autoLogin, rmbName) values ('$user', '$pwd', '$userID', '$autoLogin', '$rememberName')";//构建查询语句
$result=mysql_query($query);//执行查询
if(!$result)
{
	die("could not obtain any result from this database</br>".mysql_error());

}

mysql_free_result($result);

mysql_close($connection);//关闭连接4


//returning a string to IOS
$return_value = array("result" => "success",
						"name" => $user,
						"password" => $pwd,
						"ID" => $userID);
$return_value2 = @"this is a testing returning value";
echo json_encode($return_value);


?>