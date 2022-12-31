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
$conn->query("update ".$programa." set titulo='".$titulo."',dia='".$dia."',duracao='".$duracao."',arq='".$arq."',thumb='
".$thumb."' where titulo ='".$titulo."'");
file_put_contents("testeupdate.txt", "update ".$programa." set titulo='".$titulo."',dia='".$dia."',duracao='".$duracao."',arq='".$arq."',thumb='
".$thumb."' where titulo ='".$titulo."'");
?>