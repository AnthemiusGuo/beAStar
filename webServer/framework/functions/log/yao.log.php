<?php
include_once FR.'functions/log/log.func.php';
function yao_log_bet($room_id,$table_id,$match_id,$uid,$men,$point){
    $log_id = floor(($match_id-1377964800)/20)*20+$table_id+$uid;
    log_to_file('yao','bet',$log_id,array($room_id,$table_id,$match_id,$uid,$men,$point));
    return $log_id;
}


function yao_log_open($room_id,$table_id,$match_id,$open){
    global $zeit;
    $log_id = floor(($zeit-1377964800)/20)*20+$table_id;
    log_to_file('yao','open',$log_id,array($room_id,$table_id,$match_id,$open));
    return $log_id;
}

?>