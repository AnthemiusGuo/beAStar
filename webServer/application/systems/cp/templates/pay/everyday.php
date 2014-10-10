<table class="table table-bordered table-striped">
    <caption>每日统计</caption>
    <thead>
      <tr>
        <th>日期</th>
        <th>新增登入帐号</th>
        <th>新建角色</th>
        
        <th>日登陆人数</th>
        <th>平均在线</th>
        <th>最高在线</th>
        
        <th>充值人数</th>
        <th>日充值</th>
        <th>消耗人数</th>
        <th>消耗人次</th>
        <th>消耗金额</th>
        <th>剩余数据</th>
      </tr>
    </thead>
    <tbody>
    <?
    foreach ($everyday as $this_day){
        $this_json_info = json_decode($this_day['json_data'],true);
    ?>
    <tr>
        <td><?=date('m-d',$this_day['zeit_sunrise'])?></td>
        <td><?=$this_day['count_new_account']?></td>
        <td><?=$this_day['count_new_user']?></td>
        
        <td><?=$this_day['acu']?></td>
        <td><?=$this_day['avg_pcu']?></td>
        <td><?=$this_day['max_pcu']?></td>
        
        <td><?=$this_day['count_payer']?></td>
        <td><?=common_format_incoming($this_day['total_pay'])?>元</td>
        <td><?=$this_day['count_coster']?></td>
        <td><?=$this_day['count_cost']?></td>
        <td><?=$this_day['total_cost']?>点券</td>
        <td ><a href="#" onclick="showpaydata(<?=$this_day['zeit_sunrise']?>);">查看或隐藏</a></td>
    </tr>
    <div style="display: none;" id="paydata_<?=$this_day['zeit_sunrise']?>" class="paydata row-fluid">
        <h3><?=date('m-d',$this_day['zeit_sunrise'])?></h3>
        <div class="row-fluid">
            <div class="span4">
                <h3>俱乐部等级</h3>
                <?
                $amount_array =$money_array= $ponit_array=$player_level_array= array(7=>0,10=>0,20=>0,30=>0,40=>0,50=>0,60=>0);
                if(isset($this_json_info['club_level'])&&!empty($this_json_info['club_level'])){
                foreach($this_json_info['club_level'] as $this_level=>$value){                       
                    if($this_level<=7){
                        $amount_array[7] += $value['amount'];
                        $money_array[7]+= $value['all_club_money'];                        
                        $ponit_array[7]+= $value['all_attr_points'];
                    }else if($this_level<=10){
                        $amount_array[10] += $value['amount'];
                        $money_array[10]+= $value['all_club_money'];                        
                        $ponit_array[10]+= $value['all_attr_points'];
                    }else if($this_level<=20){
                        $amount_array[20] += $value['amount'];
                        $money_array[20]+= $value['all_club_money'];                        
                        $ponit_array[20]+= $value['all_attr_points'];
                    }else if($this_level<=30){
                        $amount_array[30] += $value['amount'];
                        $money_array[30]+= $value['all_club_money'];                        
                        $ponit_array[30]+= $value['all_attr_points'];
                    }else if($this_level<=40){
                        $amount_array[40] += $value['amount'];
                        $money_array[40]+= $value['all_club_money'];                        
                        $ponit_array[40]+= $value['all_attr_points'];
                    }else if($this_level<=50){
                        $amount_array[50] += $value['amount'];
                        $money_array[50]+= $value['all_club_money'];                        
                        $ponit_array[50]+= $value['all_attr_points'];
                    }else if($this_level<=60){
                        $amount_array[60] += $value['amount'];
                        $money_array[60]+= $value['all_club_money'];                        
                        $ponit_array[60]+= $value['all_attr_points'];
                    }
                }
                ?>
                <? foreach($amount_array as $level=>$num){?>
                    <?=$level?>以下：<?=$num?>人, 剩余足球币： <?=$money_array[$level]?>剩余战术知识： <?=$ponit_array[$level]?><br/>
                <?}
            }?>
            </div>            
        </div>
        <div class="row-fluid">
            <div class="span4">
                <h3>球员等级</h3>
                <?
                if(isset($this_json_info['player_level'])&&!empty($this_json_info['player_level'])){
                foreach($this_json_info['player_level'] as $this_level=>$value){                       
                    if($this_level<=7){
                        $player_level_array[7] += $value;
                         
                    }else if($this_level<=10){
                        $player_level_array[10] += $value;
                         
                    }else if($this_level<=20){
                        $player_level_array[20] += $value;
                        
                    }else if($this_level<=30){
                        $player_level_array[30] += $value;
                        
                    }else if($this_level<=40){
                        $player_level_array[40] += $value;
                        
                    }else if($this_level<=50){
                        $player_level_array[50] += $value;
                        
                    }else if($this_level<=60){
                        $player_level_array[60] += $value;
                        
                    }
                }
                ?>
                <? foreach($player_level_array as $level=>$num){?>
                    <?=$level?>以下：<?=$num?>人<br/>
                <?}
                }?>
            </div>
        </div>
        <div class="row-fluid">
            <div class="span4">
                <h3>转生球员等级个数</h3>
                <?
                if(isset($this_json_info['player_reincarnation_lev'])&&!empty($this_json_info['player_reincarnation_lev'])){
                foreach($this_json_info['player_reincarnation_lev'] as $this_level=>$value){                       
                    ?>
                     <?=$this_level?>转生球员：<?=$value?> 个 <br/>
                <?     
                }
                }
                ?>
                
            </div>
        </div>
        <div class="row-fluid">
            <div class="span4">
                <h3>技能石剩余</h3>
                <?
                $stone_array = array(1=>'攻击型',2=>'组织型',3=>'防守型');
                 if(isset($this_json_info['u_skill_stone'])&&!empty($this_json_info['u_skill_stone'])){
                foreach($this_json_info['u_skill_stone'] as $this_typ=>$this_value){
                    foreach($this_value as $this_level=>$value){
                      echo $this_level.'级'.$stone_array[$this_typ].'技能石：'.$value."个"."<br/>";                         
                    }
                }
                 }
                ?>
                
            </div>
        </div>
    </div>
    <?
    }
    ?>
    </tbody>
</table>
<?
if ($total_page>1){
?>
<div class="pagination">
  <ul>
    <li><a href="#" onclick="goto_page('pay','everyday','page=<?=$page-1?>');">上一页</a></li>
    <?
    for ($i=1;$i<=$total_page;$i++){
    ?>
    <li><a href="#" onclick="goto_page('pay','everyday','page=<?=$i-1?>');"><?=$i?></a></li>
    <?
    }
    ?>
    <li><a href="#" onclick="goto_page('pay','everyday','page=<?=$page+1?>');">下一页</a></li>
  </ul>
</div>
<?
}
?>
<script>
    function showpaydata(aa){
        var b = $('#paydata_'+aa).css('display');
        $(".paydata").hide();
        $('#paydata_'+aa).css('display',b);
        $('#paydata_'+aa).toggle();
    }
</script>
