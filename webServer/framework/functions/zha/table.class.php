<?php
class table{
    var $table_id;
    var $table_limition;
    var $online;
    function __construct($table_id,$limition) {
        $this->table_id = $table_id;
        $this->online = 0;
        $this->table_limition = $limition;
        
    }
}
?>