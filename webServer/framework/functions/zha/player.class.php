<?php
class player {
    var $uid;
    var $uname;
    var $avatar_url;
    var $socket;
    function __construct($uid) {
        $user_info = user_get_user_base($uid);
        $this->uname=$user_info['uname'];
        $this->uid=$uid;
        
    }
    
    
}

class normal_player extends player {
    
}

class zhuang_player extends player {
    
}
?>
