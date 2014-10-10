<?
include_once FR.'functions/player/player.func.php';
$uid = $_GET['user_uid'];
$ext = user_get_user_extend($uid);
$load_news_count = $ext['load_news_count'];
$player_team_list = player_get_team_player_list($uid);
foreach($player_team_list as $this_pid=>$this_players){
        $this_players->player_info['cond']=100;
        $this_players->player_info['inj']=0;
        $this_players->player_info['cond_recover_week_day'] = $load_news_count;
        $this_players->writeback_player_info();

}
?>