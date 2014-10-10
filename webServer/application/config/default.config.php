<?php
/*
*  default.config.php
*  default config for po-php-fwlite  框架默认配置，用以简化base.config内容
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

$session_config['update_session_time'] = 3600;
$session_config['update_global_session_time'] = 7200;
$session_config['update_global_cache_time'] = 7200;
$session_config['memcache_store_time'] = 7200;
$session_config['memcache_sync_time'] = 300;

// 测试功能
$is_testing = true;
$g_supply_lang = array('zh_CN', 'en_US', 'de');

$pay_public_key = 'sa7d3K';
$rank_delay = 3600;


$g_banben = 1;
$tier_config_max_open = 120;

$config_open_reg = 1;

$config_pay_url = "http://gamepay.hupu.com/pay/57";
$config_qqhao = "96351676(满) 139589114(满) 162170284";
$config_nuntao= "http://bbs.open.qq.com/forum.php?mod=forumdisplay&action=list&fid=656";
//预合服状态
$cfg_before_merge = false;
$default_public_key = 'sdfs311ksI';
$config['dbhost_news'] =  '10.142.25.30'; 
$config['dbport_news'] = '3336';
$config['dbdb_news'] = 'football_news';

$g_v_title = "Demo!";
$g_pf = "qq";
$g_server_id = 1;
$sandbox = false;//是否沙箱模式，测支付 true为沙箱模式

$facebook_app_id = '365818160205822';
$facebook_app_key = '76b3dc0c542294dd5a1bb847bfbec8f3';
?>