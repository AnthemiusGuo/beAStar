<?
//include_once FR.'config/define/pf_server.config.php';
$admin_role = 0;
if ($admin_id>0) {
    $g_admin = admin_get_user_base($admin_id);
    $admin_role = $g_admin['admin_role'];
} 
?>