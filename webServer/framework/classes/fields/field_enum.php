<?php
include_once('field_int.php');

class Field_enum extends Field_int {
    public $enum;
    public function __construct($show_name,$name,$is_must_input=false) {
        parent::__construct($show_name,$name,$is_must_input);
        $this->typ = "Field_enum";
    }
    public function setEnum($enumArray){
        $this->enum = $enumArray;
        $this->enumReverse = array_flip($enumArray);
    }
    public function build_validator(){
        if ($this->is_must_input){
            $validater .= ' required="required" ';
        }
        $validater .= Fields::build_validator();
        return $validater;
    }

    public function init($value){
        parent::init($value);
    }
    public function gen_list_html(){
        return $this->enum[$this->value];
    }
    public function gen_show_value(){
        return $this->enum[$this->value];
    }
    public function gen_show_html(){
        return '<span class="label label-primary">'.$this->enum[$this->value].'</span>';
    }
    public function gen_search_element($default="="){
        return "<input type='hidden' name='searchEle_{$this->name}' id='searchEle_{$this->name}' value=\"{$default}\">=";
    }
    public function check_data_input($input)
    {
        return Fields::check_data_input($input);
    }
    public function gen_value($input){
        $input = (int)$input;
        if (!isset($this->enum[$input])){
            $input = 0;
        }

        return $input;
    }
    public function gen_editor($typ=0){
        $inputName = $this->build_input_name($typ);
        $validates = $this->build_validator();
        if ($typ==1){
            $this->default = $this->value;
        }
        $editor = "<select id=\"{$inputName}\" name=\"{$inputName}\" class=\"{$this->input_class}\" $validates>";
        foreach ($this->enum as $key => $value) {
            $editor.= "<option ". (($key==$this->default)?'selected="selected"':'') ." value=\"$key\">$value</option>";
        }
        $editor .= "</select>";
        return $editor;
    }
    public function gen_search_result_show($value){
        return $this->enum[$value];
    }
    public function checkImportData($value){
        $values = array_values($this->enum);
        if (in_array($value, $values)) {
            return 1;
        } else {
            return -1;
        }
    }

    public function importData($value){
        foreach ($this->enum as $k => $v) {
            if ($value==$v){
                return $k;
            }
        }
        return 0;
    }
}
?>
