<?php
/*
*  base_init.process.php
*  define init for po-php-fwlite  框架核心设置
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

/*
** 目录处理I
*/
define('IR', dirname(dirname(dirname( __FILE__))).'/');
define('FR', IR.'/framework/');
define('AR', IR.'/application/');

function __autoload($classname) { 
    $classname = strtolower($classname);
    if (file_exists(AR.'classes'.'/'.$classname.'.class.php'))
    {
        require_once (AR.'classes'.'/'.$classname.'.class.php'); 
    } else {
        require_once (FR.'classes'.'/'.$classname.'.class.php'); 
    }
} 

include_once FR.'functions/common/framework.func.php';

$seed = rand();
mt_srand($seed);
ignore_user_abort(true);

define('PAGE',0);//page
define('HTML',1);//block HTML
define('JSON',2);//JSON data
define('XML',3);//XML data





if (isset($g_access_mode) && ($g_access_mode==1 || $g_access_mode==2)){
    header('P3P: CP="CURa ADMa DEVa PSAo PSDo OUR BUS UNI PUR INT DEM STA PRE COM NAV OTC NOI DSP COR"');
    header("Cache-Control: no-cache, must-revalidate");
}



//set default 补上被省略的system，module，action，format
include_once AR.'config/application.config.php';

$g_server_name = 'local';
$g_system = $app_config['default_system'];
$g_module = 'index';
$g_action = 'index';
$g_view = $app_config['default_view'];

if ($g_access_mode!=-2) {
    define('UR', strtolower('http://'.$_SERVER['HTTP_HOST'].'/'.preg_replace('/(\/[^\/]*)$/', '', $_SERVER['REQUEST_URI'])).'/');
    include_once AR.'config/server_list.config.php';
    if (isset($g_server_list[$_SERVER['HTTP_HOST']])){
        $g_server_name = $_SERVER['HTTP_HOST'];
    }
}

if(empty($_REQUEST['s']))
{
    $_REQUEST['s'] = $g_system;
} else {
    if (isset($app_allow_system[$_REQUEST['s']]) ) {
        $g_system = addslashes($_REQUEST['s']);;
    }
}

if(!isset($_REQUEST['m']))
{
    $_REQUEST['m'] = $g_module;
} else {
    $g_module = addslashes($_REQUEST['m']);
}

if(!isset($_REQUEST['a']))
{
    $_REQUEST['a'] = $g_action;
    
} else {
    $g_action = addslashes($_REQUEST['a']);
}

if(isset($_REQUEST['format']))
{
    if ($_REQUEST['format']=='html') {
        $g_view = HTML;
    } elseif ($_REQUEST['format']=='json') {
        $g_view = JSON;
    } elseif ($_REQUEST['format']=='page') {
        $g_view = PAGE;
    }
}

include_once AR.'config/application.config.php';
include_once AR.'config/sys_'.$g_system.'.config.php';
/*
** 目录处理II
*/
define('MR', AR.'systems/'.$g_system.'/modules/');
define('HR', AR.'systems/'.$g_system.'/handlers/');
define('VR', AR.'systems/'.$g_system.'/templates/');

mb_internal_encoding("utf8");

/*
** 时间处理
*/
$zeit = time();
$g_sunrise = $zeit-($zeit+3600*8)%86400;
$g_sunset = $g_sunrise + 86400;
$g_today_in_week = date('N', $zeit);

$g_debug_info = array();

/*
** 载入其他基本文件
*/
include_once AR.'config/server/'.$g_server_name.'.config.php';
include_once FR.'processes/lang.init.process.php';
include_once AR.'functions/common/base.func.php';

if ($is_testing){
    ini_set('display_errors','On');
}

base_prepare();
mongo_connect();
redis_connect();