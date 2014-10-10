<?
foreach ($bets as $this_bet){
?>
<table class="table table-bordered table-striped">
    <caption><?=$this_bet['title']?>
    <a href="javascript:void(0);" onclick="change_bet_stat(<?=$this_bet['bet_id']?>,1)" class="btn btn-primary">已可结算</a>
    <a href="javascript:void(0);" onclick="change_bet_stat(<?=$this_bet['bet_id']?>,2)" class="btn btn-primary">已经结束</a>
    </caption>
    <?
    if ($this_bet['bet_typ']==1){
    ?>
    
    <thead>
      <tr>
        <th>场次</th>
        <th>主场</th>
        <th>客场</th>
        
        <th>胜</th>
        <th>平</th>
        <th>负</th>
        
        <th>状态</th>
        <th>操作</th>
      </tr>
    </thead>
    <?
    } elseif ($this_bet['bet_typ']==2){
    ?>
    
    <thead>
      <tr>
        <th>id</th>
        <th>净胜球</th>
        <th>赔率</th>
        <th>设为结果</th>
      </tr>
    </thead>
    <?
    }
    ?>
    <tbody>
        <?
        foreach ($this_bet['detail'] as $this_detail) {
            if ($this_bet['bet_typ']==1){
        ?>
    <tr>
        <td><?=$this_detail['id']?></td>
        <td><input type="text" value="<?=$this_detail['home_clubname']?>"/></td>
        <td><input type="text" value="<?=$this_detail['away_clubname']?>"/></td>
        
        <td><input type="text" value="<?=$this_detail['win']?>"/></td>
        <td><input type="text" value="<?=$this_detail['draw']?>"/></td>
        <td><input type="text" value="<?=$this_detail['loose']?>"/></td>
        
        <td><?=$this_detail['real_result']?></td>
        <td><?=$this_detail['id']?></td>
        
    </tr>
        <?
        } else {
        ?>
        <tr>
        <td><?=$this_detail['score_id']?></td>
        <td><?=$this_detail['score_name']?></td>
        <td><?=$this_detail['score_rate']?></td>
        <td><?=$this_detail['score_id']?></td>
        </tr>
        
    </tr>
        <?
        }
        }
        ?>
    </tbody>
</table>
<?
}
?>
<script>
    function change_bet_stat(bet_id,stat){
        var url = '?sub_sys=cp_news&m=user&a=fix_player_cond&h=1&user_uid='+user_uid;
        $.getJSON(url,function(json) {
            if(json.rstno>=1){
                    alert("操作成功!");
            }else{
                alert(json.error);
            }
        });
    }
</script>