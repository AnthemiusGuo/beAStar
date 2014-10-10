(function ($) {
    $.extend({
        ajax_req: function (options) {
            this.defaults = {
				m: 'index',
				a: 'index',
                h: 0,
                auto_relogin: 1,
				plus: {},
				error_alert:1,
				callback: function(json){
					alert(json.error);
				}
			};
			var opts = $.extend({}, this.defaults, options);
			
			var url = 'w.php?m='+opts.m+'&a='+opts.a;
            if (opts.h==1) {
                url += '&h=1';
            }
			$.each(opts.plus,function(index,val){url = url +'&'+index+'='+val});
			$.getJSON(url,{},function(json){
                if (opts.auto_relogin==1 && json.rstno==-99){
                    window.location.reload();
                    return;
                }
				if (opts.h==1&&opts.m!='account') { 
					if (json.rstno>=1) {						
						if (json.level!=undefined) {
							g_level = json.level;
						}
						if (json.credits!=undefined) {
							g_credits = json.credits;
						}
						if (json.total_credits!=undefined) {
							g_total_credits = json.total_credits;
						}
						if (json.credits!=undefined) {
							//code
							if (g_total_credits<1000) {
								//推荐购买vip获取金币
								show_lightbox('recommend');
							}else if (g_credits<1000) {
								//保险箱里还有金币
								alert("您的现金少于1000无法正常游戏，去保险箱取一些出来吧！")
							}
						}
						
					}else{
						if (opts.error_alert==1) {
							//code
							alert(json.error);
						}
						
					}
				}
				
				opts.callback.apply(this,arguments);
			});
        },
        ajax_load: function (options) {
            this.defaults = {
				view: 'index',
                dom: '',
                dom_x: undefined,
				plus: {},
				callback: function(){
					
				}
			};
            var opts = $.extend({}, this.defaults, options);
            var url = './js_temp/'+opts.view+'.htm';
            $.get(url,function(_html){
                if (opts.dom_x!=undefined){
                    opts.dom_x.html(_html);
                } else {
                    $(opts.dom).html(_html);
                }
                
                opts.callback.apply(this,arguments);
            }); 
        },
        uuid: function (){
            var uuid = $.localStorage('uuid');
            if (uuid==null){
                var d = new Date().getTime();
                uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
                    var r = (d + Math.random()*16)%16 | 0;
                    d = Math.floor(d/16);
                    return (c=='x' ? r : (r&0x7|0x8)).toString(16);
                });
                $.localStorage('uuid',uuid);
            }
            return uuid;
        },

        
    });
    
})(jQuery);
;(function($, window, document) {
    'use strict';

    $.map(['localStorage', 'sessionStorage'], function( method ) {
        var defaults = {
            cookiePrefix : 'fallback:' + method + ':',
            cookieOptions : {
                path : '/',
                domain : document.domain,
                expires : ('localStorage' === method) ? { expires: 365 } : undefined
            }
        };

        try {
            $.support[method] = method in window && window[method] !== null;
        } catch (e) {
            $.support[method] = false;
        }

        $[method] = function(key, value) {
            var options = $.extend({}, defaults, $[method].options);

            this.getItem = function( key ) {
                var returns = function(key){
                    return JSON.parse($.support[method] ? window[method].getItem(key) : $.cookie(options.cookiePrefix + key));
                };
                if(typeof key === 'string') return returns(key);

                var arr = [],
                    i = key.length;
                while(i--) arr[i] = returns(key[i]);
                return arr;
            };

            this.setItem = function( key, value ) {
                value = JSON.stringify(value);
                return $.support[method] ? window[method].setItem(key, value) : $.cookie(options.cookiePrefix + key, value, options.cookieOptions);
            };

            this.removeItem = function( key ) {
                return $.support[method] ? window[method].removeItem(key) : $.cookie(options.cookiePrefix + key, null, $.extend(options.cookieOptions, {
                    expires: -1
                }));
            };

            this.clear = function() {
                if($.support[method]) {
                    return window[method].clear();
                } else {
                    var reg = new RegExp('^' + options.cookiePrefix, ''),
                        opts = $.extend(options.cookieOptions, {
                            expires: -1
                        });

                    if(document.cookie && document.cookie !== ''){
                        $.map(document.cookie.split(';'), function( cookie ){
                            if(reg.test(cookie = $.trim(cookie))) {
                                 $.cookie( cookie.substr(0,cookie.indexOf('=')), null, opts);
                            }
                        });
                    }
                }
            };

            if (typeof key !== "undefined") {
                return typeof value !== "undefined" ? ( value === null ? this.removeItem(key) : this.setItem(key, value) ) : this.getItem(key);
            }

            return this;
        };

        $[method].options = defaults;
    });
}(jQuery, window, document));

