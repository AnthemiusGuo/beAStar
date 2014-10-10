<table class="table table-striped">
    <caption>聚合总消耗</caption>
    <thead>
        <tr>
        <th >付费点</th>
        <th >消耗</th>
        <th >(消耗)%</th>
        <th >次数</th>
        <th >(次数)%</th>
        </tr>
    </thead>
    <tbody>

<?
foreach ($total_rss as $this_typ=>$total){
?>
    <tr>
        <?
            if (!isset($config_rss_name[$this_typ])){
                echo "<td>-(".$this_typ.")</td>";
            } else {
                echo "<td>".$config_rss_name[$this_typ]."</td>";
            }
        ?>
            <td>
                <?=$total['total_cost']?>
            </td>
            <td>
                <?=round($total['total_cost']/$sum_all*100,2)?>%
            </td>
            <td>
                <?=$total['count_pay']?>
            </td>
            <td>
                <?=round($total['count_pay']/$count_all*100,2)?>%
            </td>
            
    </tr>
<?
}
?>
</tbody>
</table>

<br/><br/><br/><br/>

<table class="table table-striped">
    <caption>全部付费点总消耗</caption>
    <thead>
        <tr>
        <th >付费点</th>
        <th >消耗</th>
        <th >(消耗)%</th>
        <th >次数</th>
        <th >(次数)%</th>
        </tr>
    </thead>
    <tbody>

<?
foreach ($pay_total as $this_typ=>$total){
?>
    <tr>
        <?
            if (!isset($config_pay_name[$this_typ])){
                echo "<td>-(".$this_typ.")</td>";
            } else {
                echo "<td>".$config_pay_name[$this_typ]."</td>";
            }
        ?>
            <td>
                <?=$total['total_cost']?>
            </td>
            <td>
                <?=round($total['total_cost']/$sum_all*100,2)?>%
            </td>
            <td>
                <?=$total['count_pay']?>
            </td>
            <td>
                <?=round($total['count_pay']/$count_all*100,2)?>%
            </td>
            
    </tr>
<?
}
?>
</tbody>
</table> 