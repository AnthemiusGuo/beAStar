<?php

class Field_text extends Field {

    public function __construct($show_name,$name,$is_must_input=false) {
        parent::__construct($show_name,$name,$is_must_input);
        $this->typ = "Field_text";
        $this->value = "";
    }
    public function init($value){
        parent::init($value);
    }
    public function gen_list_html($len = 20){
        if (mb_strlen($this->value)>$len) {
            return mb_substr($this->value,0,$len)."...";

        } else {
            return $this->value;

        }
    }
    public function gen_show_html(){
        return nl2br($this->value);
    }

    public function gen_editor($typ=0){
        $inputName = $this->build_input_name($typ);
        if ($typ==1){
            $this->default = $this->value;
        }
        return "<textarea id=\"$inputName\" rows=\"6\" name=\"$inputName\" class=\"{$this->input_class}\">{$this->default}</textarea>";
    }
}
?>
