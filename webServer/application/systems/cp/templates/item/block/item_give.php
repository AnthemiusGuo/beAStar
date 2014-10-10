<?
if($item_id==0){
	?>
<form method="post" id="form_item" action="?sub_sys=admin&m=item&a=give_item&item_id=0&h=1">
    <dl class="item_info">
		    
        <dd>
			<dl>赠送标题：<input type="text" name="title" id="title" value=""/><br/>CID：<input type="text" name="cid" id="cid" value="<?=$cid?>"/><dl/>
        </dd>
        <dd><a href="javascript:void(0);" onclick="add_new_order()">赠送道具</a></dd>
        <div id="add_item_gift"></div>

    </dl>
    <input type="hidden" name="item_id" value="0"/>
</form>
<? } ?>
<div class="clear"></div>
<a href="javascript:void(0)" class="btn" onclick="give_item('form_item',<?=$item_id?>)">赠送</a>
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