<?php include_once VR.'head.php';?>
<body style="font-size:12px">
    
    <div class="container-fluid">
      <div class="row-fluid">
        <div class="span2">
          <div class="well sidebar-nav">
                <ul id="side_main_nav" class="nav nav-list">
                    <li class="nav-header">zone_id:<?=$zone_id?></li>
                    <li class="nav-header"><?=$g_server_id?>服</li>
                <?
                if ($admin_id>0){
                ?>
                <li class="nav-header"><?=$g_admin['name']?></li>
                <li><a href="javascript:void(0);" onclick="logout()">注销</li>
                <?
                }
                ?>
                        <?
                        if ($admin_id>0){
                        ?>
                            <? if(in_array($admin_role,array(0,1,2,3,4))){?>
                            <li class="nav-header">玩家信息</li>                            
                            <li id="nav_user_index"><a href="javascript:void(0);" onclick="goto_page('user','index');">玩家信息</a></li>
          		   			<? } ?>
          		   			
          		   			<? if(in_array($admin_role,array(0,1,2,3,4))){?>
                            <li class="nav-header">金币</li>                            
                            <li id="nav_user_index"><a href="javascript:void(0);" onclick="goto_page('msg','index');">送金币</a></li>
          		   			<? } ?> 
                        <?
                        } else {
                        ?>
                            <li class="nav-header">用户系统</li>
                            <li class="active"><a href="javascript:void(0);" onclick="goto_page('index','login');">登录</a></li>
                        <?
                        }
                        ?>
						</ul>
            </div><!--/.well -->
        </div><!--/span-->
        <div class="span10">
		 