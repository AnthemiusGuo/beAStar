<?php
function laba_analyse_typ($cards,$cColor){
    $huase = array();
    $dianshu = array();
    foreach ($cards as $card){
        $huase[] = (int)($card / 13);
        $dianshu[] = $card % 13;        
    }
    sort($dianshu);
    #����>ͬ��˳>��>˳��>����>ɢ��
    if ($dianshu[0]==$dianshu[1] && $dianshu[1]==$dianshu[2]) {
        if ($dianshu[0] ==12) {
            return 0;//����
        }else{
            return 1;
        }
        #����
    }
    if ($huase[0]==$huase[1] && $huase[1]==$huase[2]) {
		if($dianshu[2]==12&&$dianshu[1]==1&&$dianshu[0]==0){
			return 2;#ͬ��˳
		}else{
			if ($dianshu[0] == $dianshu[1]-1 && $dianshu[1]==$dianshu[2]-1){
				return 2;
				#ͬ��˳
			} else {
				return 5;//��
			}
		}
        
        
    }
    if($dianshu[2]==3&&$dianshu[1]==1&&$dianshu[0]==0){
		return 3;//����
	}
	if($dianshu[2]==12&&$dianshu[1]==1&&$dianshu[0]==0){
		return 4;//˳��
	}
    if ($dianshu[0] == $dianshu[1]-1 && $dianshu[1]==$dianshu[2]-1){
        return 4;
        #˳��
    } 
    if ($dianshu[0]==$dianshu[1]) {
        return 6;
        #����
    }
    if ($dianshu[1]==$dianshu[2]) {
        return 6;
        #����
    }
    if (($huase[0]==$cColor and $huase[1]==$cColor) or ($huase[2]==$cColor and $huase[1]==$cColor) or ($huase[2]==$cColor and $huase[0]==$cColor) ){
        return 7;
    }
    if ($huase[0]==$cColor or $huase[1]==$cColor or $huase[2]==$cColor) {
        return 8;
    }
    return 9;

}