function lightbox_show(options){
    this.defaults = {
        view: 'index',
        size: 'l'
    };

    var opts = $.extend({}, this.defaults, options);
	if(g_is_anonym==1){
		game_info('您是游客，无法使用该功能!','请点击个人头像完成注册');
		return;
	}
    $("#lightbox_mask").css({opacity:0.5,height:'100%'}).show();
    switch(opts.size){
        case "xl":
            lightbox_width = 930;
            //lightbox_ct_main = 836;
            lightbox_c_height = 830;
            lightbox_height = 530;
            break;
        case "l":
            lightbox_width = 800;
            lightbox_c_height = 300;
            lightbox_height = 350;
            break;
        default:
            lightbox_width = 720;
            lightbox_height = 440;
            break;
    }
    var lightbox_margin = {
        l_top:-Math.round(lightbox_height/2),
        l_left:-Math.round(lightbox_width/2)
    }

    $.ajax_load({dom_x:g_lightbox_con_obj,view:opts.view});
    g_lightbox_con_obj.css({height:lightbox_c_height});
    g_lightbox_obj.show().css({top:'20%',width:lightbox_width,height:lightbox_height,marginLeft:lightbox_margin.l_left,marginTop:lightbox_margin.l_top}).animate({top:'50%'},"1.5s");
}

function lightbox_close(){
    g_lightbox_obj.animate({top:'20%'},400,function(){
        g_lightbox_obj.hide();
        $("#lightbox_mask").hide();
    });
}

//----------------------------------------------------------//
var js_temp;


//----------------------------------------------------------//
$(function(){
    my_uuid = $.uuid();
    check_login();
});

function check_login(){
    $.ajax_req({m:'index',
               a:'chk_login',
               auto_relogin:0,
               callback:function(json){
                    if (json.rstno==1) {
                        init_game(json);
                    } else if (json.rstno==-99) {
                        $.ajax_load({view:'login',dom:'#wrap'});
                    }
                }
    });
}

function hack_login(){
    var tuid = $("#hack_uid").val();
    $.ajax_req({m:'account',a:'test_login',h:1,plus:{uid:tuid,uuid:my_uuid},callback:function(json){
		init_game(json);
	}});
}

function init_game(json){
    window.setInterval(real_cd,1000);
    $.ajax_load({view:'total',
                dom:'#wrap'});
    uid = json.login_info.uid;
    sid = json.login_info.sid;
}
var g_userinfo;
function show_user_info(userinfo){
    g_userinfo = userinfo;
    credits = g_userinfo.credits;
    var js_temp_userinfo = '<img class="perimg" src="{avatar_url}" width="55px" height="55px"/><div class="perinfo_detail"><span>{uname}</span>'+
            '<span>游戏币:<a href="javascript:void(0);" id="credits_show" show_v="{credits}">{credits_show}</a></span><span>等级:{level}</span></div>';
    $("#perinfo").html(js_temp_userinfo.str_supplant(userinfo));
}

function show_license(){
    lightbox_show({view:'license'});
}

function show_lightbox(view) {
	lightbox_show({view:view});
}
var room_list_1 = undefined;
function show_game(game_id){
    if (game_id==1) {
        var _html_temp = '<li><a href="#" onclick="enter_zha_room({room_id})"><img src="images/game_1/pic_{room_id}.png"><span>入场限制 : {room_desc}</span></a></li>';
        var _html = '';
        if (room_list_1!=undefined) {
            $.each(room_list_1,function(k,v){
                _html += _html_temp.str_supplant(v);
            });
            $("#game_1 .game_sel_list").html(_html);
            $("#game_1").show();
        } else {
            
        }
    }
}

