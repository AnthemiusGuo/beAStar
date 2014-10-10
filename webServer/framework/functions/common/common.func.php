<?php
/*
*  base.func.php
*  basic function for framework 框架通用基础函数
*  need rewrite every function for your project
*  Guo Jia(Anthemius, NJ.weihang@gmail.com)
*
*  Created by Guo Jia on 2008-3-12.
*  Copyright 2008-2012 Guo Jia All rights reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
// 用CURL 请求远端接口

function call_remote_by_curl($url_str)
{
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url_str ); 
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    $remote_result = curl_exec($ch);

    if (curl_errno($ch)) {
        $remote_result = 0;
    }
    curl_close($ch);

    return $remote_result;
}

function call_remote_by_curl_post($url_str,$post_data)
{
    $ch = curl_init();
    if ( is_string($post_data) ){
        $curlPosts = $post_data;
    } else {
        $curlPost = array();
        foreach ($post_data as $key => $value) {
            $curlPost[] = $key.'='  . urlencode($value);
        }
        $curlPosts = implode('&', $curlPost);
    }
    curl_setopt($ch, CURLOPT_URL, $url_str ); 
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
    
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $curlPosts);

    $remote_result = curl_exec($ch);
    if (curl_errno($ch)) {
        $remote_result = 0;
        // var_dump(curl_error($ch));
    }
    curl_close($ch);

    return $remote_result;
}

function get_user_ip(){
		$onlineip = '';
    if(getenv('HTTP_CLIENT_IP') && strcasecmp(getenv('HTTP_CLIENT_IP'), 'unknown')) {
        $onlineip = getenv('HTTP_CLIENT_IP');
    } elseif(getenv('HTTP_X_FORWARDED_FOR') && strcasecmp(getenv('HTTP_X_FORWARDED_FOR'), 'unknown')) {
        $onlineip = getenv('HTTP_X_FORWARDED_FOR');
    } elseif(getenv('REMOTE_ADDR') && strcasecmp(getenv('REMOTE_ADDR'), 'unknown')) {
        $onlineip = getenv('REMOTE_ADDR');
    } elseif(isset($_SERVER['REMOTE_ADDR']) && $_SERVER['REMOTE_ADDR'] && strcasecmp($_SERVER['REMOTE_ADDR'], 'unknown')) {
        $onlineip = $_SERVER['REMOTE_ADDR'];
    }

    preg_match("/[\d\.]{7,15}/", $onlineip, $onlineipmatches);
    $onlineip = $onlineipmatches[0] ? $onlineipmatches[0] : 'unknown';
	$ipx = explode(".", $onlineip);
	for($i=0;$i<=3;$i++)
	{
		if( !isset( $ipx[$i] ) )
		{
			$ipx[$i] = 0;
		}
	}
	$ipx[4] = $ipx[0]*pow(255,3)+$ipx[1]*pow(255,2)+$ipx[2]*255+$ipx[3];
	return $ipx;
}

function _cmp_ip_addr($a,$b){
    if ($a['scare']>$a['scare']){
	return -1;
    } else if ($a['scare']<$a['scare']){
	return -1;
    } else {
	return 0;
    }
}

function common_get_ip_addr($ip){
    $sql = "SELECT * FROM  `s_ip` 
	    WHERE  `ip_from` <=$ip
	    AND  `ip_to` >=$ip";
    $rst = mysql_x_query($sql);
    $addr = array();
    while ($row = mysql_fetch_assoc($rst)){
	$addr[] = $row;
    }
    uasort($addr,'_cmp_ip_addr');
    if (count($addr)==0){
	return '';
    } else {
	return $addr[0]['ip_info'];
    }
}

//检查输入是否完备
//$val_input = check_input(array('aid','iid','uid'),'POST');
//if ($val_input!='') {
//$return_url = XXXXX
//如果有缺失，返回缺失的参数；如果没有缺失，返回''空字符串
function check_input($arr,$input_typ='GET') {
    if ($input_typ=='GET') {
        foreach ($arr as $this_value) {
            if ($this_value=='') {
                    continue;
            }
            if (!isset($_GET[$this_value])) {
                    return $this_value;
            }
        }	
    } else {
        foreach ($arr as $this_value) {
            if ($this_value=='') {
                    continue;
            }
            if (!isset($_POST[$this_value])) {
                    return $this_value;
            }
        }
    }
    return '';
}

//对于出错返回，构建返回url串
//出错处理方法
//handler返回后，刷新页面，
//页面判断$callback,如果有callback，则调用callback函数，参数是$rst_typ和$ext_rst
//callback函数负责回到刚才的页面并且输出错误信息。
//这样，即使页面url不变继续点击ajax进行操作，不会再次触发callback函数，不会再次显示出错信息，除非这时候强制刷新页面。

//总的来说，大部分输入校验进行js/AJAX，基本上不可能出现错误，出现错误一般都是伪造数据包，因此可能性极小。
//因此不需要针对每个详细的输出做过多的输出提示。
function build_return_url($rst_typ,$ext_rst,$callback='',$url=''){
    $base_str="rst=$rst_typ";
    if ($ext_rst!='') {
        $base_str .="&ext_rst=$ext_rst";
    }
	if ($callback!='') {
        $callback .="&callback=$callback";
    }
	if ($url!='') {
		
	}	
	elseif (isset($_SERVER['HTTP_REFERER'])) {
		$url = $_SERVER['HTTP_REFERER'];	
	} else {
		$url = 'index.php';
	}
	
	$url = preg_replace('/rst=\w*/', '', $url);
	$url = preg_replace('/ext_rst=\w*/', '', $url);
	$url = preg_replace('/callback=\w*/', '', $url);
	
    if(preg_match('/\?/',$url))
	{
		if(!preg_match('/[?&]$/',$url))
		{
			$return_url = $url."&".$base_str;
		}
		else
		{
			$return_url = $url.$base_str;
		}
	}
	else
	{
		$return_url = $url."?".$base_str;
	}
	return $return_url;
}

