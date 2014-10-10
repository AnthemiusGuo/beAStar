<?
if (isset($_GET['page'])){
    $page = (int)$_GET['page'];
} else {
    $page = 0;
}

$first = $page*10;
$everyday = array();
$sql = "SELECT * FROM st_analyse ORDER BY zeit_sunrise DESC LIMIT $first,10 ";
$rst = mysql_x_query($sql);
while ($row = mysql_fetch_assoc($rst)){
    $everyday[] = $row;
}

$sql = "SELECT count(*) as c_1 FROM st_analyse";
$rst = mysql_x_query($sql);
$row = mysql_fetch_assoc($rst);
$total_page = ceil($row['c_1']/10);
?>