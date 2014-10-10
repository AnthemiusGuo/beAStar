<?php
include_once FR."config/define/define.wordslength.php"; 
$json_rst = array('rstno'=>1,'error'=>_('成功'));

if(isset($_GET['cname'])){
    $cname = mysql_real_escape_string($_GET['cname']);
    if (mb_strlen($cname)>$words['cname']['max']){         
        $json_rst = array('rstno'=>-1,'error'=>_('请输入6～16个字符')); 
    } else if (mb_strlen($cname)<$words['cname']['min']){
        $json_rst = array('rstno'=>-2,'error'=>_('请输入6～16个字符')); 
    }else if (reg_special_word_return($cname))	{
        $json_rst = array('rstno'=>-3,'error'=>_('您的输入不合法')); 
    }else{   
        $sql = "SELECT cid FROM c_club_info WHERE club_name = '$cname'";
        $rst = mysql_w_query($sql);
        if(mysql_num_rows($rst)>0){
            $json_rst = array('rstno'=>-4,'error'=>_('俱乐部名称已存在'));             
        }
    }
}
if(isset($_GET['mname'])&&$json_rst['rstno']==1){
    $mname = mysql_real_escape_string($_GET['mname']);
    if (mb_strlen($mname)>$words['mname']['max']){         
        $json_rst = array('rstno'=>-5,'error'=>_('请输入6～16个字符')); 
    } else if (mb_strlen($mname)<$words['mname']['min']){
        $json_rst = array('rstno'=>-6,'error'=>_('请输入6～16个字符')); 
    }else if (reg_special_word_return($mname))	{
        $json_rst = array('rstno'=>-7,'error'=>_('您的输入不合法'));       
    } else{   
        $sql = "SELECT cid FROM c_club_info WHERE manager_name  = '$mname'";
        $rst = mysql_w_query($sql);
        if(mysql_num_rows($rst)>0){
            $json_rst = array('rstno'=>-8,'error'=>_('经理名称已存在'));         
        }
    }
} 
 

?>