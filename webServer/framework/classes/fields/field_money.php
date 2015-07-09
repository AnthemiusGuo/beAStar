<?php
include_once('field_float.php');

class Field_money extends Field_float {
	public function __construct($show_name,$name,$is_must_input=false) {
        parent::__construct($show_name,$name,$is_must_input);
        $this->typ = "Field_money";
    }
    private function __calc_money(){
    	return number_format($this->value);
    }
    private function __calc_cn_money(){
        if ($this->value<10000){
            return $this->value;
        } else if ($this->value<100000000){
            return ($this->value/10000).'万';
        }
    }

    public function gen_show_html(){
        return $this->__calc_cn_money();//." (".$this->__calc_cn_money().")";
    }
    public function gen_list_html($len=16){
        return $this->__calc_cn_money();
    }
}
