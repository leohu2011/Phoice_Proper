<?php
header('Content_type: audio/wav; charset=UTF-8');

// echo "insert page";

if(($_FILES['testingVoice']['type'] == "audio/wav") && ($_FILES["testingVoice"]["size"] < 100000)){
	if($_FILES['testingVoice']['error'] > 0){
		echo $_FILES['testingVoice']['error'];
	
	else{
		$fileName = $_FILES['testingVoice']['name'];
		$fileSize = $_FILES['testingVoice']['size'];
		$dotArray = explode('.', $fileName);
		$type = end($dotArray);
		$path = "./download/sample.wav";
		$success = move_uploaded_file($_FILES['testingVoice']['tmp_name'], $path);

		$resultArray = array("result" => "success",
								"path" => $path,
								"filename" => $fileName,
								"type" => $type,
								"size" => $fileSize,
								"move status" => $success,
								"error" => $_FILES['testingVoice']['error']);
		echo json_encode($resultArray);
	}
}
else{
	echo "wrong format";
}


?>