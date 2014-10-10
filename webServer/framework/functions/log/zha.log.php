<?php
function zha_log_bet($room_id,$table_id,$match_id,$uid,$men,$point){
    global $zeit;
    $sql = "INSERT INTO log_zha_bet
            (room_id,table_id,match_id,uid,men,point,zeit)
            VALUES
            ($room_id,$table_id,$match_id,$uid,$men,$point,$zeit)";
    mysql_x_query($sql);
}


function zha_log_open($room_id,$table_id,$match_id,$open){
    $json_open = json_encode($open);
    $sql = "INSERT INTO log_zha_open
            (room_id,table_id,match_id,json_open)
            VALUES
            ($room_id,$table_id,$match_id,'$json_open')";
    mysql_x_query($sql);
    return mysql_insert_id();
}

?>