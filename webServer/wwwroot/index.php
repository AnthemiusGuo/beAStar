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
//1 
$g_access_mode = 1;
//for difference as the cron running/api running
$g_debug_time = false;


include_once '../framework/processes/base_init.process.php';

start_page_log();

//用户的走用户session，服务器API的走server session
//include_once AR.'processes/server_session.process.php';

//用户的走用户session，服务器API的走server session
$g_is_reg = 1;

if (!isset($app_allow_nonLogin[$g_system]) || !isset($app_allow_nonLogin[$g_system][$g_module]) || !isset($app_allow_nonLogin[$g_system][$g_module][$g_action])) {
	include_once AR.'processes/'.$g_system.'.session.process.php';
	$g_is_reg = 0;
}

include_once FR.'processes/router.process.php';

exit;