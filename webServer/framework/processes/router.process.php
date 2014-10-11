<?php
//if set h=1 in url or form, do this as a handle request
if (isset($_REQUEST['h']) && ($_REQUEST['h']==1)) {
    
    $json_rst = array('rstno'=>1,'error'=>_('成功!'),'m'=>$g_module,'a'=>$g_action);     
    if (!file_exists(HR.$g_module.'/'.$g_action.'.php')) {
		$json_rst = array('rstno'=>-98,'error'=>_('您访问的接口不存在!'),'m'=>$g_module,'a'=>$g_action,'data'=>array());
        echo json_encode($json_rst);
		exit;
    } 
    
    include_once(HR.$g_module.'/'.$g_action.'.php');
    echo json_encode($json_rst);
} else {    
    //check if module/templates is exists
    //判断文件是否存在，如果不存在就报错
    
    if (!file_exists(MR.$g_module.'/'.$g_action.'.php'))
    {
        return_not_exist();
    }
    if (!file_exists(VR.$g_module.'/'.$g_action.'.php') && $g_view == PAGE)
    {
        return_not_exist();
        
    }
    if (!file_exists(VR.$g_module.'/block/'.$g_action.'.php') && $g_view == HTML)
    {
        return_not_exist();
    }
	if ($g_view == JSON) {
		$json_rst = array('rstno'=>1,'error'=>_('成功!'),'m'=>$g_module,'a'=>$g_action,'data'=>array());
	}
    if (file_exists(MR.$g_module.'/common.php'))
    {
        include_once(MR.$g_module.'/common.php');
    }
    include_once(MR.$g_module.'/'.$g_action.'.php');
    
    //读取界面文件
	 
    if ($g_view == PAGE) {
		$v_title = $g_v_title;
        include_once(VR.$g_module.'/'.$g_action.'.php');
    } elseif ($g_view == HTML) {
          
        include_once(VR.$g_module.'/block/'.$g_action.'.php');
    } elseif ($g_view == JSON) {        
        if (isset($_GET['callback'])) {
            print $_GET['callback'].'('.json_encode($json_rst).');';
        } else {
            print json_encode($json_rst);
        }
    }    
}