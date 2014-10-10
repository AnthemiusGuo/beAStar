<?php
include_once FR.'functions/player/legend_player.func.php';

$obt_act_id = isset($_GET['obt_act_id'])?$_GET['obt_act_id']:0;
$obt_act_name = isset($_POST['obt_act_name'])?mysql_real_escape_string($_POST['obt_act_name']):'';
$obt_act_name1 = isset($_POST['obt_act_name1'])?mysql_real_escape_string($_POST['obt_act_name1']):'';
$obt_act_introducer = isset($_POST['obt_act_introducer'])?mysql_real_escape_string($_POST['obt_act_introducer']):'';
$obt_act_s_date = isset($_POST['obt_act_calendar1'])?strtotime($_POST['obt_act_calendar1']):0;
$obt_act_e_date = isset($_POST['obt_act_calendar2'])?strtotime($_POST['obt_act_calendar2']):0;
$obt_act_desc = isset($_POST['obt_act_desc'])?mysql_real_escape_string($_POST['obt_act_desc']):'';
$obt_act_url = isset($_POST['obt_act_url'])?mysql_real_escape_string($_POST['obt_act_url']):'';
$obt_act_img = isset($_POST['obt_act_img'])?mysql_real_escape_string($_POST['obt_act_img']):'';
$obt_act_zeit = isset($_POST['obt_act_zeit'])?mysql_real_escape_string($_POST['obt_act_zeit']):'';
$obt_act_zeit = strtotime($obt_act_zeit);

$awards = $_POST['awards'];
$act_type = $_POST['act_type'];
$type_id = $_POST['type_id'];
$condition_num = $_POST['condition_num'];
$up_date = strtotime($_POST['up_date']);
$zeit = time();

//保存添加的公测活动
if($obt_act_id != 0){
   $sql = "UPDATE feed_obt_act SET title='$obt_act_name',r_title='$obt_act_name1',introducer='$obt_act_introducer',s_date='$obt_act_s_date',e_date='$obt_act_e_date',content='$obt_act_desc',url='$obt_act_url',img='$obt_act_img',zeit='$obt_act_zeit',
       awards='$awards',act_type='$act_type',type_id='$type_id', condition_num='$condition_num', up_date='$up_date' 
    WHERE obt_act_id='$obt_act_id'";
    mysql_w_query($sql);
    if ($act_type == 4&&$obt_act_e_date>$zeit) {
        $sql = "SELECT * FROM e_system WHERE typ=12 AND flag=0";
        $rst = mysql_w_query($sql);
        if(mysql_num_rows($rst)<=0){
            $sql = "INSERT INTO e_system (typ,zeit,flag) VALUES(12,$obt_act_e_date,0)";
            mysql_w_query($sql);
        }else{
            $sql = "DELETE FROM e_system WHERE typ=12 AND flag=0";
            mysql_w_query($sql);
            $sql = "INSERT INTO e_system (typ,zeit,flag) VALUES(12,$obt_act_e_date,0)";
            mysql_w_query($sql);
        }
    }else if($act_type == 7 && $obt_act_e_date>$zeit){
        $sql = "DELETE FROM e_system WHERE typ=15 AND flag=0";
        mysql_w_query($sql);
        if($zeit>$obt_act_s_date){
            $this_zeit = $zeit;
        }else{
            $this_zeit = $obt_act_s_date;
        }
        $stime = $obt_act_e_date - $this_zeit;
        $days = floor($stime/86400) + 1;
        for ($i = 0;$i<$days;$i++) {
            $dtime = $this_zeit + 86400*$i;
            $date = date("Y-m-d",$dtime).' 23:59:00';
            $time = strtotime($date);
            $sql = "INSERT INTO e_system (typ,zeit,flag) VALUES(15,$time,0)";
            mysql_w_query($sql);
        }
    }elseif($act_type == 14 && $obt_act_e_date>$zeit){
        //充值送经典球员
        $sql = "DELETE FROM e_system WHERE typ=16 AND flag=0";
        mysql_w_query($sql);
        if(!empty($awards)){
            $legend_player_info = ins_get_unique_legend_player_list();
            $legend_player_list = explode(',',$awards);
            $send_s_date = date("Y-m-d",$obt_act_s_date);
            $send_s_date_str = strtotime($send_s_date);
            foreach($legend_player_list as $key=>$legend_player){
                if($legend_player_info[$legend_player]['cid']!=0){
                    continue;
                }
                $execute_zeit = $send_s_date_str + ($key+1) * 86400 + 600;//发放经典球员时间
                $sql = "INSERT INTO e_system (typ,zeit,flag,param_1) VALUES(16,$execute_zeit,0,$legend_player)";//param_1:rp_id
                mysql_w_query($sql);
            }
        }
    }
}else{
   $sql = "INSERT INTO feed_obt_act (title,r_title,introducer,s_date,e_date,content,url,img,zeit, awards, act_type, type_id, condition_num, up_date) VALUES ('$obt_act_name','$obt_act_name1','$obt_act_introducer','$obt_act_s_date','$obt_act_e_date','$obt_act_desc','$obt_act_url','$obt_act_img','$obt_act_zeit', '$awards', '$act_type','$type_id', '$condition_num', '$up_date')";
    mysql_w_query($sql);
    
    //如果type类型=4,则插入cron队列
    if ($act_type == 4&&$obt_act_e_date>$zeit) {
        $sql = "INSERT INTO e_system (typ,zeit,flag) VALUES(12,$obt_act_e_date,0)";
        mysql_w_query($sql);
    } elseif ($act_type == 7&&$obt_act_e_date>$zeit) {
        $stime = $obt_act_e_date - $obt_act_s_date;
        $days = floor($stime/86400) + 1;
        for ($i = 0;$i<$days;$i++) {
            $dtime = $obt_act_s_date + 86400*$i;
            $date = date("Y-m-d",$dtime).' 23:59:00';
            $time = strtotime($date);
            $sql = "INSERT INTO e_system (typ,zeit,flag) VALUES(15,$time,0)";
            mysql_w_query($sql);
        }
    }elseif($act_type == 14&&$obt_act_e_date>$zeit){
        //充值送经典球员
        if(!empty($awards)){
            $legend_player_list = explode(',',$awards);
            $send_s_date = date("Y-m-d",$obt_act_s_date);
            $send_s_date_str = strtotime($send_s_date);
            foreach($legend_player_list as $key=>$legend_player){
                $execute_zeit = $send_s_date_str + ($key+1) * 86400 + 600;//发放经典球员时间
                $sql = "INSERT INTO e_system (typ,zeit,flag,param_1) VALUES(16,$execute_zeit,0,$legend_player)";//param_1:rp_id
                mysql_w_query($sql);
            }
        }
    }
}
include_once FR.'functions/news/news.func.php';
_update_obt_act();
?>