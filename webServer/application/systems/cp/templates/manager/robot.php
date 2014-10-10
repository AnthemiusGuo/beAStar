<table class="table table-bordered table-striped">
    <caption>机器人</caption>
    <thead>
      <tr>
        <th>cid</th>
        <th>俱乐部</th>
        <th>等级</th>
      </tr>
    </thead>
    <tbody>
<?
foreach ($robots as $this_robot){
    $cid = $this_robot['cid'];
    $club_info = club_get_club_info($cid);
?>
<tr>
        <td><?=$cid?></td>
        <td><?=$club_info['club_name']?></td>
        <td><?=$club_info['rating_lev']?></td>
</tr>
<?
}
?>
</tbody>
</table>