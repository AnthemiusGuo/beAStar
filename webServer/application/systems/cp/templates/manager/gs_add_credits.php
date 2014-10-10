<div class="row-fluid">
    <h3>每次默认添加1000点券记录</h3>
    <table class="table table-striped">
        <?  foreach($gs_list as $this_gs){?>
        <tr>
            <td>俱乐部名：<?=$this_gs['club_name']?></td>
            <td>经理名：<?=$this_gs['manager_name']?></td>
            <td>
                <a href="javascript:void(0)" onclick="add_gs_creadits_cheat(<?=$this_gs['cid']?>)">加充值记录</a>
            </td>
        </tr>
        <? } ?>
    </table>
</div>
<script>
    function add_gs_creadits_cheat(cid){
        if(confirm('你确定为他添加1000点券充值记录？')){
            ajax_handler('user','add_gs_creadits_cheat',0,'cid='+cid,function(json){
                goto_page('manager','gs_add_credits');
            })
        }
    }
</script>