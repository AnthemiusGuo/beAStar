<table class="table table-bordered">
    <caption>礼包名:<?=$item_list[$gift_voucher_info['package_id']]['package_name']?></caption>
    <thead>
        <tr>
            <th>ID</th>
            <th>验证码</th>
            <th>状态(>0已领取人的uid)</th>
            <th>领取日期</th>
            <th>有效日期</th>
            <th>类型(2：媒体包，1:全服，0:普通)</th>
        </tr>
    </thead>
    <tbody>
    <? foreach ($gift_voucher_list  as $voucher_id=>$gift_voucher_info) {?>
        <tr>
            <td><?=$voucher_id?></td>
            <td><?=$gift_voucher_info['verify_num']?></td>
            <td><?=$gift_voucher_info['voucher_status']?></td>
            <td><?=date("Y-m-d H:i:s",$gift_voucher_info['get_zeit'])?></td>
            <td><?=date("Y-m-d H:i:s",$gift_voucher_info['zeit'])?></td>
            <td><?=$gift_voucher_info['voucher_typ']?></td>
        </tr>
    <? } ?>
  </tbody>
</table>