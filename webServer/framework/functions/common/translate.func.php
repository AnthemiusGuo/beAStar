<?php

#################### 文件到 数据库 数据 #######################

// 导入一种语言资源到数据库
function import_to_db($lang)
{
    // 获取: lang, dir, filename, key, value, 文件扩展名
    $path = FR.'config/text/';
    $path .= $lang."/";

    // 遍历文件和目录
    walk_dir($path);
}

// 遍历一个目录下的所有文件
function walk_dir($path)
{
    global $dir_arr, $lang;
    $handle=opendir($path); //打开目录

    while ($file = readdir($handle)) //取得目录中的文件名
    {
        //如果$file为目录，则不做操作
        if (is_dir($file)) 
        {
            if($file == ".." || $file == "." || $file[0] == '.')
            {
                continue;
            }
            else 
            {
                array_push($dir_arr, $file);
                walk_dir($path."/".$file);
                array_pop($dir_arr);
            }
        }
        else 
        {
            insert_db_per_file($path, $file);
        }
    }
    closedir($handle); //关闭目录
}

function insert_db_per_php_file($path, $file,$file_name,$file_ext){
    global $dir_arr, $lang;
    require($path."/".$file);

    $var_name = "text_".$file_name;
    if(isset($$var_name))
    {
        foreach($$var_name as $key => $value){
            import_per_item($path, $file,$file_name,$file_ext,$key,$value);
        }
    }
}

function insert_db_per_js_file($path, $file,$file_name,$file_ext){
    global $dir_arr, $lang;
    $org_file = fopen($path.'/'.$file,'r');
    if (!$org_file)
    {
        return -1;
    }
    while (!feof($org_file))
    {
        $this_line=trim(fgets($org_file));
        if ($this_line==''){
            continue;
        }
        if (preg_match('/^var\s+(\w+)\s*\=\s*\'(\S+)\'\s*\;$/i',$this_line,$key_values)){
            $vars[$key_values[1]]=$key_values[2];    
        }   
    }
    foreach($vars as $key => $value)
    {
        import_per_item($path, $file,$file_name,$file_ext,$key,$value);
    }
}

function import_per_item($path, $file,$file_name,$file_ext,$key,$value){
    global $lang;
    global $g_supply_lang;
    if ($lang=='cn'){
        //看是否存在这个Key
        $sql = "SELECT i.t_value,k.id as key_id,i.id as value_id
            FROM `trans_file_key` k
                LEFT JOIN `trans_item` i ON i.`t_key_id` = k.`id` AND i.`lang`='cn'
            WHERE `filename`='$file_name' AND `filetyp`='$file_ext' AND `t_key`='$key'";
        $rst = mysql_x_query($sql);
        if ($row = mysql_fetch_array($rst)){
            //KEY存在，比对VALUE是否更新
            if ($row['t_value'] == $value){
                return;
            }
            else{
                $key_id = $row['key_id'];
                $value_id = $row['value_id'];
                //更新了，更新LANG＝CN的T_VALUE,and update all lang!=cn ,set flag=1
                $sql = "UPDATE trans_item
                        SET `t_value`='$value',`flag`=2
                        WHERE id=$value_id";
                mysql_w_query($sql);
                $sql = "UPDATE trans_item
                        SET `flag`=1
                        WHERE lang!='cn' AND `t_key_id`=$key_id";
                mysql_w_query($sql);
            }
        }
        else{
            //insert the key
            //insert the value of lang=cn
            //insert the value of lang!=cn with flag=0 and value=null
            $sql = "INSERT INTO trans_file_key
                    (`dir`,`filename`,`filetyp`,`t_key`)
                    VALUES
                    ('','$file_name','$file_ext','$key')";
            mysql_w_query($sql);
            $key_id = mysql_insert_id();
            
            $sql = "INSERT INTO trans_item
            (`lang`,`t_key_id`,`t_value`,`flag`)
            VALUES
            ";
            $sql_plus[] = "('cn','$key_id','$value','2')";
            foreach ($g_supply_lang as $this_lang){
                if ($this_lang=='cn'){
                    continue;
                }
                $sql_plus[] = "('$this_lang','$key_id','','0')";
            }
            if (count($sql_plus)>0){
                $sql = $sql.join(',',$sql_plus);              
            }
            mysql_w_query($sql);
        }
    }
    else{
        //lang!=cn not allow insert new key
        //read key table
        $sql = "SELECT i.t_value,k.id as key_id,i.id as value_id
            FROM `trans_file_key` k
                LEFT JOIN `trans_item` i ON i.`t_key_id` = k.`id` AND i.`lang`='$lang'
            WHERE `filename`='$file_name' AND `filetyp`='$file_ext' AND `t_key`='$key'";
        $rst = mysql_x_query($sql);
        if ($row = mysql_fetch_array($rst)){
            //KEY存在，比对VALUE是否更新
            if ($row['t_value'] == $value){
                return;
            }
            else{
                $key_id = $row['key_id'];
                $value_id = $row['value_id'];
                //更新了，更新LANG＝$lang的T_VALUE,and update lang=$lang with flag=1
                $sql = "UPDATE trans_item
                        SET `flag`=1,`t_value`='$value'
                        WHERE id = $value_id";
                mysql_w_query($sql);
            }
        }
        else{
            return;
        }
    }
}

