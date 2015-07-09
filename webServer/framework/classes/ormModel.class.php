<?php
class OrmModel {
   public $id;
   public $field_list;
   public $tableName;
   public $id_is_id = true;//id字段是mongoid对象还是字符串
   public $none_field_data = array();
   public $is_inited = false;
   public $data = array();
   public $is_only_brief_fields = false;

   public function __construct($tableName='') {
       global $g_mongo;
       $this->tableName = $tableName;
       $this->field_list = array();
       $this->orgId = 0;
       $this->errData = '';

       $this->db = $g_mongo;
       $this->lastError = array('err'=>false,'errNo'=>0,'id'=>"",'msg'=>"");

   }
   public function init($id){
       $this->id = $id;

   }

   public function fetchArray(){
       return $this->data;
   }

   public function gen_list_html($templates){

   }
   public function gen_editor(){

   }

   public function check_data($data,$strict=true){
       $effect = 0;
       $this->error_field = "";
       foreach ($this->field_list as $key => $value) {
           if ($value->is_must_input){
               if (!isset($data[$key])){
                   if ($strict){
                       $this->error_field = $key;
                       return false;
                   }

               }  elseif ($value->check_data_input($data[$key])==false) {
                   $this->error_field = $key;
                   return false;
               }
           }
       }
       return true;
   }

   public function get_error_field(){
       if (isset($this->error_field)){
           return $this->error_field;
       } else {
           return "";
       }
   }

   public function checkNameExist($name){
       $this->db->select('*')
                   ->from($this->tableName)
                   ->where('name', $name);
       $query = $this->db->get();
       if ($query->num_rows() > 0)
       {
           return true;
       } else {
           return false;
       }
   }

   public function init_with_foreignId($foreignKey,$foreignId){

       $this->db->where(array($foreignKey => $foreignId));
       $this->checkWhere();

       $query = $this->db->get($this->tableName);
       if ($query->num_rows() > 0)
       {
           $result = $query->row_array();
           $this->init_with_data($result['_id'],$result);
           return true;
       } else {
           return false;
       }
   }

   public function reset(){
       foreach ($this->field_list as $key => $value) {
           $this->field_list[$key]->init("");
       }
   }

   public function init_with_id($id){
       if (!is_object($id) && $this->id_is_id){
           $real_id = new MongoId($id);
       } else {
           $real_id = $id;
       }
       $this->db->where(array('_id' => $real_id));
       $this->checkWhere();

       $query = $this->db->get($this->tableName);
       if ($query->num_rows() > 0)
       {
           $result = $query->row_array();
           $this->init_with_data($result['_id'],$result);
           return true;
       } else {
           return false;
       }
   }

   public function init_with_data($id,$data,$isFullInit=true){
       $this->id = $id->{'$id'};
       $this->data = $data;

       foreach ($data as $key => $value) {
           $is_inited = false;
           if (isset($this->field_list[$key])){
               //简易版初始化，只初始化部分字段
               if ($this->is_only_brief_fields && !in_array($key,$this->brief_fields)){
                   $this->field_list[$key]->baseInit($value);
                   continue;
               }
               if ($isFullInit) {
                   $this->field_list[$key]->init($value);
               } else {
                   $this->field_list[$key]->baseInit($value);
               }
           }
       }
       // foreach ($this->field_list as $key => $value) {
       //     $this->data[$key] = $value->value;
       // }
       $this->is_inited = true;
   }

   public function gen_op_view(){

   }
   public function gen_op_edit(){
       return '<a class="list_op tooltips" onclick="lightbox({size:\'m\',url:\''.site_url($this->edit_link).'/'.$this->id.'\'})" title="编辑"><span class="glyphicon glyphicon-edit"></span></a>';

   }
   public function gen_op_delete(){
       return '<a class="list_op tooltips" onclick=\'reqDelete("'.$this->deleteCtrl.'","'.$this->deleteMethod.'","'.$this->id.'")\' title="删除"><span class="glyphicon glyphicon-trash"></span></a>';

   }

   public function get_list_ops(){
       $allow_ops = array();

       $allow_ops[] = 'edit';
       $allow_ops[] = 'delete';
       return $allow_ops;
   }

   public function get_info_ops(){
       return array('edit','delete');
   }

   public function gen_list_op(){
       $opList = $this->get_list_ops();
       $strs = array();
       foreach ($opList as $op) {
           $func = "gen_op_".$op;
           $strs[] = $this->$func();
       }
       return implode(" | ", $strs);
   }

   public function insert_db($data){
       if (isset($this->field_list['_id']) && $this->field_list['_id']->typ == "Field_mongoid") {
           if (!isset($data['_id'])) {
               //补充_id 字段
               $data['_id'] = new MongoId();
               if (isset($this->field_list['showId']) && !isset($data['showId'])){
                   $data['showId'] = strtoupper(substr(md5((string)$data['_id']),-8));
               }
           }
       }
       $this->db->insert($this->tableName, $data);
       $id = $this->db->insert_id();
       $this->id = (string)$id;
       return $id;
   }

