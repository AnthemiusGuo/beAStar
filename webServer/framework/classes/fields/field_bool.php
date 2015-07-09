<?php
include_once('field_enum.php');
class Field_bool extends Field_enum {

    public function __construct($show_name,$name,$is_must_input=false) {
        parent::__construct($show_name,$name,$is_must_input);
        $this->typ = "Field_bool";
        $this->setEnum(array(
            '否',
            '是'
            ));
    }
    public function toBool(){
    	if ($this->value==1) {
    		return true;
    	} else {
    		return false;
    	}
    }

}
?>
