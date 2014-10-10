<h2>礼包编辑</h2>
<ul id="item_nav" class="nav nav-tabs">
    <li class="active">
      <a href="javascript:void(0);" onclick="goto_page('item','index');" >礼包首页</a>
    </li>
    <li><a href="javascript:void(0);" onclick="hide_item_span(0)" >添加礼包</a></li>
    <li><a href="javascript:void(0);" onclick="hide_item_give(0)" >赠送道具</a></li>
    <li><a href="javascript:void(0);" onclick="hide_item_give_log(0)" >赠送日志</a></li>
    <li><a href="javascript:void(0);" onclick="gift_voucher_list(0)" >所有验证码</a></li>
</ul>
<div class="row-fluid" id="item_data">
</div>
<div class="row-fluid" id="item_list_index">
    <div class="span6">
        <table class="table table-striped">
            <?  foreach($item_list as $this_item_id=>$this_item){?>
                    <tr>
                        <td><?=$this_item['package_name']?></td>
                        <td>
                            <a href="javascript:void(0)" onclick="hide_item_span_disp(<?=$this_item_id?>)">查看礼包</a>
                        </td>
                        <td>
                            <a href="javascript:void(0)" onclick="gift_voucher(<?=$this_item_id?>)">生成验证码</a>
                        </td>
                        <td>
                            <a href="javascript:void(0);" onclick="gift_voucher_list(<?=$this_item_id?>)">查看验证码</a> 
                        </td>
                        <td>
                            <a href="javascript:void(0)" onclick="del_item(<?=$this_item_id?>,'<?=$this_item['package_name']?>')">删除</a>
                        </td>   
                    </tr>
              <?}?>
        </table>
    </div>
    <div id="span_item" class="span6 hide">
        <? //include_once VR.'item/block/item_info.php';?>
    </div>
</div>



<script>
var item_list = <?=json_encode($item_list)?>;

 function export_item_data(){
     
    $('#item_data').load('?sub_sys=cp&m=item&a=item_data&format=json').siblings().addClass('hide');
}
//添加新item
 function package_list(item_id){ 
     $('#span_item').removeClass('hide').load('?sub_sys=cp&m=item&a=create_package&item_id='+item_id);
 }
//添加新item
function hide_item_span(item_id){ 
    $('#item_list_index').addClass('hide');
    $('#item_data').removeClass('hide').load('?sub_sys=cp&m=item&a=item_info&format=html&item_id='+item_id);
}
//查看item
function hide_item_span_disp(item_id){ 
    $('#span_item').removeClass('hide').load('?sub_sys=cp&m=item&a=item_disp&format=html&item_id='+item_id);
}
//赠送item
function hide_item_give(item_id){ 
    $('#item_list_index').addClass('hide');
    $('#item_data').removeClass('hide').load('?sub_sys=cp&m=item&a=item_give&format=html&item_id='+item_id);
}
//生成验证码item
function gift_voucher(item_id){ 
    $('#span_item').removeClass('hide').load('?sub_sys=cp&m=item&a=gift_voucher&format=html&item_id='+item_id);
}
//赠送item
function hide_item_give_log(item_id){ 
    $('#item_list_index').addClass('hide');
    $('#item_data').removeClass('hide').load('?sub_sys=cp&m=item&a=item_give_log&format=html&item_id='+item_id);
}
//赠送item
function gift_voucher_list(item_id){
    $('#item_list_index').addClass('hide');
    
    $('#item_data').removeClass('hide').load('?sub_sys=cp&m=item&a=gift_voucher_list&format=html&item_id='+item_id);
}
//保存item
function save_item(form_id,typ){
    if($('#package_name').val()==""){
        alert('item名字不能为空!');
        return;
    }
    if($('#item_desc').val()==""){
        alert('item描述不能为空!');
        return;
    }
    if(typ==1){
        $('#item_id').val(0);
    }
    ajax_post(form_id,function(){
        
    });
    goto_page('item','index');
}
//生成验证码
function create_gift_voucher(form_id,typ){
    if($('#num').val()==""){
        alert('num数量不能为空或0!');
        return;
    }
    ajax_post(form_id,function(){
        
    });
    goto_page('item','index');
}
//保存item
function give_item(form_id,typ){
    if($('#cid').val()==""){
        alert('CID不能为空!');
        return;
    }
    if($('#title').val()==""){
        alert('赠送标题名不能为空!');
        return;
    }
    if($('#item_num').val()==""){
        alert('赠送道具不能为空!');
        return;
    }
    if(typ==1){
        $('#item_id').val(0);
    }
    ajax_post(form_id,function(){
        
    });
    goto_page('item','index');
}
//删除item
function del_item(item_id,package_name){
	var url = 'index.php?sub_sys=cp&m=item&a=del_item&h=1'+'&item_id='+item_id;
	if(confirm('是否将此['+package_name+']删除?')){
	    $.getJSON(url,function(json){
	        if(json.rstno>=1){
	            goto_page('item','index');
	        }else{
	            alert(json.error);
	        }
	    }); 
	}else{
		return false;
	} 
}
</script>