function getmicrotime(){
    list($usec, $sec) = explode(" ",microtime());
    return intval((float)$usec + (float)$sec);
}

//$typ=1 月-日 时分秒，$typ=2 时分秒
function common_format_datetime($time,$typ){
    if ($typ==1) {
        $format = 'm-d H:i:s';
    } elseif ($typ==2){
        $format = 'H:i:s';
    } else {
        $format = 'y-m-d H:i:s';
    }
    return date($format,$time);
}
//格式化时间，不带天的
function common_format_time($atime){
    $H = intval($atime /3600);
    $M = intval(($atime%3600)/60);
    $S = $atime%60;
    
    if ($H<10){$H = '0'.$H;}else{$H = $H;}
    if ($M<10){$M = '0'.$M;}else{$M = $M;}
    if ($S<10){$S = '0'.$S;}else{$S = $S;}
    $atimeTime = $H.':'.$M.':'.$S;
    return $atimeTime;
}

//格式化倒计时需要的时间，带天的
/*function format_need_time($atime){
    $H = intval(($atime)/3600);
    $M = intval(($atime%3600)/60);
    $S = $atime%60;
    if ($H<10){$H = '0'.$H;}else{$H = $H;}
    if ($M<10){$M = '0'.$M;}else{$M = $M;}
    if ($S<10){$S = '0'.$S;}else{$S = $S;}
    $atimeTime = $H.':'.$M.':'.$S;
    return $atimeTime;
}*/



/**
 *
 *
 * Return part of a string(Enhance the function substr())
 *
 * @param string  $String  the string to cut.
 * @param int     $Length  the length of returned string.
 * @param booble  $append  whether append "...": false|true
 * @return string           the cutted string.
 */
