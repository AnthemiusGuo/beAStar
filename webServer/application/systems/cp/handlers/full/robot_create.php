<?
include_once FR."functions/user/reg.func.php";
include_once FR."functions/user/robot.func.php"; 
include_once FR."config/define/define.wordslength.php";
include_once FR."config/define/define.reg.php";
include_once FR.'functions/player/player.func.php';
include_once FR.'functions/club/club.func.php';
include_once FR.'functions/instance/ins.func.php';
include_once FR.'functions/buddy/buddy.func.php';

$g_version_flag = 0;
$g_old_version_op = $g_version_op;
$g_version_op = 0;
$reg_config_player_list[1] = array('main_position_typ'=>1,'kit_number'=>1,'quality'=>4,'position_id'=>12);//GK 1
$reg_config_player_list[2] = array('main_position_typ'=>1,'kit_number'=>13,'quality'=>2,'position_id'=>1);//GK 2
$reg_config_player_list[3] = array('main_position_typ'=>2,'kit_number'=>5,'quality'=>3,'position_id'=>3);//DC
$reg_config_player_list[4] =array('main_position_typ'=>2,'kit_number'=>6,'quality'=>5,'position_id'=>4);//DC 2
$reg_config_player_list[5] =array('main_position_typ'=>2,'kit_number'=>10,'quality'=>4,'position_id'=>13);//DC 3 
$reg_config_player_list[6] = array('main_position_typ'=>3,'kit_number'=>3,'quality'=>3,'position_id'=>5);//DL
$reg_config_player_list[7] = array('main_position_typ'=>4,'kit_number'=>2,'quality'=>4,'position_id'=>2);//DR
$reg_config_player_list[8] = array('main_position_typ'=>5,'kit_number'=>4,'quality'=>3,'position_id'=>15);//DMC
$reg_config_player_list[9] = array('main_position_typ'=>6,'kit_number'=>8,'quality'=>5,'position_id'=>7);//MC
$reg_config_player_list[10] = array('main_position_typ'=>6,'kit_number'=>16,'quality'=>4,'position_id'=>8);//MC
$reg_config_player_list[11] = array('main_position_typ'=>6,'kit_number'=>17,'quality'=>3,'position_id'=>14);//MC
$reg_config_player_list[12] = array('main_position_typ'=>7,'kit_number'=>15,'quality'=>4,'position_id'=>9);//ML
$reg_config_player_list[13] = array('main_position_typ'=>8,'kit_number'=>7,'quality'=>4,'position_id'=>6);//MR
$reg_config_player_list[14] = array('main_position_typ'=>9,'kit_number'=>10,'quality'=>4,'position_id'=>16);//AMC
$reg_config_player_list[15] = array('main_position_typ'=>10,'kit_number'=>11,'quality'=>4,'position_id'=>0);//WL
$reg_config_player_list[16] = array('main_position_typ'=>11,'kit_number'=>14,'quality'=>3,'position_id'=>0);//WR
$reg_config_player_list[17] = array('main_position_typ'=>12,'kit_number'=>9,'quality'=>5,'position_id'=>10);//FC
$reg_config_player_list[18] = array('main_position_typ'=>12,'kit_number'=>12,'quality'=>4,'position_id'=>11);//FC

