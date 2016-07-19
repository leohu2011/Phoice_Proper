<?php
header('Content_type: text/json; charset=UTF-8');

// echo "insert page";

if(($_FILES['testingPhoto']['type'] == "image/png") && ($_FILES["testingPhoto"]["size"] < 100000)){
	if($_FILES['testingPhoto']['error'] > 0){
		echo $_FILES['testingPhoto']['error'];
	}
	else{
		$fileName = $_FILES['testingPhoto']['name'];
		$fileSize = $_FILES['testingPhoto']['size'];
		$dotArray = explode('.', $fileName);
		$type = end($dotArray);
		$path = "./download/wu.png";
		$success = move_uploaded_file($_FILES['testingPhoto']['tmp_name'], $path);

		$resultArray = array("result" => "success",
								"path" => $path,
								"filename" => $fileName,
								"type" => $type,
								"size" => $fileSize,
								"move status" => $success,
								"error" => $_FILES['testingPhoto']['error']);
		echo json_encode($resultArray);
	}
}
else{
	echo "wrong format";
}


?>