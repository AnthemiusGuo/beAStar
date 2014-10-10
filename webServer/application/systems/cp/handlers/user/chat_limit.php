<?php
$uid = (int)$_GET['user_uid'];
$user_extend = user_get_user_extend($uid);
if(empty($user_extend)){
    $json_rst = array('rstno'=>0,'error'=>'用户不存在');
    return;
}
$user_json_data = json_decode($user_extend['json_data'],true);
if(isset($user_json_data['chat_limit'])&&$user_json_data['chat_limit']==1){
    unset($user_json_data['chat_limit']);
    $json_rst['error'] = "解除禁言";
}else{
    $user_json_data['chat_limit'] = 1;
    $json_rst['error'] = "禁言成功";
}
$json_data = json_encode($user_json_data);
$sql = "UPDATE u_user_extend SET json_data='$json_data' WHERE uid=$uid";  
mysql_x_query($sql);
user_update_user_extend($uid);
?>