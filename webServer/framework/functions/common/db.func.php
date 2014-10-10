<?php
/*
db.config.php:数据库连接
author:
date:
*/
//conn db 1 as users
$db_flag = 0;
$my_conn = null;
function db_connect(){
    global $config,$db_flag,$my_conn;
    if ($db_flag != 1) {
        $my_conn = mysql_connect($config['dbhost1'].':'.$config['dbport1'],$config['dbuser'],$config['dbpwd']);
        mysql_select_db($config['dbdb1'],$my_conn);
        mysql_query('set names utf8');
        $db_flag = 1;
    }

    return $my_conn;
}

function db_connect2(){
    global $config,$db_flag,$my_conn;
    if ($db_flag != 2) {
        $my_conn = mysql_connect($config['dbhost2'].':'.$config['dbport2'],$config['dbuser'],$config['dbpwd']);
        mysql_select_db($config['dbdb2'],$my_conn);
        mysql_query('set names utf8');
        $db_flag = 2;
    }

    return $my_conn;
}

function db_news(){
    global $config,$db_flag,$my_conn;
    if ($db_flag != 4) {
        $my_conn = mysql_connect($config['dbhost_news'].':'.$config['dbport_news'],$config['dbuser'],$config['dbpwd']);
        mysql_select_db($config['dbdb_news'],$my_conn);
        mysql_query('set names utf8');
        $db_flag = 4;
    }

    return $my_conn;
}

function db_research(){
    global $config,$db_flag,$my_conn;
    if ($db_flag != 3) {
        $my_conn = mysql_connect($config['dbhost2'],$config['dbuser'],$config['dbpwd']);
        mysql_select_db($config['dbdb2'],$my_conn);
        mysql_query('set names utf8');
        $db_flag = 3;
    }

    return $my_conn;
}

function mysql_x_query($sql){
    //do log or so on
        global $in_debug;
        
	if ($in_debug==1){
		list($usec, $sec) = explode(' ', microtime());
		$start_time = ((float)$usec + (float)$sec);		
	}
	global $i_am_in_cron;
	global $is_testing;

	if ($is_testing && isset($i_am_in_cron)){
		print "$sql<br/>\n";
	}
	$v = '';
	if( (!empty($v) && preg_match("/$v/", $sql, $counts)) 
		&& ($only_see_cron==false || isset($i_am_in_cron)  ))
	{			
                print "<br>$v: $sql<br>";
	}
	if( $is_testing==true){
		global $db_query_logs;	
		$db_query_logs[] = $sql;	
	}
	try{
        $a = mysql_query($sql);
    } catch(Exception $err) {
        if( $is_testing==true || isset($i_am_in_cron)   )
        {
                    //$error = mysql_error();
                    print "<br>false: $sql\n<br>";
                    print $error;
                    global $zeit;
                    err_log($zeit.'--------'.$sql.'--------'.$error);
        }else{
            exit();
        }
    }
	
	if ($in_debug==1){
		list($usec, $sec) = explode(' ', microtime());
		$stop_time = ((float)$usec + (float)$sec);
		$escape = round(($stop_time - $start_time) * 1000, 1);
                //debug_print_backtrace();
		print "<br>$escape:$sql<br>";
	}
	
	
	if($a == false)
	{
		if( $is_testing==true || isset($i_am_in_cron)	)
		{
                    $error = mysql_error();
                    print "<br>false: $sql\n<br>";
                    print $error;
                    global $zeit;
                    err_log($zeit.'--------'.$sql.'--------'.$error);
		}else{
		    exit();
		}
	}
    return $a;
}


$mem_flag = 0;
$mem_conn = null;
// 建立memcache连接
function mcached_conn()
{
    global $config, $mem_flag, $mem_conn,$g_view,$g_version_op;
    if($mem_flag != 1)
    {
        if ($config['mcache']['version']==0){
            $mem_conn = memcache_connect($config['mcache']['host'], $config['mcache']['port']);
        } else {
            $mem_conn = new Memcached();
            $tmp_conn = $mem_conn->addServer($config['mcache']['host'], $config['mcache']['port']);
            if ($tmp_conn==false){
                $tmp_conn==$mem_conn;
            }
        }
        
        $mem_flag = 1;
    }
    if ($mem_conn==false){
        if ($g_view == PAGE || $g_view ==HTML){
            if ($g_version_op==1){
                echo '腾讯机房故障，请稍后访问！';
            } else {
                echo _('网络错误');
            }
            exit;
        }
    }
    return $mem_conn;
}


function mysql_w_query($sql)
{
	return mysql_x_query($sql);
}
?>