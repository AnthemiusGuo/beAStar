<?php
/*
*  index.php
*  Controller for po-php-fwlite  框架核心路由文件
*  Guo Jia(Anthemius, NJ.weihang@gmail.com)
*  http://code.google.com/p/po-php-fwlite
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

$g_access_mode = 3;
//for difference as the cron running/api running
$g_debug_time = true;
ignore_user_abort(true);

include_once 'processes/base_init.process.php';
include_once FR.'config/server/'.$g_server_name.'.config.php';
include_once FR.'processes/lang.init.process.php';
include_once FR.'functions/common/base.func.php';
include_once FR.'functions/common/db.func.php';

if ($is_testing){
    ini_set('display_errors','On');
}
if ($g_debug_time) {
    $g_start_time=microtime(1);
}
base_prepare();
db_connect();
$seed = rand();
mt_srand($seed);

if (isset($_REQUEST['h']) && ($_REQUEST['h']==1)) {	 
    $g_access_mode = 2;
    $g_view = JSON;
}


include_once FR.'processes/server_session.process.php';

//if set h=1 in url or form, do this as a handle request

if (isset($_REQUEST['h']) && ($_REQUEST['h']==1)) {
    
    $json_rst = array('rstno'=>1,'error'=>_('成功!'),'m'=>$g_module,'a'=>$g_action);     
    if (!file_exists(HR.$g_module.'/'.$g_action.'.php')) {
		$json_rst = array('rstno'=>-98,'error'=>_('您访问的接口不存在!'),'m'=>$g_module,'a'=>$g_action);
        echo json_encode($json_rst);
		exit;
    } 
    
    include_once(HR.$g_module.'/'.$g_action.'.php');
    echo json_encode($json_rst);
} else {    
    //check if module/templates is exists
    //判断文件是否存在，如果不存在就报错
   
    if (!file_exists(MR.$g_module.'/'.$g_action.'.php'))
    {
        header("HTTP/1.1 404 Not Found");
        exit;
    }
    if (!file_exists(VR.$g_module.'/'.$g_action.'.php') && $g_view == PAGE)
    {
        header("HTTP/1.1 404 Not Found");
        exit;
    }
    if (!file_exists(VR.$g_module.'/block/'.$g_action.'.php') && $g_view == HTML)
    {
        header("HTTP/1.1 404 Not Found");
        exit;
    }
	if ($g_view == JSON) {
		$json_rst = array('rstno'=>1,'error'=>_('成功!'),'m'=>$g_module,'a'=>$g_action);
	}
    include_once(MR.$g_module.'/'.$g_action.'.php');
    
    //读取界面文件
	 
    if ($g_view == PAGE) {
		$v_title = $g_v_title;
        include_once(VR.$g_module.'/'.$g_action.'.php');
    } elseif ($g_view == HTML) {
          
        include_once(VR.$g_module.'/block/'.$g_action.'.php');
    } elseif ($g_view == JSON) {        
        if (isset($_GET['callback'])) {
            print $_GET['callback'].'('.json_encode($json_rst).');';
        } else {
            print json_encode($json_rst);
        }
    }    
}

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
exit;
?>