function sysSubStr($str,$len,$append = false)
{
	$len = ceil($len / 3);
	$chars = $str;
	$len_org = mb_strlen($str);
    $i=$m=$n=0;
    do{
		if (!isset($chars[$i])){
			break;
		}
        if (preg_match ("/[0-9a-zA-Z]/", $chars[$i])){//纯英文   
            $m++;   
		}   
		else
		{
			$n++;
		}//非英文字节,   
        $k = $n/3+$m/2;   
        $l = $n/3+$m;//最终截取长度；$l = $n/3+$m*2？
		if ($l>=$len_org){
			break;
		}
        $i++;   
    } while($k < $len);
	
	if ($l<$len){
		return $str;
	} else {
        if($append)
        {
			$l = $l - 1;
			$str = mb_substr($str,0,$l,'utf-8');
            $str .= "..";
        } else {
			$str = mb_substr($str,0,$l,'utf-8');
		}
        return $str;
	}
} 


/*
* support UTF-8 only,
* ** the function return HTML Format string **
*/
function html_escape_insert_wbrs($str, $n=10,
         $chars_to_break_after='',$chars_to_break_before='')
{
    $out = '';
    $strpos = 0;
    $spc = 0;
    $len = mb_strlen($str,'UTF-8');
    for ($i = 1; $i < $len; ++$i) {
      $prev_char = mb_substr($str,$i-1,1,'UTF-8');
      $next_char = mb_substr($str,$i,1,'UTF-8');
      if (_u_IsSpace($next_char)) {
        $spc = $i;
      } else {
        if ($i - $spc == $n
         || mb_strpos( $chars_to_break_after,
            $prev_char,0,'UTF-8' ) !== FALSE
         || mb_strpos( $chars_to_break_before,
            $next_char,0,'UTF-8')  !== FALSE )
          {
            $out .= htmlspecialchars(
                mb_substr($str,$strpos, $i-$strpos,'UTF-8')
                       ) . '<wbr>';
            $strpos = $i;
            $spc = $i;
          }
      }
    }
    $out .= htmlspecialchars(
             mb_substr($str,$strpos,$len-$strpos,'UTF-8')
               );
    return $out;
}
/////
function _u_IsSpace($ch)
{
  return mb_strpos("\t\r\n",$ch,0,'UTF-8') !== FALSE;
}

// 返回给定时间戳 time 的月份中, 第 nth 个 week 的 起始时戳
function get_saturday_in_month($time , $week, $nth=1)
{
    if( $week == 7) $week = 0;
    $date_array = getdate($time);
    $f_t = ($time - $time%86400) - 86400*($date_array['mday']-1);   // 月份第一天
    $last_t = date('t', $f_t);  // 此月的天数
    
    $w = getdate($f_t);
    $wday = $w['wday'];
    $w_array = array();
    for( $i=1 ; $i<=$last_t ; $i++ )
    {
        if( $wday++ == $week )
        {
            $w_array[] = $i;
        }

        if($wday == 7)
        {
            $wday = 0;
        }
    }
    $day = isset($w_array[$nth-1])?$w_array[$nth-1]:null;
    $day_stamp = 0;
    if($day)
    {
        $day_stamp = $f_t + ($day-1)*86400;
    }
    return $day_stamp;
}


function base_prepare() {
    date_default_timezone_set('Etc/GMT-8');
}

 

//格式化倒计时需要的时间，带天的
function format_need_time($atime){
    $H = intval(($atime)/3600);
    $M = intval(($atime%3600)/60);
    $S = $atime%60;
    if ($H<10){$H = '0'.$H;}else{$H = $H;}
    if ($M<10){$M = '0'.$M;}else{$M = $M;}
    if ($S<10){$S = '0'.$S;}else{$S = $S;}
    $atimeTime = $H.':'.$M.':'.$S;
    return $atimeTime;
}