$config_reg_player[1] = array(-580,-451,-411,-252,-250,-233,-231,-193,-183,-182,-181,-180,-158,-150,-126,-125,-119,-111,-96,-75,-71,-60,-58,-57,-29,-14534);
$config_reg_player[2] = array(-9198,-8409,-8317,-8003,-8000,-7843,-7818,-7645,-7618,-7593,-7455,-7418,-7296,-7281,-7172,-6932,-6883,-6882,-6831,-6815,-6807,-6802,-6776,-6755,-6640,-6589,-6457,-6439,-6422,-6417,-6401,-6390,-6355,-6330,-6280,-6240,-6237,-6231,-6187,-6144,-6133,-6121,-6050,-6033,-5986,-5983,-5978,-5946,-5914,-5900);
$config_reg_player[3] = array(-7590,-6221,-5926,-5919,-4615,-4463,-4114,-4077,-3956,-3946,-3922,-3873,-3812,-3750,-3554,-3459,-3451,-3448,-3397,-3366,-3344,-3335,-3324,-3318,-3314,-3304,-3275,-3164,-3163,-3162,-3146,-3120,-3108,-3080,-3063,-3036,-3014,-2959,-2955,-2949,-2932,-2921,-2915,-2898,-2885,-2850,-2840,-2809,-2767,-2760);
$config_reg_player[4] = array(-154,-122,-116,-97,-94,-69,-62,-56,-53,-40,-17,-16,-12,-8);
$config_reg_player[5] = array(-2174,-1016,-965,-890,-868,-770,-750,-714,-680,-592,-590,-588,-583,-582,-574,-520,-484,-481,-458,-457,-447,-440,-431,-429,-424,-415,-406,-402,-396,-377,-369,-362,-360,-342,-340,-335,-327,-324,-302,-301,-300,-298,-295,-294,-291,-276,-271,-260,-251,-246);
$config_reg_player[6] = array(-4936,-4415,-4375,-3986,-3890,-3858,-3850,-3815,-3777,-3638,-3358,-3325,-3198,-3125,-2963,-2918,-2557,-2534,-2449,-2404,-2326,-2205,-2150,-2122,-2121,-2119,-2050,-2043,-2038,-2004,-1908,-1873,-1843,-1824,-1715,-1666,-1638,-1630,-1606,-1588,-1586,-1585,-1581,-1557,-1532,-1515,-1465,-1450,-1435,-1431);
$config_reg_player[7] = array(-478,-473,-463,-384,-320,-315,-287,-235,-205,-14693,-14694,-14755);
$config_reg_player[8] = array(-5751,-5669,-5315,-4528,-3981,-3836,-3768,-3665,-3642,-3547,-3377,-3212,-3070,-3067,-3019,-2947,-2888,-2865,-2864,-2860,-2832,-2788,-2784,-2765,-2753,-2715,-2637,-2636,-2630,-2619,-2523,-2459,-2437,-2380,-2360,-2356,-2278,-2265,-2244,-2239,-2231,-2215,-2190,-2124,-2100,-2090,-2081,-2078,-2065,-2048);
$config_reg_player[9] = array(-244,-133,-95,-85,-70,-20,-6,-3);
$config_reg_player[10] = array(-1194,-1047,-912,-828,-689,-506,-467,-433,-427,-422,-397,-391,-389,-388,-374,-357,-351,-350,-347,-336,-333,-330,-319,-317,-316,-307,-305,-289,-288,-273,-269,-256,-255,-249,-245,-225,-218,-209,-161,-146,-114,-110,-105);
$config_reg_player[11] = array(-4534,-3875,-3855,-3844,-3716,-3419,-3370,-3347,-3322,-3232,-3225,-3188,-3185,-3084,-3023,-2997,-2966,-2961,-2952,-2951,-2914,-2911,-2904,-2887,-2823,-2819,-2774,-2721,-2714,-2693,-2690,-2682,-2647,-2629,-2628,-2626,-2610,-2593,-2544,-2527,-2521,-2483,-2472,-2471,-2458,-2456,-2418,-2399,-2397,-2395);
$config_reg_player[12] = array(-329,-297,-290,-213,-197,-184,-168,-149,-120,-115,-80,-14610);
$config_reg_player[13] = array(-687,-597,-449,-421,-332,-311,-263,-254,-247,-224,-112,-103);
$config_reg_player[14] = array(-678,-465,-441,-408,-371,-352,-337,-334,-258,-208,-196,-186,-185,-152,-130,-123,-109,-104,-101,-98,-93,-92,-89,-83,-67,-64,-14565,-14618,-14772,-15224);
$config_reg_player[15] = array(-359,-77,-65,-51,-14587);
$config_reg_player[16] = array(-2957,-2291,-1933,-1137,-1068,-862,-806,-707,-647,-613,-607,-557,-533,-489,-461,-407,-404,-14773);
$config_reg_player[17] = array(-118,-87,-68,-66,-49,-48,-42,-38,-33,-30,-28,-24,-23,-22,-18,-14,-13,-5,-1);
$config_reg_player[18] = array(-1297,-900,-871,-596,-477,-383,-372,-348,-325,-285,-275,-267,-259,-253,-242,-239,-234,-229,-214,-194,-190,-187,-175,-173,-171,-170,-167,-157,-151,-144,-143,-141,-138,-135,-134,-129,-127,-124,-121,-108,-106,-102,-100,-99,-90,-82,-76,-74,-72,-35);
$g_version_op = $g_old_version_op;
$now_have_robot = robot_get_list();
$g_version_op = 0;
$base_robot_id = count($now_have_robot)+1;

if ($g_old_version_op==1){
    $img_url = 'http://app100640938.imgcache.qzoneapp.com/app100640938/images/common/60.jpg';
} else {
    $img_url = 'http://football.static.kingnet.com/outer/images/common/trophy_sm.png';
}

