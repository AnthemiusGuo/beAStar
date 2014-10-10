<div class="row-fluid">
    <h4>周赛数据初始化</h4>
    当前状态<br/>
    周赛报名结束时间：
    <span style="color: red">
        <?= ($begin_tour_zeit!=0) ? date('Y-m-d H:i:s',$begin_tour_zeit) : '暂无数据'?>
    </span>
    <br/>
    周赛系统事件：
    <div>
        <ul class="inline">
  
    <?
    foreach ($has_event as $this_event){
    ?>
    <li>
        <?=($this_event['typ'].'_'.$this_event['param_1'].':'.date('Y-m-d H:i:s',$this_event['zeit']))?>
    </li>
    <?
    }
    ?>
    </ul>
    </div>
    <div class="clearfix"></div>
    周赛信息
    <div>
        <?
        foreach ($tour_info as $this_tour){
            echo '第'.$this_tour['counter_history'].'届'.$this_tour['info']['cup_typ_name'].':status:'.$this_tour['status'].'<br/>';
        }
        ?>
    </div>
    输入第一次结束报名的时间戳（即本周三或者下周三的凌晨4点）
    <input type="text" id="start_tour" value=""/>
    <a href="javascript:void(0)" class="btn" onclick="initialization_tour()">确定</a>
</div>
<div class="row-fluid">
    <h4>开服活动初始化</h4>
    <dd>排行榜发榜执行时间<span style="color: red">：<?= !empty($obt_act_system) ? date('Y-m-d H:i:s',$obt_act_system['zeit']) : '暂无数据'?><span></dd>
    <dd>当前存在活动:</dd>
    <?
        if(!empty($feed_obt_act_list)){
            foreach($feed_obt_act_list as $act){
    ?>
                <dd>活动名称：<?=$act['title']?>活动类型：<?=$act['act_type']?>&nbsp;&nbsp;&nbsp;开始时间：<?=date('Y-m-d H:i:s',$act['s_date'])?>&nbsp;&nbsp;&nbsp;结束时间：<?=date('Y-m-d H:i:s',$act['e_date'])?></dd>
    <?
            }
    ?>
    <?}else{?>
            <dd style="color: red">数据为空</dd>
    <?}?>
    <dd>开服11天活动数据迁移事件:</dd>
    <?
        if(!empty($open_game_e_sys_list)){
            foreach($open_game_e_sys_list as $open_game_sys){
                if($open_game_sys['flag']==2){
                    $status = _('已执行');
                }elseif($open_game_sys['flag']==0){
                    $status = _('未执行');
                }elseif($open_game_sys['flag']==1){
                    $status = 1;
                }
    ?>
           <dd>事件执行时间:&nbsp;&nbsp;&nbsp;<?=date('Y-m-d H:i:s',$open_game_sys['zeit'])?>&nbsp;&nbsp;&nbsp;事件执行状态:&nbsp;&nbsp;&nbsp;<?=$status?></dd>
    <?
            }
        }else{
    ?>
            <dd style="color: red">数据为空</dd>
    <?
        }
    ?>
</div>
<br />
<div class="row-fluid">
    <h4>经典球员事件初始化</h4>
    <div>
        <? if(!empty($legend_player_time)){?>
            <div style="color: red">最新经典球员系统事件执行时间:&nbsp;&nbsp;<?= $legend_player_time?></div>
        <? }else{?>
            <div style="color: red">点击添加默认添加执行时间30分钟后的数据（点击验证：验证数据是否添加成功！）</div>
            <a href="javascript:void(0)" class="btn" onclick="add_legend_player()">添加</a>
            <a href="javascript:void(0)" class="btn" onclick="check_legend_player_data()">验证</a>
        <?}?>
    </div>
</div>
<div class="row-fluid">
    <h4>机器人</h4>
    现有<?=count($robots)?>个机器人。
    <a href="javascript:void(0)" class="btn" onclick="gen_robot()">生成</a>
</div>

<div class="row-fluid">
    <h4>快捷开服(开服前半小时执行)</h4>
    输入开服时间(如:&nbsp;<span>2013-01-01 05:34:00&nbsp;</span>)<br/>
    <?if(isset($open_game) && !empty($open_game)){?>
        <span style="color: red"><?=$open_game['value']?></span>&nbsp;&nbsp;&nbsp;<b>开服</b>
    <?}else{?>
        <input type="text" id="open_game_time" value=""/>
        <a href="javascript:void(0)" class="btn" onclick="quick_create_server()">开服</a>
    <?}?>

</div>
<script>
    //添加经典球员数据
    function add_legend_player(){
        var url = 'index.php?sub_sys=cp&m=full&a=legend_player&h=1';
        $.getJSON(url,function(json){
            if(json.rstno>=1){
                //alert(json.error);
                goto_page('full','start');
            }else{
                alert(json.error);
            }
        });
    }
    //检查经典球员数据
    function check_legend_player_data(){
        var url = 'index.php?sub_sys=cp&m=full&a=legend_player&h=1&type=1';
        $.getJSON(url,function(json){
            if(json.rstno>=1){
                goto_page('full','start');
                alert(json.error);
            }else{
                alert(json.error);
            }
        });
    }
    //初始化周赛
    function initialization_tour(){
        var start_tour=$('#start_tour').val();
        var url = 'index.php?sub_sys=cp&m=full&a=tour_match&h=1&start='+start_tour;
        $.getJSON(url,function(json){
            if(json.rstno>=1){
                goto_page('full','start');
                alert(json.error);
            }else{
                alert(json.error);
            }
        });
    }
    
    function gen_robot(){
        ajax_handler('full','robot_create',0,'',function(){
            goto_page('full','start');
            });
    }
    function quick_create_server(){
         var open_game_time=$('#open_game_time').val();
         var plus = 'open_game_time='+open_game_time;
         ajax_handler('full','quick_create_server',1,plus,function(){
            goto_page('full','start');
        });
    }
</script>