//
function format_date_time($time,$typ){
    if ($typ==1){
        //2009-12-12 00:00:00
        return date('Y-m-d H:i:s',$time);
    } elseif ($typ == 2){
        return date('m-d H:i:s',$time);	
    } elseif ($typ == 3)
    {
        return date('H:i:s',$time);
    }
	//2 12-12 00:00:00
	//3 00:00:00
}

//转换数字到二进制字符串，length是补齐后的长度
function convert_decbin($number,$length){
    $bin_num = decbin($number);
    while(strlen($bin_num)<$length){
        $bin_num = "0".$bin_num;
    }
    return $bin_num;
}



function RGB_TO_HSV ($R, $G, $B)  // RGB Values:Number 0-255 
{                                 // HSV Results:Number 0-1 
   $HSL = array(); 

   $var_R = ($R / 255); 
   $var_G = ($G / 255); 
   $var_B = ($B / 255); 

   $var_Min = min($var_R, $var_G, $var_B); 
   $var_Max = max($var_R, $var_G, $var_B); 
   $del_Max = $var_Max - $var_Min; 

   $V = $var_Max; 

   if ($del_Max == 0) 
   { 
      $H = 0; 
      $S = 0; 
   } 
   else 
   { 
      $S = $del_Max / $var_Max; 

      $del_R = ( ( ( $var_Max - $var_R ) / 6 ) + ( $del_Max / 2 ) ) / $del_Max; 
      $del_G = ( ( ( $var_Max - $var_G ) / 6 ) + ( $del_Max / 2 ) ) / $del_Max; 
      $del_B = ( ( ( $var_Max - $var_B ) / 6 ) + ( $del_Max / 2 ) ) / $del_Max; 

      if      ($var_R == $var_Max) $H = $del_B - $del_G; 
      else if ($var_G == $var_Max) $H = ( 1 / 3 ) + $del_R - $del_B; 
      else if ($var_B == $var_Max) $H = ( 2 / 3 ) + $del_G - $del_R; 

      if ($H<0) $H++; 
      if ($H>1) $H--; 
   } 

   $HSL['H'] = $H; 
   $HSL['S'] = $S; 
   $HSL['V'] = $V; 

   return $HSL; 
} 

