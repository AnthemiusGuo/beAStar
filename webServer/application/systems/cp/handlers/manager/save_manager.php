<?php
$manager_id = isset($_GET['manager_id'])?$_GET['manager_id']:0;
$manager_name = isset($_GET['manager_name'])?mysql_real_escape_string($_GET['manager_name']):'';
$manager_desc = isset($_GET['manager_desc'])?mysql_real_escape_string($_GET['manager_desc']):'';
$manager_url = isset($_GET['manager_url'])?mysql_real_escape_string($_GET['manager_url']):'';
$manager_source = isset($_GET['manager_source'])?mysql_real_escape_string($_GET['manager_source']):'';

//保存添加的管理员
if($manager_id != 0){
    if($manager_url=='')
    {
        $sql = "UPDATE admin_editor SET name='$manager_name',login_name='$manager_desc',admin_role='$manager_source' WHERE admin_uid='$manager_id'";    
    }else{
        $manager_url = md5($manager_url);
        $sql = "UPDATE admin_editor SET name='$manager_name',login_name='$manager_desc',pwd='$manager_url',admin_role='$manager_source' WHERE admin_uid='$manager_id'";
    }
    mysql_w_query($sql);
}else{
    $manager_url = md5($manager_url);
    $sql = "INSERT INTO admin_editor (name,login_name,pwd,admin_role) VALUES ('$manager_name','$manager_desc','$manager_url','$manager_source')";
    mysql_w_query($sql);
}
?>