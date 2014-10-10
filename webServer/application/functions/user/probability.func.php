<?
function youth_get_refresh_probalility($typ,$counter,$youth_assit_level){
    //原来是1/1000-30/1000概率
    if ($youth_assit_level<=0){
        $youth_assit_level = 1;
    } else {
        $youth_assit_level = ceil($youth_assit_level/10);
        if ($youth_assit_level>5){
            $youth_assit_level = 5;
        }
    }
    //$youth_assit_level除以10后最大值6
    switch ($typ){
        case 'football_coin':
            //橙色不走这个，否则配置列表太长了
            if ($counter>400/$youth_assit_level){
                //清0   ，外面做             
                return 5;
            }
            $max = 20;
            $pro_list = array(1,3,2,2,3,
                              2,1,2,2,1,
                              3,4,2,2,1,
                              1,2,2,3,2);
            break;
        case 'refresh_vocher':
            //刷新券
            //15-180次出橙，
            //30级助教，30/10=3，90/3=30,大概25次出橙
            //20-29级，75/2 = 38
            if ($counter>90/$youth_assit_level){
                //清0   ，外面做
                return 5;
            }
            if ($counter>55/$youth_assit_level){
                if (mt_rand(1,100)>50){
                    return 5;
                }
            }
            $max = 20;
            $pro_list = array(3,4,3,3,2,
                              3,3,4,2,3,
                              4,4,3,2,3,
                              3,3,2,3,4);
            break;
        
        case 'real_credits':
            //点券，调紫色略高
            //29点券一次刷新，13次左右出橙
            //33/1000 - 60/1000
            if ($counter%13==6){
                return 5;
            }
            $max = 20;
            $pro_list = array(4,3,4,3,3,
                              3,3,4,3,4,
                              3,4,3,3,4,
                              4,3,3,4,3);
            break;
    }
    return $pro_list[$counter%$max];
}

function transfer_get_refresh_probalility($cid,$typ,$counter){
    global $g_user_extend;
    //原来概率需要乘8
    $max = 10;
    switch ($typ){        
        case 'free':
            //$quality = common_lottery(array(1=>600,2=>296,3=>100,4=>3,5=>1));
            //千分之8出橙，放在偏中间的地方
            if ($counter%135==70){
                //检查全服掉率，如果全服允许掉落再说
                $t = user_refresh_character_limit();
                if ($t==5){
                    user_reset_probability_info($cid,'refresh_player',1);
                    return array(1,1,2,3,1,2,3,5);    
                } else {
                    //改为三紫色
                    return array(1,4,2,1,4,2,1,4);    
                }
                
            }
            //千分之24出紫
            if ($counter%41==40){
                return array(2,1,1,2,3,2,1,4);
            }
            $rand = mt_rand(2,4);
            for ($i=0;$i<$rand;$i++){
                $rst_pro[] = 3;
            }
            $count_now = count($rst_pro);
            for ($i=$count_now;$i<8;$i++){
                $rst_pro[] = 2;
            }
        break;
        case 'refresh_vocher':
            //刷新券
            
            if ($g_user_extend['total_pay']==0){
                if ($counter<=6){
                    $rst_pro[] = 4;
                } elseif ($counter>=20){
                    $rst_pro[] = 5;
                    user_reset_probability_info($cid,'refresh_player',4);
                } else {
                    $quality = common_lottery(array(4=>19,5=>1));
                    if ($quality==5){
                        $rst_pro[] = 5;
                        user_reset_probability_info($cid,'refresh_player',4);
                    } else {
                        $rst_pro[] = 4;
                    }
                }
            } else {
                if ($counter<=4){
                    $rst_pro[] = 4;
                } elseif ($counter>=14){
                    $rst_pro[] = 5;
                    user_reset_probability_info($cid,'refresh_player',4);
                } else {
                    $quality = common_lottery(array(4=>14,5=>1));
                    if ($quality==5){
                        $rst_pro[] = 5;
                        user_reset_probability_info($cid,'refresh_player',4);
                    } else {
                        $rst_pro[] = 4;
                    }
                }
            }            
            
            $quality = common_lottery(array(4=>5,3=>5));
            $rst_pro[] = $quality;
            $count_now = count($rst_pro);
            for ($i=$count_now;$i<8;$i++){
                $rst_pro[] = 3;
            }
            
        break;
        
        case 'real_credits':
            //39点券刷一次，390点券出一个橙
            //$quality = common_lottery(array(3=>90,4=>9,5=>1));
            //点券紫色提高，每次1紫或者1橙
            if ($counter<=4){
                $rst_pro[] = 4;
            } elseif ($counter>=10){
                $rst_pro[] = 5;
                user_reset_probability_info($cid,'refresh_player',2);
            } else {
                $quality = common_lottery(array(4=>9,5=>1));
                if ($quality==5){
                    $rst_pro[] = 5;
                    user_reset_probability_info($cid,'refresh_player',2);
                } else {
                    $rst_pro[] = 4;
                }
            }            
            $count_now = count($rst_pro);
            for ($i=$count_now;$i<8;$i++){
                $rst_pro[] = 3;
            }   
        break;
    }
    
    shuffle($rst_pro);
    return $rst_pro;
    
}

