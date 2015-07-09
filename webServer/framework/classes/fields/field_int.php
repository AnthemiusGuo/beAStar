<?php
class Field_int extends Field {

    public function __construct($show_name,$name,$is_must_input=false) {
        parent::__construct($show_name,$name,$is_must_input);
        $this->typ = "Field_int";
    }
    public function init($value){
        parent::init((int)$value);
    }
    public function gen_value($input){
        $input = (int)$input;

        return $input;
    }
    public function build_validator($need_require_validator=true){
        $validater = ' digits ';
        if ($this->is_must_input){
            $validater .= ' min="1" ';
        }
        $validater .= parent::build_validator($need_require_validator);
        return $validater;
    }
    public function gen_editor($typ=0,$need_require_validator=true){
        $inputName = $this->build_input_name($typ);
        $validates = $this->build_validator($need_require_validator);
        if ($typ==1){
            $this->default = $this->value;
        }
        return "<input autocomplete=\"on\" id=\"{$inputName}\" name=\"{$inputName}\" class=\"{$this->input_class}\" placeholder=\"{$this->placeholder}\" type=\"text\" value=\"{$this->default}\" $validates /> ";
    }
    public function check_data_input($input)
    {
        if ($input==0){
            return false;
        }
        return parent::check_data_input($input);
    }
}
?>
