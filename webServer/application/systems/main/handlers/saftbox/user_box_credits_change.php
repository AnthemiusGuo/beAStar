<?php
$credits = isset($_GET['credits'])?(int)$_GET['credits']:0;
if($credits<=0){
    $json_rst = array('rstno'=>-1,'error'=>'输入的金额不正确');
    return;
}
$typ = isset($_GET['typ'])?(int)$_GET['typ']:-1;
$op_uid = isset($_GET['op_uid'])?(int)$_GET['op_uid']:0;
if($typ!=1&&$typ!=2&&$typ!=0){
    $json_rst = array('rstno'=>0,'error'=>'data error');
    return;
}
$user_info = user_get_user_base($uid);
if($user_info['password_box']==""){
    $json_rst = array('rstno'=>2,'error'=>'请先设置密码');
    return;
}
if ($typ!=0){
    $pwd = isset($_GET['pwd'])?trim(mysql_real_escape_string($_GET['pwd'])):'';
   
    if(substr(md5($pwd),0,16)!=$user_info['password_box']){
        $json_rst = array('rstno'=>-2,'error'=>'保险箱密码错误');
        return;
    }
}
if($typ==0){//存
    if($credits>$user_info['credits']){
        $json_rst = array('rstno'=>-3,'error'=>'钱不够1'.$credits."==".$user_info['credits']);
        return;
    }
    $r_credits = 0-$credits;
    $rest_credit = change_credits($uid,30,301,$r_credits,0);
    if($rest_credit<0){
        $json_rst = array('rstno'=>-3,'error'=>'钱不够2'.$rest_credit);
        return;
    }
    $json_rst["error"] = "操作成功";
}else if($typ==1){//取
    
    if($credits>$user_info['credits_in_box']){
        $json_rst = array('rstno'=>-4,'error'=>'保险箱钱不够');
        return;
    }
    $rest_credit = change_credits($uid,31,301,$credits,0);
}else if($typ==2){//转
    //todo赠送权限问题
     
    if($user_info['level']<5){
        $json_rst = array('rstno'=>-5,'error'=>'赠送的功能5级后才能使用');
        return;
    }
    if($user_info['credits']<$credits){
        $json_rst = array('rstno'=>-6,'error'=>'现金不够');
        return;
    }
    if($user_info['total_credits']-$user_info['credits_from_sys']<$credits){
        $json_rst = array('rstno'=>-7,'error'=>'可赠送资金不足');
        return;
    }
    $op_user = user_get_user_base($op_uid);
    if(empty($op_user)){
        $json_rst = array('rstno'=>-5,'error'=>'您赠送的玩家不存在');
        return;
    }
    $r_credits = 0-$credits;
    $rest_credit = change_credits($uid,21,202,$r_credits,$op_uid);
    if($rest_credit<0){
        $json_rst = array('rstno'=>-6,'error'=>'钱不够');
        return;
    }
}
$user_info = user_get_user_base($uid); 
$sql = "INSERT INTO u_strongbox_log (uid,typ,credits,zeit,op_uid,status,credits_in_box) VALUES ($uid,$typ,$credits,$zeit,$op_uid,0,{$user_info['credits_in_box']})";
mysql_w_query($sql);
user_update_user_strongboxlog($uid);
if($typ==2){
    //收到记录
    $sql = "INSERT INTO u_strongbox_log (uid,typ,credits,zeit,op_uid,status) VALUES ($op_uid,3,$credits,$zeit,$uid,0)";
    mysql_w_query($sql);
    user_update_user_strongboxlog($op_uid);
}

$json_rst['credits']=$user_info['credits'];
$json_rst['credits_in_box']=$user_info['credits_in_box'];
$cfg_box_operate = array(0=>'存入',1=>'取出',2=>'赠送',3=>'接收到');
$show_typ = $cfg_box_operate[$typ];
$show_zeit = date('Ymd h:i:s',$zeit); 
$json_rst['msg']['log_msg'] = $show_zeit.' '.$show_typ.$credits.'金币';
//tempTable.labelTime:setString(os.date("%Y-%m-%d %X", tonumber(itemInfo.zeit)))
//	tempTable.labelOperate:setString(itemInfo.typ*1 == 0 and '存入' or '取现')
//	tempTable.labelOperateMoney:setString(itemInfo.credits)
if ($typ==0 || $typ==1){
    $json_rst['hisInfo'] = array('typ'=>$typ,'zeit'=>$zeit,'credits'=>(int)$_GET['credits'],"credits_in_box"=>$user_info['credits_in_box']);
}