<div>
    筛选条件：
    <div class="btn-group">
    <button class="btn btn-mini"><?=$lt/10?></button>
    <button class="btn btn-mini dropdown-toggle" data-toggle="dropdown">
      <span class="caret"></span>
    </button>
    <ul class="dropdown-menu">
        <li onclick="goto_page('pay','high','lt=100');">100</li>
        <li onclick="goto_page('pay','high','lt=500');">500</li>
        <li onclick="goto_page('pay','high','lt=1000');">1000</li>
    </ul>
</div>
</div>
<table class="table table-bordered">
    <caption>高付费列表</caption>
    <thead>
      <tr>
        <th>经理名</th>
        <th>俱乐部名</th>
        <th>uid</th>
        <th>充值金额</th>
        <th>余额点券</th>
        <th>最近登录</th>
      </tr>
    </thead>
    <tbody>
    <?
    foreach ($high_players as $this_high){
    ?>
    <tr>
        <td><?=$this_high['manager_name']?></td>
        <td><?=$this_high['club_name']?></td>
        <td><?=$this_high['cid']?></td>
        <td><?=common_format_incoming($this_high['total_pay'])?>元</td>
        <td><?=$this_high['real_credits']?>点券</td>
        <td><?=date('m-d H',$this_high['last_online'])?></td>
    </tr>
    <?
    }
    ?>
    </tbody>
</table>