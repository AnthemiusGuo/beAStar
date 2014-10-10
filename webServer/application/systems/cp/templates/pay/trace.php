<style type="text/css">
tbody,.table_tt{background: #ffffff;}
.table_tt th{_padding-left: 15px;}
.bold_center{font-weight: bold;text-align: center;}
h3.bold_center{font-size: 14px;line-height: 25px;}
</style>
<div class="row-fluid">
    <h2>单玩家追踪</h2>
        <div>
        uid查询:<input type="text" name="user_uid" id="user_uid" value="<?=($user_uid>0)?$user_uid:''?>"/>
         	支付类型:
            <select name="main_typ" id="main_typ" onchange="change_real_typ(this.value)">
                <option value="-1" <? if($main_typ==-1){?>selected="selected"<?}?>>全部</option>            
                <option value="1" <? if($main_typ==1){?>selected="selected"<?}?>>增加点券</option>
                <option value="2" <? if($main_typ==2){?>selected="selected"<?}?>>消耗点券</option> 
            </select>
        	项目:<select name="typ" id="typ">
                    <option value="-1" <? if($typ==-1){?>selected="selected"<?}?>>全部</option>
                    <?
                    foreach ($config_change_real_credits as $id=>$infos){
                        foreach($infos as $this_typ=>$info){
                        ?> 
                            <option <? if($typ==$this_typ&&$main_typ==$id){?>selected="selected"<?}?> class="change_real_credits change_real_credits_typ_<?=$id?> <?=$main_typ!=$id?'hide':''?>" value="<?=$this_typ?>"><?=$info.",".$this_typ?></option> 
                        <?
                        }
                    }
                        ?>
                </select>
        <a href="javascript:void(0)" class="btn" onclick="search_pay_user('user_uid','main_typ','typ')">搜索</a>
        </div>
        <ul class="nav nav-tabs">
            <li><a class="active"  href="#pay_any" onclick="$(this).tab('show');">付费分析</a></li>
            <li><a  href="#base_info" onclick="$(this).tab('show');">支付流水</a></li>        
                    
        </ul>
        <div class="tab-content">
            <div class="tab-pane active" id="pay_any">
            <table class="table table-striped">
            <caption>支付类型统计</caption>
            <thead>
                <tr>
                    <th>
                        类型
                    </th>
                    <th>
                        消耗
                    </th>
                </tr>
            </thead>
            <tbody>
            <?
            foreach ($pay_total as $pay_typ=>$cost_info){
            ?>
            <tr>
                <td><?=$config_pay_name[$pay_typ]?></td>
                <td><?=$cost_info['total_cost']?></td>
            </tr>
            <?
            }
            ?>
            </tbody>
            </table>
        </div>
            <div class="tab-pane" id="base_info">
        <? if($user_uid>0&&empty($pay_list)){?>
        	没有任何支付记录！
        <?}else{?>
         <? if(isset($club_info)){?>
                        俱乐部：<?=$club_info['club_name']?> 　经理：<?=$club_info['manager_name']?> 　等级：<?=$club_info['rating_lev']?>　点劵：<?=$club_info['real_credits']?><br/>
         <? }?>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th width="90px">流水号(id)</th>
                        <th width="90px">类型(main_typ)</th>
                        <th width="150px">项目(typ)</th>
                        <th width="90px">点劵(real_credits)</th>
                        <th width="90px">点劵(rest_real_credits)</th>
                        <th width="90px">mapping_id</th>
                        <th width="180px">时间</th>
                        <th width="90px">时间(zeit)</th>
                    </tr>
                </thead>
                <tbody>
                <?
                $i= $real_credits = $rest_real_credits= 0;
                foreach ($pay_list as $pay_info){
                    $i++;
                    if($pay_info['main_typ']==1){
                        $real_credits += $pay_info['real_credits'];
                    }else{
                        $rest_real_credits += $pay_info['rest_real_credits'];
                    }
                    ?>	 	 	 	
                    <tr>                   
                        <td class="bold_center"><?=$pay_info['id']?></td>
                        <td class="bold_center"><?=($pay_info['main_typ']==1)?'增加点券':'消耗点券'?></td>
			<td class="bold_center"><?=isset($config_change_real_credits[$pay_info['main_typ']][$pay_info['typ']])?($config_change_real_credits[$pay_info['main_typ']][$pay_info['typ']]):'请添加类型'.$pay_info['main_typ']?></td>
                        <td class="bold_center"><?=$pay_info['real_credits']?></td>
			<td class="bold_center"><?=$pay_info['rest_real_credits']?></td>
                        <td class="bold_center"><?=$pay_info['mapping_id']?></td>
                        <td class="bold_center"><?=date("Y-m-d H:i:s",$pay_info['zeit'])?></td>	
                        <td class="bold_center"><?=$pay_info['zeit']?></td>		
                    </tr>
                <?
                }
                ?>
                <tr class="show_table_list <?=($i%2==1)?'odd1':'odd2'?>" style="height: 55px;">                   
                        <td class="bold_center">小计:</td>
                        <td class="bold_center"></td>
			<td class="bold_center"></td>
                        <td class="bold_center">增加点券:<?=$real_credits?></td>
			<td class="bold_center">扣除点券:<?=$rest_real_credits?></td>
                        <td class="bold_center"></td>	
                        <td class="bold_center"></td>		
                </tr>
                </tbody>
            </table>
        <?}?>
        </div>
        
</div>
<script>
function search_pay_user(user_uid,main_typ,typ){
    goto_page('pay','trace',user_uid+'='+$("#"+user_uid).val()+"&"+main_typ+'='+$("#"+main_typ).val()+"&"+typ+'='+$("#"+typ).val());
}
function change_real_typ(typ){
    $('#typ .change_real_credits').addClass('hide');
    $('#typ .change_real_credits_typ_'+typ).removeClass('hide');
}
</script>