function transfer_get_black_market_probability($typ,$counter){
    //黑市概率
    switch ($typ){
        case 'football_coin':
            //橙色不走这个，否则配置列表太长了
            if ($counter%250==131){
                return 5;
            }
            $max = 20;
            //common_lottery(array(2=>10,3=>9,4=>1));
            $pro_list = array(2,3,3,2,2,
                              3,2,2,3,3,
                              3,2,3,2,4,
                              2,3,3,2,2);
            break;
        case 'refresh_vocher':
            //刷新券
            //$quality = common_lottery(array(3=>6,4=>3,5=>1));
            $max = 20;
            //common_lottery(array(2=>10,3=>9,4=>1));
            $pro_list = array(3,4,3,3,4,
                              3,4,3,3,5,
                              4,3,3,4,3,
                              4,3,5,3,3);
            break;
        
        case 'real_credits':
            //点券，调紫色略高
            //$quality = common_lottery(array(3=>5,4=>4,5=>1));
            $max = 20;
            $pro_list = array(4,3,4,3,5,
                              3,3,4,3,4,
                              3,4,5,3,4,
                              4,3,3,4,3);
            break;
    }
    return $pro_list[$counter%$max];
}

function player_package_get_probability($package_source,$item_id,$counter){
    //不同包出橙概率不同
    //保证1个紫色，所以紫色直接返回
    //最后做一次shuffle，决定位置
    //返回值最终就是位置=>颜色的结构
    //$counter为开包次数，
    
    $rst_pro[] = 4;
    switch ($item_id) {
        case 7:
            //英超 7%
            $max = 20;//max为组数不是个数
            //第二，三个位置的概率，连续两个一组
            switch ($package_source){
                //$package_source：'1:点券购买;2 :礼券兑换;0:掉落; '
                case 1:
                    if ($counter>=500){
                        $rst_pro[] = 5;
                        $rst_pro[] = mt_rand(3,4);
                        return $rst_pro;
                    }
                    $pro_list = array(3,4,
                              3,3,
                              4,3,
                              3,3,
                              4,3,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5);
                    break;
                case 2:
                    if ($counter>=500){
                        $rst_pro[] = 5;
                        $rst_pro[] = mt_rand(3,4);
                        return $rst_pro;
                    }
                    $pro_list = array(3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5);
                    break;
                case 0:
                    if ($counter>=500){
                        $rst_pro[] = 5;
                        $rst_pro[] = mt_rand(3,4);
                        return $rst_pro;
                    }
                    $pro_list = array(3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5);
                    break;
            }
                       
            break;
        case 8:
            //意甲
            //5%
            $max = 20;//max为组数不是个数
            //第二，三个位置的概率，连续两个一组
            switch ($package_source){
                //$package_source：'1:点券购买;2 :礼券兑换;0:掉落; '
                case 1:
                    if ($counter>=500){
                        $rst_pro[] = 5;
                        $rst_pro[] = mt_rand(3,4);
                        return $rst_pro;
                    }
                    $pro_list = array(3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5);
                    break;
                case 2:
                    if ($counter>=500){
                        $rst_pro[] = 5;
                        $rst_pro[] = mt_rand(3,4);
                        return $rst_pro;
                    }
                    $pro_list = array(3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5);
                    break;
                case 0:
                    if ($counter>=500){
                        $rst_pro[] = 5;
                        $rst_pro[] = mt_rand(3,4);
                        return $rst_pro;
                    }
                    $pro_list = array(3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5);
                    break;
            }
            break;
        case 11:
            //德甲
            //4%
            $max = 20;//max为组数不是个数
            //第二，三个位置的概率，连续两个一组
            switch ($package_source){
                //$package_source：'1:点券购买;2 :礼券兑换;0:掉落; '
                case 1:
                    if ($counter>=500){
                        $rst_pro[] = 5;
                        $rst_pro[] = mt_rand(3,4);
                        return $rst_pro;
                    }
                    $pro_list = array(3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5);
                    break;
                case 2:
                    if ($counter>=500){
                        $rst_pro[] = 5;
                        $rst_pro[] = mt_rand(3,4);
                        return $rst_pro;
                    }
                    $pro_list = array(3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5);
                    break;
                case 0:
                    if ($counter>=500){
                        $rst_pro[] = 5;
                        $rst_pro[] = mt_rand(3,4);
                        return $rst_pro;
                    }
                    $pro_list = array(3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5);
                    break;
            }
            break;
        case 12:
            //法甲
            //2%
            $max = 20;//max为组数不是个数
            //第二，三个位置的概率，连续两个一组
            switch ($package_source){
                //$package_source：'1:点券购买;2 :礼券兑换;0:掉落; '
                case 1:
                    if ($counter>=500){
                        $rst_pro[] = 5;
                        $rst_pro[] = mt_rand(3,4);
                        return $rst_pro;
                    }
                    $pro_list = array(3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5);
                    break;
                case 2:
                    if ($counter>=500){
                        $rst_pro[] = 5;
                        $rst_pro[] = mt_rand(3,4);
                        return $rst_pro;
                    }
                    $pro_list = array(3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5);
                    break;
                case 0:
                    if ($counter>=500){
                        $rst_pro[] = 5;
                        $rst_pro[] = mt_rand(3,4);
                        return $rst_pro;
                    }
                    $pro_list = array(3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5);
                    break;
            }
            break;
        case 13:
            //西甲
            //8%
            $max = 20;//max为组数不是个数
            //第二，三个位置的概率，连续两个一组
            switch ($package_source){
                //$package_source：'1:点券购买;2 :礼券兑换;0:掉落; '
                case 1:
                    if ($counter>=500){
                        $rst_pro[] = 5;
                        $rst_pro[] = mt_rand(3,4);
                        return $rst_pro;
                    }
                    $pro_list = array(3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5);
                    break;
                case 2:
                    if ($counter>=500){
                        $rst_pro[] = 5;
                        $rst_pro[] = mt_rand(3,4);
                        return $rst_pro;
                    }
                    $pro_list = array(3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5);
                    break;
                case 0:
                    if ($counter>=500){
                        $rst_pro[] = 5;
                        $rst_pro[] = mt_rand(3,4);
                        return $rst_pro;
                    }
                    $pro_list = array(3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5);
                    break;
            }
            break;
        default:
            $max = 20;//max为组数不是个数
            //第二，三个位置的概率，连续两个一组
            switch ($package_source){
                //$package_source：'1:点券购买;2 :礼券兑换;0:掉落; '
                case 1:
                    if ($counter>=500){
                        $rst_pro[] = 5;
                        $rst_pro[] = mt_rand(3,4);
                        return $rst_pro;
                    }
                    $pro_list = array(3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5);
                    break;
                case 2:
                    if ($counter>=500){
                        $rst_pro[] = 5;
                        $rst_pro[] = mt_rand(3,4);
                        return $rst_pro;
                    }
                    $pro_list = array(3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5);
                    break;
                case 0:
                    if ($counter>=500){
                        $rst_pro[] = 5;
                        $rst_pro[] = mt_rand(3,4);
                        return $rst_pro;
                    }
                    $pro_list = array(3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5,
                              
                              3,4,
                              5,3,
                              4,5,
                              3,5,
                              4,5);
                    break;
            }
            break;
    }
    $rst_pro[] = $pro_list[$counter%($max*2)];
    $rst_pro[] = $pro_list[($counter+1)%($max*2)];
    shuffle($rst_pro);
    return $rst_pro;
}