function HSV_TO_RGB ($H, $S, $V)  // HSV Values:Number 0-1 
{                                 // RGB Results:Number 0-255 
    $RGB = array(); 

    if($S == 0) 
    { 
        $R = $G = $B = $V * 255; 
    } 
    else 
    { 
        $var_H = $H * 6; 
        $var_i = floor( $var_H ); 
        $var_1 = $V * ( 1 - $S ); 
        $var_2 = $V * ( 1 - $S * ( $var_H - $var_i ) ); 
        $var_3 = $V * ( 1 - $S * (1 - ( $var_H - $var_i ) ) ); 

        if       ($var_i == 0) { $var_R = $V     ; $var_G = $var_3  ; $var_B = $var_1 ; } 
        else if  ($var_i == 1) { $var_R = $var_2 ; $var_G = $V      ; $var_B = $var_1 ; } 
        else if  ($var_i == 2) { $var_R = $var_1 ; $var_G = $V      ; $var_B = $var_3 ; } 
        else if  ($var_i == 3) { $var_R = $var_1 ; $var_G = $var_2  ; $var_B = $V     ; } 
        else if  ($var_i == 4) { $var_R = $var_3 ; $var_G = $var_1  ; $var_B = $V     ; } 
        else                   { $var_R = $V     ; $var_G = $var_1  ; $var_B = $var_2 ; } 

        $R = $var_R * 255; 
        $G = $var_G * 255; 
        $B = $var_B * 255; 
    } 

    $RGB['R'] = $R; 
    $RGB['G'] = $G; 
    $RGB['B'] = $B; 

    return $RGB; 
}
function common_get_user_browser() 
{ 
    $u_agent = $_SERVER['HTTP_USER_AGENT'];
    $rst['browser'] = '';
    $rst['version'] = '';
    $rst['special'] = '';
    if (strpos($u_agent,'QQ')!==false) {
        $rst['special'] = 'QQ';
    } elseif (strpos($u_agent,'360SE')!==false){
        $rst['special'] = '360SE';
    }
    if(preg_match('/MSIE/i',$u_agent)) 
    { 
        $rst['browser'] = "MSIE";
	$match=preg_match('/MSIE ([0-9]\.[0-9])/',$u_agent,$reg);
	if($match==0)
	    $rst['version'] =  -1;
	else
	    $rst['version'] = floatval($reg[1]);
    } 
    elseif(preg_match('/Firefox/i',$u_agent)) 
    { 
        $rst['browser'] = "firefox"; 
    }
    elseif(preg_match('/Chrome/i',$u_agent)) 
    { 
        $rst['browser'] = "chrome"; 
    } 
    elseif(preg_match('/Safari/i',$u_agent)) 
    { 
        $rst['browser'] = "safari"; 
    } 
    elseif(preg_match('/Opera/i',$u_agent)) 
    { 
        $rst['browser'] = "opera"; 
    } 
    return $rst; 
} 
function common_get_IE_fix_png_style($img_src,$width,$height,$special=''){
    global $browser;
    if ($browser['browser']=='MSIE' && $browser['version']<7){
	return '<span style="filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='.$img_src.', sizingMethod=\'scale\');width='.$width.'px;height='.$height.'px;display:block;" '.$special.'></span>';
    } else {
	return '<img src="'.$img_src.'" width="'.$width.'px" height="'.$height.'px" '.$special.'/>';	
    }
}

function common_add_zero_left($src,$length){
    while(strlen($src)<$length){
        $src = "0".$src;
    }
    return $src;
}
function common_get_zipd_number($src){
    
    $src = (int)$src;
    if ($src < 0 ){
        $pre = '-';
        $src = abs($src);
    } else {
        $pre = '';
    }
    if($src<10000){
		return $pre.$src;
	}
    if($src<100000000){
		$rst = (round($src/10000,2)).'万';
		return $pre.$rst;
	}else{
		$rst = (round($src/100000000,2)).'亿';
		return $pre.$rst;
	}
}

//module=模块，当module=common时走通用的错误,$err_no对于hack型错误一律返回-100以后，不需要写出错提示
function common_set_json_rst($module,$err_no,$replace_arr = '',$replace_by_arr = ''){
    global $json_rst,$text_handler_text;
    if (isset($text_handler_text[$module][$err_no])){
	if ($replace_arr!=''){
	    $json_rst['error'] = str_replace($replace_arr,$replace_by_arr,$text_handler_text[$module][$err_no]);
	} else {
	    $json_rst['error'] = $text_handler_text[$module][$err_no];
	}
	
    } else {
	if ($err_no>0){
	    $json_rst['error'] = $text_handler_text['succ'];
	} else {
	    $json_rst['error'] = $text_handler_text['err'];
	}
	
    }
    $json_rst['err_module'] = $module;
    $json_rst['rstno'] = $err_no;
}

