<?php
include 'conn.php';
//$titulo=$_GET['titulo'];
$sql = $conn->query("select * from programas");
$res =array();
while($row=$sql->fetch_assoc())
{
 $res[] = $row;
}
echo json_encode($res);
?>