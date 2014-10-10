<?
function _file_cache_get_cache($key){
    $file_name = FR.'config/cache/'.$key.'.cache.php';
    if (!file_exists($file_name)){
        return array('rst'=>-1);
    } else {
        include $file_name;
        //TODO 过期逻辑
        return array('rst'=>1,'data'=>$file_cache['data']);
    }
}

function _file_cache_gen_cache($key,$data){
    $write_data = "<?php\r\n\$file_cache['data']= ";
    $write_data .= var_export($data,true);
    $write_data .=";\r\n?>";
    $file_name = FR.'config/cache/'.$key.'.cache.php';
    _cache_write($file_name,$write_data);
}

function _cache_write($file_name, $write_data, $openmod='w'){
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
?>