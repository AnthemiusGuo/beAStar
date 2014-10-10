<?php
if (isset($_COOKIE['set_lang']) && ($is_testing == 1)){
    $g_lang = $_COOKIE['set_lang'];
}

if (isset($_GET['set_lang']) && ($is_testing == 1)){
    $g_lang = $_GET['set_lang'];
    setcookie('set_lang',$g_lang,time()+86400*365,'/');
}

$locale = $g_lang.".utf8";

setlocale(LC_ALL, $locale);
putenv("LC_ALL=$locale");
bind_textdomain_codeset("default" , 'UTF-8' );
bindtextdomain("default", FR."/locale");
textdomain("default");

if ($g_lang=='zh_CN'){
    $g_timeformat = 'Y-m-d';
} else {
    $g_timeformat = 'm/d Y';
}
?>
