function consoleLog(tag,info){
	$("#console").append(tag+":"+info+"<br/>");
}

function updateUserInfo(userInfo){
	$("#userInfo").html(JSON.stringify(userInfo));
}

WEB_SOCKET_SWF_LOCATION = "js/WebSocketMain.swf";
var GAME_ID = 1;
var packetId = 0;
var uuid = uuid();
var uid = 0;
var gTicket = "";
var webUrl = "http://127.0.0.1/bestar/webServer/wwwroot/u.php";
var req_url_template = webUrl+"?m={ctrller}&a={action}";
var req_id_template = "&id={id}";
var nowRoomId = null;

function rand(min, max) {
  //  discuss at: http://phpjs.org/functions/rand/
  // original by: Leslie Hoare
  // bugfixed by: Onno Marsman
  //        note: See the commented out code below for a version which will work with our experimental (though probably unnecessary) srand() function)
  //   example 1: rand(1, 1);
  //   returns 1: 1

  var argc = arguments.length;
  if (argc === 0) {
    min = 0;
    max = 2147483647;
  } else if (argc === 1) {
    throw new Error('Warning: rand() expects exactly 2 parameters, 1 given');
  }
  return Math.floor(Math.random() * (max - min + 1)) + min;
}


// ajax_get({
//         m: 'index',
//         a: 'index',
//         id: '',
//         data: {},
//         error_alert:1,
//         callback: function(json){
//             alert(json);
//         }
//     });
$(function() {
	ajax_get({
        m: 'user',
        a: 'doLogin',
        id: '',
        data: {uuid:uuid},
        error_alert:1,
        callback: function(json){
        	gTicket = json.data.ticket;
        	updateUserInfo(json.data.user_info);
            consoleLog("web","login suceess!!! ticket:"+gTicket);
        },
        callback_fail: function(json){
            consoleLog("web","login failed!!!");
        },
    });

});

setInterval(function(){
	ajax_get({
        m: 'user',
        a: 'doRefresh',
        id: '',
        data: {uid:uid},
        error_alert:1,
        callback: function(json){
        	if (typeof(json.data.ticket)!="undefined"){
				gTicket = json.data.ticket;	
			}
            if (json.ret!=1) {
				consoleLog("web","refresh failed!!!");
				return;
			}
        }
    });
},180000)