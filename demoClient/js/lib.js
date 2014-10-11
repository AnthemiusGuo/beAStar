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

function genUuid(){
	var S4 = function () {
        return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
    };
    return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
}

function uuid(){
	var uuid = getLocal("uuid",false);
	if (uuid) {
		return uuid;
	} else {
		uuid = genUuid();
		setLocal("uuid",uuid);
		return uuid;
	}
}

function getLocal(key,dft){
	var storage = window.localStorage;
	var value = storage.getItem(key);
	if (!value) {
		return dft;
	} else {
		return value;
	}
}

function setLocal(key,value){
	var storage = window.localStorage;
	storage.setItem(key,value);
}

function ajax_get(opts){
    var dft_opt = {
        m: 'index',
        a: 'index',
        id: null,
        data: {},
        error_alert:1,
        callback: function(json){
            alert(json);
        },
        callback_fail: function(json){
            alert(json.error);
        }
    };
    opts = $.extend({},dft_opt,opts);
    console.log("ajax get",opts);
    // $.blockUI();
    var url = req_url_template.str_supplant({ctrller:opts.m,action:opts.a});
    if (opts.id!=null) {
    	url = url + req_id_template.str_supplant({id:opts.id});
    }
    $.each(opts.data,function(k,v){
        url = url + '&'+k+'='+v;
    });
    $.ajax( 
        {type: "GET",
        url: url,
        dataType:"json"}
    ).done(function(json) {
    	console.log("ajax get return",json);
    	if (json.rstno<0) {
			opts.callback_fail(json);
			return;
		} else {
			opts.callback(json);
		}
    }).fail(function() {
    	opts.callback_fail({rstno:-999,error:"网络错误或json解析失败"});
    }).always(function() {
        // $.unblockUI();
    });
}