<?php
class Field {
    public $name;
    public $value;
    public $show_name;
    private $html;
    public $is_must_input;
    public $CI;
    public $special_search_element;
    public $is_title;
    public $list_short_len = 15;
    public $is_hidden_input = false;
    public $tips = '';

    public function __construct($show_name,$name,$is_must_input=false) {
        global $g_mongo;
        $this->db = $g_mongo;
        $this->show_name = $show_name;
        $this->name = $name;
        $this->default = "";
        $this->placeholder = "";
        $this->is_must_input = $is_must_input;
        $this->value = 0;
        $this->input_class = "form-control";
        $this->special_search_element = "";
        $this->is_title = false;
        $this->min_len = 0;
        $this->is_fullInited = false;
    }
    public function init($value){
        $this->is_fullInited = true;
        $this->value = $value;
    }

    public function baseInit($value){
        $this->value = $value;
    }
    public function in_array($arr){
        return in_array($this->value,$arr);
    }
    public function setOrgId($orgId){
        $this->orgId = $orgId;
    }
    public function gen_show_name(){
        return '<span class="field_name">'.$this->show_name.'</span>';
    }
    public function gen_editor_show_name(){
        if ($this->is_must_input) {
            return '<span class="field_name_must">'.$this->show_name.' <em>*<em> </span>';
        } else {
            return '<span class="field_name">'.$this->show_name.'</span>';
        }

    }
    public function gen_search_editor($default=""){

        $this->input_class = "form-control input-sm";
        if ($default!="" && $default!=null) {
            $this->setDefault($default);
        }

        return $this->gen_editor(2);

    }
    public function gen_search_element($default="="){
        if ($this->special_search_element!="") {
            return $this->special_search_element;
        }
        $editor = "<select id=\"searchEle_{$this->name}\" name=\"searchEle_{$this->name}\" class=\"form-control input-sm\" value=\"{$default}\">";
        $editor.= "<option value=\"=\" ".(($default=="=")?"selected=\"selected\"":"").">=</option>";
        $editor.= "<option value=\">\" ".(($default==">")?"selected=\"selected\"":"").">&gt</option>";
        $editor.= "<option value=\"<\" ".(($default=="<")?"selected=\"selected\"":"").">&lt</option>";
        $editor .= "</select>";
        return $editor;
    }
    public function gen_list_html($len=16){
        $str = $this->gen_show_html();
        if (mb_strlen($str)>$len) {
            return mb_substr($str, $len-2)."...";
        } else {
            return $str;
        }
    }
    public function gen_show_value(){
        return $this->value;
    }
    public function toString(){
        return (string)$this->value;
    }

    public function gen_show_html(){
        return $this->value;
    }
    public function gen_js_value(){
        return $this->value;
    }
    public function gen_editor(){

    }
    public function check_data_input($input)
    {
        if ($input===''){
            return false;
        }
        return true;
    }
    public function setPlaceHolder($placeholder){
        $this->placeholder = $placeholder;
    }
    public function setDefault($default){
        $this->default = $default;
    }
    public function build_input_name($typ){
        switch ($typ) {
            case 0:
                $inputName = "creator_".$this->name;
                break;
            case 1:
                $inputName = "modify_".$this->name;
                break;
            case 2:
                $inputName = "search_".$this->name;
                break;
            default:
                # code...
                break;
        }
        return $inputName;
    }
    public function gen_hidden_editor($typ,$default=null){
        $inputName = $this->build_input_name($typ);
        if ($typ==1 || $default==null){
            $this->default = $this->value;
        } else {
            $this->default = $default;
        }
        $value = urlencode($this->default);
        return "<input id=\"$inputName\"  name=\"$inputName\" type=\"hidden\" value=\"{$value}\"/>";
    }
    public function build_validator($need_require_validator=true){
        $validater = '';
        if ($this->is_must_input && $need_require_validator){
            $validater .= ' required ';
        }
        if ($this->min_len>0){
            $validater .= ' minlength="'.$this->min_len.'" ';
        }
        return $validater;
    }
    public function gen_value($input){
        return $input;
    }
    public function gen_value_from_front($input){
        return $this->gen_value($input);
    }
    public function gen_search_result_show($value){
        return $value;
    }
    public function gen_search_result_id($value){
        return $value;

    }
    public function checkImportData($value){
        return 1;
    }

    public function importData($value){
        return $value;
    }
}