function enter_zha_room(room_id) {
    $.ajax_req({m:'zha',a:'ask_enter_room',plus:{room_id:room_id},callback:function(json){
        if (json.rstno<=0) {
            alert(json.error);
            return;
        }
        $.blockUI({ css: { 
            border: 'none', 
            padding: '15px', 
            backgroundColor: '#000', 
            '-webkit-border-radius': '10px', 
            '-moz-border-radius': '10px', 
            color: '#fff' 
        },
        overlayCSS:{
            opacity:0.3,
        },
        message:'正在连接服务器' }); 
		zha_room_info = json.room_info;
        zha_room_id = zha_room_info.room_id;
        zha_server_info = json.table_info;
        zha_table_id = zha_server_info.table_id;
        $("#container").hide();
        $("#container_game").css({height:0,opacity:0.1}).show().animate({height:481,opacity:1},{duration:400});
        $.ajax_load({view:'zha',
                dom:'#container_game',
                callback:function(){
                    s_init(zha_server_info.socket_ip,zha_server_info.port);
                },
            });
        in_game = 1;
        manual_close_game = 0;
        
        
	}});
}

function show_chip(){
    var credits = g_userinfo.credits;
    var chips = get_can_use_chip(credits);
    var _html = '';
    var _html_temp = '<li id="chip_{chip}" class="{vclass}"><a href="#" onclick="select_chip({chip})"><img src="images/chip/{chip}.png" width="35px" height="35px"></a></li>';
    $.each(chips,function(k,v){
        var vclass = '';
        if (k==2){
            vclass='selected';
            zha_now_chip = v;
        }
        _html += _html_temp.str_supplant({chip:v,vclass:vclass});
    });
    $("#chip_list").html(_html);
}

function select_chip(chip){
    $("#chip_list li").removeClass('selected');
    $("#chip_list li#chip_"+chip).addClass('selected');
    zha_now_chip = chip;
}

function game_info(title,msg){
    $.growlUI(title, msg);
}

function fail_connect(error_state){
    $.unblockUI();
    game_info('出错了！','连接服务器失败，可能服务器人满了，也可能是网络故障。错误码:'+error_state);
    close_game(1);
}
var has_bet = 0;
var manual_close_game = 0;
function close_game(force){
    if (force==0 && has_bet==1){
        game_info('不可退出!','已经下注，不可退出当前游戏！');
        return;
    }
    if (force==0){
        manual_close_game =1;
        quit_game();
    }
    cfg_kaipai_obj=undefined;
    $("#container").show();
    $("#container_game").hide();
    in_game = 0;
}
var cfg_kaipai_obj;
function _show_pai(target_no,data) {
    if (cfg_kaipai_obj==undefined){
        cfg_kaipai_obj = [$("#zhuang_open"),$("#xian1 .open"),$("#xian2 .open"),$("#xian3 .open"),$("#xian4 .open")];
    }
    target = cfg_kaipai_obj[target_no];
    if (target==null){
        alert(target_no);
        return;
    }
    target.html('');

    var arr = data.p[target_no];
    var paixingx = data.px[target_no];
    if (target_no!=0){
        var result = data.r[target_no-1];
        if (data.c==undefined){
            var change_credits = 0;
        } else {
            var change_credits = data.c[target_no-1];
        }
    } else {
        var result = 0;
        var change_credits = 0;
    }
    

    pai1 = arr.shift();
    pai2 = arr.shift();
    pai3 = arr.shift();

    var _html = '';
    var _html_temp = '<div class="pai"><img src="./images/card/{pai1}.png" width="35px" class="pai1"/><img src="./images/card/{pai2}.png" width="35px" class="pai2"/><img src="./images/card/{pai3}.png" width="35px" class="pai3"/></div><div class="zha_result {win_loose}">{paixing}</div><div class="my_get">{my_change}</div>';
    if (target_no!=0) {
        my_result = class_of_result[result];
        if (change_credits==0){
            my_change = '无成绩';
        } else {
            my_change = common_get_zipd_number(change_credits);

            if (change_credits>0){
                my_change = '+'+my_change;
            } 
            change_credits_of_show(change_credits,1);
        }
        
    } else {
        my_result = 'cy';
        my_change = '';
    }
    target.html(_html_temp.str_supplant({pai1:pai1,pai2:pai2,pai3:pai3,paixing:str_of_paixing[paixingx],win_loose:my_result,my_change:my_change}));
}


