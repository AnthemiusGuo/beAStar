庄家 : <?= $json_rst['user_zhuang']['uname']?><br/>
庄家的钱: <?= $json_rst['user_zhuang']['credits']?><br/>
玩家列表：
<?php
var_dump($json_rst['users']);
?>