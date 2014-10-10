if (!String.prototype.str_supplant) {
    String.prototype.str_supplant = function (o) {
        return this.replace(/{([^{}]*)}/g,
            function (a, b) {
                var r = o[b];
                return typeof r === 'string' || typeof r === 'number' ? r : a;
            }
        );
    };
}

if (!String.prototype.trim) {
    String.prototype.trim = function () {
        return this.replace(/^\s*(\S*(?:\s+\S+)*)\s*$/, "$1");
    };
}

function log(msg){ 
	console.log(msg);
}

function common_get_zipd_number(src){
	if (src<0){
		var pre = '-';
		src = 0 - src;
	} else {
		var pre = '';
	}
	if(src<10000){

		return pre+src;
	}
    if(src<100000000){
		rst = (src/10000)+'万';
		return pre+rst;
	}else{
		rst = (Math.round(src/100000000,4))+'亿';
		return pre+rst;
	}
}

var zha_server_info;
var zha_room_info;
var zha_room_id;
var zha_table_id;
var zha_my_bet_info = [0,0,0,0];
var zha_total_bet_info = [0,0,0,0];
var socket;
var my_uuid;
var uid;
var sid;
var in_game = 0;
var credits = 0;
var credits_hold = 0;
function s_init(ip,port){
	has_bet = 0;
    var host = "ws://"+ip+":"+port+"/card";
    try{
		socket = new WebSocket(host);
		log('WebSocket - status '+socket.readyState);
		socket.onopen    = function(msg){
			log("Welcome - status "+this.readyState);
			var smsg = {m:'user',a:'login','uuid':my_uuid,'uid':uid,'sid':sid};
			send(smsg);
		};
		socket.onmessage = function(msg){
			var data = JSON.parse(msg.data);
			if (data.event!=6){
				log("Received: "+msg.data);
			}
			process(data);
		};
		socket.onclose   = function(msg){ 
			if (manual_close_game==1){

			} else {
				fail_connect(this.readyState);
				log("Disconnected - status "+this.readyState); 
			}
			
		};
	}
	catch(ex){
		log(ex);
	}
}


function process(data){
	
	switch (data.event) {
		case 0:
				$.unblockUI();
				_show_status(data.status);
				
				_show_total_bet(data.total_bet_info);
				_show_my_bet(data.my_bet_info);
				if (data.status==1) {
					_show_cd(data.cd);
				} else if (data.status==3) {
					_reset_cd();
					_kaipai_pre(data);
					
				} else {
					_reset_cd();
				}
				get_user_list(zha_room_id,zha_table_id);
			break;
		case 1:
				_reset_pai();
				_show_status(data.status);
				_show_cd(data.cd);

			break;
		case 2:
				_show_status(data.status);
				_reset_cd();
			break;
		
		case 3:
				_show_status(data.status);
				_kaipai(data);
				_reset_cd();
			break;
		case 4:
			break;
		case 5:
				zha_total_bet_info = data.total_bet_info;
				_show_total_bet(zha_total_bet_info);
				zha_my_bet_info = data.my_bet_info;
				_show_my_bet(zha_my_bet_info);
			break;
		case 6:
				_show_total_bet(data.total_bet_info);
			break;
		case -1:
			//报错
			alert(data.err_no);
			break;
	}
}

var str_of_huase = ['♤黑','♡红','♧梅','♢方'];
var str_of_dianshu = ['2','3','4','5','6','7','8','9','10','J','Q','K','A'];
var str_status = ['初始化','下注','买定离手等待开牌','开牌'];
var str_of_paixing = {6:'豹子',
					5:'顺金',
					4:'金花',
					3:'顺子',
					2:'对子',
					1:'散牌'};
var class_of_result = ["cg","cr","cy"];
var str_of_result = ['<span class="c_r">负</span>','<span class="c_g">胜</span>'];

var server_status = 0;
function _show_status(status){
	server_status = status;
	
	$("#status").html(str_status[server_status]);
}

function _reset_pai() {
	$("#zhuang_open").html('');
	$("#xian1 .open").html('');
	$("#xian2 .open").html('');
	$("#xian3 .open").html('');
	$("#xian4 .open").html('');

	credits_hold = 0;

	zha_my_bet_info = [0,0,0,0];
	_show_my_bet(zha_my_bet_info);

	zha_total_bet_info  = [0,0,0,0];
	_show_total_bet(zha_total_bet_info);
}

function real_cd() {
	$(".counterdown").each(function(){
		cd = parseInt($(this).html());
		if (cd>0) {
			$(this).show();
			cd -- ;
			$(this).html(cd);
		} else {
			$(this).hide();
		}

	});
}

function send(msg){
	try{
		var to_send = JSON.stringify(msg);
		socket.send(to_send);
		log('Sent: '+to_send);
	}
	catch(ex){
		log(ex);
	}
}
function quit_game(){
  log("Goodbye!");
  socket.close();
  socket=null;

}

function add_point(men,point) {
	if (point*10 > credits-credits_hold){
		game_info('不可下注','您必须保持下注金额10倍以上的游戏币!');
		return;
	}
	var smsg = {m:'zha',a:'add_point',men:men,point:point};
	send(smsg);
}

var zha_now_chip;
function get_can_use_chip(credits){
// 	游戏币持有量	筹码面值
// 1000-9999	10.20.50
// 10000-29999	20.50.100
// 30000-49999	50.100.200
// 50000-199999	100.200.500
// 200000-499999	500.1000.2000
// 500000-999999	1000.2000.5000
// 1000000-2999999	2000.5000.1W
// 3000000-4999999	5000.1W.2W
// 5000000-19999999	1W.2W.5W
// 2000W以上	2W.5W.10W
	if (credits<=9999){
		return [10,20,50];
	} else if (credits<=29999){
		return [20,50,100];
	} else if (credits<=49999){
		return [50,100,200];
	} else if (credits<=199999){
		return [100,200,500];
	} else if (credits<=499999){
		return [500,1000,2000];
	} else if (credits<=999999){
		return [1000,2000,5000];
	} else if (credits<=2999999){
		return [2000,5000,10000];
	} else if (credits<=4999999){
		return [5000,10000,20000];
	} else if (credits<=19999999){
		return [10000,20000,50000];
	} else {
		return [20000,50000,100000]
	}

}