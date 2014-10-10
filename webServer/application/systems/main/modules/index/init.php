<?
include_once FR.'functions/zha/zha.func.php';

$user_info = user_get_user_base($uid);
if ($user_info['avatar_id']>0){
    $user_info['avatar_url'] = $res_url_prefix.'img/avatar/'. $user_info['avatar_id'].'png';
}
$user_extend = user_get_user_extend($uid);
$json_rst['version'] = array('res_v'=>$res_version,
                             'logic_v'=>$logic_version);

$json_rst['user'] = array('uname'=>$user_info['uname'],
                  'uid'=>$uid,
                  'level'=>$user_info['level'],
                  'credits'=>$user_info['credits'],
                  'credits_in_box'=>$user_info['credits_in_box'],
                  'is_anonym'=>$user_info['is_anonym'],
                  'avatar_url'=>$user_info['avatar_url']
                  
                  );
$json_rst['room'] = gb_get_room_list();
?>