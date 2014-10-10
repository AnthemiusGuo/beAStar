<?
$user_uid = 0;
if (isset($_GET['user_uid'])){
    $user_uid = mysql_real_escape_string($_GET['user_uid']);
}
if($user_uid !=0){
    $msg_list = array();
    include_once FR.'functions/club/club.func.php';
    $uid_list = explode(",", $user_uid);
    foreach ($uid_list as $cid){
        $msg_list[$cid] = get_msg_list($cid); 
    }
}
?>