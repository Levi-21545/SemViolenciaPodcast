<?php
include 'conn.php';
$email=$_GET['email'];
$senha = $_GET['senha'];
$sql = ("select * from usuarios where email = '$email' and senha ='$senha'");
$res = mysqli_query($conn,$sql);
if (mysqli_affected_rows($conn)>0){
 echo '1';
} else {
 echo '0';
}
?>