function user_get_probability_info($cid,$system,$typ){
    $user_extend = user_get_user_extend($cid);
    //处理历史遗留数据先
    if(isset($user_extend['probability_counter']) && ($user_extend['probability_counter'])!=''){
        $probability_counter = json_decode($user_extend['probability_counter'],true);
        if (!isset($probability_counter[$system][$typ])) {
            $probability_counter[$system][$typ] = 0;
        }
    }else{
        $this_info = json_decode($user_extend['json_data'],true);
        if (isset($this_info['probability_counter'])){
            $probability_counter = $this_info['probability_counter'];
            if (!isset($probability_counter[$system][$typ])) {
                $probability_counter[$system][$typ] = 0;
            }
        } else {
            $probability_counter = array();
            $probability_counter[$system][$typ] = 0;
        }
        
    }
    
    return $probability_counter[$system][$typ];
}

function user_get_probability_info_and_next($cid,$system,$typ){
    $user_extend = user_get_user_extend($cid);
    //处理历史遗留数据先
    if(isset($user_extend['probability_counter']) && ($user_extend['probability_counter'])!=''){
        $probability_counter = json_decode($user_extend['probability_counter'],true);
        if (!isset($probability_counter[$system][$typ])) {
            $probability_counter[$system][$typ] = 0;
        }
    }else{
        $this_info = json_decode($user_extend['json_data'],true);
        if (isset($this_info['probability_counter'])){
            $probability_counter = $this_info['probability_counter'];
            if (!isset($probability_counter[$system][$typ])) {
                $probability_counter[$system][$typ] = 0;
            }
        } else {
            $probability_counter = array();
            $probability_counter[$system][$typ] = 0;
        }
        
    }
    
    $probability_counter[$system][$typ]++;
    $change['probability_counter'] = json_encode($probability_counter);
    user_write_back_extend_data($cid,$user_extend,$change);
    return $probability_counter[$system][$typ]-1;
}

