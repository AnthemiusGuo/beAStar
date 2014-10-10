<div class="row-fluid">
    <h2>玩家信息编辑</h2>
    <div>
        uid查询:<input type="text" name="user_uid" id="user_uid" value="<?=($user_uid>0)?$user_uid:''?>"/>
        <a href="javascript:void(0)" class="btn" onclick="search_user('user_uid')">搜索</a>
        俱乐部名查询:<input type="text" name="club_name" id="club_name" value="<?=$club_name?>"/>
        <a href="javascript:void(0)" class="btn" onclick="search_user('club_name')">搜索</a>
        经理名查询:<input type="text" name="club_name" id="manager_name" value="<?=$manager_name?>"/>
        <a href="javascript:void(0)" class="btn" onclick="search_user('manager_name')">搜索</a>
        pp_uid查询:<input type="text" name="pp_uid" id="pp_uid" value="<?=$pp_uid?>"/>
        <a href="javascript:void(0)" class="btn" onclick="search_user('pp_uid')">搜索</a>
    </div>
    <div>
        <?
        if ($user_uid==-1){
        ?>
        您查询的玩家不存在
        <?
        }
        if (!empty($users)){
        ?>
        请选择玩家
        <ul>
        <?
            foreach ($users as $this_user){
        ?>
            <li>
                <?=$this_user['uid']?>:
                <?=($this_user['base_info']==false)?'已删除或出错':''?>:
                <?=($this_user['club_info']==false)?'':$this_user['club_info']['club_name']?>
                <a href="#" onclick="goto_page('user','index','user_uid=<?=$this_user['uid']?>')">查看</a>
            </li>
        <?
            }
        ?>
        </ul>
        <?
        }
        ?>
    </div>
</div>
<?
if ($user_uid>0){
?>
<div class="row-fluid">
    <div class="span3">
        <?
        if ($base_info['DOA']!=1){
        ?>
        用户不可用<?=$base_info['DOA']?>
        <?
        } else {
        ?>
        平台id: <?=$base_info['pp_uid']?><br/>
        俱乐部：<?=$club_info['club_name']?><br/>
        经理：<?=$club_info['manager_name']?><br/>
        <?=($base_info['newbie_stat']==0)?'新手期':'非新手';?>
        等级：<?=$club_info['rating_lev']?><br/><br/><br/><br/>
        <? if($base_info['newbie_stat']==0||$admin_role==1){?>
        <a href="#" class="btn"  onclick="delete_user(<?=$user_uid?>)">删号</a>（目前只确认新手期用户可用！！！)<br/>
        <?}?>
        <a href="#" class="btn" onclick="chat_limit(<?=$user_uid?>)">禁言</a><br/>
        <a href="#" class="btn">封号</a><br/>
        <a href="#" class="btn" onclick="fix_feed(<?=$user_uid?>)">修复新闻</a><br/>
        <a href="#" class="btn" onclick="fix_player_cond(<?=$user_uid?>)">修复球员体力</a><br/>
        <a href="#" class="btn" onclick="fix_lock_pass(<?=$user_uid?>)">修复密保</a><br/>
        <? if($g_version_op==1){?>
        <a href="#" class="btn" onclick="fix_user_market(<?=$user_uid?>)">完成交叉营销任务</a><br/>
        <?}?>
        <? if($admin_role==1||$admin_role==4){?>
            <a href="#" class="btn" onclick="update_user_cond(<?=$user_uid?>,<?=$club_info['is_robot']?>)"><?=$club_info['is_robot']!=3?'帐号管理':'取消管理'?></a><br/>
        <?}?>
        
        <?
        }
        ?>
        <a href="#" class="btn" onclick="fix_skill_stone(<?=$user_uid?>,4)">补偿3种4级技能石各4个</a><br/>
        <a href="#" class="btn" onclick="fix_skill_stone(<?=$user_uid?>,3)">补偿3种3级技能石各4个</a><br/>
        
    </div>
    <div class="span9">
        <ul class="nav nav-tabs">
            <li><a class="active"  href="#base_info" onclick="$(this).tab('show');">user_base</a></li>        
            <li><a  href="#extend_info" onclick="$(this).tab('show');">user_extend</a></li>        
            <li><a  href="#club_info" onclick="$(this).tab('show');">club</a></li>
            <li><a  href="#squad_info" onclick="$(this).tab('show');">squad</a></li>
            <li><a  href="#player_info" onclick="$(this).tab('show');">p_player</a></li>
        </ul>
        <div class="tab-content">
            <div class="tab-pane active" id="base_info">
            <pre>
            <?
            var_dump($base_info);
            ?>    
            </pre>
            </div>
            <div class="tab-pane" id="extend_info">
            <pre><?
            var_dump($extend_info);
            ?>
            </pre>
            </div>
            <div class="tab-pane" id="club_info">
            <pre>
                
            <?
            var_dump($club_info);
            ?>
            </pre>
            </div>
            
            <div class="tab-pane" id="squad_info">
            <pre>
                
            <?
            var_dump($squad_info);
            ?>
            </pre>
            </div>

            <div class="tab-pane" id="player_info">
                <table class="table-bordered">
                    <tr>
                        <td>pid</td>
                        <td>player_name</td>
                        <td>inj</td>
                        <td>rp_id</td>
                        <td>主要位置</td>
                        <td>转生等级</td>
                        <td>level</td>
                        <td>quality</td>
                        <td>on_list</td>
                    </tr>
                    <? if(!empty($player_info)){
                            foreach($player_info as $player){
                    ?>
                    <tr>
                        <td><?=$player['pid']?></td>
                        <td><?=$player['player_name']?></td>
                        <td><?=$player['inj']?></td>
                        <td><?=$player['rp_id']?></td>
                        <td><?=$player['main_position_typ']?></td>
                        <td><?=$player['reincarnation_lev']?></td>
                        <td><?=$player['level']?></td>
                        <td><?=$player['quality']?></td>
                        <td><?=$player['on_list']?></td>
                    </tr>
                    <?
                            }
                    }?>

                </table>
            </div>
            
            <div class="tab-pane" id="settings">...</div>
        </div>
        
    </div>
