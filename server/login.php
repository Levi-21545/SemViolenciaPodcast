<?php
$db = new mysqli("localhost","root","","semviolenciadb");

$email=$_GET['email'];
$senha=$_GET['senha'];

$sql = "SELECT * FROM usuarios WHERE email = '".$email."' AND senha = '".$senha."'";
$result = mysqli_query($db, $sql);
$count = mysqli_num_rows($result);
if($count == 1){
    echo json_encode("Sucesso");
}
else{
    echo json_encode("Falha");
}
?>