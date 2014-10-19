<?
include_once AR.'functions/user/user_session.func.php';
class User { 
	public $typ = 1;//1 for full,0 for just base
	public $baseInfo = array();
	public $devicesList = array();
	public $extendInfo = array();
	public $counters = array();
	public $attrInfo = array();

	public $uid = '';
	public $uuid = '';
	public $hasSync = true;
	public $hasGet = false;
	public $ticket = '';
	private $ticket_ts = 0;

	public function init($uid){
		$dbInfo = mongoSearchOne("user",array("uid"=>$uid));
		if ($dbInfo!=null) {
			$this->initByFulldata($dbInfo);
			return true;
		}
		return false;
	}

	public function initBaseByUid($uid){
		$dbInfo = mongoSearchOne("user",array("uid"=>$uid),array('baseInfo'));
		if ($dbInfo!=null) {
			$this->uid = (string) $data['_id'];
			$this->baseInfo = $data['baseInfo'];
			return true;
		}
		return false;
	}

	public function initFullByUid($uid){
		$dbInfo = mongoSearchOne("user",array("uid"=>$uid));
		if ($dbInfo!=null) {
			$this->initByFulldata($dbInfo);
			return true;
		}
		return false;
	}

	public function setUuid($uuid) {
		$this->uuid = $uuid;
	}
	public function initByUuid($uuid){
		$dbInfo = mongoSearchOne("user",array("baseInfo.uuid"=>$uuid));
		if ($dbInfo!=null) {
			$this->initByFulldata($dbInfo);
			return true;
		}
		return false;
	}

	public function initByFulldata($data) {
		$this->uid = (string) $data['_id'];
		$this->baseInfo = $data['baseInfo'];
		$this->attrInfo = $data['attrInfo'];
	    $this->devicesList = $data['devicesList'];
	    $this->extendInfo = $data['extendInfo'];
	    $this->counters = $data['counters'];
	    $this->hasGet = true;
	}

	public function regAnonymousUser($uuid,$uname='')
	{
		global $zeit,$cfg_reg;

		if ($uname==''){
			$uname = '游客'.user_get_display_uid($zeit).user_get_display_uid(mt_rand(0,10000));
		}
		$this->create(	array(
				'uuid' => $uuid,
				'is_anonym' => 1,
				"uname" => $uname,
				'reg_zeit' => $zeit,
				'level' => 0,
				'exp' => 0,
				'money' => $cfg_reg["money"],
				"credits" => $cfg_reg["credits"],
				"voucher" => $cfg_reg["voucher"]
			)
		);
		# code...
	}

	public function getAttrInfo($force = false)
	{
		if (empty($this->attrInfo) || $force){
			$dbInfo = mongoSearchOne("user",array("uid"=>$this->uid),array('attrInfo'));
			if ($dbInfo!=null) {
				$this->attrInfo = $data['attrInfo'];
				return true;
			}
			return false;
		} else {
			return true;
		}
	}

	public function create($userInfo = array(),$extendInfo = array()){  
		global $zeit,$cfg_reg;
	    $baseArray = array(
	        "uuid" => "",
	        "is_anonym" => 0,
	        "uname" => "",
	        "avatar_url" => "",
	        "avatar_id" => 1,
	        "level" => 0,
	        "exp" => 0,
	        "mood" => 0,
	        "point" => 0,
	        "point_all" =>0,
	        "energy" => $cfg_reg["energy"],

	       	'money' => $cfg_reg["money"],
			"credits" => $cfg_reg["credits"],
			"voucher" => $cfg_reg["voucher"],

	        "is_robot" => 0,
	        "DOA" => 0,
	        "pp_id" => 0,
	        "pp_uid" => "",
	        "real_name" => "",
	        "pp_vip_level" => 0,
	        "game_from" => "",
	        "via_from" => "",
	        "reg_zeit" => 0,
	        "login_name" => "",
	        "login_pwd" => "",
	        "password_box" => "",
	        "phone_number" => "",
	        "vip_level" => 0,
	        "vip_end_zeit" => 0,
	        "intro_uid" => 0
	    );
	    $deviceList = array();
	    if (isset($userInfo['uuid'])){
	    	array_push($deviceList,$userInfo['uuid']);
	    }
	    

	    $extendArray = array(
	        "last_login" => $zeit,
	        "last_online" => $zeit,
	        
	        "gen_online_gift" => 0,
	        "gen_alms_num" => 0,
	        "gen_alms_zeit" => 0,
	        "gen_intro_gift_zeit" => 0,
	    );

	    $counters = array(
	        "online_keeps" => 0,
	    	"total_pay" => 0,
	    	"match_counter" => 0,
	        "win_counter" => 0,
	        "speaker_count" => 0
	    );

	    $attrInfo = array(
	    	"common"=>array(
	    			"charm"=>0,
	    			"looks"=>0,
	    			"intelligence"=>0,
	    		),
	    	"special"=>array(
	    			"voice"=>0,
	    			"musicality"=>0,
	    			"play"=>0,
	    			"acting"=>0, 
	    			"literature"=>0
	    		),

	    );
	    foreach ($userInfo as $key => $value) {
	    	$baseArray[$key] = $value;
	    }
	    foreach ($extendInfo as $key => $value) {
	    	$extendArray[$key] = $value;
	    }
	    $this->baseInfo = $baseArray;
	    $this->devicesList = $deviceList;
	    $this->extendInfo = $extendArray;
	    $this->counters = $counters;
	    $this->attrInfo = $attrInfo;

	    $this->hasSync = false;
	    $ret = mongoInsert("user",array('baseInfo'=>$baseArray,
	    	'devicesList' => $deviceList,
			"extendInfo" => $extendArray,
			'counters' => $counters,
			'attrInfo' => $attrInfo));
	    $this->uid = (string) $ret;
	    $newdata = array('$set' => array("uid" => $this->uid));
	    mongoUpdate("user",array("_id"=>$ret),$newdata);

	    $this->hasSync = true;
	    $this->hasGet = true;
	}  

