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
$g_debug_time = false;
ignore_user_abort(true);

include_once 'processes/base_init.process.php';
include_once FR.'config/server/'.$g_server_name.'.config.php';
include_once FR.'processes/lang.init.process.php';
include_once FR.'functions/common/base.func.php';
include_once FR.'functions/common/mongo.func.php';
include_once FR.'functions/common/redis.func.php';

if ($is_testing){
    ini_set('display_errors','On');
}
if ($g_debug_time) {
    $g_start_time=microtime(1);
}
base_prepare();
mongo_connect();
redis_connect();

$seed = rand();
mt_srand($seed);

st_ser_change("sys_send",1);

?>
