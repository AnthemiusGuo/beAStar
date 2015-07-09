<?php
class Field_mongoid extends Field {

    public function __construct($show_name,$name,$is_must_input=false) {
        parent::__construct($show_name,$name,$is_must_input);
        $this->typ = "Field_mongoid";
    }
    public function init($value){
        parent::init($value);
    }
    public function gen_value($input){
        if (is_object($input)){
            $input = $input->{'$id'};
        } else {
            $input = $input;
        }


        return $input;
    }
    public function gen_list_html(){
        return $this->gen_show_html();
    }
    public function isValid(){
        return MongoId::isValid($this->value);
    }
    public function build_validator(){

    }
    public function gen_editor($typ=0){

    }
    public function check_data_input($input)
    {
        if ($input===0){
            return false;
        }
        return parent::check_data_input($input);
    }

    public function toShowID(){
        $id = $this->toString();
        // return hexdec(substr($id,strlen($id)-8,8));
        return strtoupper(substr(md5($id),-8));
    }
}
?>
