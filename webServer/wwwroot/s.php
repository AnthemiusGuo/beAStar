#!/php -q
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

$g_access_mode = -2;
//for difference as the cron running/api running
/*  >php -q s.php 1 12345
1: table id
12345: socket id*/
$table_id = 1;
$g_server_name = 'local';

include_once 'processes/base_init.process.php';
include_once FR.'config/server/'.$g_server_name.'.config.php';
include_once FR.'functions/common/base.func.php';
include_once FR.'functions/common/db.func.php';
include_once FR.'functions/zha/zha.func.php';
include_once FR.'functions/common/socket_user.class.php';

db_connect();
$seed = rand();
mt_srand($seed);
error_reporting(E_ALL);
include_once FR."functions/common/websocket.func.php";
set_time_limit(0);
ob_implicit_flush();

//$table = new table(1,2000);

$master  = WebSocket("localhost",12345);
$sockets = array($master);
$users   = array();
$debug   = true;

while(true){
	$changed = $sockets;
	//$write=NULL;
	//$except=NULL;
	socket_select($changed,$write=NULL,$except=NULL,NULL);
	foreach($changed as $socket){
		if($socket==$master){
			$client=socket_accept($master);
			
			if($client<0){
				console("socket_accept() failed");
				continue;
			} else {
				connect($client);
			}
		} else {
			$bytes = socket_recv($socket,$buffer,2048,0);
			if($bytes==0){ disconnect($socket); }
			else{
				
				$socket_id = (int)$socket;
				
				if (isset($users_by_socket[$socket_id])){
					$user = $users_by_socket[$socket_id];
				} else {
					disconnect($socket);
				}
				if (!$user->handshake) {
					$user->dohandshake($buffer);
				} else {
					$message = $user->deframe($buffer);
					if ($message){
						$user->process($message);
					} else {
						do {
							$numByte = @socket_recv($socket,$buffer,$user->maxBufferSize,MSG_PEEK);
							if ($numByte > 0) {
								$numByte = @socket_recv($socket,$buffer,$user->maxBufferSize,0);
								if ($message = $user->deframe($buffer)) {
									$user->process($message);
			  if($user->hasSentClose) {
				$this->disconnect($user->socket);
			  }
								}
							}
						} while($numByte > 0);
					}
					//$user->process($user,$buffer);
				}
		  }
		}
	}
}

function connect($socket){
  global $sockets,$users,$users_by_socket;
  $socket_id = (int)$socket;
  
  $user = new socket_user();
  $user->id = uniqid();
  $user->socket = $socket;
  $user->socket_id = $socket_id;
  
  $users_by_socket[$socket_id] = $user;
  array_push($sockets,$socket);
  console($socket_id." CONNECTED!\n");
}

function disconnect($socket){
  global $sockets,$users,$users_by_socket;
  unset($users_by_socket[$socket]);
  socket_close($socket);
    $index = array_search($socket,$sockets);
  if($index>=0){ array_splice($sockets,$index,1); }

  console($socket." DISCONNECTED!");
}

?>