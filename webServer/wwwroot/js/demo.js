


/*=======================*/
var my_uuid;

function get_my_uuid() {
    var storage = window.localStorage;
    my_uuid = storage.getItem("my_uuid");
    if (my_uuid==undefined) {
        my_uuid=$.uuid();
        storage.setItem("my_uuid", my_uuid);
    }
    console.log(my_uuid);
}

function check_uuid() {
    if (my_uuid==undefined) {
        $("#my_uuid").html('checking for uuid...');
        window.setTimeout(check_uuid,100);
    } else {
        $("#my_uuid").html('uuid:'+my_uuid);
    }
}

function send_login() {
    $.ajax_handler({m:'account',a:'test_login',plus:{uuid:my_uuid},callback:function(json){
		window.location.href=json.url;	
	}});
}

function send_demo(options) {
	this.defaults = {
		m: 'index',
		a: 'index',
		plus: {},
		callback: function(json){
			alert(json.error);
		}
	};
	var opts = $.extend({}, this.defaults, options);
	
	var url = 'test.php?m='+opts.m+'&a='+opts.a;
	$.each(opts.plus,function(index,val){url = url +'&'+index+'='+val});
	$.get(url,function(data){
		$("#demo_target").html(data);
	});
}




// Utilities
function log(msg){ $("#log").append("<br>"+msg); }
function onkey(event){ if(event.keyCode==13){ send(); } }