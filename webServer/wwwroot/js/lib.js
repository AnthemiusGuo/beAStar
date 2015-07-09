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

(function($) {
  $.uuid = function() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
            return v.toString(16);
        });
    };
})(jQuery);

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

function myParseFloat(input){
    var ret = parseFloat(input);
    console.log(ret);
    if (isNaN(ret)){
        return 0
    } else {
        return ret;
    }
}

function refresh(){
    window.location.href = window.location.href;
}
function gotoPage(m,a){
    window.location.href = req_url_template.str_supplant({ctrller:m,action:a});;
}
function gotoUrl(url){
    window.location.href = url;
}
function ajax_get(opts){
    var dft_opt = {
        m: 'index',
        a: 'index',
        id: '',
        data: {},
        popSuccess : 1,//0->不提示 1->提示
        popError : 1,//0->不提示 1->提示
        successCallback : null,
        errorCallback : null,
    };
    opts = $.extend({},dft_opt,opts);
    $.blockUI({ css: {
            border: 'none',
            padding: '15px',
            backgroundColor: '#000',
            'border-radius': '5px',
            opacity: .7,
            color: '#fff'
        },
        message:  '<h3>请稍候</h3>'  });
    var url = req_url_template.str_supplant({ctrller:opts.m,action:opts.a});
    url = url + '/'+opts.id;
    $.each(opts.data,function(k,v){
        url = url + '&'+k+'='+v;
    });
    $.ajax(
        {type: "GET",
        url: url,
        dataType:"json"}
    ).done(function(json) {
        $.unblockUI();
         if(json.rstno == 1)  {
            if (opts.popSuccess === 1){alertPlug.alert(json.data['err']['msg'],'s') };
            if (opts.successCallback != null) {opts.successCallback.apply( this,arguments)};
        } else {
           if (opts.popError === 1){ alertPlug.alert(json.data['err']['msg'],'e') };
           if (opts.errorCallback != null) {opts.errorCallback.apply( this,arguments)};
        }
    }).fail(function() {
       $.unblockUI();
       alert('网络故障，请稍候重试');
    }).always(function() {
        //$.unblockUI();
    });
}
function ajax_post(opts){
    var dft_opt = {
        m: 'index',
        a: 'index',
        url: null,
        plus: '',
        data: {},
        popSuccess : 1,//0->不提示 1->提示
        popError : 1,//0->不提示 1->提示
        autoBlock: 1,
        successCallback : null,
        errorCallback : null,
    };
    opts = $.extend({},dft_opt,opts);
    if (opts.autoBlock==1){
        $.blockUI({ css: {
            border: 'none',
            padding: '15px',
            backgroundColor: '#000',
            'border-radius': '5px',
            opacity: .7,
            color: '#fff'
        },
        message:  '<h3>请稍候</h3>' });
    }
    if (opts.url==null){
        var url = req_url_template.str_supplant({ctrller:opts.m,action:opts.a})+'/'+opts.plus;
    } else {
        var url = opts.url+'/'+opts.plus;
    }

    $.ajax(
        {type: "POST",
        url: url,
        dataType:"json",
        data: opts.data}
    ).done(function(json) {
        if (opts.autoBlock==1){
            $.unblockUI();
        }

        if(json.rstno >= 1)  {
            if (opts.popSuccess === 1){alertPlug.alert(json.data['err']['msg'],'s') };
            if (opts.successCallback != null) {opts.successCallback.apply( this,arguments)};
        } else {
           if (opts.popError === 1){ alertPlug.alert(json.data['err']['msg'],'e') };
           if (opts.errorCallback != null) {opts.errorCallback.apply( this,arguments)};
        }
    }).fail(function() {
        if (opts.autoBlock==1){
            $.unblockUI();
        }
        alert('网络故障，请稍候重试');
    }).always(function() {
        //$.unblockUI();
    });
}

function ajax_load(selector,url) {
    $(selector).load(url);
}


function reqOperator(url_m,url_a,id,data){
    if (typeof(data)=="undefined"){
        data = {};
    }
    ajax_post({
            m:url_m,a:url_a,
            plus:id,data:data,
            popSuccess:0,
            successCallback:function(json){
            if (json.rstno>0){
                alertPlug.alert("操作成功! ",'s');
                if (json.data.goto_url!=undefined) {
                    window.location.href=json.data.goto_url;
                }

            } else {
                alertPlug.alert(json.data.err.msg);
            }
        }
    });
}

function reqOpInputs(url_m,url_a,id,data,inputs){
    if (typeof(data)=="undefined"){
        data = {};
    }
    $.each(inputs,function(k,v){
        data[v] = $("#"+v).val();
    });
    ajax_post({m:url_m,a:url_a,plus:id,data:data,popSuccess:0,successCallback:function(json){
            if (json.rstno>0){
                alertPlug.alert("操作成功! ",'s');
                if (json.data.goto_url!=undefined) {
                    window.location.href=json.data.goto_url;
                }

            } else {
                alertPlug.alert(json.data.err.msg);
            }
        }
    });
}

var alertPlug = {};
alertPlug.alert = function(msg){
    alert(msg);
}
