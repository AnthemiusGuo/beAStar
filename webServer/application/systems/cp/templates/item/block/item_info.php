<?
if($item_id==0){
	?>
<form method="post" id="form_item" action="?sub_sys=cp&m=item&a=save_item&item_id=0&h=1">
    <dl class="item_info">
		    
        <dd>类型：<select name="item_typ" class="item_select_order_type">
			<option value='3' selected='selected'>验证码礼包</option>
			</select>
			<br/>名字：<input type="text" name="item_name" id="item_name" value=""/> 
        </dd>
        <dd><a href="javascript:void(0);" onclick="add_new_order()">添加道具</a></dd>
        <div id="add_item_gift"></div>

    </dl>
    <input type="hidden" name="item_id" value="0"/>
</form>
<? } ?>
<div class="clear"></div>
<a href="javascript:void(0)" class="btn" onclick="save_item('form_item',<?=$item_id?>)">保存</a>
<script>
$(document).ready(function(){
    bindListener();
})
function add_new_order(){
    $("#add_item_gift").append('<div class="iptdiv" >道具类型：<select name="gift_typ[]" class="card_select_order_type"><option value="-1">足球币</option><option value="-2">礼券</option><? 
    			foreach ($item_list as $item_id=>$item_info){
					echo "<option value=".$item_id.">".$item_info['item_name']."</option>";
		  		}
		  ?></select> 道具数量：<input type="text" name="item_num[]" id="item_num[]" value="1"/> <a href="#" name="rmlink">X</a></div>');
     bindListener();
}
function bindListener(){
    $("a[name=rmlink]").unbind().click(function(){
        $(this).parent().remove();
    })
}
</script>