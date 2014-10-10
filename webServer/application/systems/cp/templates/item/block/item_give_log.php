<div>
    <dl class="item_info">
		    
        <dd>服务区　　　　赠送标题　　　 　　CID 　　赠送道具 　　日期</dd>
        <? foreach ($give_log_list  as $give_log_id=>$give_log_info) {?>
        <?
			$give_item = json_decode($give_log_info['give_item'],true);
			$str = '';
			foreach ($give_item['gift_typ'] as $key=>$val)
			{
				if($val==-1)
				{
					$str .="足球币:".$give_item['item_num'][$key];
				}else if($val==-2)
				{
					$str .=" 礼券:".$give_item['item_num'][$key];
				}else{
					$item_id = $val;
					$sql = "SELECT * FROM s_item WHERE item_id=$val";
					$ret = mysql_w_query($sql);
					if($row=mysql_fetch_assoc($ret)){
						$str .=" ".$row['item_name'].":".$give_item['item_num'][$key];
					}
				}
			}
        ?>
        <dd>　<?=$give_log_info['give_title']?>　　　 　　<?=$give_log_info['give_cid']?> 　　<?=$str?> 　　<?=date("Y-m-d H:i:s",$give_log_info['zeit'])?> </dd>
        <? } ?>

    </dl>
</div>