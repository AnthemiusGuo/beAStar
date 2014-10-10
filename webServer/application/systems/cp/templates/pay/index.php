<div class="row-fluid">
    <div class="row-fluid">
        <div class="span4">
            <h3>今日货币存量</h3>
            <?=$sum_reverse_all['sum_all']?>点券
        </div>
        <div class="span4">
            <h3>今日有余额用户数</h3>
            <?=$sum_reverse_all['c_cid']?>
        </div>
        <div class="span4">
            <h3>今日消耗收入</h3>
            <?=$sum_today['count_cid']?>人<br/>
            <?=$sum_today['count_pay']?>次<br/>
            <?=$sum_today['total_cost']?>点券<br/>
        </div>
    </div>
    <div class="row-fluid">
        <h2>今日消费预览</h2>
        <?
        foreach ($any_today as $this_typ=>$this_info){
        ?>
            <div class="span2" style="height: 100px;">
                <h4><?=$config_pay_name[$this_typ];?></h4>
                <?=$this_info['count_cid']?>人<br/>
                <?=$this_info['count_pay']?>次<br/>
                <?=$this_info['total_cost']?>点券<br/>
            </div>
        <?
        }
        ?>
    </div>
    <h2>每日信息</h2>

    <div>
        <?
        for ($i=1;$i<6;$i++){
        ?>
            <table class="table table-striped">
                <caption>第<?=$i?>批数据</caption>
                <thead>
                    <tr>
                    <th width="8%">
                        Date
                    </th>
                    <?
                    foreach ($config_pay_name as $this_typ=>$this_typ_name){
                        if ($this_typ>$i*10 || $this_typ<=($i-1)*10){
                            continue;
                        }
                    ?>
                    <th  width="8%"><?=$this_typ_name?></th>
                    <?
                    }
                    ?>
                    </tr>
                </thead>
                <tbody>
            
            <?
            foreach ($everyday_any as $this_day=>$info){
            ?>
                <tr>
                    <td>
                        <?=date('m-d',$this_day)?>
                    </td>
                    <?
                    foreach ($config_pay_name as $this_typ=>$this_typ_name){
                        if ($this_typ>$i*10 || $this_typ<=($i-1)*10){
                            continue;
                        }
                        if (!isset($info[$this_typ])){
                            echo "<td>-</td>";
                        } else {
                    ?>
                        <td>
                            <?=$info[$this_typ]['count_pay']?>次;<br/>
                            <?=$info[$this_typ]['count_cid']?>人;<br/>
                            <?=$info[$this_typ]['total_cost']?>钱;<br/>
                        </td>
                    <?
                        }
                    }
                    
                    
                    ?>
                </tr>
            <?
            }
            ?>
            </tbody>
            </table> 
        <?
        }
        ?>  
    </div>
    <div>
        <ul class="nav nav-tabs">
            <?
            foreach ($everyday_any as $this_day=>$info){
            ?>
                <li><a href="#info_detail_<?=$this_day?>" onclick="$(this).tab('show');"><?=date('m-d',$this_day)?></a></li> 
            <?
            }
            ?>
        </ul>
        <div class="tab-content">
            <?
            foreach ($everyday_any as $this_day=>$info){
            ?>
                <div class="tab-pane active" id="info_detail_<?=$this_day?>">
                    <?
                    foreach ($info as $this_typ=>$this_detail){
                    ?>
                        <div class="span_4" style="height: 200px;">
                            <h4><?=$config_pay_name[$this_typ];?></h4>
                            <?
                            foreach ($this_detail['json_data']['by_level'] as $this_level=>$this_level_info){
                                echo (($this_level-1)*5).'-'.($this_level*5);
                            ?>
                            级: <?=$this_level_info['count_cid']?>人 | <?=$this_level_info['count_pay']?>次 | <?=$this_level_info['total_cost']?>钱 <br/>
                            <?
                            }
                            
                            ?>
                        </div>
                        
                    <?
                    }
                    ?>
                </div>
            <?
            }
            ?>
        </div>
    </div>
</div>