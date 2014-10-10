<div class="row-fluid">
    <h4>经典球员时间延长一天</h4>
    <div>
        <div>今天中午12点要回收的经典球员有&nbsp;&nbsp;<span style="color: red"><?= $recovering_num?></span>&nbsp;&nbsp;个</div>
        <? if($recovering_num>0){?>
        <div style="color: red">点击延长默认将时间延长一天</div>
        <a href="javascript:void(0)" class="btn" onclick="delay_legend_player_zeit()">延长</a>
        <?}?>
    </div>
</div>

<div class="row-fluid">
    <h4>玩家市場延時2个小時</h4>
    <div>
        <div>正在交易的球员&nbsp;&nbsp;<span style="color: red"><?= $trading_num?></span>&nbsp;&nbsp;个</div>
        <? if($trading_num>0){?>
        <div style="color: red">点击延长默认将时间延长2个小时</div>
        <a href="javascript:void(0)" class="btn" onclick="delay_trade_player_zeit()">延长</a>
        <?}?>
    </div>
</div>

<div>
    停服礼包：<?=$maintain_voucher?>
</div>

<script>
    //添加经典球员数据
    function delay_legend_player_zeit(){
        var url = 'index.php?sub_sys=cp&m=full&a=delay&h=1&typ=1';
        $.getJSON(url,function(json){
            if(json.rstno>=1){
                alert(json.error);
                goto_page('full','delay');
            }else{
                alert(json.error);
            }
        });
    }

    function delay_trade_player_zeit(){
        var url = 'index.php?sub_sys=cp&m=full&a=delay&h=1&typ=2';
        $.getJSON(url,function(json){
            if(json.rstno>=1){
                alert(json.error);
                goto_page('full','delay');
            }else{
                alert(json.error);
            }
        });
    }

</script>