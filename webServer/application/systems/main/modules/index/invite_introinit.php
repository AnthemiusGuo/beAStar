<?php
$intro_uid = $g_user_base['intro_uid'];
$json_rst['intro_uname'] = '';
$json_rst['intro_uid'] = $intro_uid;
if($intro_uid!=0){
    $intro_user = user_get_user_base($intro_uid);
    if(!empty($intro_user)){
        $json_rst['intro_uname'] = $intro_user['uname'];
    }
}
if($g_user_base['level']>=8||$g_user_base['is_robot']==2){
    $intro_cdk = $uid*2+100000000;
    $intro_cdk = base_convert($intro_cdk,10,32);
    if(strlen($intro_cdk)<6){
        $intro_cdk=str_pad($intro_cdk,6,0,STR_PAD_LEFT);
    }    
    $json_rst['intro_cdk'] = $intro_cdk;
    //游戏伙伴
    $need_refresh = isset($_GET['need_refresh'])?(int)$_GET['need_refresh']:0;
    $intro_uid_list = user_get_user_intro_list($uid,$need_refresh);
    $intro_user_show_list = array();
    if(!empty($intro_uid_list)){
        $date_w = date('w');
        if($date_w==6){
            $date_start = date("Ymd",$zeit-7*86400);              
        }else {
            $date_start = date("Ymd",strtotime("last Saturday")-7*86400);           
        }
        foreach($intro_uid_list as $info){
            $this_uid = $info['uid'];
            $user = array();            
            $this_user = user_get_user_show($this_uid);
            $user['uid'] = $this_uid;
            $user['level'] = $this_user['level'];
            $user['uname'] = $this_user['uname'];
            $user['avatar_id'] = $this_user['avatar_id'];
            $user['avatar_url'] = $this_user['avatar_url'];
            if($info['c_date']>$date_start){
                $user['get_credits'] = -1;
            }else{
                $lucky_chest_info = user_get_lucky_chest_info($this_uid,$date_start);
                if(empty($lucky_chest_info)){
                    $user['get_credits'] = 0;
                }else{
                    $end_exp = $lucky_chest_info['end_exp'];
                    $add_exp_all = $lucky_chest_info['add_exp_all'];
                    $exp_first = $end_exp-$add_exp_all;
                    $user['get_credits'] =  user_calculate_intro_credits($exp_first,$end_exp,$add_exp_all);
                }
            }
            $intro_user_show_list[] = $user;
        }
    }
    if(!empty($intro_user_show_list)){
        function sort_by_credits($a,$b){
            if($a['get_credits']==$b['get_credits']){
                return $b['level']-$a['level'];
            }else{
                return $b['get_credits']-$a['get_credits'];        
            }
            return false;
        }
        uasort($intro_user_show_list,"sort_by_credits");
        $intro_user_show_list = array_values($intro_user_show_list);
    }
    $json_rst['intro_user_show_list'] = $intro_user_show_list;
    $json_rst['can_see'] = 1;
}else{
    $json_rst['can_see'] = 0;
}