function _insert_db_per_php_file($path, $file,$file_name,$file_ext){
    global $dir_arr, $lang;
    require($path."/".$file);

    $var_name = "text_".$file_name;
    if(isset($$var_name))
    {
        $sql_max = 50;
        $sql_i = $sql_max;
        $sql_head = "\nINSERT INTO g_translate(id, lang, file_typ, dir, file_name, t_key, t_value, modify_zeit) VALUES \n";
        $sql_body = '';
        foreach($$var_name as $key => $value)
        {
            $sql_body .= " (NULL, '$lang', '$file_ext', '".join($dir_arr, "/")."', '$file_name', '$key', '$value', '".time()."'),";            
            // echo $lang.":".join($dir_arr, "/").":".$file_name.":".$key .":".$value.":".$file_ext.":"."\n";
            if( --$sql_i==0 )	//do something
    		{	
                $sql_body = preg_replace("/,$/","",$sql_body);                
                mysql_x_query($sql_head.$sql_body);
                //echo $sql_head.$sql_body ;
    			$sql_i = $sql_max;
    			$sql_body = '';
    		}            
        }
    	if( $sql_i>0 )
    	{	
                $sql_body = preg_replace("/,$/","",$sql_body);
                mysql_x_query($sql_head.$sql_body);
                //echo $sql_head.$sql_body ;
    	}         
    }
    $sql_head = "\nINSERT INTO g_translate(id, lang, file_typ, dir, file_name, modify_zeit) VALUES \n";
    $sql_body = " (NULL, '$lang', '$file_ext', '".join($dir_arr, "/")."', '$file_name', '".time()."')";                
    mysql_x_query($sql_head.$sql_body);   
}
function _insert_db_per_js_file($path, $file,$file_name,$file_ext){
    global $dir_arr, $lang;
    $org_file = fopen($path.'/'.$file,'r');
    if (!$org_file)
    {
        return -1;
    }
    while (!feof($org_file))
    {
        $this_line=trim(fgets($org_file));
        if ($this_line==''){
            continue;
        }
        if (preg_match('/^var\s+(\w+)\s*\=\s*\'(\S+)\'\s*\;$/i',$this_line,$key_values)){
            $vars[$key_values[1]]=$key_values[2];    
        }   
    }
    $sql_head = "INSERT INTO g_translate(id, lang, file_typ, dir, file_name, t_key, t_value, modify_zeit) VALUES \n";
    $sql_body = '';
    foreach($vars as $key => $value)
    {
        $sql_body .= " (NULL, '$lang', '$file_ext', '".join($dir_arr, "/")."', '$file_name', '$key', '$value', '".time()."'),";            
    }
    $sql_body = preg_replace("/,$/","",$sql_body);
    mysql_x_query($sql_head.$sql_body);     
}


// 把一个文件的资源导入数据库
function insert_db_per_file($path, $file)
{
    global $dir_arr, $lang;
    // 取文件名, 找到对应的 变量名称, 和文件的扩展名
    // 遍历变量内的 键 和 值, 写入数据库
    $file_info = explode(".",$file); //分割字符串
    $file_name = $file_info[0];
    $file_ext = $file_info[1];
    if ($file_ext=='php'){
        insert_db_per_php_file($path,$file,$file_name,$file_ext);
    } elseif ($file_ext=='js'){
        insert_db_per_js_file($path,$file,$file_name,$file_ext);
    }
     
}

function clear_db_by_lang($lang)
{
    $sql = "DELETE 
            FROM g_translate
            WHERE lang = '$lang'";
    $rst = mysql_x_query($sql);
    return ;
}


#################### 数据库数据 到 文件 #######################

// 生成目录和文件
function gen_dir_file($curr_path, $dir, $lang)
{
    if(!empty($dir))
    {
        if($dir_handle = @opendir($curr_path.$dir))
        {
            closedir($dir_handle);
        }
        else 
        {
            mkdir ($curr_path.$dir);
        }
    }

    $sql = "SELECT DISTINCT(filename), filetyp 
            FROM trans_file_key
            WHERE dir = '$dir'";
    $rst = mysql_x_query($sql);
    
    while ($row = mysql_fetch_assoc($rst)) 
    {
    	gen_file($curr_path.$dir, $dir, $lang, $row['filename'], $row['filetyp']);
    }
}

// 生成文件
function gen_file($path, $dir, $lang, $file_name, $file_ext)
{

    if($file_handle = @fopen($path."/".$file_name.".".$file_ext, 'r'))
    {
        null;
    }
    else 
    {
        $file_handle = fopen($path."/".$file_name.".".$file_ext, 'w');
    }

    $sql = "SELECT k.`t_key`, i.`t_value`
            FROM trans_file_key k
                LEFT JOIN `trans_item` i ON i.`t_key_id` = k.`id` AND i.`lang`='$lang'
            WHERE k.`dir` = '$dir'
                AND k.`filename` = '$file_name'
                AND k.`filetyp` = '$file_ext'";
    $rst = mysql_x_query($sql);
    if ($file_ext=='php'){
        fwrite($file_handle, "<?php\n\n");
        while ($row = mysql_fetch_assoc($rst))
        {
            if ($row['t_key']!=''){
                insert_date_to_file($file_name, $file_handle, $row);
            }
        }
        fwrite($file_handle, "\n\n?>");
    } elseif ($file_ext=='js')
    {
        while ($row = mysql_fetch_assoc($rst)) 
        {
            if ($row['t_key']!=''){
                fwrite($file_handle,"var {$row['t_key']} = '{$row['t_value']}'\n");
            }
        }
    }
    
    fclose($file_handle);
    
}

// 灌入数据到文件
function insert_date_to_file($file_name, $file_handle, $row)
{
    fwrite($file_handle, "\$text_{$file_name}['{$row['t_key']}'] = '{$row['t_value']}';\n");
    return ;
}

?>