	public function insertDeviceList(){
		//先检查是否存在这条
	}

	private function refreshData()
	{
		foreach ($this->userInfo as $key => $value) {
			
		}
	}

	public function genTicket()
	{
		global $public_key;
		$now = time();
		$redis_key = "user/ticket/".$this->uid;
		$ticket = md5(substr(md5($now.$this->uid.$public_key),5,32-5));
		redis_set_hash($redis_key,array('ticket'=>$ticket,'ts'=>$now),3600);
		$this->ticket = $ticket;
		$this->ticket_ts = $now;
		return $ticket;
	}

	public function verifyTicket($ticket) 
	{
		$this->getTicket();
		if ($ticket!=$this->ticket) {
			return false;
		} else {
			return true;
		}
	}

	public function refreshTicket($force = false)
	{
		global $zeit;
		if ($force || $zeit - $this->ticket_ts > 300) {
			$this->ticket_ts = $zeit;
			$redis_key = "user/ticket/".$this->uid;
			redis_refresh($redis_key,3600);

			$newdata = array('$set' => array(
				"last_online" => $zeit)
			);
	    	mongoUpdate("userOnline",array("uid"=>$this->uid,"ticket"=>$this->ticket),$newdata);

	    	$newdata = array('$set' => array(
				"extendInfo.last_online" => $zeit)
			);
	    	mongoUpdate("user",array("uid"=>$this->uid),$newdata);
		}
		
	}

	public function getTicket()
	{
		$redis_key = "user/ticket/".$this->uid;
		$ret = redis_get_hash($redis_key);
		if ($ret!=null) {
			$this->ticket = $ret['ticket'];
			$this->ticket_ts = $ret['ts'];
		} else {
			$this->ticket = '';
			$this->ticket_ts = 0;
		}
		return $this->ticket;
	}
	public function insertOnlineInfo()
	{
		global $zeit;
		$ipx = get_user_ip();
		$newdata = array("uid" => $this->uid,
		                 "ticket" => $this->ticket,
		                 "first_online" => $zeit,
		                 "last_online" => $zeit,
		                 "ip1" => $ipx[0],
		                 "ip2" => $ipx[0],
		                 "ip3" => $ipx[0],
		                 "ip4" => $ipx[0],
		                 "ip_all" => $ipx[0],
		                 "uuid" => $this->uuid,
		                 );
		mongoInsert("userOnline",$newdata);
	}

	public function checkAndRefreshTicket()
	{
	}

	function get_user_show($show_credits=0,$is_myself=0){
		global $res_url_prefix;

		if(empty($this->baseInfo)){
			return array();
		}
		if ($this->baseInfo['avatar_id']>0){
			$this->baseInfo['avatar_url'] = $res_url_prefix.'images/avatar/'. $this->baseInfo['avatar_id'].'.png';
		}
		return array('uname'=>$this->baseInfo['uname'],
				'vip_level'=>$this->baseInfo['vip_level'],
				'uid'=>$this->uid,
				'level'=>$this->baseInfo['level'],
	            'exp'=>$this->baseInfo['exp'],
	            'exp_len'=>0,
				'money'=>($show_credits==1)?$this->baseInfo['money']:0,
				'voucher'=>($is_myself==1)?$this->baseInfo['voucher']:0,
				'credits'=>($is_myself==1)?$this->baseInfo['credits']:0,
				'money_show'=>($show_credits==1)?common_get_zipd_number($this->baseInfo['money_show']):0,
				'avatar_url'=>$this->baseInfo['avatar_url'],
				'avatar_id'=>$this->baseInfo['avatar_id'],
				'show_uid'=>user_get_display_uid($this->uid),
				'is_anonym'=>$this->baseInfo['is_anonym'],
				'energy'=>($is_myself==1)?$this->baseInfo['energy']:0,
				'mood'=>($is_myself==1)?$this->baseInfo['mood']:0,
				
    	);
	}

	function writeBack($key,$subKey,$value){
		$newdata = array('$set' => array($key.'.'.$subKey => $value));
	    mongoUpdate("user",array("uid"=>$this->uid),$newdata);
	}
	function writeBackBatch($updates){
		$newdata = array('$set' => $updates);
	    mongoUpdate("user",array("uid"=>$this->uid),$newdata);
	}
}  


?>