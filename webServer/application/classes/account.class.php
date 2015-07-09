<?
class Account extends ormModel {
    public function __construct() {
        parent::__construct('uAccount');
        $this->field_list['_id'] = load_field('Field_mongoid',"uid","_id");
        $this->field_list['uid'] = load_field('Field_mongoid',"uid","uid");
        $this->field_list['name'] = load_field('Field_string',"电话","name");
        $this->field_list['password'] = load_field('Field_string',"密码","password");

    }
    function init_by_name_pwd($name,$pwd){
        $this->db->where(array('name' => $name));
        $query = $this->db->get($this->tableName);
        if ($query->num_rows() > 0)
        {
            $result = $query->row_array();
            if (md5($pwd)==$result['password']){
                $this->init_with_data($result['_id'],$result);
                return 1;
            } else {
                return -1;
            }
        } else {
            return -2;
        }
    }
    function create_account_by_name_pwd($name,$password){
        $newData = array('name'=>$name,'password'=>md5($password),'uid'=>'');
        return $this->insert_db($newData);
    }
}
?>
