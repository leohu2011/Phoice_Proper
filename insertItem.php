<?php

// header('Content_type: text/json; charset=UTF-8');

// echo "I am here yo<br>";
// echo "<pre>";

// print_r($_POST);
// if($_POST["user"] == "") echo "name is an empty string <br>";
// if($_POST["user"] == false) echo "name is false<br>";
// if($_POST["user"] == null) echo "name is null<br>";
// if(isset($_POST["user"])) echo "name is set<br>";
// if(!empty($_POST["user"])) echo "name is not empty<br>";
// $user = $_POST["user"];
// $pwd = $_POST["pwd"];

$name = $_POST["name"];
$ID = $_POST["ID"];
$description = $_POST["description"];
$data = $_POST["testingPhoto"];


// print_r($_GET);
// if($_GET["user"] == "") echo "name is an empty string <br>";
// if($_GET["user"] == false) echo "name is false<br>";
// if($_GET["user"] == null) echo "name is null<br>";
// if(isset($_GET["user"])) echo "name is set<br>";
// if(!empty($_GET["user"])) echo "name is not empty<br>";

// $user = $_GET["user"];
// $pwd = $_GET["pwd"];


// echo "user name is: $user <br>";
// echo "$user password is: $pwd <br>";


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

$query="insert into photoInfo (photoName, photoID, photoDescription, photoData) values ('$name', '$ID', '$description', '$data')";//构建查询语句
$result=mysql_query($query);//执行查询
if(!$result)
{
	die("could not obtain any result from this database</br>".mysql_error());

}

// echo "I have reached here yo <br>";

mysql_free_result($result);

mysql_close($connection);//关闭连接

//returning a string to IOS
$return_value = array("result" => "this is a testing returning value");
echo json_encode($return_value);



?>