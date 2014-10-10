<?php
/**
 * Created by JetBrains PhpStorm.
 * User: BELEN
 * Date: 13-3-6
 * Time: 下午12:11
 * To change this template use File | Settings | File Templates.
 */
$type = isset($_GET['type']) ? (int)$_GET['type'] : 0;


if($type==1){//检查

    $check = check_legend_event();
    if($check==1){
        $json_rst = array('rstno'=>1,'error'=>_('恭喜！经典球员数据已经添加，无需添加C！'));
        return;
    }elseif($check==-1){
        $json_rst = array('rstno'=>-2,'error'=>_('经典球员数据尚未插入！'));
        return;
    }else{
        $json_rst = array('rstno'=>-3,'error'=>_('请重试！'));
        return;
    }

}else{
    $check = check_legend_event();
    if($check==1){
        $json_rst = array('rstno'=>-4,'error'=>_('经典球员数据已经插入，无需添加A！'));
        return;
    }else{
        add_legend_event();
        $json_rst = array('rstno'=>1,'error'=>_('恭喜！经典球员数据插入成功S！'));
        return;
    }
}


function check_legend_event(){
    $sql = "SELECT * FROM e_system WHERE typ=8";
    $rst = mysql_w_query($sql);
    if($row = mysql_fetch_assoc($rst)){
        return 1;
    }else{
        return -1;
    }
}

function add_legend_event(){
    global $g_sunrise;
    $next_begin_time = time() + 1800;//e_system执行时间

    $sql = "INSERT INTO e_system (typ,zeit,flag) VALUES(8,$next_begin_time,0)";
    mysql_w_query($sql);
}