for ($robot_id=$base_robot_id;$robot_id<$base_robot_id+50;$robot_id++){
    $pp_uid = 'Robot_'.$robot_id;
    $email = '';
    $mname = player_gen_name(105);
    $mname = $mname['player_local_name'];
    $sql = "INSERT INTO u_account
                (pp_uid,birth,real_name,img_url,gender,game_friend,form_friend,vip_level,game_form,invite_pp_uid)
                VALUES
                ('$pp_uid','','$mname','$img_url',0,0,0,0,'pengyou','0')";
    $rst = mysql_x_query($sql);
    $uid = mysql_insert_id();
    $uid = create_user($uid,$pp_uid,0,0,1);
    $cname = common_gen_club_name($uid,1);
    while ($cname==''){
        $cname = common_gen_club_name($uid,1);
    }
    //$result_str[] =  "creating robot as:$pp_uid | $mname | $cname";
    //print "creating robot as:$pp_uid | $mname | $cname";
    $temp = $robot_id %20;
    if ($temp<6){
        $robot_level = 1; 
    } elseif ($temp<=10){
        $robot_level = 2;      
    } elseif ($temp==11){
        $robot_level = 3;     
    } elseif ($temp==12){
        $robot_level = 4;     
    } elseif ($temp==13){
        $robot_level = 5;     
    } elseif ($temp==14){
        $robot_level = 6;     
    } elseif ($temp==15){
        $robot_level = 7;     
    } elseif ($temp==16){
        $robot_level = 8;     
    } elseif ($temp==17){
        $robot_level = 9;     
    } elseif ($temp==18){
        $robot_level = 10;   
    } else {
        $robot_level = 11;   
    }
    
    $cid = $uid;
    $credits = 0;
    
    $pid_list = array();
    $sql_squad_list = array();
    $club_att_value = 0;
    $club_def_value = 0;
    $player_squad_list = array();
    foreach($reg_config_player_list as $key=>$v){
        $main_pos = $v['main_position_typ'];
        $kit_number = $v['kit_number'];
        $pid_key = $cid%count($config_reg_player[$key]);
        $rp_id = $config_reg_player[$key][$pid_key];
        $this_player = new real_player($rp_id);
        
        $exp = $cfg_player_exp_to_lvl[rand(6,12)];
        $pid = $this_player->copy_user_player($cid,$kit_number,'',$exp,0,0,0,0,2);
     
        $this_player_att_defend = $this_player->get_player_att_defend_by_level(1);
        $position_id = $v['position_id'];
        if($position_id!=0){
            if($position_id<12){
                $is_suitable = 1;
                $club_att_value += $this_player_att_defend['att_value'];
                $club_def_value += $this_player_att_defend['def_value'];
            }else{
                $is_suitable = -1;
            }
            $player_squad_list[$pid] = array('pid'=>$pid,'cid'=>$cid,'position_id'=>$position_id,'is_suitable'=>$is_suitable);
            $sql_squad_list[] = "($pid,$cid,$position_id,$is_suitable)";            
        }
        $pid_list[] = $pid;
    }
    player_update_squad_list($cid,$player_squad_list); 
    _update_player_id_list_in_team($cid,$pid_list);
    $ins_stage_id = round($robot_level/1.5+4);
    if ($g_old_version_op==1){
        $img_url = 'http://app100640938.imgcache.qzoneapp.com/app100640938/images/common/60.jpg';
    } else {
        $img_url = 'http://football.static.kingnet.com/outer/images/common/trophy_sm.png';
    }
    $sql = "INSERT INTO c_club_info(`cid`, `club_name`,`manager_name`, img_url,
            `club_money`, `credits`, `rating_lev`, `rating_total`,`formation_id`,ins_stage_id,
            `formation_level`,`tactic_slot_count`,`attr_points_can_use`,`att_value`,`def_value`,is_robot
        )
        VALUES ($cid, '$cname','$mname','$img_url',
            100000,$credits,1,0,21,$ins_stage_id,
            1,1,500,$club_att_value,$club_def_value,1)";
    mysql_w_query($sql);
	
     
    //初始化阵容
    if(!empty($sql_squad_list)){
        $sql_squad_list_str = implode(',',$sql_squad_list);
        $sql = "INSERT INTO c_squad (pid,cid,position_id,is_suitable) VALUES $sql_squad_list_str";
        mysql_w_query($sql);
    }
    
    //赠送阵型战术
    $formation_id = rand(1,28);
    $sql = "INSERT INTO c_formation (cid,formation_id,level,show_or_hide) VALUES ($cid,21,1,1)";
    mysql_w_query($sql);
    if ($robot_level<5){
        $tactic_id = 1;
        $tactic_level = 1;
    } elseif ($robot_level<8){
        $tactic_id = rand(1,3);
        $tactic_level = 1;
    } else{
        $tactic_id = rand(1,4);
        $tactic_level = 2;
    }
    $tactic_base_rate = update_tactic_chance($cid,$tactic_id,$formation_id,$tactic_level);
    $sql = "INSERT INTO c_tactic (cid,tactic_id,in_use,chance) VALUES($cid,$tactic_id,1,$tactic_base_rate)";
    mysql_w_query($sql);
 
    $sql = "INSERT INTO `p_player_youth_study_site`(`cid`,`study_lev`) VALUES ($cid,1)";
    mysql_w_query($sql);
	
    //生成雇员
    $sql_insert = array();
    for($i=1;$i<=5;$i++){
        $employe_lev = 1;		 
        $nid = 105;
        $name = player_gen_name($nid);
        $employee[$i] = array( 'typ'=>$i,
            'employe_name'=>$name['player_name'],
            'employe_lev'=>1);
    }
    $extend_info['cid'] = $cid;
    $extend_info['employee'] = $employee;
    //club_write_back_extend_data($cid,$extend_info);
    set_cache($cid,'club_info_extend',$extend_info,1);
    $sql = "INSERT INTO c_club_info_extend (cid,json_data) VALUES($cid,'".mysql_real_escape_string(json_encode($extend_info))."')";;
    mysql_x_query($sql);
    become_robot($uid,$robot_level);    
    
    
}

$g_version_op = $g_old_version_op;
robot_update_list();
$json_rst['error'] = '生成10条机器人数据';
?>