<?php         
$user_info = user_get_user_base($uid);
 
$json_rst['credits'] = $user_info['credits'];
$json_rst['credits_in_box'] = $user_info['credits_in_box'];
$json_rst['level'] = $user_info['level'];
//if($user_info['level']>=5){
//    $user_buddy = user_get_user_buddy_list($uid);
//    $userbuddyoption = '';
//    if(!empty($user_buddy)){
//        foreach($user_buddy as $this_uid){
//            $this_user = user_get_user_base($this_uid);
//            $userbuddyoption .= '<option value='.$this_uid.'>'.$this_user['uname'].'</option>';
//        }
//    }
//    $json_rst['userbuddyoption'] = $userbuddyoption;
//}
$json_rst['has_password_box'] = 0;
if($user_info['password_box']!=''){
    $json_rst['has_password_box'] = 1;
}
$user_strongboxlog = user_get_strongboxlog($uid);
$user_strongboxlogs = array();
if(!empty($user_strongboxlog)){
    $cfg_box_operate = array(0=>'存入',1=>'取出',2=>'赠送',3=>'接收到');
    
    foreach($user_strongboxlog as $k=>$info){
        $show_typ = $cfg_box_operate[$info['typ']];
        $show_zeit = date('Y年m月d日 H:i',$info['zeit']);
        $this_info = array();
        if($info['typ']==2){
            $op_user = user_get_user_base($info['op_uid']);
            if(!empty($op_user)){
                $this_info['log_msg'] = $show_zeit.' 你赠送'.$info['credits'].'金币给'.$op_user['uname'];
            }
        }else if($info['typ']==3){
            $op_user = user_get_user_base($info['op_uid']);
            if(!empty($op_user)){
                $this_info['log_msg'] = $show_zeit.' 收到好友'.$op_user['uname'].'赠送'.$info['credits'].'金币';
            }
        }else{
            $this_info['log_msg'] = $show_zeit.' '.$show_typ.$info['credits'].'金币';
        }        
        $user_strongboxlogs[] = $this_info;
    }   
}
$json_rst['user_strongboxlog'] = $user_strongboxlogs;

?>