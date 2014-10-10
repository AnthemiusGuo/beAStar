<table class="table table-striped">
    <caption>基本数据</caption>
    <thead>
        <tr>
            <th  width="8%">
                五分钟在线
            </th>
            <th  width="8%">
                一小时在线
            </th>
            <th  width="8%">
                今日活跃
            </th>
            <th  width="8%">
                今日注册
            </th>
            <th  width="8%">
                今日去新活跃
            </th>
            <th  width="8%">
                完成新手任务
            </th>
            <th  width="8%">
                总注册
            </th>
            <th  width="8%">
                已删除用户
            </th>
            <th  width="8%">
                进行比赛
            </th>
            <th  width="8%">
                充值总额
            </th>
            <th  width="8%">
                今日充值总额
            </th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>
               <?=$base_info['5m_online'];?>
            </td>
            <td>
                <?=$base_info['1h_online'];?>
            </td>
            <td>
                <?=$base_info['1d_active'];?>
            </td>
            <td>
                <?=$base_info['1d_reg'];?>
            </td>
            <td>
                <?=$base_info['1d_active']-$base_info['1d_reg'];?>
            </td>
            <td>
                <?=$base_info['finish_newbie'];?>
            </td>
            <td>
                <?=$base_info['total_reg'];?>
            </td>
            <td>
                <?=$base_info['total_del'];?>
            </td>
            <td>
                <?=$base_info['now_match'];?>
            </td>
            <td>
                <?=common_format_incoming($base_info['total_pay']);?>
            </td>
            <td>
                <?=common_format_incoming($base_info['today_pay']);?>
            </td>
        </tr>
    </tbody>
</table>