   public function delete_db($ids){
       $effect = 0;
       $idArray = explode('-',$ids);
       foreach ($idArray as $id) {
           $this->db->where(array('_id'=> new MongoId($id)))->delete($this->tableName);
           $effect += 1;
       }
       return $effect;
   }

   public function push_db($id,$fieldName,$data){
       if (!is_object($id) && $this->id_is_id){
           $real_id = new MongoId($id);
       } else {
           $real_id = $id;
       }

       $this->db->where(array('_id'=>$real_id))
               ->push($fieldName, $data)
               ->update($this->tableName);
   }

   public function pull_db($id,$fieldName,$data){
       if (!is_object($id) && $this->id_is_id){
           $real_id = new MongoId($id);
       } else {
           $real_id = $id;
       }
       // pull('comments', array('comment_id'=>123))
       $this->db->where(array('_id'=>$real_id))
               ->pull($fieldName, $data)
               ->update($this->tableName);
   }

   public function pull_db_id($id,$fieldName,$sub_id){
       if (!is_object($id) && $this->id_is_id){
           $real_id = new MongoId($id);
       } else {
           $real_id = $id;
       }
       if (!is_object($sub_id) && $this->id_is_id){
           $real_sub_id = new MongoId($sub_id);
       } else {
           $real_sub_id = $sub_id;
       }

       $this->db->where(array('_id'=>$real_id))
               ->pull($fieldName, array('_id'=>$real_sub_id))
               ->update($this->tableName);
   }


   public function check_can_delete(){
       return true;
   }

   public function delete_related($ids){
       if ($this->relateIdName=='null'){
           return;
       }
       $effect = 0;
       $idArray = explode('-',$ids);
       foreach ($idArray as $id) {
           foreach ($this->relateTableName as $thisTableName){
               $this->db->where(array($this->relateIdName=> $id))->delete($thisTableName);
               $effect += 1;
           }
       }
       return $effect;
   }


    public function update_db($data,$id=null){
       if ($id==null){
           $id = $this->id;
       }
       if (!is_object($id) && $this->id_is_id){
           $real_id = new MongoId($id);
       } else {
           $real_id = $id;
       }

       $this->db->where(array('_id'=>$real_id))->update($this->tableName,$data);
       return true;
   }

   public function genShowId($orgId,$typ){
        $this->db->select('*')
                   ->from('oMaxIds')
                   ->where('orgId', $orgId);

       $query = $this->db->get();

       if ($query->num_rows() > 0)
       {
           $result = $query->row_array();
       }
       else
       {
           $this->db->insert('oMaxIds', array("orgId"=>$orgId));
           $result = array("orgId"=>$orgId);
       }
       //处理年份
       if (!isset($result['lastModifyTs'])){
           $result['lastModifyTs'] = 0;
       }

       $zeit  = time();
       $now_year = date('Y',$zeit);
       $last_modify_year = date('Y',$result['lastModifyTs']);

       if ($now_year > $last_modify_year) {
           $result[$typ] = 0;
       }

       if (!isset($result[$typ])){
           $update[$typ] = 1;
       } else {

           $update[$typ] = $result[$typ]+1;
       }
       $update["lastModifyTs"] = $zeit;
       $this->db->where('orgId', $orgId)->update('oMaxIds',$update);

       return $now_year . sprintf("%06d",$update[$typ]);

   }

   function checkImportDataBase($data,$cfg_field_lists){
       $errorData = array();
       foreach ($data as $key => $value) {
           # code...
           if (!isset($cfg_field_lists[$key])) {
               continue;
           }
           $rst = $this->field_list[$cfg_field_lists[$key]]->checkImportData($value);
           if ($rst<=0) {
               $errorData[$this->field_list[$cfg_field_lists[$key]]->gen_show_name()] = $value;
           }
       }
       return $errorData;
   }

   function checkIdBy($param){
       $this->db->select("id")
           ->from($this->tableName)
           ->where($param);
       // $this->checkWhere();

       $query = $this->db->get();
       if ($query->num_rows() > 0)
       {
           $result = $query->row_array();
           return $result["id"];
       } else {
           return -1;
       }
   }

   function checkWhere(){

   }
   public function buildChangeNeedFields($arr_plus = array()){
       $array = $arr_plus;
       foreach ($this->buildChangeShowFields() as $value) {
           foreach ($value as $v) {
               if ($v=='null'){
                   continue;
               }
               $array[] = $v;
           }
       }
       return $array;
   }

   public function setError($errNo,$msg,$id=""){
       $this->lastError['err'] = true;

       $this->lastError['errNo'] = $errNo;
       $this->lastError['id'] = $id;
       $this->lastError['msg'] = $msg;
   }

   public function getLastError(){
       if (!$this->lastError['err']){
           return array('errNo'=>0,'msg'=>'未知错误');
       }
       return array('errNo'=>$this->lastError['errNo'],'id'=>$this->lastError['id'],'msg'=>$this->lastError['msg']);
   }

}
?>