function user_reset_probability_info($cid,$system,$typ){
    $user_extend = user_get_user_extend($cid);
    $probability_counter = json_decode($user_extend['probability_counter'],true);
    $probability_counter[$system][$typ] = 0;
    $change['probability_counter'] = json_encode($probability_counter);
    user_write_back_extend_data($cid,$user_extend,$change);
}

/**
 * @param $cid
 * @param $system
 * @param $typ
 * @param $item_id
 * @author BELEN
 * @action 1:加人品值 2:减人品值
 * 开球员包或得人品值
 */
function user_get_probability_info_and_next_for_open_player_package($cid,$system,$typ,$item_id,$action=1){
    $user_extend = user_get_user_extend($cid);
    
    //处理历史遗留数据先
    if(isset($user_extend['probability_counter']) && ($user_extend['probability_counter'])!=''){
        $probability_counter = json_decode($user_extend['probability_counter'],true);
        if (!isset($probability_counter[$system][1])) {
            $probability_counter[$system][1] = 0;
        }
    }else{
        $this_info = json_decode($user_extend['json_data'],true);
        if (isset($this_info['probability_counter'])){
            $probability_counter = $this_info['probability_counter'];
            if (!isset($probability_counter[$system][1])) {
                $probability_counter[$system][1] = 0;
            }
        } else {
            $probability_counter = array();
            $probability_counter[$system][1] = 0;
        }
        
    }
    //开出橙色球员减500人品值
    if(2 == $action){
        $probability_counter[$system][1] = $probability_counter[$system][1]-500;
        $change['probability_counter'] = json_encode($probability_counter);
        user_write_back_extend_data($cid,$user_extend,$change);
        return;
    }
    if(7 == $item_id){
        $add_counter = 219;//英超包
    }elseif(8 == $item_id){
        $add_counter = 99;//意甲包
    }elseif(11 == $item_id){
        $add_counter = 99;//德甲包
    }elseif(12 == $item_id){
        $add_counter = 59;//法甲包
    }elseif(13 == $item_id){
        $add_counter = 199;//西甲包
    }else{
        return -1;
    }

    if(1 == $typ){
        $rate_counter = 1;//点券
    }elseif(2 == $typ){
        $rate_counter = 0.8;//礼券
    }elseif(3 == $typ){
        $rate_counter = 0.5;//掉落
    }else{
        $rate_counter = 0;
    }
    //当前人品值
    $current_counter = $probability_counter[$system][1];
    $probability_counter[$system][1] = $current_counter+round($add_counter*$rate_counter);

    $change['probability_counter'] = json_encode($probability_counter);
    user_write_back_extend_data($cid,$user_extend,$change);
    return $current_counter;
}

?>