//特殊字屏蔽
function special_word_replace($str){
   return reg_special_word_return($str);
//	global $snda_word_list;
//    $snda_bad_word = array();
//	foreach($snda_word_list as $i=>$this_word_list){
//        //$snda_bad_word = $snda_bad_word+$this_word_list;
//        $snda_bad_word = array_merge($snda_bad_word, $this_word_list);  
//	}
//   
//    uasort($snda_bad_word, "my_sort_word_length");
//    //var_dump($snda_bad_word);
//    foreach($snda_bad_word as $str_replace){
//        $str_replace_to = '***'; 
//		$str = str_ireplace($str_replace,$str_replace_to,$str);
//    } 
//	return $str;
}
function my_sort_word_length($a,$b){
    return strlen($b)-strlen($a);
}
//reg特殊字屏蔽
function reg_special_word_return($str){
    include_once FR.'config/define/bad_word.config.php';
    $bad_word_list = get_barword_list();	
    foreach($bad_word_list as $s){
        if(preg_match('/'.implode('|',$s).'/i',$str,$matches)>0){ 
            return true;
        }
    }
    return false;	  
}
function get_length( $str )
{
	$len = 0;
	$str_length = strlen( $str );
	for( $i = 0 ; $i < $str_length ; $i++ )
	{
		if( intval( bin2hex( $str[$i] ) , 16 ) < 0x80 )
		{
			$len++;
		}
		else 
		{
			$len += 2;
			$i += 2;
		}
	}
	return $len;
}

/**
 * 格式化CM$ 只保留一个小数点
 */
function common_remain_one_decimal($str){
    $preg = '/^([\d]+[\.]?[\d]?)[\d]*([\D]+)$/';
    $str = preg_replace($preg, '\1\2', $str);
    return $str;
}

//
function common_trans_xy_from_latlng($lat,$lng,$max_x,$max_y,$pos_x = 0,$pos_y=0){
    /*Spherical Mercator*/
    $x = ($max_x * (180 + $lng) / 360) % $max_x;
    // latitude: using the Mercator projection
    $radlat = $lat * pi() / 180;  // convert from degrees to radians
    $y = log(tan(($radlat/2) + (pi()/4)));  // do the Mercator projection (w/ equator of 2pi units)
    $y = ($max_y / 2) - ($max_x * $y / (2 * pi()));   // fit it to our map
    return array('x'=>$x+$pos_x,'y'=>$y+$pos_y);
}

function common_trans_xy_from_latlng_by_equirectangular($lat,$lng,$max_x,$max_y,$pos_x = 0,$pos_y=0){
    /*equirectangular*/
    $x = round((($lng + 180)*($max_x / 360))+$pos_x);
    $y = round(((($lat * -1)+90)*($max_y / 180))+$pos_y);
    return array('x'=>$x,'y'=>$y);
}
/**
 * @Author:tanghaihua
 * @param: page 当前 页的id
 * @param:page_count 总页数
 * example:transfer_search_content.php
 */
function common_page_list($page,$page_count){
    $page_list = array();
    if($page_count <= 7){
		for ($i = 1; $i <= $page_count; $i++){
			$page_list[] = $i;
		}
    }else{
        $page_other = $page_count-4;
        if($page <= 4){
            $page_list = array(1,2,3,4,5,6,'...',$page_count);
        }else if($page>4 && $page<$page_other){
            $page_list = array(1,'...',$page-2,$page-1,$page,$page+1,$page+2,'...',$page_count);
        }else if($page >= $page_other){
            $page_list = array(1,'...',$page_count-5,$page_count-4,$page_count-3,$page_count-2,$page_count-1,$page_count);
        }
    }
    return $page_list;
}

//in_array的扩充版 可以在多维数组里找到某个值
function in_multi_array($needle, $haystack)
{
    $in_multi_array = false;
    if(in_array($needle, $haystack))
    {
        $in_multi_array = true;
    }
    else
    {   
        foreach($haystack as $key=>$value)
        {
            if(is_array($value))
            {
                if(in_multi_array($needle, $value))
                {
                    $in_multi_array = true;
                    break;
                }
            }
        }
    }
    return $in_multi_array;
}

//相当于Douglas Crockford的supplant函数
function str_supplant($orginal_str,$replace_array){
    foreach($replace_array as $param_name => $this_param){
        $params[] = '{'.$param_name.'}';
        $replaces[] = $this_param;
    }
	//var_dump($orginal_str);
	//var_dump(str_replace($params,$replaces,$orginal_str));
	//echo "<br/>";
    return str_replace($params,$replaces,$orginal_str);
}

