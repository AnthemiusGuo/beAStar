<?
include_once FR.'functions/club/bet.func.php';
$bets = bet_get_bet_list();
foreach ($bets as $bet_id=>$this_bet){
    if ($this_bet['bet_typ']==1){
        $bets[$bet_id]['detail'] = bet_get_bet_one_by_one($bet_id);
    } elseif ($this_bet['bet_typ']==2){
        $bets[$bet_id]['detail'] = bet_get_bet_score($bet_id);
    }
    
}
?>