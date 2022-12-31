<?php
include 'conn.php';
//$id = $_POST['id'];
$titulo = $_POST['titulo'];
$programa = $_POST['programa'];
$conn->query("delete from ".$programa." where titulo ='".$titulo."'");

file_put_contents("testdelete.txt","delete from ".$programa." where titulo ='".$titulo."'");
?>