function _show_total_bet(total_bet){
    $("#total1").html(common_get_zipd_number(total_bet[0]));
    $("#total2").html(common_get_zipd_number(total_bet[1]));
    $("#total3").html(common_get_zipd_number(total_bet[2]));
    $("#total4").html(common_get_zipd_number(total_bet[3]));
}

function _show_my_bet(total_bet){
    $("#my_bet_1").html(common_get_zipd_number(total_bet[0]));
    $("#my_bet_2").html(common_get_zipd_number(total_bet[1]));
    $("#my_bet_3").html(common_get_zipd_number(total_bet[2]));
    $("#my_bet_4").html(common_get_zipd_number(total_bet[3]));
    credits_bet = total_bet[0]+total_bet[1]+total_bet[2]+total_bet[3];
    credits_hold = (credits_bet)*10;
    if (credits_hold>0){
        has_bet = 1;
    }
}

function _show_cd(cd) {
    $("#bet_cd").html(cd);
}

function _reset_cd(){
    $("#bet_cd").html(0).hide();
}

function _kaipai(data){
    _show_pai(0,data);
    window.setTimeout(function(){
        _show_pai(1,data);
    },1000);
    window.setTimeout(function(){
        _show_pai(2,data);
    },2000);
    window.setTimeout(function(){
        _show_pai(3,data);
    },3000);
    window.setTimeout(function(){
        _show_pai(4,data);
    },4000);
    if (data.cr!=-1){
        credits = data.cr;
    }
    if (data.c!=undefined){
        var total_incoming = data.c[0]+data.c[1]+data.c[2]+data.c[3];
    } else {
        var total_incoming = 0;
    }
    total_incoming = common_get_zipd_number(total_incoming);
    zhuang_incoming = common_get_zipd_number(data.zi);
    window.setTimeout(function(){
        _html_temp = '<span>本人战果:{total_incoming}</span><span>庄本局战果:{zhuang_incoming}</span>';
        $("#kaipai_jieguo").html(_html_temp.str_supplant({total_incoming:total_incoming,zhuang_incoming:zhuang_incoming}));

    },5000);
    
    
}

function _kaipai_pre(data){
    _show_pai(0,data);
    _show_pai(1,data);
    _show_pai(2,data);
    _show_pai(3,data);
    _show_pai(4,data);   
}

function get_user_list(room_id,table_id) {
    $.ajax_req({m:'zha',a:'room_user_list',plus:{room_id:room_id,table_id:table_id},callback:function(json){
        var _html_temp = '<img class="perimg" src="{avatar_url}" width="55px" height="55px"><span>{uname}</span><span>{credits_show}</span>';
        $("#zhuang_info").html(_html_temp.str_supplant(json.user_zhuang));
    }});
}
var g_credits_show_obj;
var timer_credits_show;
function change_credits_of_show(change,is_animate){
    window.clearInterval(timer_credits_show);
    if (g_credits_show_obj==undefined){
        g_credits_show_obj = $("#credits_show");
    }
    var pre_credits = parseInt(g_credits_show_obj.attr('show_v'));

    if (is_animate==0){
        g_credits_show_obj.html(common_get_zipd_number(pre_credits+change)).attr('show_v',pre_credits+change);
    } else {        
        var counter_timer = 0;
        var counter_timer_target = 4;
        var step = Math.round(change/counter_timer_target);
        timer_credits_show = window.setInterval(function(){
            counter_timer++;
            if (counter_timer==counter_timer_target){
                window.clearInterval(timer_credits_show);
                g_credits_show_obj.html(common_get_zipd_number(pre_credits+change)).attr('show_v',pre_credits+change);
            } else {
                g_credits_show_obj.html(common_get_zipd_number(pre_credits+step*counter_timer)).attr('show_v',pre_credits+step*counter_timer);
            }
        },150);
    }
}


function buy_vip(typ){
	$.ajax_req({m:'user',a:'buy_vip',h:1,plus:{typ:typ},callback:function(json){
		if (json.rstno==1) {
			if (json.change_credits>0) {
				change_credits_of_show(json.change_credits,1);
			}
		}
	}});
}

function ask_zhuang(){
    $.ajax_req({m:'zha',a:'ask_zhuang',h:1,plus:{room_id:zha_room_id,table_id:zha_table_id},callback:function(json){
        if (json.rstno<0){
            alert(json.error);
        }
    }});
}
