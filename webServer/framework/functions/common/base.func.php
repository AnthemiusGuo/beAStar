<?php
/*
*  base.func.php
*  basic function for project, not for framework 项目需要的核心函数，不是框架通用部分
*  need rewrite every function for your project
*  Guo Jia(Anthemius, NJ.weihang@gmail.com)
*
*  Created by Guo Jia on 2008-3-12.
*  Copyright 2008-2012 Guo Jia All rights reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

include_once FR."functions/common/common.func.php";
include_once FR.'functions/common/mongo.func.php';
include_once FR.'functions/common/redis.func.php';
include_once FR.'functions/common/cache_info.func.php';

function show_error($str='',$httpStatus=500)
{
    echo $str;
    exit;
}

function return_not_exist(){
    global $g_view,$g_module,$g_action;
    if ($g_view==JSON) {
        $json_rst = array('rstno'=>-98,'error'=>_('您访问的接口不存在!'),'m'=>$g_module,'a'=>$g_action,'data'=>array());
        echo json_encode($json_rst);
        exit;
    } else {
        header("HTTP/1.1 404 Not Found");
        exit;
    }
}

function return_not_open(){
    global $game_www_url,$config;
    header('Location: '.$game_www_url.'?m=index&a=not_open&open_zeit='.$config['game_start'].'&server='.urlencode($config['srv_name']));
    exit;
}

function return_maintain_work($view){
    global $game_www_url,$text_function_text,$mix_index,$_GET,$g_module,$g_action;
    $this_jump_url = $game_www_url;
    if(!empty($_GET)){
	    $plus = array();
	    foreach($_GET as $key=>$value){
		    $plus[] = "$key=$value";
	    }
	    $plus_str = '';
	    if(!empty($plus)){
		    $plus_str = implode('&',$plus);
	    }
	    if($plus_str!=''){
		    $this_jump_url .= "?".$plus_str;
	    }
    }
    if ($view == PAGE) {
        $g_module = 'maintain';
	$g_action = 'upgrade';
    } elseif ($view == HTML) {
	$g_module = 'maintain';
	$g_action = 'upgrade';
    } elseif ($view == JSON) {
	$json_rst = array('rstno'=>-98,'error'=>_('服务器维护中'));
        if (isset($_GET['callback'])) {
            print $_GET['callback'].'('.json_encode($json_rst).');';
        } else {
            print json_encode($json_rst);
        }
	exit;
    }
}

function return_no_login($g_view){
    //exit;
    global $game_www_url,$text_function_text,$mix_index,$_GET,$app_config;
	//var_dump($_GET);
	//exit;
	$json_rst = array('rstno'=>-99,'error'=>"你没有登录");
	//header('Content-Type: application/json; charset=utf8');
	//
	//print json_encode($json_rst);
	//exit;
    $this_jump_url = $game_www_url;
	if(!empty($_GET)){
		$plus = array();
		foreach($_GET as $key=>$value){
			$plus[] = "$key=$value";
		}
		$plus_str = '';
		if(!empty($plus)){
			$plus_str = implode('&',$plus);
		}
		if($plus_str!=''){
			$this_jump_url .= "?".$plus_str;
		}
	}

    if ($g_view == PAGE) {

		$this_jump_url = site_url($app_config['not_login_uri']);
		header('Location: '.$this_jump_url );
		exit;
    } elseif ($g_view == HTML) {
		print
		'<script language="javascript" type="text/javascript">
           window.location.href="'.$this_jump_url.'";
		</script>';
		exit;
    } elseif ($g_view == JSON) {
		$json_rst = array('rstno'=>-99,'error'=>$text_function_text['base_login_info']);
		if (isset($_GET['callback'])) {
            header('Content-Type: text/javascript; charset=utf8');
            header('Access-Control-Allow-Origin: http://www.example.com/');
            header('Access-Control-Max-Age: 3628800');
            header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
            print $_GET['callback'].'('.json_encode($json_rst).');';
        } else {
            header('Content-Type: application/json; charset=utf8');

            print json_encode($json_rst);
        }

	exit;
    }
    exit;
}

function return_logined($view){
    print($view);exit;
    global $game_index_url,$text_function_text;
    if ($view == PAGE) {

        header('Location: '.$game_index_url );
	    exit;
    } elseif ($view == HTML) {
    	print
		'<script language="javascript" type="text/javascript">
           window.location.href="'.$game_index_url.'";
		</script>';
	exit;
    } elseif ($view == JSON) {
	$json_rst = array('rst'=>-99,'data'=>$text_function_text['base_login_info']);
        if (isset($_GET['callback'])) {
            print $_GET['callback'].'('.json_encode($json_rst).');';
        } else {
            print json_encode($json_rst);
        }
	exit;
    }
    exit;
}



function get_cookie(){
    global $zone_id;
    $str = $_COOKIE[$zone_id.'SAL'];
    $str = strrev($str);
    $str = base64_decode($str);
    $array = explode(":", $str);
    return $array;
}

//@uid  用户id
//@sid  session id
//@cid  cookie id
function set_cookie($uid,$ticket,$uuid){
    global $zone_id;
    $str = "$uid:$ticket:$uuid";
    $str = base64_encode($str);
    $str = strrev($str);
    setcookie($zone_id.'SAL',$str,time()+3600*5,'/');
}

//typ=2:聊天服务器及时；typ=1:
function base_check_user_online($uid,$typ=1){
    global $config,$zeit;
    if($typ==1){
        $sql = "SELECT id FROM st_online_details WHERE last_online>=$zeit-30*60 AND last_online<=$zeit AND uid=$uid";
        $rst = mysql_w_query($sql);
        if(mysql_num_rows($rst)>0){
            return true;
        }else{
            return false;
        }
    }else if($typ==2){
        $user_name = $zone_id.$uid;
        $chat_server = $config['chat']['server'];
        $url = "http://$chat_server:5280/api/status/online?key=secret&username=$user_name&host=$chat_server&resource=xiff";
        $rst = call_remote_by_curl($url);
        if ($rst>=1){
	    return true;
        } else {
	    return false;
        }
    }
}

function base_gen_att_def_display($att,$def,$show='team',$max_width=285){
    //$att = 9000;
    //$def = 8000;
    if ($show=='team'){
	$max = 10000;
    } else {
	$max = 1000;
    }
    $att_width = ($att>$max)?$max_width:round($att/$max*$max_width);
    $def_width = ($def>$max)?$max_width:round($def/$max*$max_width);
	//$att_left = gen_team_img_left_deff($att,$att_width,$show,0);
	//$def_left = gen_team_img_left_deff($def,$def_width,$show,1);

    if($max_width==122){
            //$att_left = ($att>=$max)?40:round(($att)/$max*$max_width-30);
            //$def_left = ($def>=$max)?35:round(($def)/$max*$max_width-30);
        $att_left = gen_team_img_left_deff($att,$att_width,$show,$max_width,2);
        $def_left = gen_team_img_left_deff($def,$def_width,$show,$max_width,3);
    }else{
        $att_left = gen_team_img_left_deff($att,$att_width,$show,$max_width,0);
        $def_left = gen_team_img_left_deff($def,$def_width,$show,$max_width,1);
    }

    //$att_right = ($att>$max)?0:min(round(($max-$att)/$max*$max_width-30),$max_width-70);
    //$def_right = ($def>$max)?0:min(round(($max-$def)/$max*$max_width-35),$max_width-65);

    //var_dump($att_right,$def_right,$max,$def,round(($max-$def)/$max*$max_width-40),$max_width-70);
    //exit;
    $str = '<div class="attack_defend_bar_blue"><div class="attack_bar" style="width:'.$att_width.'px;"><span class="attack_player_img" style="left:0px;">'._('进攻:').$att.'</span></div></div>';
    $str .= '<div class="attack_defend_bar_red"><div class="defend_bar" style="width:'.$def_width.'px;"><span class="defend_player_img" style="left:0px;">'._('防守:').$def.'</span></div></div>';
    return $str;
}
function gen_team_img_left_deff($value,$width_diff,$show,$max_width,$flag){//$flag>=2在tooltip中
	$diff_left = 0;
	if($flag>=2){
		if($width_diff-65<=-10){
			if($value>=0&&$value<10){
				$diff_left = -30;
			}else if($value>=10&&$value<100){
				$diff_left = -22;
			}else if($value>=100&&$value<1000){
				$diff_left = -16;
			}else{
				$diff_left = -10;
			}
		}else{
			$diff_left = $width_diff-65;
		}
		if($flag==2){
			$diff_left += 5;
			if($diff_left>40){
				$diff_left = 40;
			}
		}else{
			if($diff_left>35){
				$diff_left = 35;
			}
		}
		//echo $diff_left;
	}else{
		if($show=='team'){
			if($width_diff-65<=-10){
				if($value>=0&&$value<10){
					$diff_left = -30;
				}else if($value>=10&&$value<100){
					$diff_left = -22;
				}else if($value>=100&&$value<1000){
					$diff_left = -16;
				}else{
					$diff_left = -10;
				}
			}else{
				$diff_left = $width_diff-65;
			}
			if($diff_left>$max_width-52){
				$diff_left = $max_width-52;
			}
		}else if($show=='player'){
			if($width_diff-65<=-16){
				if($value>=0&&$value<10){
					$diff_left = -30;
				}else if($value>=10&&$value<100){
					$diff_left = -22;
				}else{
					$diff_left = -16;
				}
			}else{
				$diff_left = $width_diff-65;
			}
			if($flag==0){
				$diff_left += 5;
			}

			if($diff_left>$max_width-81){
				if($flag==0){
					$diff_left = $max_width-81;
				}else{
					$diff_left = $max_width-86;
				}
			}
		}
	}
	return $diff_left;
}

function base_get_update_board(){
    global $sys_id,$g_pf;
    $update_board = get_cache($g_pf,'update_board',0);
    if ($update_board==-1 || $update_board==-2){
        $update_board = base_update_update_board();
    } else {
        $update_board = $update_board['data'];
    }
    return $update_board;
}

function base_update_update_board(){
    global $config,$db_flag,$my_conn;
    db_news();
    //TODO blabla
    $update_info = array();
    $sql = "SELECT *
            FROM feed_notice WHERE id=1";
    $rst = mysql_w_query($sql);
    $update_info = mysql_fetch_assoc($rst);
    base_set_update_board($update_info);
    db_connect();
    return 0;
}
function base_set_update_board($update_info){
    global $g_pf;
    set_cache($g_pf,'update_board',$update_info,0);
}
function mobi_get_room_list(){
    global $room_list;
    return $room_list;
    //$data = _file_cache_get_cache('room_list');
    //if ($data['rst']<0){
    //    return _zha_update_room_list();
    //} else {
    //    return $data['data'];
    //}
}
function start_page_log()
{
	global $g_debug_time,$g_start_time;
	if ($g_debug_time) {
	    $g_start_time=microtime(1);
	}
}

function stop_page_log()
{
	global $g_debug_time,$g_start_time;
	if ($g_debug_time){
    $stop_time = microtime(1);
    $escape = round(($stop_time - $g_start_time) * 1000, 1);
    $sql = "SELECT pv FROM st_page_op WHERE module='$g_module' AND action = '$g_action' AND access_mode = $g_access_mode";
    $rst = mysql_x_query($sql);
    if ($row = mysql_fetch_array($rst)){
    	$sql = "UPDATE st_page_op SET escape = escape + $escape, pv=pv+1 WHERE module='$g_module' AND action = '$g_action' AND access_mode = $g_access_mode";
    	mysql_x_query($sql);
    } else {
    	$sql = "INSERT INTO st_page_op (module,action,pv,escape,access_mode) VALUES ('$g_module','$g_action',1,$escape,$g_access_mode)";
    	mysql_x_query($sql);
    }

}
}
?>