function str_array_supplant($orginal_str_array,$replace_array){
	foreach($orginal_str_array as $key=>$orginal_str){
		$orginal_str_array[$key] = str_supplant($orginal_str,$replace_array);		 
	}
    return $orginal_str_array;
	
}
//页面中文字显示
function common_format_name($name,$len=8){
    global $g_lang;
    $length = mb_strlen($name,'UTF-8');
    if ($g_lang!='zh_CN'){
        $len = $len*2;
    }
    if($length>$len){
        $name = mb_substr($name,0,$len-1,'utf8').'...';
    }
    return $name;
}

function my_debug($info){
    global $g_debug_info;
    $g_debug_info[] = $info;
}

function err_log($log){
    global $zeit;
    $sql = "INSERT INTO `err_log` (`info`,`zeit`) VALUES ('$log',$zeit)";
    mysql_query($sql);
}
function request_uri()
{
    if (isset($_SERVER['REQUEST_URI']))
    {
        $uri = $_SERVER['REQUEST_URI'];
    }
    else
    {
        if (isset($_SERVER['argv']))
        {
            $uri = $_SERVER['PHP_SELF'] .'?'. $_SERVER['argv'][0];
        }
        else
        {
            $uri = $_SERVER['PHP_SELF'] .'?'. $_SERVER['QUERY_STRING'];
        }
    }
    return $uri;
}
function super_rand_seed(){
    global $g_rand_seed;
    $g_rand_seed = microtime(true)*1000;
}
//加上vip图标
function format_club_name($vip_level,$club_name){
    global $res_url_prefix;
    //todo
    $vip_info = '';
    if($vip_level==0)
    {
        $vip_info = '';
    }else if($vip_level==1){
        $vip_info = " <img src=".$res_url_prefix."images/common/club_bronze.png alt='铜牌教头'/>";
    }else if($vip_level==2){
        $vip_info = " <img src=".$res_url_prefix."images/common/club_silvel.png alt='银牌教头'/>"; 
    }else if($vip_level==3){
        $vip_info = " <img src=".$res_url_prefix."images/common/club_g.png alt='金牌教头'/>";  
    }
    return $club_name.$vip_info;
}

function super_rand($min,$max){
    global $g_rand_seed;
    //return mt_rand($min,$max);
    $scope = abs($max - $min);
    if ($scope>10000){
        return mt_rand($min,$max);
    }
    
    if (!isset($g_rand_seed)){
	$g_rand_seed = round(microtime(true)*10000);
    }
    $result = $g_rand_seed % $scope;
    return $min + $result;
}

//参数{1=>10,2=>30,3=>30},意味着1/7返回1，3/7返回2，3/7返回3
function common_lottery($arr){
    $max = 0;
    $keys = array_keys($arr);
    shuffle($keys);
    $max = array_sum(array_values($arr));
    $rand_key = mt_rand(1, $max);
    $radix = 0;
    foreach ($keys as $key) {
        $radix += $arr[$key];
        if ($rand_key <= $radix)
        {
            return $key;
            break;
        }
    }
}

	/**
	 * 生成随机
	 * @param unknown_type $rand_data
	 * @param unknown_type $rand_key
	 */
	function random_lottery($rand_data) {
		if (empty($rand_data)) {
			return array();
		}
		$result = 0;
        $end = end($rand_data);
		$rand_num = mt_rand(1, $end[1]);
		foreach ($rand_data as $data) {
			if ($rand_num <= $data[1]) {
				$result = $data[0];
				break;
			}
		}
		return $result;
	}

// chat udp
function chat_content_udp($chat_content){
    global $g_is_public,$config; 
    $server_ip = $config['chat']['server_ip'];
    $port = $config['chat_udp']['port'];
    $sock= socket_create(AF_INET,SOCK_DGRAM,0);
    if(!$sock){
        err_log("socket create failure");
    } 
    if(!socket_sendto($sock,$chat_content,strlen($chat_content),0,$server_ip,$port)){
        err_log("socket sendto failure");
    }
    socket_close($sock);
}

