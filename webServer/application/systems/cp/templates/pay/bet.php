<table class="table table-bordered table-striped">
    <caption>押注收入及开奖支出</caption>
    <thead>
      <tr>
        <th>id</th>
        <th>场次</th>
        <th>礼券</th>
        <th>点券</th>
        <th>发奖奖金-礼券</th>
        <th>发奖奖金-点券</th>
        <th>利润-礼券</th>
        <th>利润-点券</th>
      </tr>
    </thead>
    <tbody>
    <?
    foreach ($bet_list as $this_bet){
    ?>
    <tr>
        <td><?=$this_bet['bet_id']?></td>
        <td><?=$this_bet['title']?></td>
        <td><?=$bet_credits[$this_bet['bet_id']][1]?></td>
        <td><?=$bet_credits[$this_bet['bet_id']][2]?></td>
        <td><?=$revenue_creadits[$this_bet['bet_id']][1]?></td>
        <td><?=$revenue_creadits[$this_bet['bet_id']][2]?></td>
        <td><?=$bet_credits[$this_bet['bet_id']][1] - $revenue_creadits[$this_bet['bet_id']][1]?></td>
        <td><?=$bet_credits[$this_bet['bet_id']][2] - $revenue_creadits[$this_bet['bet_id']][2]?></td>
    </tr>
    <?
    }
    ?>
    <tr>
        <td>x</td>
        <td>总计</td>
        <td><?=$sum_bet_credits[1]?></td>
        <td><?=$sum_bet_credits[2]?></td>
        <td><?=$sum_revenue_credits[1]?></td>
        <td><?=$sum_revenue_credits[2]?></td>
        <td><?=$sum_bet_credits[1] - $sum_revenue_credits[1]?></td>
        <td><?=$sum_bet_credits[2] - $sum_revenue_credits[2]?></td>
    </tr>
    </tbody>
</table>