<?
if($item_id!=0){
	?>
<form method="post" id="form_item" action="?sub_sys=cp&m=item&a=gift_voucher&item_id=0&h=1">
    <dl class="item_info">
		    
        <dd>item类型：<select name="item_typ" class="item_select_order_type">
			<option value='3' selected='selected'>验证码礼包</option>
			</select>
			<br/>item名字：<input type="text" name="package_name" id="package_name" value="<?=$item_list[$item_id]['package_name']?>"/> 
        <br/>item有效期：<INPUT onclick="disableOption()" type="radio" CHECKED value="0" name="validity">无有效期 <INPUT onclick="displayOption()" type="radio" value="1" name="validity">
                    有效期至<input type="text" id="calendar1" name="calendar" class="calendarFocus" disabled/>
        <br/>item数量：<input type="text" name="num" id="num" value="" class="card_select_order_type" />
        </dd>
    </dl>
    <input type="hidden" name="item_id" value="<?=$item_id?>"/>
</form>
<? } ?>
<div class="clear"></div>
<a href="javascript:void(0)" class="btn" onclick="create_gift_voucher('form_item',<?=$item_id?>)">生成验证码</a>
<script type="text/javascript">
function disableOption(){
  document.getElementsByName("calendar")[0].disabled = true;
}
function displayOption(){
  document.getElementsByName("calendar")[0].disabled = false;
}
</script>