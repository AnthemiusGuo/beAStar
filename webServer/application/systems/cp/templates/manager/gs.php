<div class="row-fluid">
    <h3>一次加10000点券</h3>
    <table class="table table-striped">
        <?  foreach($gs_list as $this_gs){?>
            <tr>
                <td>俱乐部名：<?=$this_gs['club_name']?></td>
                <td>经理名：<?=$this_gs['manager_name']?></td>
                <td>点券数：<?=$this_gs['real_credits']?></td>
                <td>
                    <input type="text" id="add_real_credits_<?=$this_gs['cid']?>" value="10000"/>
                    <a href="javascript:void(0)" onclick="add_gs_creadits(<?=$this_gs['cid']?>)">加点券</a> 
                </td>                  
            </tr>
        <? } ?>
    </table>
</div>
<script>
    function add_gs_creadits(cid){
        var num = $("#add_real_credits_"+cid).val();
        if(confirm('你确定为他添加'+num+'点券？')){            
            ajax_handler('user','add_gs_creadits',0,'cid='+cid+'&num='+num,function(json){
                goto_page('manager','gs');
            })
        }
    }
</script>