</div>
<?
}
?>
<script>
function search_user(typ){
    goto_page('user','index',typ+'='+$("#"+typ).val());
}
function delete_user(user_uid){
    var url = '?sub_sys=cp&m=user&a=delete&h=1&user_uid='+user_uid;
    $.getJSON(url,function(json) {
    	if(json.rstno>=1){
    		alert("操作成功!");
                goto_page('user','index');
        }else{
            alert(json.error);
        }
    });
}
function fix_player_cond(user_uid){
    var url = '?sub_sys=cp&m=user&a=fix_player_cond&h=1&user_uid='+user_uid;
    $.getJSON(url,function(json) {
    	if(json.rstno>=1){
    		alert("操作成功!");
        }else{
            alert(json.error);
        }
    });
}
function fix_lock_pass(user_uid){
    var url = '?sub_sys=cp&m=user&a=fix_lock_pass&h=1&uid='+user_uid;
    $.getJSON(url,function(json) {
    	if(json.rstno>=1){
    		alert("操作成功!");
        }else{
            alert(json.error);
        }
    });
}
function fix_feed(user_uid){
    var url = '?sub_sys=cp&m=user&a=fix_feed&h=1&user_uid='+user_uid;
    $.getJSON(url,function(json) {
    	if(json.rstno>=1){
    		alert("操作成功!");
        }else{
            alert(json.error);
        }
    });
}
function fix_user_market(user_uid){
    var url = '?sub_sys=cp&m=user&a=fix_market_task&h=1&user_uid='+user_uid;
    $.getJSON(url,function(json) {
    	if(json.rstno>=1){
    		alert("操作成功!");
        }else{
            alert(json.error);
        }
    });
}
function update_user_cond(user_uid,is_robot){
    if(is_robot!=3){
        var msg = "你确定他为托？";
    }else{
        var msg = "取消托权限？";
    }
    if(confirm(msg)){
        ajax_handler('user','update_user_cond',1,'user_uid='+user_uid,function(){
            goto_page('user','index','user_uid='+user_uid);
        })
    }
}
function chat_limit(user_uid){
    ajax_handler('user','chat_limit',1,'user_uid='+user_uid,function(){
            goto_page('user','index','user_uid='+user_uid);
        })
}

function fix_skill_stone(user_uid,level){
     ajax_handler('user','fix_skill_stone',1,'user_uid='+user_uid+'&level='+level,function(){
            goto_page('user','index','user_uid='+user_uid);
        })
}
</script>