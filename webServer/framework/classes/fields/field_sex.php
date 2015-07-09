<?php
include_once('field_enum.php');

class Field_sex extends Field_enum {

    public function __construct($show_name,$name,$is_must_input=false) {
        parent::__construct($show_name,$name,$is_must_input);
        $this->typ = "Field_sex";
        $this->setEnum(array(
            '未设置',
            '男',
            '女',
            '保密'
            ));
    }
}
?>
