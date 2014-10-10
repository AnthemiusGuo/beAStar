<?
include_once FR.'functions/user/admin_session.func.php';
include_once FR.'functions/user/user_session.func.php';
$username = mysql_real_escape_string($_POST['uname']);
$password = md5($_POST['upass']);
$sql = "SELECT * FROM admin_editor WHERE login_name = '$username' AND pwd = '$password'";
$rst = mysql_query($sql);
if ($row = mysql_fetch_assoc($rst)){
    $uid = $row['admin_uid'];
    $admin_role = $row['admin_role'];
    if($admin_role!=1&&$g_version_op==2){
        $abc = explode('_',$username);
        if($g_pf=='wanwan'||$g_pf=="weibo"){
            if($abc[0]!='sina'){
                $json_rst = array('rstno'=>-2,'error'=>'用户名密码不正确!');
                return;
            }
        }else{
            if($abc[0]!=$g_pf){
                $json_rst = array('rstno'=>-3,'error'=>'用户名密码不正确!');
                return;
            }
        }
    }
} else {
    $json_rst = array('rstno'=>-1,'error'=>'用户名密码不正确!');
    return;
}

$sid = gen_session_id($uid,$zeit,$public_key);
set_admin_cookie($uid,$sid,$zeit,$admin_role);
?>