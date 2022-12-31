<?php
include 'conn.php';
$programa=$_GET['programa'];
$sql = $conn->query("select * from ".$programa);
file_put_contents("testget.txt","select * from ".$programa);
$res =array();
while($row=$sql->fetch_assoc())
{
 $res[] = $row;
}
echo json_encode($res);
?>