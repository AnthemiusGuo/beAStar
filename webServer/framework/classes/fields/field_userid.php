<?php
include_once('field_relate_simple_id.php');

class Field_userid extends Field_relate_simple_id {

    public function __construct($show_name,$name,$is_must_input=false) {
        parent::__construct($show_name,$name,$is_must_input);
        $this->typ = "Field_userid";
        $this->set_relate_db('uUser','_id','name');
    }

    public function set_typ($typ){

        $this->add_where(WHERE_TYPE_WHERE,'typ',$typ);
    }
    public function set_in_typ($typ){
        $this->add_where(WHERE_TYPE_IN,'typ',$typ);
    }
    public function init($value){

        if (is_numeric($value) && $value<=0){
            $this->showValue = '[系统]';
        } else {
            parent::init($value);
            $this->userName = $this->showValue;
        }

    }
    public function gen_list_html(){
        return $this->showValue;
    }
    public function gen_show_html(){
        return $this->showValue;
    }
    public function gen_search_element($default="="){
        $editor = "<input type=\"hidden\" id=\"searchEle_{$this->name}\" name=\"search_{$this->name}\" class=\"form-control input-sm\" value=\"=\">";
        $editor .= "=";
        return $editor;
    }

}
?>
