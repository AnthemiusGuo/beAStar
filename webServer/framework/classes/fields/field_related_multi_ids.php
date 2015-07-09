<?php
include_once('field_relate_simple_id.php');

class Field_related_multi_ids extends Field_relate_simple_id {

    public function __construct($show_name,$name,$is_must_input=false) {
        parent::__construct($show_name,$name,$is_must_input);
        $this->typ = "Field_related_multi_ids";
        $this->model_name = '';
        $this->valueSetted = false;
        $this->placeholder = '请点击<+>输入';
        $this->jsonValue = array();
        $this->plusCreateData = NULL;
    }
    public function setPlusCreateData($data){
        $this->plusCreateData = $data;
    }
    public function setEditor($editorUrl){
        $this->editorController = $controller;
        $this->editorMethod = $method;
    }
    public function init($value){
        $this->value = $value;
        $this->jsonValue = array();

        $eles = explode(',', $value);
        if (count($eles)<=0 || trim($value)==''){

            return;
        }

        $this->valueSetted = true;
        $this->CI->db->select("{$this->valueField},{$this->showField}")
            ->from($this->tableName)
            ->where_in($this->valueField, $eles);
        $this->checkWhere();
        $this->placeholder = '';
        $query = $this->CI->db->get();
        if ($query && $query->num_rows() > 0)
        {
            foreach ($query->result_array() as $row)
            {
                $this->jsonValue[] = array('id'=>$row[$this->valueField],
                    'name'=>$row[$this->showField]);
                $this->placeholder .= ' <span class="label label-primary">'.$row[$this->showField].'</span> ';
            }
        } else {
            $this->placeholder = '请点击<+>输入';
        }


    }
    public function gen_search_editor($default=""){
        $this->input_class = "form-control input-sm";
        if ($default!="" && $default!=null) {
            $this->jsonValue = json_decode($default,true);
            $this->showValue = $this->jsonValue[0]['name'];
            $this->value = $this->jsonValue[0]['id'];
            $this->default = $this->jsonValue[0]['id'];
            if ($this->value>0){
                $this->placeholder = '<span class="label label-primary">'.$this->showValue.'</span>';
            } else {
                $this->placeholder = '请点击<+>输入';
            }

        }
        return $this->gen_editor(2);
    }
    public function gen_search_result_id($value){
        $value = json_decode($value,true);
        if (count($value)!=1){
            return 0;
        } else {
            if ($value[0]['id']==-1){
                return -1;
            } else {
                return $value[0]['id'];
            }

        }
    }
    public function gen_search_result_show($value){
        $value = json_decode($value,true);
        if (count($value)!=1){
            return '-';
        } else {
            if ($value[0]['id']==-1){
                return '-';
            } else {
                return $value[0]['name'];
            }

        }
    }
    public function gen_list_html(){
        $this->showValues = array();
        foreach ($this->jsonValue as $value) {
            $this->showValues[] = $value['name'];
        }
        return implode(' , ', $this->showValues);
    }
    public function gen_show_html(){
        $this->showValues = array();
        foreach ($this->jsonValue as $value) {
            $this->showValues[] = $value['name'];
        }
        return implode(' , ', $this->showValues);
    }
    public function plusCreate($input){
        $this->plusCreateData[$this->showField] = $input[$this->showField];
        if (isset($this->whereOrgId)){
            $this->plusCreateData['orgId'] = $this->whereOrgId;
        } else {
            $this->plusCreateData['orgId'] = $this->CI->orgId;
        }
        $this->CI->db->insert($this->tableName,$this->plusCreateData);
        return $this->CI->db->insert_id();
    }
    public function gen_value($input){
        $value = json_decode($input,true);
        if (count($value)<=0){
            return '';
        } else {
            $ids = array();
            foreach ($value as $v) {
                if ($v['id']==-1){
                    $v['id'] = $this->plusCreate($v);
                }
                $ids[] = $v['id'];
            }
            return implode(',', $ids);
        }
    }
    // public function gen_list_html(){
    //     return $this->value;
    // }
    // public function set_relate_model($modelName,$showField,$editorUrl){
    //     $modelName = strtolower($modelName);

    //     $this->modelName = $modelName;
    //     $this->showField = $showField;
    //     $this->editorUrl = $editorUrl;

    //     $modelFile = APPPATH."models/records/{$modelName}.php";
    //     if ( ! file_exists($modelFile))
    //     {
    //         return false;
    //     }
    //     require_once($modelFile);

    //     $class = ucfirst($modelName);

    //     return $this->dataModel = new $class();
    // }

    // public function gen_show_html(){
    //     return $this->dataModel->field_list[$this->showField]->gen_show_html();
    // }
    public function gen_editor($typ=0){
        $inputName = $this->build_input_name($typ);
        $validates = $this->build_validator();
        $default = json_encode($this->jsonValue);
        if ($typ==2){
            $width = 70;
            $sm_typ = "single";
        } else {
            $width = 80;
            $sm_typ = "multi";

        }
        return "<div class=\"holder-editor-related-id\" id=\"holder-editor-{$inputName}\">
                    <input type=\"hidden\" value='{$default}' id=\"$inputName\" name=\"$inputName\"/>
                    <div id=\"holder-editor-{$inputName}\">

                        <div id=\"holder_{$inputName}\" class=\"alert alert-danger editor-related-inputed pull-left\" style=\"width:{$width}%;\">{$this->placeholder}</div>
                        <a class=\"btn btn-default pull-right\" href=\"javascript:void(0);\" onclick=\"build_relate_box('{$this->name}','{$sm_typ}',$typ,'".site_url($this->editorUrl)."')\">
                        <span class=\"glyphicon glyphicon-search\"></span>
                        </a>
                    </div>
                </div>";
    }
    public function check_data_input($input)
    {
        if ($input==""){
            return false;
        }
        return Fields::check_data_input($input);
    }
}
?>