function common_format_incoming($incoming){
    $t = floor($incoming/10);
    $s = array();
    
    
    while ($t>=10000){
        $s[] = common_add_zero_left($t % 10000,4);
        $t= floor($t / 10000);
    }
    $s[] = $t % 10000;
    $s = array_reverse($s);
    $r = implode(' ',$s);
    $r.='.'.($incoming%10);
    return $r;
}

function common_get_game_config(){
    global $sys_id;
    $game_config_info = get_cache($sys_id,'game_config_info',0);
    //$game_config_info = -1;
    if($game_config_info==-1 || $game_config_info==-2){
        $game_config_info = common_update_game_config();
    }else{
        $game_config_info = $game_config_info['data'];
    }
    return $game_config_info;
}

function common_update_game_config(){
    global $sys_id;
    $sql = "SELECT * FROM s_game_config";
    $rst = mysql_w_query($sql);
    $game_config_info = array();
    while($row= mysql_fetch_assoc($rst)){
        $game_config_info[$row['key']] = $row;
    }
    set_cache($sys_id,'game_config_info',$game_config_info,0);
    return $game_config_info;
}

/**
 * @param $date1
 * @param $date2
 * 两个日期均为日期不需要时间
 */
function common_date_diff($begin_date,$end_date){
    $begin_date_unixtime = strtotime($begin_date);
    $end_date_unixtime = strtotime($end_date);
    return round(abs($end_date_unixtime-$begin_date_unixtime)/60/60/24) + 1;
}

/**
 * @return int
 * 获取当前是开服的第几天
 */
function get_which_date_from_open_game(){
    global $g_sunrise;
    $game_cfg = common_get_game_config();
    $open_game_time = isset($game_cfg['open_game']['value'])?$game_cfg['open_game']['value']:'';
    $open_game_unixtime = strtotime($open_game_time);
    $open_game_sunrise = strtotime(date('Y-m-d',$open_game_unixtime));
    $today = common_date_diff(date('Y-m-d',$open_game_sunrise),date('Y-m-d',$g_sunrise));
    return (int)$today;
}


function common_insert_table($table,$info){
	foreach($info as $k=>$v){
		$keys[] = '`'.$k.'`';
		$values[] = "'".mysql_real_escape_string($v)."'";
	}
	$keys_str = implode(',',$keys);
	$values_str = implode(',',$values);
	$sql = "INSERT INTO $table ($keys_str) VALUES ($values_str)";
	try{
		mysql_w_query($sql);
	}catch (Exception $e){
		error_log($sql.'::'.$e->getMessage());
	}
	return;
	
}

function common_alpha_id($in, $to_num = false)  
{  
    $index = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";  
    
   
    $base  = strlen($index);  
   
    if ($to_num) {  
        // Digital number  <<--  alphabet letter code  
        $in  = strrev($in);  
        $out = 0;  
        $len = strlen($in) - 1;  
        for ($t = 0; $t <= $len; $t++) {  
            $bcpow = bcpow($base, $len - $t);  
            $out   = $out + strpos($index, substr($in, $t, 1)) * $bcpow;  
        }  
       
         
        $out = sprintf('%F', $out);  
        $out = substr($out, 0, strpos($out, '.'));  
    } else {  
        // Digital number  -->>  alphabet letter code  
         
       
        $out = "";  
        for ($t = floor(log($in, $base)); $t >= 0; $t--) {  
            $bcp = bcpow($base, $t);  
            $a   = floor($in / $bcp) % $base;  
            $out = $out . substr($index, $a, 1);  
            $in  = $in - ($a * $bcp);  
        }  
        $out = strrev($out); // reverse  
    }  
   
    return $out;  
}
?>
