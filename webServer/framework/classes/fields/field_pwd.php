<?php
include_once('field_string.php');

class Field_pwd extends Field_string {

    public function __construct($show_name,$name,$is_must_input=false) {
        parent::__construct($show_name,$name,$is_must_input);
        $this->typ = "Field_pwd";
        $this->value = '';
        $this->tips = '修改时，如果不打算修改密码，留空即可';
        $this->min_len = 6;

    }
    public function init($value){
        parent::init($value);
    }
    public function gen_list_html(){
        $len = $this->list_short_len;
        $str = $this->gen_show_html();
        if (mb_strlen($str)>$len) {
            return mb_substr($str, 0,$len-2)."...";
        } else {
            return $str;
        }
    }
    public function gen_value($input){
        return strtolower(md5($input));
    }
    public function gen_show_html(){
        return '***';
    }
    public function gen_search_element($default="="){
        $editor = "<select id=\"searchEle_{$this->name}\" name=\"searchEle_{$this->name}\" class=\"form-control input-sm\" value=\"{$default}\">";
        $editor.= "<option value=\"=\" ".(($default=="=")?"selected=\"selected\"":"").">=</option>";
        $editor.= "<option value=\"like\" ".(($default=="like")?"selected=\"selected\"":"").">包含</option>";
        $editor .= "</select>";
        return $editor;
    }
    public function gen_editor($typ=0,$need_require_validator=true){
        $inputName = $this->build_input_name($typ);
        $validates = $this->build_validator($need_require_validator);
        if ($typ==1){
            $this->default = $this->value;
        }
        return "<input autocomplete=\"on\" id=\"$inputName\"  name=\"$inputName\" class=\"{$this->input_class}\" type=\"password\" value=\"\" $validates/>";
    }
}
?>
