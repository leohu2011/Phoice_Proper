<?php

// echo "this is login page";


$user = $_POST["name"];
$pwd = $_POST["password"];

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

$query="select * from userList where userName = '$user'";//构建查询语句
$result=mysql_query($query);//执行查询
if(!$result)
{
	die("could not obtain any result from this database</br>".mysql_error());

}

// echo "printing out the resultant table <br>";
//	array mysql_fetch_row(resource $result);
while($result_row=mysql_fetch_row(($result)))//取出结果并显示
{
	$name=$result_row[0];
	$pass=$result_row[1];

	if($pwd == $pass){
		// echo "login successful <br>";
		$loginResult = "success";
		$detail = "password correct";
	}
	else{
		// echo "worong password <br>";
		$loginResult = "failure";
		$detail = "password wrong";
	}

	// echo "<tr>";
	// echo "<td>$name<br></td>";
	// echo "<td>$pass<br></td>";
	// echo "------------------------- <br>";
	// echo "</tr>";
}

mysql_free_result($result);

mysql_close($connection);//关闭连接4


//returning a string to IOS
$return_value = array("result" => $loginResult,
						"detail" => $detail);
// var_dump($return_value);
echo json_encode($return_value);



?>