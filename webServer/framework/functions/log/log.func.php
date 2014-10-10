<?php
function log_to_file($game,$log_title,$log_id,$log_info){
    global $g_sunrise,$zeit;
    $openmod='w';
    
    $file_name = FR.'logs/'.$game.'/'.$log_title.'.'.$g_sunrise.'.log';
    $write_data = $log_id."|".$zeit."|".json_encode($log_info);
    if(@$fp = fopen($file_name, $openmod)) {
        flock($fp, 2);
        fwrite($fp, $write_data);
        fclose($fp);
        return true;
    } else {
        echo "File: $file_name write error.";
        return false;
    }
}