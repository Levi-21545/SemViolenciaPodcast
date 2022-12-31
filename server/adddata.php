<?php
include 'conn.php';
$programa = $_POST['programa'];
$titulo = $_POST['titulo'];
$dia = $_POST['dia'];
$duracao= $_POST['duracao'];
$arq = $_POST['arq'];
$thumb = $_POST['thumb'];
$arqD = $_POST['arqD'];
$thumbD = $_POST['thumbD'];

file_put_contents('eps/'.$arq, $arqD);
file_put_contents('thumb/'.$thumb, $thumbD);
echo "File Uploaded Successfully.";
$conn->query("insert into ".$programa."(programa,titulo,dia,duracao,arq,thumb) values ('".$programa."','".$titulo."','".$dia."','".$duracao."','".$arq."','".$thumb."')");
file_put_contents("test.txt","insert into ".$programa."(programa,titulo,dia,duracao,arq,thumb) values ('".$programa."','".$titulo."','".$dia."','".$duracao."','".$arq."','".$thumb."')");


?>