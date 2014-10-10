/***********************通用库函数******************************/
if(!window.console) {
    //var console = function(){};
    //console.log = function(){};
}
var Cookie = {
    setCookie : function(name, value)
    {
	document.cookie = name + "=" + value + ";";
    }
};

if (!Array.prototype.in_array) {
    Array.prototype.in_array = function(e)
    {
        for(i=0;i<this.length;i++){
            if(this[i] == e){
                return true;
            }
        }
        return false;
    }
}
Array.prototype.deleteOf = function(a) {  
    for(var i=this.length; i-- && this[i] !== a;);  
    if (i >= 0) this.splice(i,1);
}; 
  
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

function var_dump(data, addwhitespace, safety, level)
{
    var rtrn = '';
    var dt, it, spaces = '';

    if (!level) {
        level = 1;
    }
    for (var i=0; i<level; i++) {
        spaces += '   ';
    } //end for i<level
    if (typeof(data) != 'object') {
        dt = data;
        if (typeof(data) == 'string') {
            if (addwhitespace == 'html') {
                dt = dt.replace(/&/g,'&amp;');
                dt = dt.replace(/>/g,'&gt;');
                dt = dt.replace(/</g,'&lt;');
            } //end if addwhitespace == html
            dt = dt.replace(/\"/g,'\"');
            dt = '"' + dt + '"';
        } //end if typeof == string
        if (typeof(data) == 'function' && addwhitespace) {
            dt = new String(dt).replace(/\n/g,"\n"+spaces);
            if (addwhitespace == 'html') {
                dt = dt.replace(/&/g,'&amp;');
                dt = dt.replace(/>/g,'&gt;');
                dt = dt.replace(/</g,'&lt;');
            } //end if addwhitespace == html
        } //end if typeof == function
        if (typeof(data) == 'undefined') {
            dt = 'undefined';
        } //end if typeof == undefined
        if (addwhitespace == 'html') {
            if (typeof(dt) != 'string') {
                dt = new String(dt);
            } //end typeof != string
            dt = dt.replace(/ /g,"&nbsp;").replace(/\n/g,"<br>");
        } //end if addwhitespace == html
        return dt;
    } //end if typeof != object && != array
    for (var x in data) {
        if (safety && (level > safety)) {
            dt = '*RECURSION*';
        } else {
            try {
                dt = var_dump(data[x],addwhitespace,safety,level+1);
            } catch (e) {
                continue;
            }
        } //end if-else level > safety
        it = var_dump(x,addwhitespace,safety,level+1);
        rtrn += it + ':' + dt + ',';
        if (addwhitespace) {
            rtrn += '\n'+spaces;
        } //end if addwhitespace
    } //end for...in
    if (addwhitespace) {
        rtrn = '{\n' + spaces + rtrn.substr(0,rtrn.length-(2+(level*3))) + '\n' + spaces.substr(0,spaces.length-3) + '}';
    } else {
        rtrn = '{' + rtrn.substr(0,rtrn.length-1) + '}';
    } //end if-else addwhitespace
    if (addwhitespace == 'html') {
        rtrn = rtrn.replace(/ /g,"&nbsp;").replace(/\n/g,"<br>");
    } //end if addwhitespace == html
    return rtrn;
} //end function var_dump

//type='01'，left add zero
//type='10'，right add zero
function add_zero(number, length,type) {
    var buffer = "";
    if (number ==  "") {
        for (var i = 0; i < length; i ++) {
            buffer += "0";
        }
    } else {
        if (length < number.length) {
            return "";
        } else if (length == number.length) {
            return number;
        } else {
            for (var i = 0; i < (length - number.length); i ++) {
                buffer += "0";
            }
	    if (type=='01'){
		buffer += number;
	    } else {
		buffer = number+buffer;
	    }
            
        }
    }
    return buffer;
} 
//function common_get_zipd_number(src){	
//    src = parseInt(src);
//	var temp = 0,rst = '';
//	var dst = new Array();
//	if(src==0){
//            return 0;
//	}
//	//$g_lang = 'en';
//    if (g_lang=='en'){
//        var split = 1000;    
//        temp = Math.floor(src / split);
//        if (temp<1){
//            dst.push(src);
//        }
//        while (temp>=1){
//            dst.push(src % split);
//            temp = src = Math.floor(src / split);
//        }    
//        rst = '';
//        if (dst.length>1){
//            var i = 0;
//            for(dst in temp){
//                switch (i){
//                case 0:
//                temp = common_add_zero_left(temp,3);
//                temp = temp.replace('/0*$/','');
//                if (temp==''){
//                    rst = 'M';
//                } else {
//                    rst = '.'+temp+'M';
//                }
//                break;
//                case 1:
//                    temp = common_add_zero_left(temp,3);
//                    rst = temp+rst;
//                    break;
//                default:		    
//                    rst = temp+','+rst;
//                    break;
//                }
//                i++;
//            }
//        } else {
//            rst = src+'K';
//        }    
//        rst = rst.replace('/^0+/','');     
//        return rst;
//	}else if(g_lang=='zh_CN'){
//            if(src<10){
//                    rst = src+'千';
//            }else if(src/(10*10000)<1){
//                if (src%10==0){
//                    rst = Math.floor(src/10)+'万';
//                } else {
//                    rst = Math.floor(src/10)+'.'+(src%10)+'万';
//                }
//            }else if(src/(10*10000)>=1){
//                temp = Math.floor(src/100000);
//                temp = Math.floor(src)%100000;
//                temp = common_add_zero_left(temp,5);
//                temp = temp.replace('/0*$/','');
//                if(temp!=0){
//                    rst = temp+'.'+temp+'亿';
//                }else{
//                    rst = temp+'亿';
//                }
//            }
//            rst = rst.replace('/^0+/',''); 
//            return rst;
//	}
//	return rst;
//}
//function get_zipd_number_transfer(src){	 
//	if(src==0){
//	    return 0;
//	}
//	var ds = src.substr(-1);
//	//alert(src);
//	if(ds == 'K'){
//	    return parseInt(src);
//	}else if(ds == 'M'){
//	    return 1000*parseFloat(src);
//	}     
//    return src;
//}

//格式化时间日期
//format=1输出 YYYY-MM-DD hh:nn:ss
//format=2输出 MM-DD hh:nn:ss
//format=3输出 今天/明天/后天/第几天 hh:nn:ss
function formatDateTime(show_time,format)
{
    var date = new Date(parseInt(show_time) * 1000);
    var month=date.getMonth()+1;
    var day=date.getDate();
    var minutes =date.getMinutes();
    var seconds = date.getSeconds();
    var rst = date.getFullYear()+"-"+((month<10)?"0"+month:month)+"-"+((day<10)?"0"+day:day)
    +" "+date.getHours()+":"+((minutes<10)?"0"+minutes:minutes)+":"+((seconds<10)?"0"+seconds:seconds);
    return rst;
}
//格式化时间
function formatTime(aTime)
{
    var ta = new Array( 60*60 , 60, 1);
    var tb = new Array(3);
    var i;

    if( aTime>0 )
    {
    for(i=0;i<=2;i++)
    {
        tb[i]=Math.floor( aTime / ta[i] );
        aTime = aTime % ta[i];
    }
    return (zero(tb[0])+":"+zero(tb[1])+":"+zero(tb[2]));
    } else {
    return '00:00:00';
    }
}

function zero(time)
{
    if(time <= 9)
    {
	return '0' + time;
    }else{ 
	return time;
    } 
}

function common_get_IE_fix_png_style(img_src,width,height,special){
    if (special==undefined){
	special = '';
    }
    if (is_IE6){
	return '<span style="filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='+img_src+', sizingMethod=\'scale\');width='+width+'px;height='+height+'px;display:block;" '+special+'></span>';
    } else {
	return '<img src="'+img_src+'" width="'+width+'px" height="'+height+'px" '+special+'/>';	
    }
}

//php的in_array函数js实现
function js_in_array(js_value,js_arr){
    for(i = 0; i < js_arr.length; i++){
        if(js_arr[i] == js_value){
            return true;
        }
    }
    return false;
}


//获取字节数
function mb_str_len(s) {
    var total_len = 0;
    var i;
    var char_code;
    for (i = 0; i < s.length; i++) {
        char_code = s.charCodeAt(i);
        if (char_code < 0x007f) {
            total_len = total_len + 1;
	} else if ((0x0080 <= char_code) && (char_code <= 0x07ff)) {
	    total_len += 2;
	} else if ((0x0800 <= char_code) && (char_code <= 0xffff)) {
	    total_len += 3;
	}
    }
    return total_len;
}


// 长字符串换行(m:每行长度, b:换行分割符, c:强制换行)
function wordWrap(bigString, m, b, c)
{
    var i, j, s, r = bigString.split("\n");
    if(m > 0) 
	for(i in r)
	{
	    for(s = r[i], r[i] = "";
		s.length > m;
		j = c ? m : (j = s.substr(0, m).match(/\S*$/)).input.length - j[0].length
		|| m, r[i] += s.substr(0, j) + ((s = s.substr(j)).length ? b : ""));
	    r[i] += s;
	}
    return r.join(b);
}

function add_fav(url)
{
	title = msg_favourite; 
	if (window.sidebar) {
		// Mozilla Firefox Bookmark
		window.sidebar.addPanel(title, url,"");
	} else if( window.external ) {
		// IE Favorite
		window.external.AddFavorite( url, title);
	}
	else if(window.opera && window.print) {

	}
}

function scroll_action(list_finder, list_elem, speed, is_series,least_count) {	//list_obj为需要滚动的列表，  speed为滚动速度
	var pos, top, aniTop, height;
	var id = '';  //记录setInterval的标记id
	var list_obj = $(list_finder);
	pos = list_obj.position();	
	top = pos.top;			//列表的top
	aniTop = top;				//记录当前运动时的top
	height = list_obj.height();	//列表的高度

	var scrollUp = function() {
		list_obj = $(list_finder);
		if (list_obj.length==0){
			window.clearInterval(id);
		}
		aniTop--;
		if(!is_series) {	//is_series变量控制是否连续滚动，false不连续，true连续
			if(aniTop == -height) {	//不连续，滚动玩重新滚动
				list_obj.css({'top': top});
				aniTop = top;
			};
		} else {
			if(aniTop == -list_obj.children().first().height()) {	//连续滚动
				var firstItem = '<' + list_elem +'>' + list_obj.children().first(0).html() + '</' + list_elem +'>';
				list_obj.children().eq(0).remove();
				list_obj.append(firstItem);
				aniTop = 4;
			};
		};
		list_obj.css({'top': aniTop + 'px'});
	};

	var hover = function(id) {
		list_obj.hover(function() {
			clearInterval(id);
		}, function() {
			id = setInterval(scrollUp, speed);
		});
	};

	this.start = function() {
		if ($(list_finder).children().length<=least_count){
			return;
		}
		id = setInterval(scrollUp, speed);
		hover(id);
	};

};
	

jQuery.extend({
    getEvent: function(){
        if(window.event){
            return window.event;
        }else{
            var c = this.getEvent.caller;
            while (c) {
                ev = c.arguments[0];
                if (ev && (Event == ev.constructor || MouseEvent  == ev.constructor)) { //怿飞注：YUI 源码 BUG，ev.constructor 也可能是 MouseEvent，不一定是 Event
                    break;
                }
                c = c.caller;
            }
            return ev;
        }
    }
});

(function($) {
	$.fn.quickPager = function(options) {
            var defaults = {
                pageSize: 10,
                currentPage: 1,
                holder: null,
                pagerLocation: "after",
                id:'',
                typ:'page',
                pageCounter:0,
                need_odd:0,
                need_compress:0,
				struct:null
            };
	    options = $.extend(defaults, options);
            return this.each(function() {
                var selector = $(this);	
                var pageCounter = 1;
                if (!selector.parent().hasClass('simplePagerContainer')){
                    selector.wrap("<div class='simplePagerContainer'></div>");
                }
                var real_counter=0;
                selector.children().each(function(i){
                        
                    $(this).removeAttr('PagerPage');
                    if ($(this).attr('skipPager')==1){
                        $(this).attr('PagerPage',0);
                    } else {
                        if(real_counter < pageCounter*options.pageSize && real_counter >= (pageCounter-1)*options.pageSize) {
                            $(this).attr('PagerPage',pageCounter);
                        }
                        else {
                            $(this).attr('PagerPage',pageCounter+1);
                            pageCounter ++;
                        }
                        real_counter++;
                    }   
                });
                options.pageCounter = pageCounter;
                // show/hide the appropriate regions
                selector.children().addClass('hide');
                
                if (options.need_odd==1){
                    selector.children("[PagerPage="+options.currentPage+"]").removeClass('hide').each(function(index){
                        var odd = index % 2 + 1;
                        $(this).removeClass('odd1').removeClass('odd2').addClass('odd'+odd);
                    });
                } else {
                    selector.children("[PagerPage="+options.currentPage+"]").removeClass('hide');
                }
                if(pageCounter <= 1) {
                    if(!options.holder) {
                        $("#"+options.id).remove();
                    } else {
                        $(options.holder).html('');
                    }
                    return;
                }
                if (pageCounter>10){
                    options.need_compress = 1;
                    
                }
                if (options.typ=='page'){
                    //Build pager navigation
                    var pageNav = "<ul class='page_list' id='"+options.id+"'>";
                    if (options.need_compress==1 && options.currentPage>10){
                        pageNav += "<a class='page_pre_compress>...</a>";
                    }
                    for (i=1;i<=pageCounter;i++){
                        if (i==options.currentPage) {
                            pageNav += "<a class='now_page att_page_able simplePageNav"+i+"' rel='"+i+"'>"+i+"</a>";	
                        }
                        else {
                            if (options.currentPage<5){
                                var temp_cur_page = 5;
                            } else {
                                var temp_cur_page = options.currentPage;
                            }
                            if (options.need_compress==1 && (i<temp_cur_page-5 || i>temp_cur_page+5)){
                                pageNav += "<a class='att_page_able hide simplePageNav"+i+"' rel='"+i+"'>"+i+"</a>";
                            } else {
                                pageNav += "<a class='att_page_able simplePageNav"+i+"' rel='"+i+"'>"+i+"</a>";
                            }
                            
                        }
                    }
                    if (options.need_compress==1 && options.currentPage<10){
                        pageNav += "<span class='page_post_compress'>...</span>";
                    }
                    pageNav += "</ul>";
                } else {
                    //Build pager navigation
                    var pageNav = "<ul class='page_list' id='"+options.id+"' cur_page='"+options.currentPage+"' >";
                    pageNav += "<a class='att_page_able' rel_typ='pre'>"+msg_common_i18n.pre+"</a>";
                    pageNav += "<a class='att_page_able' rel_typ='next'>"+msg_common_i18n.next+"</a>";
                    pageNav += "</ul>";
                }
                
                if(!options.holder) {
                    $("#"+options.id).remove();
                    switch(options.pagerLocation)
                    {
                    case "before":
                        selector.before(pageNav);
                    break;
                    case "both":
                        selector.before(pageNav);
                        selector.after(pageNav);
                    break;
                    default:
                        selector.after(pageNav);
                    }
                    var click_target = selector.parent();
                }
                else {
                    var click_target = $(options.holder);
                    click_target.html(pageNav);   
                }   
                //pager navigation behaviour
                click_target.find(".page_list a").click(function() {
                    if (options.typ=='page'){
                        //grab the REL attribute
                        var clickedLink = $(this).attr("rel");
                        options.currentPage = clickedLink;
                        var pageDom = $(this).parent("ul");
                        if(options.holder) {
                            $(this).parent("ul").parent(options.holder).find("a.now_page").removeClass("now_page");
                            $(this).parent("ul").parent(options.holder).find("a[rel='"+clickedLink+"']").addClass("now_page");
                        }
                        else {
                            //remove current current (!) page
                            pageDom.find(".now_page").removeClass("now_page");
                            //Add current page highlighting
                            pageDom.find("a[rel='"+clickedLink+"']").addClass("now_page");
                        }
                        //hide and show relevant links
                        selector.children().addClass('hide');
                        if (options.need_odd==1){
                            selector.find("[PagerPage="+clickedLink+']').removeClass('hide').each(function(index){
                                var odd = index % 2 +1;
                                $(this).removeClass('odd1').removeClass('odd2').addClass('odd'+odd);
                            });
                        } else {
                            selector.find("[PagerPage="+clickedLink+']').removeClass('hide');
                        }
                        if (options.need_compress==1){
                            pageDom.find("a").removeClass('hide');
                            if (options.currentPage<5){
                                var temp_cur_page = 5;
                            } else if (options.currentPage>options.pageCounter-5) {
                                var temp_cur_page = parseInt(options.pageCounter)-5;
                            } else {
                                var temp_cur_page = parseInt(options.currentPage);
                            }
                            //alert(temp_cur_page);
                            //alert(options.pageCounter);
                            for (var i=1;i<=options.pageCounter;i++){
                                if (i<temp_cur_page-5 || i>temp_cur_page+5){
                                    pageDom.find("a[rel='"+i+"']").addClass('hide');
                                    //alert(i);
                                }
                            }                            
                        } 
                        
                        return false;
                    } else {
                        if ($(this).attr("rel_typ")=='pre'){
                            options.currentPage--;
                            if (options.currentPage<=0){
                                options.currentPage = 1;
                            }
                        } else {
                            options.currentPage++;
                            if (options.currentPage>=options.pageCounter){
                                options.currentPage = options.pageCounter;
                            }
                        }
                        selector.children().addClass('hide');
                        if (options.need_odd==1){
                            selector.find("[PagerPage="+options.currentPage+']').removeClass('hide').each(function(index){
                                var odd = index % 2 +1;
                                $(this).removeClass('odd1').removeClass('odd2').addClass('odd'+odd);
                            });
                        } else {
                            selector.find("[PagerPage="+options.currentPage+']').removeClass('hide');
                        }
                        
                        return false;
                    }
                });
            });
	}
})(jQuery);

/***********************全局变量******************************/
var group_chat_msg = new Array();
var private_chat_msg = new Array();
var world_chat_msg = new Array();
var chat_count=0;

var thick_border_width = 12;
var thick_border_height = 12;
var thick_animation = 3;
/*
 1:easeOutBounce
 2:expand
 3:drop
*/
var widget_animation = 104;
//技术或者身体型球员特殊属性点
var cfg_player_special_attr = new Array();
cfg_player_special_attr[0] = 'tec_cross';
cfg_player_special_attr[1] = 'tec_move';
cfg_player_special_attr[2] = 'phy_sta';
cfg_player_special_attr[3] = 'phy_str';
cfg_player_special_attr[4] = 'tec_first_touch';
cfg_player_special_attr[5] = 'tec_pass';
cfg_player_special_attr[6] = 'att_drib';

var differ_time = 0;
var sync_timer = 1;

function sync_time(){
    if (sync_timer<=1){
        var t1 = Date.parse(new Date()) / 1000;
        $.getJSON('?m=index&a=sync_time&format=json',function(json){
            var t3 = Date.parse(new Date()) / 1000;
            var t2 = json.zeit;
            differ_time = (t3+t1) / 2 - t2;
        });
    }
    sync_timer ++;
    if (sync_timer>=36000){
        sync_timer = 1;
    }
}
//防沉迷接入
var is_obsession_flag = 0;//是否防沉迷状态位
function update_obsession_status(){
    if(1==0){//if(g_version_op==1){       
        fusion2.iface.updateExpRate
        (     
            function (rate) 
            {
                is_obsession_flag = 1;
                if(rate!=obsession_status){
                    var cur_status = rate;
                    ajax_handler('account','update_obsession_status',0,'status='+cur_status,function(json){
                        obsession_status = rate;
                        if(obsession_status==0.5){
                            msg_obsession = msg_common_i18n.msg_obsession;
                            if(g_obsession_alert!=3){
                                alert_box(msg_obsession,1);
                                g_obsession_alert = 3;
                            }
                            obsession_obj.removeClass('hide').html(msg_obsession);
                        }else if(obsession_status==0){
                            msg_obsession = msg_common_i18n.msg_obsession1; 
                            if(g_obsession_alert!=5){
                                alert_box(msg_obsession,1);
                                g_obsession_alert = 5;
                            }
                            obsession_obj.removeClass('hide').html(msg_obsession);
                        }
                        on_line_zeit = json.on_line_zeit;
                        last_online = json.last_online;
                    });
                }
               //在这里写入经验值减半或清零的逻辑。
               //应用无需关注用户在线时长以及是否未成年等信息，这部分逻辑判断由腾讯平台去做，平台返回用户的经验倍率值rate
               //应用只需要使用rate值即可。rate为经验倍率，有1，0.5，0  这3种取值 
               //当rate=1时，因此用户的收益保持不变，FusionAPI不会回调本方法
               //当rate=0.5或0时，表示用户是FusionAPI会回调本方法，对用户实施收益减半或清零
            }
        );       
    }
    if(is_obsession_flag==0){
        if(obsession_status!=1){
            ajax_handler('account','update_obsession_status',0,'status=1',function(json){
                obsession_status = 1;
            });
        }
    }
}
function sync_refresh_openkey(){ 
    $.getJSON('?m=index&a=sync_refresh_openkey&format=json',function(json){
        var num = json.refresh_openkey_num; 
        has_refresh_openkey[num] = 1;
    });
}

//浏览器兼容访问DOM
function thisMovie(movieName) {
    if(jQuery.browser.msie && parseInt(jQuery.browser.version)>=9){
        return document.getElementById(movieName);
    }else{
        if (navigator.appName.indexOf("Microsoft") != -1) {
        return window[movieName];
        }else {
        return document[movieName]
        }
    }     
}

function reset_bg_size(){
    auto_fit_swf_timer = 0;
    g_window_height = $(window).height();
    g_window_width = $(window).outerWidth();
    
    g_content_height = g_window_height;
    g_content_width = g_window_width;
    if (g_window_width > 1440){
        g_content_width = 1440;
        wrap_w = '100%';
        g_border_width = (g_window_width - g_content_width)/2;
    } else if (g_window_width < 1000){
        g_content_width = 1000;
        wrap_w = 1000;
        g_border_width = 0;
    } else {
	wrap_w = g_content_width;
	g_border_width = 0;
    }
    if (g_window_height > 740){
        g_content_height = 700;
    } else if (g_window_height < 600){
        g_content_height = 600;
    } else {
        g_content_height = g_window_height - 28;
    }
    $(".reset_bg_size").css({height:g_content_height,width:g_content_width});    
    $(".reset_bg_size_holder").css({height:g_content_height,width:g_content_width,marginLeft:0-g_content_width/2});
    //my_debug(t_w);
    //my_debug(t_h);
    $("#wrap").css({height:g_content_height,width:wrap_w});
    g_present_gift.css({right:g_border_width + 30});
    g_friend_list.css({right:g_border_width});

    g_i_task_list.css({left:g_border_width});
    if (g_window_width>1280 && g_lang=='zh_CN'){
        reset_task_size(1);
    } else {
        reset_task_size(0);  
    }    
    g_i_vip_gift.css({left:g_border_width+15});
    $("#container").css({height:g_content_height});
    g_body_height = $('body').height();
    
}

function flash_gen_swf_res_url(){
    //alert(res_url_prefix+'|'+g_body_height+'|'+t_w);
    return res_url_prefix+'|'+g_content_height+'|'+g_content_width+'|'+g_lang;
}

function flash_get_version(){
    return g_res_version;
}
function auto_fit_swf(p_conf){
    var conf = {movie:'',
    id:'swf',
    width:'100%',
    height:'100%',
    wmode:'window',
    target_id:'swf_holder',
    FlashVars:'',
    bg_color:'#333333',
    reset_bg:true
    };
    $.extend(conf, p_conf);
    if (conf.reset_bg){
        reset_bg_size();
    }    
    var _html = '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="'+conf.width+'" height="'+conf.height+'" id="'+conf.id+'" align="middle">'+
        '<param name="movie" value="'+conf.movie+'" />'+
        '<param name="quality" value="high" />'+
        '<param name="bgcolor" value="'+conf.bg_color+'" />'+
        '<param name="play" value="true" />'+
        '<param name="loop" value="true" />'+
        '<param name="wmode" value="'+conf.wmode+'" />'+
        '<param name="scale" value="noscale" />'+
        '<param name="menu" value="true" />'+
        '<param name="devicefont" value="true" />'+
        '<param name="salign" value="TC" />'+
        '<param name="allowScriptAccess" value="always" />'+
        '<param name="hasPriority" value="true" />'+
        '<param name="FlashVars" value="'+conf.FlashVars+'" />'+
        '<embed src="'+conf.movie+'" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer"'+
                        'type="application/x-shockwave-flash" width="'+conf.width+'" height="'+conf.height+'"'+
        'name="'+conf.id+'"'+
        'bgcolor="'+conf.bg_color+'"'+
        'play="true"'+
        'loop="true"'+
        'scale="noscale"'+
        'menu="true"'+
        'devicefont="true"'+
        'salign="TC"'+
        'allowScriptAccess="always"'+
        'hasPriority="true"'+
        'wmode="'+conf.wmode+'"'+
        'FlashVars="'+conf.FlashVars+'"'+
        '</embed>'+
        '</object>';       
    $("#"+conf.target_id).html(_html);
}

var pre_loader_counter = 0;

function pre_loader(){
    if (cfg_pre_loader == undefined){
        return;
    }
    if (cfg_pre_loader.length<=0){
        return;
    }
    
    var this_res = cfg_pre_loader.pop();
    if (this_res==undefined){
        return;
    }
    pre_loader_counter++;
    if (this_res.typ=='img'){
            g_pre_loader.append("<div class='this_pre_loader' id='loader_count_"+pre_loader_counter+"'><img src='"+this_res.url+"'/></div>");	
    } else if (this_res.typ=='swf') {
        var _html = '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="1px" height="1px" align="middle">'+
            '<param name="movie" value="'+this_res.url+'" />'+
            '<param name="quality" value="high" />'+
            '<param name="hasPriority" value="true" />'+
            '<param name="allowScriptAccess" value="always" />'+
            '<param name="FlashVars" value="res_url_prefix='+res_url_prefix+'" />'+
            '<embed src="'+this_res.url+'" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer"'+
            'type="application/x-shockwave-flash" width="1px" height="1px" hasPriority="true"'+
            'allowScriptAccess="always"'+
            'FlashVars="res_url_prefix='+res_url_prefix+'"'+
            '</embed>'+
            '</object>';
        g_pre_loader.append("<div class='this_pre_loader' id='loader_count_"+pre_loader_counter+"'>"+_html+"</div>");
    }
    setTimeout(pre_loader,1000);
}

function insert_swf(this_res,target){
    if (this_res.flashvars==undefined){
        this_res.flashvars = 'res_url_prefix='+res_url_prefix;
    } else {
        this_res.flashvars += '&res_url_prefix='+res_url_prefix;
    }
    var _html = '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="'+this_res.width+'px" height="'+this_res.height+'px" id="'+this_res.id+ '" align="middle">'+
            '<param name="movie" value="'+res_url_prefix+this_res.url+'" />'+
            '<param name="quality" value="high" />'+
            '<param name="hasPriority" value="true" />'+
            '<param name="wmode" value="'+this_res.wmode+'" />'+
            '<param name="allowScriptAccess" value="always" />'+
            '<param name="FlashVars" value="'+this_res.flashvars+'" />'+
            '<embed src="'+res_url_prefix+this_res.url+'" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer"'+
            'type="application/x-shockwave-flash" width="'+this_res.width+'px" height="'+this_res.height+'px" hasPriority="true"'+
            'allowScriptAccess="always"'+
            'wmode="'+this_res.wmode+'"'+
            'FlashVars="'+this_res.flashvars+'"'+
            '</embed>'+
            '</object>';
    target.html(_html);
}

/***********************界面库******************************/
function box_loading(){
    g_loading_box.removeClass('hide');
    insert_swf({width:340,height:220,url:'images/flash/loading_box.swf?ver='+g_res_version,wmode:'transparent',id:'loading_swf_real'},g_loading_box);
}
function box_loading_finish(){
    g_loading_box.addClass('hide').html('');
}

function ajax_post(form_id,succ_alert,callback,err_callback,data_plus,deal_url){
    if(data_plus != undefined && deal_url != undefined){
        var url = deal_url; 
        data_param = data_plus;
    }else{
        var url =  $('#'+form_id).attr('action');
        data_param = $('#'+form_id).serialize();
    }
    $.ajax({
        url:url,
        type:"POST",         
        dataType:'json',         
        data: data_param,
        success: function(json) {
            if(json.rstno==1){
                if(succ_alert!=null && succ_alert==0){
                }else{
                    alert_box(json.error,1);
                }
                if (callback !=undefined){
                    callback.apply(this,arguments);
                }  
            }else if(json.rstno == -100){
                tx_vip_box_open('vip','guide_expense');
            }else{
                alert_box(json.error,0);
                if (err_callback !=undefined){
                    err_callback.apply(this,arguments);
                }
            }
            
            //window.location.href = "?m=admin&a=content_manage&cid="+cid;
        }
    });
}

function ajax_handler(module,action,succ_alert,plus,callback,err_callback){
    if (plus!=null && plus!=''){
            var url = 'index.php?h=1&m='+module+'&a='+action+'&'+plus;
    } else {
            var url = 'index.php?h=1&m='+module+'&a='+action;
    }
    
    $.getJSON(url,function(json){
        $.unblockUI();
        $("#confirm_op a").unblock();
        if (json.tour_next_match_zeit!=undefined){
            tour_next_match_zeit = json.tour_next_match_zeit;
        }
        alert_box_close();
        if(json.rstno>=1)  {
            if(json.header_info!=undefined){
                upd_i_header_info(json.header_info);
            }
            if (succ_alert!=null && succ_alert==0){
            } else {
                //succ_box(json.error);
                alert_box(json.error);
            }
            if (json.levelup!=undefined){
                congratulations_box(0);
            }
            if (callback !=undefined){
                callback.apply(this,arguments);
            }
        } else if (json.rstno==-99){
                
        } else if(json.rstno == -100){
            tx_vip_box_open('vip','guide_expense');
        } else if(json.rstno == -101){
            tx_vip_box_open('vip','money_need');
        }else{
            //ajax_error_info(json.error);
            alert_box(json.error,0);
            if (err_callback!=undefined){
                err_callback.apply(this,arguments);
            }
        }
    });
}
//下拉框 样式
function change_selectbox(zIndex,id,callback){	 
	var p = $('#'+id),
		a = p.find('a'),
		ul = p.find('ul');
	if(a.attr('sdisabled')=="true"){
		return false;
	}
	if(is_IE6){
		var pp = p.parent();
		if(ul.hasClass('hide')){
			if($.browser.msie && $.browser.version==6){
				pp.css('z-index',parseInt(zIndex)+1);
			}
			p.css('zIndex',parseInt(zIndex)+1);
			ul.removeClass('hide').find('li:[content='+a.attr('content')+']').addClass('hover').siblings().removeClass('hover');
			function add_sliderbar(){
				return (ul.children().length>8)?true:false;
			}
			function li_select(callback){
				if(ul.children().length==0){
					var content_li = _t('None');
					ul.append('<li content="select_none">'+content_li+'</li>');
				}
				ul.find('li').each(function(){
					$(this).click(function(){
						ul.addClass('hide');
						p.css('zIndex','auto');
                        var content = $(this).attr('content');
						if($(this).attr('content')!='select_none' && content!=a.attr('content')){
							a.text($(this).text()).attr('content',content);
							if (callback!=null){
							    callback.apply(this,content);
							}
							
						}else{
							ul.addClass('hide').css('zIndex','auto');
							p.css('zIndex','auto');
							if($.browser.msie && $.browser.version==7){
							    pp.css('z-index',parseInt(zIndex)+1);
							}
						}
					})
				});
			}
			if(ul.find('.ui-widget-header').length===0 && add_sliderbar()){
				ul.addClass('scroll_target').height(136).css({overflow:'hidden',float:'left'});
				ul.contents().wrapAll('<div class="ui-widget-header"></div>');
				ul.find('.ui-widget-header').css('float','left').slider_use();
			}
			li_select(callback);
		}else{
			ul.addClass('hide');
			p.css('zIndex','auto');
			if($.browser.msie && $.browser.version==7){
				pp.css('z-index',parseInt(zIndex)+1);
			}
		}
	}else{
		var pp = p.parent();
		if(ul.hasClass('hide')){			
			if($("#selectbox_mask").length<=0){
				var selectbox_mask = "<div id='selectbox_mask'></div>";
			}
			if($.browser.msie && $.browser.version==7){
				pp.css('z-index',parseInt(zIndex)+1);
			}
			p.css('zIndex',parseInt(zIndex)+1).after(selectbox_mask);
			ul.removeClass('hide').find('li:[content='+a.attr('content')+']').addClass('hover').siblings().removeClass('hover');
			$("#selectbox_mask").css('zIndex',zIndex).click(function(){
				ul.addClass('hide').parent().css('zIndex',0);
				$(this).remove();
			});
			function add_sliderbar(){
				return (ul.children().length>8)?true:false;
			}
			function li_select(callback){
				if(ul.children().length==0){
					var content_li = 'None';
					ul.append('<li content="select_none">'+content_li+'</li>');
				}
				ul.find('li').each(function(){
					$(this).click(function(){
						ul.addClass('hide');
						p.css('zIndex','auto');
						$("#selectbox_mask").remove();
                        var content = $(this).attr('content');
                        var text = $(this).text();
						if($(this).attr('content')!='select_none' && content!=a.attr('content')){
							a.text($(this).text()).attr('content',content);
							if (callback!=null){
								callback.apply(this,[content,text]);
							}	
						}else{
							ul.addClass('hide').css('zIndex','auto');
							p.css('zIndex','auto');
							if($.browser.msie && $.browser.version==7){
								pp.css('z-index',parseInt(zIndex)+1);
							}
							$("#selectbox_mask").remove();
						}
					})
				});
			}
			if(ul.find('.ui-widget-header').length===0 && add_sliderbar()){
				ul.addClass('scroll_target').height(136).css({overflow:'hidden',float:'left'});
				ul.contents().wrapAll('<div class="ui-widget-header"></div>');
				ul.find('.ui-widget-header').css('float','left').slider_use();
			}
			li_select(callback);
		}else{
			ul.addClass('hide');
			p.css('zIndex','auto');
			if($.browser.msie && $.browser.version==7){
				pp.css('z-index',parseInt(zIndex)+1);
			}
			$("#selectbox_mask").remove();
		}
	}
}
//check input checked or unchecked and change label style
$.fn.igm_input_checked=function(checked){
	if(checked==0){
	    $(this).attr('checked',false).siblings('label').removeClass('list_checked');
	}else if(checked==1){
	    $(this).attr('checked',true).siblings('label').addClass('list_checked');
	}
}

//check whether a contains b
function contains(a, b) { 
    return a.contains ? a != b && a.contains(b) : !!(a.compareDocumentPosition(b) & 16); 
}


//针对table的hover
(function(){
	var tableHover = function(elem,conf){
            elem.mouseover(function(){
                mouseOp.mover();
            }).mouseout(function(){
                mouseOp.mout();
            });
            var mouseOp = {
                mover:function(){
                    if(elem.hasClass('map_odd')){
                        elem.removeClass('map_odd');
                        elem.data('hasclass',1);
                    }
                    elem.addClass('tr_hover');
                },
                mout:function(){
                    elem.removeClass('tr_hover');
                    if(elem.data('hasclass')==1){
                        elem.removeData('hasclass');
                        elem.addClass('map_odd');
                    }
                }
            };
	};
	$.fn.tableHover = function(conf){
            var defaultConf = {};
            this.each(function(){
                var su = new tableHover($(this),defaultConf);
            })
	}
})(jQuery);

//scroll name
var scrollTime = 0;
(function($) {
	function scrollNames(elem,limit_word){
		var lng = parseInt(elem.css('text-indent'));
		var text_width = parseInt(elem.text().length);
		var e_width = parseInt(elem.css('width'));
		elem.data('text-indent',lng);
		function checkNameLng(elem){
		    return (elem.text().length>limit_word)?1:0;
		}
		function stopName(elem){
                    elem.css('text-indent',elem.data('text-indent')+'px');
                    lng = parseInt(elem.data('text-indent'));
                    clearTimeout(scrollTime);
		}
		function scrollName(elem){
                    if(e_width>(-lng+11)){
                        elem.css('text-indent',(--lng)+'px');
                        scrollTime = setTimeout(function(){scrollName(elem)},100);
                    }else{
                        return;
                    }
		}
		elem.hover(function(){
                    scrollTime=0;
                    if(checkNameLng(elem)){
                    scrollName(elem);
                    }
		},function(){
		    stopName(elem);
		});
	}
	$.fn.scrollNames = function(limit_word){
            //limit_word = 11;
            this.each(function(){
                var el = new scrollNames($(this),limit_word);
                $(this).data('scrollNames',el);
            })
	}
})(jQuery);

//new scroll name
(function(){
    var scroll_time = 0; 
    function scroll_name(target,conf){
        var p = target.parent();
        var txt = target.text(),
        append = "<span>"+txt+"</span>";
        if(target.css('display')=='inline') target.css('display','block');
            target.html(append);
            var span = target.find('span');
            var span_w = parseInt(span.width());
            var target_w = parseInt(target.width());
            function myscroll(left){
                if(left<=-target_w){
                    span.css({display:"block"});
                    left = parseInt(target_w*conf.rest);
                    target.css('text-indent',left+'px');
                    myscroll(left);
                }else{
                    left -= conf.speed;
                    target.css('text-indent',left+'px');
                    scroll_time =  setTimeout(function(){myscroll(left);},conf.time);
                }
            }
            function startscroll(){
                if(span_w>target_w){
                    if(scroll_time!=0) stopscroll();
                    var left = parseInt(target.css('text-indent'))||0;
                    myscroll(left);
                }
            }
            function stopscroll(){
                clearTimeout(scroll_time);
                scroll_time = 0;
                target.css('text-indent',0);
            }
            p.mouseover(function(){
                startscroll();
            }).mouseout(function(){
                stopscroll();
            });
        }
        $.fn.myscroll = function(conf){
            var defaultconf = {
                time:60,
                speed:2,
                rest:0.3
            };
            $.extend(defaultconf,conf);
            this.each(function(){
               var el = new scroll_name($(this),defaultconf); 
            });
       };
})(jQuery);

//change checkbox style
(function(){
    $.fn.checkboxStyle = function(callback){
        function checkboxStyle(elem){
            elem.click(function(){
                if(elem.hasClass('list_checked')){
                    elem.removeClass('list_checked').siblings("input[type='checkbox']").removeAttr("checked");
                }else{
                    if(elem.attr('name')=='change_pids'){
                        var checkNum  =  $("input:checkbox[name='change_pid']:checked").length;
                        var voteMax = $('#change_pid').attr('voteMax');
                        if (checkNum < voteMax ) {
                            elem.addClass('list_checked').siblings("input[type='checkbox']").attr("checked",true);
                        }
                    }else{
                        elem.addClass('list_checked').siblings("input[type='checkbox']").attr("checked",true);
                    }
                }
                if(callback!=undefined){
                    callback.apply(this,arguments);
                }
            })
        }
        this.each(function(){
            var cs = new checkboxStyle($(this));
        })
    }
})(jQuery);

//改变自定义textarea中的可编辑状况
function textarea_igm_num(id,changed_id,e){
    var t = $('#'+id);
    var txt_length = 200-$.trim(t.val()).length;
    if(txt_length<1){
        if($.browser.msie){
            e.returnValue=false;
        }else{
            e.preventDefault();
        }
    }
    $('#'+changed_id+' span').text(txt_length);
}

//输入自定义textarea框时，改变滚动条的状态
function change_text_area(id){
    $('#'+id).find('.ui-widget-header').slider_use();
    if($('#'+id).find('.ui-slider-vertical').length!=0){
        $('#'+id).find('.ui-slider-vertical').slider("value",0);
    }
}
//让textarea获取光标
function textaresa_focus(id){
    if($('.lightbox:visible #'+id)){
        $('.lightbox:visible #'+id).attr('_moz_abspos','#212121')
        .keypress(function(){$(this).attr('_moz_abspos','#212121');});
    }
    $('#'+id).focus();
}
function bottom_text_area(id){
    if($('#'+id).find('.ui-slider-vertical:last').length!=0){
        $('#'+id).find('.ui-slider-vertical:last').slider("value",0);
    }
}

//confirm close
function confirm_close(){
    $('#confirm_wait').addClass('hide');
    $('#confirm').addClass('hide');
}

function logout(url){
    confirm_box(_t('logout?'),function(){
	window.location.href="?m=logout&a=index";
    });
}

function my_debug(obj){
    if (jQuery.browser.msie){
        //$('#debug_div').show();
        //$('#debug_div').append(var_dump(obj,'html'));
    } else {
        console.log(var_dump(obj));
    }
}

function refresh_loading_img(typ){
    return '<div class="loading_'+typ+' load_back_color2"><div id="load_bar" class="load_change_color"></div></div><script>loading_bar();</script>';
}

function loading_bar(){
    $("#load_bar").css({width:0}).animate({width:203},600,'swing');
}
function loading_bar_next_day(){
    $("#loading_bar_next_day").css({width:0}).animate({width:203},600,'swing',function(){
        $("#i_news_mask").addClass('hide');
    });
}
function need_time()
{
    $("span[need_time]").each(function(j){
	$(this).html(formatTime($(this).attr("need_time")));
    });
}
function show_time()
{
    $("span[show_time]").each(function(j){
	$(this).html(formatDateTime($(this).attr("show_time")));
    });
}
var newsbox_opened = false;
var lightbox_opened = false;
var menubox_opened = false;
var _news_boxs_html;
var news_box_showing = false;
function news_box_show(obj){
    
    if($("#newsbox").hasClass('hide')){
        if(newbie_stat==0){
            alert_box(msg_newbie_i18n.newbie_first);
            return;
        }
        news_box_open();
    }else{
        show_next_feed(0,obj);
	//news_box_close();
    }
}
function news_box_open(end_mid){    
    if(lightbox_opened){
        if(lightbox_close()==false){
            return;
        }
    }
    $('#cot_game').removeClass('cot_game_btn').addClass('cot_game_sm');
    //$("#i_hearder").removeClass('i_header_main');
    news_box_showing = true;
    $("#i_sub_menus").hide();
    change_bg_class('bg_index');
    
    $(".lightbox_mask").css({opacity:0.5,height:'100%'}).removeClass('hide');

    
	g_continue_game.attr('id','continue_game');
	g_continue_game.attr('content',msg_newbie_i18n.con_game);
    if(newsbox_opened&&end_mid==undefined){
        g_news_content.html(_news_boxs_html);
        g_news_box.removeClass('hide').css({left:'50%',top:115,width:801,height:0}).animate({height:478},'fast',"swing");
	$(".use_hovertip").hovertip();
    }else{
        var url='?m=news&a=index';
        if(end_mid!=undefined&&end_mid!=0){
            url +='&end_mid='+end_mid; 
        }
        box_loading();
        g_news_content.html('').load(url,function(){
            box_loading_finish();
            g_news_box.removeClass('hide').css({left:'50%',top:115,width:801,height:0}).animate({height:478},'fast',"swing");
            newsbox_opened = true;
            if(newbie_stat==1){
                $(".scroll_target .scroll_content").slider_use();
            }
	    $(".use_hovertip").hovertip();
        });
    }
}
function news_box_close(){
    $('#cot_game').removeClass('cot_game_sm').addClass('cot_game_btn');
    $("#i_hearder").addClass('i_header_main');
    g_news_typ = 0;
    if (news_box_showing==false){
        return;
    }
    if(newbie_stat==0&&cur_task_id==0){
        if(news_box_showing){
            var typ = $('#all_news_list').attr('typ');
            var must_response = $('#all_news_list').attr('must_response');
            if(typ==903&&must_response==1){
                alert_box(msg_common_i18n.m1);
                return;
            }else if(typ==902&&must_response==1){
                alert_box(msg_common_i18n.m2);
                return;
            }else if(must_response==1){
                alert_box(msg_common_i18n.m3);
                return;
            }else{
                if(news_box_showing){
                    var test_conttent = msg_common_i18n.m4;
                }else{
                    var test_conttent = msg_common_i18n.m5;
                }
                   
                alert_box(msg_common_i18n.s1.str_supplant({test_conttent:test_conttent}));
                return;
            }
        }
    }
    if (newbie_stat ==1 && g_level<=7){
        close_go_on_help(6000);            
    }
    if(cur_task_id==109||cur_task_id==104){
        if(cur_step_id==1){
            alert_box(msg_common_i18n.m6);
            return
        }else if(cur_step_id==2){
            var test_conttent = $('#goon_game .goon_btn').attr('content');             
            alert_box(msg_common_i18n.m7);
           
            return;
        }
    }	
    news_box_showing = false;
    if(menubox_opened==false){
        $("#ty_btn").removeClass("ty_img");
        $(".lightbox_mask").addClass('hide');
    }else{		 
	$("#i_sub_menus").show();	 
    }
    _news_boxs_html = g_news_content.html();
    g_news_content.html('');
    g_continue_game.attr('id','cot_game');
    g_continue_game.attr('content',msg_common_i18n.m4);
    var target_offset = g_inews_target_pos.offset();
    g_news_box.addClass('closing').animate({top:135,height:0},'fast',"swing",function(){
    g_news_box.removeClass('closing').addClass('hide');
    thisMovie('start_game').news_box_close();
    });
}

function news_box_hide(){
    g_news_box.addClass('hide');
    $(".lightbox_mask").addClass('hide');
}

function news_box_unhide(){
    g_news_box.removeClass('hide');
    $(".lightbox_mask").removeClass('hide');
}

//展开与收缩新闻列表
function news_open_click(){
    var obj = $('#news_list_title');
    if(obj.hasClass('hide')){
        obj.removeClass('hide');
        obj.animate({left:-244,height:460},'3s',"swing");
        if(obj.attr('has_load')==0){
            obj.load('?m=news&a=news_list&format=html').attr('has_load',1);
        }
    }else{
        obj.animate({left:-500,height:460},'3s',"swing",function(){ 
            obj.addClass('hide');
        });
    }
}
function start_friend_match(op_uid){
    if(newbie_stat==1){
        if(g_web_status==1){
            alert_box(msg_common_i18n.m8);
            return;
        }
        //if(matchbox_flash_loading){
        //    alert_box('载入中，请稍后挑战！');
        //    return;
        //}
        plus = 'op_uid='+op_uid;
        ajax_handler('match','begin_friend_match',0,plus,function(json){
            now_mid = json.mid;
            matchbox_open(json.mid);
        });
    }else{
        alert_box(msg_newbie_i18n.newbie_first);
    }
}

function start_master_match(feed_id,has_home_buff){
    var plus = '';
    if(has_home_buff!=undefined){
        plus = 'has_home_buff='+has_home_buff;
    }else{
        plus = 'has_home_buff=0';
    }
    if(feed_id!=undefined){
        plus += '&feed_id='+feed_id;
    }
    //if(matchbox_flash_loading){
    //    alert_box('载入中，请稍后挑战！');
    //    return;
    //}
    if (cur_task_id == 104){
	finish_newbie_task_step(104,1);
    } else if (cur_task_id == 109){
	finish_newbie_task_step(109,1);
    }
    ajax_handler('ins','begin_ins_match',0,plus,function(json){
        if (has_home_buff>0){
            upd_i_header_info(json.header_info);
        }        
        matchbox_open(json.mid);
        newsbox_opened = false;
    });
    
}

function use_index_map_tooltip(){ 
    $(".use_index_map_tooltip").hover(function(){
        var target = $("#"+$(this).attr('tooltip'));
        $(".index_map_tooltip").addClass('hide');
        target.removeClass('hide');
        
    },function(){         
        if(tip_hover==false){             
            $(".index_map_tooltip").addClass('hide');
        } 
    }); 
}
function show_sub_menu_v2(id){
    var target = $("#"+id+" .i_sub_menu");
    target.show().css({bottom:90}).animate({bottom:145},200);

}
function hide_sub_menu_v2(id){
    var target = $("#"+id+" .i_sub_menu");
    target.hide();
}
function show_sub_menu_v1(id){
    var target = $("#"+id+" .i_sub_menu");
    target.show().rotate(-90);
    target.rotate({animateTo:0,duration:400});

}
function hide_sub_menu_v1(id){
    var target = $("#"+id+" .i_sub_menu");
    target.rotate(-90);
    target.hide();
}
 

//function chat_widget_show(){
//    var obj = $('#i_chat_content');
//    if(obj.hasClass('hide')){
//        obj.removeClass('hide');
//        $(".scroll_target .scroll_content").slider_use();
//        $('#chat_btn_on_up').addClass('hide');
//    } 
//}
function chat_widget_hide(){
    var obj = $('#i_chat_content');
    if(!obj.hasClass('hide')){
        obj.addClass('hide');
        $('#chat_btn_on_up').removeClass('hide');
    } 
}

var bg_class = 'bg_index';
function change_bg_class(new_class){	 
    $('body').removeClass(bg_class).addClass(new_class);
    bg_class = new_class;
}

var lightbox_url_stack = [];
var lightbox_size_stack = [];
var lightbox_id_stack = [];
//vip_type=1是QQ黄钻,2是系统vip
function tx_vip_box_open(modlue,action,vip_type){
    $('#i_right_tx_vip').removeClass('i_right_tx_vip').addClass('i_right_tx_vip_open');
    $('#i_right_tx_vip_new').removeClass('#i_right_tx_vip_new').addClass('i_right_tx_vip_new_open');
    g_alert_mask.css({opacity:0.75,height:g_body_height}).removeClass('hide');
    var url = "?m="+modlue+'&a='+action;
    if( vip_type == undefined ){
        vip_type=1;
    }
    if( vip_type == 1 ){
        var box_width = 525;
        var m_h = 477;
    } else {
        var box_width = 590;
        var m_h = 320;
    }
    g_tx_vip_box.html('').css({width:box_width,height:m_h});
    g_tx_vip_box.removeClass('hide');
    g_tx_vip_box.css({width:box_width,height:m_h,top:'50%',left:'50%',marginLeft:-box_width/2,marginTop:-m_h/2}).load(url,function(){        
        $(".use_hovertip").hovertip();
        if(newbie_stat==1){
            $(".scroll_target .scroll_content").slider_use();
        }  
    });
}
function close_tx_vip_box(){
    $('#txvip_box').addClass('hide');
    //thisMovie('bf_index_swf').GiftBagIsSelected(2,0);
    thisMovie('bf_index_swf').giftSuccess(3,0);
    g_alert_mask.addClass('hide');
}

function open_activity_box(){    
    tx_vip_box_open('vip','vip_activity');
}

function lightbox_open(url,size,add_id,callback){
    operating_box_close();
    modless_box_close();
    $("#i_sub_menus").hide();
    menubox_opened = false;
    if(menubox_opened){
        $("#i_sub_menus").hide();
    }
    if (news_box_showing){
        news_box_close();        
    } else {
        $(".lightbox_mask").css({opacity:0.5,height:'100%'}).removeClass('hide');
    }    
    lightbox_opened = true;
    $('#tooltips_info').addClass('hide');     
    switch(size){
        case "xl":
            lightbox_width = 930;
            //lightbox_ct_main = 836;
            lightbox_m_width = 830;
            lightbox_height = 530;
            break;
        case "l":
            lightbox_width = 735;
            //lightbox_ct_main =730;
            lightbox_m_width = 710;
            lightbox_height = 465;
            break;
        default:
            lightbox_width = 720;
            lightbox_height = 440;
            break;
    }
    var lightbox_margin = {
        l_top:-Math.round(lightbox_height/2)+20,
        l_left:-Math.round(lightbox_width/2)+30
    }
    if(add_id==undefined){
        add_id = '';
    }
    
    //$(".lightbox_top_ct,.lightbox_ct_main,.lightbox_bottom_ct").css({width:lightbox_m_width});
    if($.browser.msie||newbie_stat==0){		 
        g_lightbox_obj.removeClass('hide').show().css({top:'50%',width:lightbox_width,height:lightbox_height,marginLeft:lightbox_margin.l_left,marginTop:lightbox_margin.l_top});
            $("#lightbox_content").html(lightbox_loading).load(url,function(){
            $(".use_hovertip").hovertip();
            if(newbie_stat==1){
                $(".scroll_target .scroll_content").slider_use();
            }               
            if (callback!=undefined){
                callback.apply();
            }
	});
    } else {     
        $("#lightbox_content").html(lightbox_loading).load(url,function(){
            $(".use_hovertip").hovertip();
            if(newbie_stat==1){
                $(".scroll_target .scroll_content").slider_use();
            }
            if (callback!=undefined){
                callback.apply();
            }
        });
        g_lightbox_obj.removeClass('hide').show().css({top:'60%',width:lightbox_width,height:lightbox_height,marginLeft:lightbox_margin.l_left,marginTop:lightbox_margin.l_top}).animate({top:'50%'},"1.5s","linear");
    }
    //if (np_mask(); 
}

//modless_box  XL 大的   L 小的
var old_left = -2000;
var old_top = -2000;
var g_old_arrow_typ = 1;
var g_modless_box_open = false;
var modless_url_stack = [];
var modless_size_stack = [];
var modless_html_stack = [];

function modless_stack_clear(){
    modless_url_stack = [];
    modless_size_stack = [];
    modless_html_stack = [];
}

function modless_box_open(options){
    var defaults = {
        url:'',
        size:'xl',
        callback:null,
        _html:''
    }
    options = $.extend(defaults,options);
    if (!g_modless_box_open){
        modless_url_stack = [];
        modless_size_stack = [];
        modless_html_stack = [];
    }
    modless_url_stack.push(options.url);
    modless_size_stack.push(options.size);
    modless_html_stack.push(options._html);
    
    $('#tooltips_info').hide();
    var box_class = "sss";
    switch(options.size){
	case "xx":
            var box_margin = {
                l_left:-350
            }
                var box_width = 716;
            break;
    case "xl":
        var box_margin = {
            l_left:-350
        }
        var box_width = 777;
        box_class = "modless_big_bg";
        break;
    case "mml":
        var box_margin = {
            l_left:-350
        }
    var box_width = 443;
    box_class = "modless_sm_bg";
        break;    
    //case "xxxl":
    //    var box_margin = {
    //        l_left:-350
    //    }
    //var box_width = 930px;
    //box_class = "modless_dna_bg";
    //    break;
    
	case "lll":
            var box_margin = {
                l_left:-150
            }
		var box_width = 310;
            break;
        case "l":
            var box_margin = {
                l_left:-150
            }
		var box_width = 322;
            break;
	case "ml":
            var box_margin = {
                l_left:-300
            }
		var box_width = 620;
            break;
        case "mll":
            var box_margin = {
                l_left:-300
            }
		var box_width = 620;
            break;
        case "xxc":
            var box_margin = {
                l_left:-350
            }
                var box_width = 590;
            break;
	case "ll":
            var box_margin = {
                l_left:-260
            }
		var box_width = 516;
            break;
	    default:
                var box_margin = {
                l_left:-160
            }
		var box_width = 336;
            break;
    }
    options.reclass = box_class;
    g_modless_mask.css({opacity:0.75,height:g_body_height}).removeClass('hide');
    if (options._html!=''){
        g_modless_content.html(options._html);
        modless_box_show(options,box_width);
    } else {
        box_loading();
        
        g_modless_content.html('').load(options.url,function(){
            box_loading_finish();
            modless_box_show(options,box_width);
        });
    }
    g_modless_box_open = true;
}

function modless_box_show(options,box_width){
    var m_h = 435;
    g_modless_box.removeClass('hide modless_big_bg modless_sm_bg').addClass(options.reclass);
    g_modless_box.width(box_width);
    if(newbie_stat==0){
        g_modless_box.css({top:'50%',left:'50%',marginLeft:-box_width/2,marginTop:"-234px"});
    } else {		
        g_modless_box.css({top:'50%',left:'50%',marginLeft:-box_width/2,marginTop:-m_h/2});
    }
    $(".use_hovertip").hovertip();          
    if (options.callback!=null){
        options.callback.apply();
    }       
    if(newbie_stat==0){
        if(cur_task_id==106&&cur_step_id>=2){				  
                show_newbie_assist_arrow(1,'#tactic_learn_btn_1');				 
        }else if (cur_task_id==107&&cur_step_id>=2){
            if(is_gk!=undefined){
                if(is_gk==1){
                    var this_obj_id = "#add_point_btn_7";
                }else{
                    var this_obj_id = "#add_point_btn_1";
                }
                show_newbie_assist_arrow(2,this_obj_id); 
            }  
        }else if(cur_task_id==108&&cur_step_id>=1){            
            show_newbie_assist_arrow(1,"#newbie_btn_in_train"); 
        }else{
            if(!$("#newbie_assist_arrow").hasClass('hide')){
                old_left = $("#newbie_assist_arrow").css('left');
                old_top = $("#newbie_assist_arrow").css('top');
                g_old_arrow_typ = g_newbie_arrow_typ;
            }
            show_newbie_assist_arrow(1,"#modless_box_close");
        }
    }else{
        g_modless_box.draggable({opacity:0.8,scroll: false,handle:".box_header,.box_header_learn",cursor:"pointer"});
        $(".scroll_target .scroll_content").slider_use();
    }
}

function modless_box_close(){
    if(g_modless_box_open){
        g_modless_mask.addClass('hide');
        g_modless_box.addClass('hide');
        if(newbie_stat==0){
            $("#newbie_assist_arrow .arrow_real_img").attr('id','arrow_'+g_old_arrow_typ);
            g_newbie_arrow.removeClass('hide').animate({left:old_left,top:old_top},500,'easeInOutCubic');
            g_arrow_left = old_left;
            g_arrow_top = old_top;
        }
        g_modless_box_open = false;
        //first pop is himself
        modless_url_stack.pop();
        modless_size_stack.pop();
        modless_html_stack.pop();
        if (modless_url_stack.length>0){
            var opt = {"url":'',"size":'xl',"_html":''};
            opt.url = modless_url_stack.pop();
            opt.size = modless_size_stack.pop();
            opt._html = modless_html_stack.pop();
            modless_box_open(opt);
        }
    }
}
function change_lightbox_npc(typ,id){
    $("#lightbox_npc").html(common_get_IE_fix_png_style(res_url_prefix+'images/npc/n_lightbox_npc_'+typ+'_'+id+'.png',135,135));
}
function change_news_npc(typ,id){
    $("#npc").html(common_get_IE_fix_png_style(res_url_prefix+'images/npc/n_lightbox_npc_'+typ+'_'+id+'.png',135,135));
}

function esc_to_close_lightbox(event) 
{
    
}
var feed_time=0;
var g_lightbox_html = [];
function lightbox_close(is_fast){
    if(g_web_status==1){
        alert_box(msg_common_i18n.m9,1);
        return true;
    }
    if(lightbox_opened){
        if(cur_task_id==101&&g_module=='team'){
            alert_box(msg_common_i18n.m10);
            return false;
        }else if(cur_task_id==102&&cur_step_id>=2&&g_module=='transfer'){
            if(cur_step_id==1){
                alert_box(msg_common_i18n.m11);
            }else if(cur_step_id==2){
                alert_box(msg_common_i18n.m12);
            }else if(cur_step_id==3){
                alert_box(msg_common_i18n.m13);
            }
            return false; 
        }else if(cur_task_id==105&&cur_step_id>=1&&g_module=='tactics'){
            if(cur_step_id==1){
                alert_box(msg_common_i18n.m14);
            }else{
                alert_box(msg_common_i18n.m15);
            }			
            return false;
        }else if(cur_task_id==106&&cur_step_id>=1&&g_module=='tactics'){
            if(cur_step_id==1){
                alert_box(msg_common_i18n.m16);
            }else if(cur_step_id==2){
                alert_box(msg_common_i18n.m17);
            }else if(cur_step_id==3){
                alert_box(msg_common_i18n.m17);
            }
            return false;
        }else if(cur_task_id==107&&cur_step_id>=1&&g_module=='team'){
            if(cur_step_id==1){
                alert_box(msg_common_i18n.m19);
            }else if(cur_step_id==2){
                alert_box(msg_common_i18n.m20);
            }else if(cur_step_id==3){
                alert_box(msg_common_i18n.m21);
            }
            return false;
        }else if(cur_task_id==108&&cur_step_id>=1&&g_module=='team'){
            if(cur_step_id==1){
                alert_box(msg_common_i18n.m22);
            }else{
                alert_box(msg_common_i18n.m23);
            }
            return false;
        }
    }
    operating_box_close();
    modless_box_close();
    if (lightbox_opened===false){
        if (news_box_showing==true){
            news_box_close();
        } else if(menubox_opened){
            hide_sub_menu();
        } 
    }else{
        lightbox_opened = false;
        if(is_IE6){
            $(".lightbox_mask").addClass('hide');
        }
         
        if(g_module=='tactics'){
            g_lightbox_html[g_module] = g_lightbox_obj.html();
        }
        if(g_module=='match'){
            clearInterval(timmer_league);                    
        }
        g_module = '';
        g_action = '';
        if (is_fast!=undefined && is_fast==1){
            g_lightbox_obj.removeAttr('style').addClass('hide');
            if(menubox_opened==false){
                   $(".lightbox_mask").addClass('hide');
            }else{
               $('#i_sub_menus').show();
               if(newbie_stat==0){
                   show_newbie_help();
               }
            }
        } else {
            g_lightbox_obj.animate({top:'60%'},
            {queue:false,
             easing:"swing",
             duration:200,
             complete:function(){
                 $(this).removeAttr('style').addClass('hide');
                 if(menubox_opened==false){
                        $(".lightbox_mask").addClass('hide');
                 }else{
                    $('#i_sub_menus').show();
                    if(newbie_stat==0){
                        show_newbie_help();
                    }
                 }
             }
            });
        }
        
    }
    return true;
}
function show_sub_menu(id){
    if (news_box_showing==true){
        news_box_close();
    }
    $(".lightbox_mask").css({opacity:0.5,height:'100%'}).removeClass('hide');
    $(".i_sub_menu").hide();
	if(newbie_stat==1){
            $("#i_sub_menus").show().css({marginTop:-100}).animate({marginTop:-150},200);
	} 
    var target = $("#"+id);
    var length_li = target.children('li').length;
    var width_ul = 130*length_li+(length_li-1)*30+60;
    $('#i_sub_menus').css('width',width_ul+'px').css({marginLeft:-width_ul/2}).show();
    target.show();
    menubox_opened = true; 
}
function hide_sub_menu(){
    $("#i_sub_menus").hide();
    menubox_opened = false;
    $(".lightbox_mask").addClass('hide');
    show_newbie_help();    
}

function bg_swf_open(){
    $("#bg_swf").css({width:1440,height:700,top:0,left:'50%'});    
}
function bg_swf_hide(){
    //$("#bg_swf").css({});
    $("#bg_swf").css({width:1,height:1,top:-2000,left:-2000});
}


function matchbox_open(mid){
    if (now_mid != mid){
        now_mid = mid;
    }
    //关闭该关闭的
    if(now_mid>0){
        lightbox_close();
        news_box_close();
        $('#newbie_assist_arrow').addClass('hide');    
        g_match_box.addClass('reset_bg_size_holder').css({top:'0px',left:'50%'});
        
        //打开大底
        matchbox_opened = true;  
        g_match_holder.addClass('reset_bg_size');
        bg_swf_hide();
        reset_bg_size();
        $("#hack_match").show();
        
        real_begin_match();
    }
}
var real_begin_match_timer = 0;
function real_begin_match(){
    //发信号
    if(now_mid>0){
        if (matchbox_flash_loading){
            //载入中
            window.clearTimeout(real_begin_match_timer);
            real_begin_match_timer = window.setTimeout(real_begin_match,1000);
        } else {
            match_swf.beginMatch();
            window.clearTimeout(real_begin_match_timer);
        }
    }else{
        window.clearTimeout(real_begin_match_timer);
    }
}

function init_match_ready(){
    //完成载入
    matchbox_flash_loading = false;
    match_swf = thisMovie('Football');
}

function clear_match_ready(){
    matchbox_flash_cleared = true;
}

function match_lost_conn(loading_typ){
    //loading_typ1：正在比赛中，点击
    //其他   
    if(loading_typ==1){
        match_swf = undefined;
        matchbox_flash_loading = true;
        g_web_status = 0;
        g_load_flash = 1; 
        $.getJSON('?m=index&a=sync_match&format=json',function(json){
            if (json.rstno>0){
                g_match_holder.html('');
                auto_fit_swf({movie:res_url_prefix+'images/flash/Football.swf?ver='+g_res_version,
                    id:'Football',
                    wmode:'window',
                    target_id:'match_swf',
                    bg_color:'#000000',
                    reset_bg:false
                });
                now_mid = json.now_mid;
                match_flag = json.flag;
                if (now_mid>=0){
                    real_begin_match();
                }
            } else {
                alert_box(msg_common_i18n.m24);
            }
        });
    }else{
        reload_login();
    }
}

var testing_timer = 0;
function matchbox_close(){
    g_match_box.removeClass('reset_bg_size_holder').css({height:1,width:1,top:-2000,left:-2000});
    g_match_holder.removeClass('reset_bg_size');
    $("#matchbox_mask").addClass('hide');    
    matchbox_opened = false;
    window.clearTimeout(testing_timer);
    bg_swf_open();
    $("#hack_match").hide();
    match_flag = 1;
    now_mid = 0;
}
var flashbox_opened_show = false;
function flashbox_open(url){
    if(g_web_status==1){
        alert_box(msg_common_i18n.m9,1);
        return;
    }
    lightbox_close();
    news_box_close();
    $('#newbie_assist_arrow').addClass('hide');
    
    
    var t_top = 0;
    if (g_content_height>600){
        t_top = (g_content_height -600)/2;
    }
    g_setform_box.css({top:t_top,left:'50%',width:1032,height:628});//.addClass('reset_bg_size_holder');
    //g_setform_holder.addClass('reset_bg_size');
    //bg_swf_hide();
    //reset_bg_size();
    if(is_set_form_ready==1){
        if(g_setting_from==1){            
            set_form_swf.send_reset_http_quest();
            g_setting_from = 0;
            g_load_form_swf_day = g_load_news_count;
        }else{           
            var diff_days = g_load_news_count-g_load_form_swf_day;         
            if(diff_days>0&&newbie_stat==1){
                set_form_swf.refreshCond(diff_days);
                g_load_form_swf_day = g_load_news_count;
            }
    
        }
    }
    g_setting_from = 0;
    flashbox_opened_show = true;
    
    if (newbie_stat==0){        
        play_setform_newbie();
        
    }
}

function play_setform_newbie(){
    if (is_set_form_ready==1){        
        set_form_swf.newStepAniMationPlay();
    } else {
         window.setTimeout(play_setform_newbie,1000);
    }
}
var testing_timer = 0;
var is_set_form_ready = 0;
function set_form_ready(){
    is_set_form_ready = 1;
    set_form_swf = thisMovie('setting_form');
    g_setting_from = 0;
    
}
function flashbox_close(){
	
    //$("#flashbox").hide().addClass('hide');
    $("#flashbox").css({width:1,height:1,top:-2000,left:-2000});
    $("#matchbox_mask").addClass('hide');    
    matchbox_opened = false;     
    window.clearTimeout(testing_timer);
    bg_swf_open();
    //flashbox_opened = false;
    flashbox_opened_show = false;
    //if(newbie_stat==0){
    //    finish_newbie_task_step(103,2);
    //}
}
var alert_close_timer = 0;
var alert_close_counter = 7;
var alert_box_exit = 0;
//typ==1,success,typ=0,error
function alert_box_1(msg,typ,callback){
    alert(msg);
    return;
    if (alert_box_exit == 0){
            if (typ==undefined || typ==0){
        congratulations_box(-1,'',msg);
        $("#alert_btn").unbind('click').click(function(){
            if (callback!=undefined){                    
                alert_box_close();
                callback.apply();
            }           
        });
            } else {
        congratulations_box(-2,'',msg);
            }
        alert_box_exit = 1;
    }
}
function alert_counterdown(){
    if (alert_close_counter!=1){
	alert_close_counter--;
	$("#alert_timer").html(alert_close_counter);
    } else {
	alert_box_close();
    }
}
function alert_box_close(){
    alert_close_counter = 7;
    g_alert_box.addClass('hide');
    g_alert_mask.addClass('hide');
    now_confirm = undefined;
    g_now_confirm = false;     
    mask_mod = '';
}

function confirm_btn(name,callback,class_name,need_block,is_enter){
    this.callback = callback;
    this.html = '<a class="'+class_name+'" href="javascript:void(0);">'+name+'</a>';
    this.need_block = need_block;
    if (is_enter==undefined){
        is_enter = false;
    }
    this.is_enter = is_enter;    
};

function newbie_box(id,msg,btn_name,callback){
    $('#alert_box_in').removeClass('game_product_bg');
    if (id!=''){
	var _msg = $("#msg"+id).html();
    } else {
	var _msg = msg;
    }
    
    var news_btn_list = new Array;
    news_btn_list[0] = new confirm_btn(btn_name,callback,'alert_right_btn fr',false);
    _confirm_box(_msg,4,news_btn_list);
}

//msg 信息，//typ==1,success,typ=0,error 3 confirm
function alert_box(msg,typ,callback){	
    var btn_list = new Array;
    btn_list[0] = new confirm_btn(msg_common_i18n.ok,callback,'alert_right_btn fr',false,true);
    if (typ == undefined){
        typ = 1;
    }
	 
    _confirm_box(msg,typ,btn_list);
}

function succ_box(msg){
    event = $.getEvent();
    if (event==undefined){
        alert_box(msg,1);
        return;
    }
    var x = event.pageX;
    var y = event.pageY;
    g_succ_info.html(msg).removeClass('hide').css({top:y,left:x});
    alert('x:'+x+',y:'+y);
}

function confirm_box(msg,callback_ok,callback_cancel){
    var btn_list = new Array;
    btn_list[0] = new confirm_btn(msg_common_i18n.cancel,callback_cancel,'alert_wrong_btn mr_fr',false);
    btn_list[1] = new confirm_btn(msg_common_i18n.ok,callback_ok,'alert_right_btn mr_fr',true);
    _confirm_box(msg,3,btn_list);
}
var now_confirm;
var g_now_confirm = false; 
function _confirm_box(msg,typ,btn_list,npc){
    mask_mod = 'confirm';
    g_alert_op.html('');
    for (var i=0;btn_list[i];i++){
        (function(){
	    var this_btn = btn_list[i];
            var j_this_btn = $(btn_list[i].html);
            var callback = btn_list[i].callback;
            j_this_btn.click(
            function(){					
                if (this_btn.need_block==true){
                    g_alert_op.block();
                }
                if ( callback!= undefined){
                    callback.apply(this,arguments);
                }
//		    $(this).unblock();
                if (typ!=4){
                    if (this_btn.need_block==false){
                        alert_box_close();
                    }
                }
            });
            if (this_btn.is_enter){
                now_confirm = j_this_btn;
            }
            g_alert_op.append(j_this_btn);    
        })();      
    }
    if (npc==undefined){
        npc = 7;
    }
    g_alert_npc.html(common_get_IE_fix_png_style(res_url_prefix+'images/npc/lightbox_npc_'+npc+'_1.png',210,375));
    g_alert_msg.removeClass().addClass('alert_img_'+typ).html(msg);
    
    g_alert_box.removeClass('hide');
    var ml = 0 - g_alert_box.width()/2-50;
    var mt = (600 - g_alert_box.height())/2;
    g_alert_box.css({marginLeft:ml,top:mt});
    
    g_alert_mask.css({opacity:0.75,height:g_body_height}).removeClass('hide');
    if(btn_list.length==1){
        g_now_confirm = $("#alert_box_in #confirm_op .alert_right_btn");         
    }
}
var congratulations_close_timer = 0;
var congratulations_stack = new Array();
var congratulations_box_opened = 0;

//typ:0 level_up恭喜；1task完成；2task接受
function congratulations_box(typ,url_plus,msg){

}
function cong_box_move_bottom(){
   
}
function cong_box_close(){

}
$.fn.op_style = function(){
    $(this).find('dt:even,dd:even').addClass('map_odd');
}
var mask_mod = '';
function operating_box(param){
	mask_mod = 'operating_box'
    var target = $("#operating_box");	
    if (param.url!=undefined){
	g_alert_mask.css({opacity:0,height:g_body_height}).removeClass('hide');
        target.html('').load(param.url,function(){
            target.css({top:param.top,left:param.left}).removeClass('hide');
            $(".scroll_target .scroll_content").slider_use(); 	
	});
    } else if (param.id!=undefined){
        g_alert_mask.css({opacity:0,height:g_body_height}).removeClass('hide');
        target.html($("#"+param.id).html());
        //$("#"+param.id).html('');
        target.css({top:param.top,left:param.left}).removeClass('hide');
        $(".scroll_target .scroll_content").slider_use(); 		
    } else {
        alert_box('bad param for op box!',0);
        return;
    }
    
}
function operating_box_close(){
    if (mask_mod == 'operating_box'){
        $("#operating_box").html('').addClass('hide');
        g_alert_mask.addClass('hide');
        mask_mod = '';
    }	
}

function show_setting_form(){
    finish_newbie_task_step(103,1);
    if(newbie_stat==0&&cur_task_id==0){
        var typ = $('#all_news_list').attr('typ');
        var must_response = $('#all_news_list').attr('must_response');
        if(typ==903&&must_response==1){
                alert_box(msg_common_i18n.m1);
                return;
        }else if(typ==902&&must_response==1){
                alert_box(msg_common_i18n.m2);
                return;
        }else if(must_response==1){
                alert_box(msg_common_i18n.m3);
                return;
        }else{ 
            if(news_box_showing){
                var test_conttent = msg_common_i18n.m4;
            }else{
                var test_conttent = msg_common_i18n.m5;
            }
                
            alert_box(msg_common_i18n.s1.str_supplant({test_conttent:test_conttent}));
            return;
        }
    }
	if(newbie_stat==0){
            if(cur_task_id!=103){
                alert_box(msg_common_i18n.m25,1);
		return;
            }  
	}
	change_bg_class('bg_setting_form');
	flashbox_open('?m=team&a=setting_form'); 
}

var g_module;
var g_action;
function lightbox_tab_show(module,action,plus){
    if(g_web_status==1){
        alert_box(msg_common_i18n.m9,1);
        return;
    }
    if (newbie_stat==0){
        var level_needed = lightbox_can_read[module];
        if (level_needed === undefined){
            alert_box(msg_newbie_i18n.newbie_first,0);
            return;
        } else {
            level_needed = lightbox_can_read[module][action];
            if (level_needed === undefined){
            alert_box(msg_newbie_i18n.newbie_first,0);
            return;
            } else if (cur_task_id < level_needed){
            alert_box(msg_newbie_i18n.m1,0);
            return;
            }
        }
        if (lightbox_hook_newbie[module]!=undefined){
            if (lightbox_hook_newbie[module][action]!=undefined){
            if (lightbox_hook_newbie[module][action]['task_id']==101){
                finish_newbie_task_step(101,1);
                finish_newbie_task_step(107,1);
            } else {
                finish_newbie_task_step(lightbox_hook_newbie[module][action]['task_id'],lightbox_hook_newbie[module][action]['task_step']);
            }
            }
        }
    } 
    if(lightbox_opened&&g_module==module){	    
        lightbox_tab_change(module,action,plus);
        
        
    }else{         
        if(action=='index'){
            var url = '?m='+module+'&a=index';
        }else{
            var url = '?m='+module+'&a=index'+'&sub_a='+action;
        }
        if (plus!=undefined){
            url += '&'+plus;
        }
        var size= 'xl';
        operating_box_close();
        modless_box_close();
        $("#i_sub_menus").hide();
        menubox_opened = false;
        if(menubox_opened){
            $("#i_sub_menus").hide();
        }
        if (news_box_showing){
            news_box_close();        
        } else {
            $(".lightbox_mask").css({opacity:0.5,height:'100%'}).removeClass('hide');
        }    
        lightbox_opened = true;
        $('#tooltips_info').addClass('hide');     
        switch(size){
            case "xl":
                lightbox_width = 930;
                //lightbox_ct_main = 836;
                lightbox_m_width = 830;
                lightbox_height = 530;
                break;
            case "l":
                lightbox_width = 735;
                //lightbox_ct_main =730;
                lightbox_m_width = 710;
                lightbox_height = 465;
                break;
            default:
                lightbox_width = 720;
                lightbox_height = 440;
                break;
        }
        var lightbox_margin = {
            l_top:-Math.round(lightbox_height/2)+20,
            l_left:-Math.round(lightbox_width/2)+30
        }
        if(g_lightbox_html[module]!=undefined&&newbie_stat==1){            
            g_lightbox_obj.html(g_lightbox_html[module]);            
            lightbox_tab_change(module,action,plus);             
            g_lightbox_obj.removeClass('hide').show().css({top:'60%',width:lightbox_width,height:lightbox_height,marginLeft:lightbox_margin.l_left,marginTop:lightbox_margin.l_top}).animate({top:'50%'},"1.5s","linear");
        }else{
            if($.browser.msie||newbie_stat==0){
                box_loading();
                $("#lightbox_content").html('').load(url,function(){
                    box_loading_finish();
                    g_lightbox_obj.removeClass('hide').show().css({top:'50%',width:lightbox_width,height:lightbox_height,marginLeft:lightbox_margin.l_left,marginTop:lightbox_margin.l_top});
                    $(".use_hovertip").hovertip();
                    if(newbie_stat==1){
                        $(".scroll_target .scroll_content").slider_use();
                    }else{              
                        newbie_stat_open_lightbox(module,action);
                    }
                });
            } else {
                box_loading();
                $("#lightbox_content").html('').load(url,function(){                    
                    box_loading_finish();
                    g_lightbox_obj.removeClass('hide').show().css({top:'50%',width:lightbox_width,height:lightbox_height,marginLeft:lightbox_margin.l_left,marginTop:lightbox_margin.l_top});
                    $(".use_hovertip").hovertip();
                    if(newbie_stat==1){
                        $(".scroll_target .scroll_content").slider_use();
                    }                   
                });
                g_lightbox_obj.removeClass('hide').show().css({top:'60%',width:lightbox_width,height:lightbox_height,marginLeft:lightbox_margin.l_left,marginTop:lightbox_margin.l_top}).animate({top:'50%'},"1.5s","linear");
            }
        }
        //g_lightbox_html[g_module] = g_lightbox_obj.html();
	//lightbox_open(url,size,function(){
	//           
	//});
    }
    
  
    close_tx_vip_box();
    g_module = module;
    g_action = action;
}
function tutorials_open(module,action){
    var tu_target = module+'_'+action;
    g_lightbox_tu.removeClass('hide');
    insert_swf({width:872,height:469,url:'images/flash/tu/'+tu_target+'.swf?ver='+g_res_version,id:'tutorials_open',wmode:'transparent'},g_lightbox_tu);
}
function tutorials_close(){
    g_lightbox_tu.addClass('hide');
    g_lightbox_tu.html('');
}
//新手期开lightbox
function newbie_stat_open_lightbox(module,action){
    if(newbie_stat==0){
        if(module=='team'){
            if(cur_task_id==101&&cur_step_id>=1){				
                if(action!='team_index'){
                    show_newbie_assist_arrow(1,"#tab_team_index");                
                }else{                 
                    var rand_index = user_uid%6+1;          
                    show_newbie_assist_arrow(1,"#newbie_task_btn_team_player_1"); 
                }                    
            }else if(cur_task_id==107&&cur_step_id>=1){
                if(action!='team_index'){
                    show_newbie_assist_arrow(1,"#tab_team_index");                
                }else{                 
                    var rand_index = user_uid%6+1;          
                    show_newbie_assist_arrow(1,"#newbie_task_btn_team_player_1"); 
                }
            }else if(cur_task_id==108&&cur_step_id>=1){
                if(action!='sp_training'){
                    show_newbie_assist_arrow(1,"#tab_sp_training");                
                }else{   
                    show_newbie_assist_arrow(1,"#training_player_select_btn"); 
                }
            }
        }else if(module=='tactics'){
            if(cur_task_id==105&&cur_step_id>=1){
                if(action!='formation_research'){
                    show_newbie_assist_arrow(1,"#tab_formation_research");                
                }else{
                    show_newbie_assist_arrow(1,'#formation_learn_new_task_btn');
                }
            }else if(cur_task_id==106&&cur_step_id>=1){
                if(action!='tactics_research'){
                    show_newbie_assist_arrow(1,"#tab_tactics_research");                
                }else{
                    show_newbie_assist_arrow(1,"#learn_tactic_btn"); 
                }
            }
        }else if(module=='vip'){
            $('#i_registration_gift_new').removeClass('#i_registration_gift_new').addClass('i_registration_gift_new_open');
        }else if(module=='transfer'){
            if(cur_task_id==102){
                if(action=="player_refresh"){					
                    if(cur_step_id<=2){            
                        show_newbie_assist_arrow(1,"#player_refresh_btn");
                    }else if(cur_step_id==3){
                        var rand_index =  user_uid%6+1;
                        show_newbie_assist_arrow(1,"#sign_player_btn_1");
                    }
                }else{
                    show_newbie_assist_arrow(1,"#tab_player_refresh"); 
                }
            }
        }
    }
}
function show_select_tab(tab){
    if(newbie_stat==0&&cur_task_id==0){
        var typ = $('#all_news_list').attr('typ');
        var must_response = $('#all_news_list').attr('must_response');
        if(typ==903&&must_response==1){
            alert_box(msg_common_i18n.m1);
            return;
        }else if(typ==902&&must_response==1){
            alert_box(msg_common_i18n.m2);
            return;
        }else if(must_response==1){
            alert_box(msg_common_i18n.m3);
            return;
        }else{
             if(news_box_showing){
                var test_conttent = msg_common_i18n.m4;
            }else{
                var test_conttent = msg_common_i18n.m5;
            }
                
            alert_box(msg_common_i18n.s1.str_supplant({test_conttent:test_conttent}));
            return;
        }
    }
    if(newbie_stat==0){
        if(cur_task_id==109||cur_task_id==104){
            if(cur_step_id==1){
                alert_box(msg_common_i18n.m26);
                return;
            }else if(cur_step_id==2){
                 if(news_box_showing){
                    var test_conttent = msg_common_i18n.m4;
                }else{
                    var test_conttent = msg_common_i18n.m5;
                }
                    
                alert_box(msg_common_i18n.s1.str_supplant({test_conttent:test_conttent}));
                return;
            }
        }else if(cur_task_id==103){
            //show_newbie_assist_arrow(1,"#i_m_training");
            show_newbie_assist_arrow(3,"#i_news_zr");
            alert_box(msg_common_i18n.m27,1);
            return;
        } else if (cur_task_id==101){
            if (tab!='team'){
                alert_box(msg_newbie_i18n.m1,0);
                return; 
            }
        } else if (cur_task_id==102){
            if (tab!='transfer'){
                alert_box(msg_newbie_i18n.m1,0);
                return; 
            }
        } else if (cur_task_id==105 || cur_task_id==106){
            if (tab!='tactics'){
                alert_box(msg_newbie_i18n.m1,0);
                return; 
            }
        }
    }
    if(lightbox_opened){
        if(cur_task_id==101&&g_module=='team'){
            alert_box(msg_common_i18n.m10);
            return;
        }else if(cur_task_id==102&&cur_step_id>=2&&g_module=='transfer'){
            if(cur_step_id==1){
                alert_box(msg_common_i18n.m11);
            }else if(cur_step_id==2){
                alert_box(msg_common_i18n.m12);
            }else if(cur_step_id==3){
                alert_box(msg_common_i18n.m13);
            }
            return;
             
        }else if(cur_task_id==105&&cur_step_id>=1&&g_module=='tactics'){
            if(cur_step_id==1){
                alert_box(msg_common_i18n.m14);
            }else{
                alert_box(msg_common_i18n.m15);
            }			
            return;
        }else if(cur_task_id==106&&cur_step_id>=1&&g_module=='tactics'){
            if(cur_step_id==1){
                alert_box(msg_common_i18n.m16);
            }else if(cur_step_id==2){
                alert_box(msg_common_i18n.m17);
            }else if(cur_step_id==3){
                alert_box(msg_common_i18n.m17);
            }
            return;
        }else if(cur_task_id==107&&cur_step_id>=1&&g_module=='team'){
            if(cur_step_id==1){
                alert_box(msg_common_i18n.m19);
            }else if(cur_step_id==2){
                alert_box(msg_common_i18n.m20);
            }else if(cur_step_id==3){
                alert_box(msg_common_i18n.m21);
            }
            return;
        }else if(cur_task_id==108&&cur_step_id>=1&&g_module=='team'){
            if(cur_step_id==1){
                alert_box(msg_common_i18n.m22);
            }else{
                alert_box(msg_common_i18n.m23);
            }
            return;
        }
    }
    lightbox_close();
    change_bg_class('bg_'+tab);
    show_sub_menu('i_sub_m_'+tab);
    if(newbie_stat==0){
        if(tab=='team'&&cur_task_id==101){		
            show_newbie_assist_arrow(1,"#sub_team_team_index");
        }else if(cur_task_id==101){
            show_newbie_assist_arrow(3,"#i_m_training");
        }else if(tab=='transfer'&&cur_task_id==102){
            show_newbie_assist_arrow(1,"#sub_transfer_player_refresh h4");
        }else if(cur_task_id==102){
            show_newbie_assist_arrow(3,"#i_m_transfer");
        //}else if(tab=='team'&&cur_task_id==103){
        //	show_newbie_assist_arrow(1,"#i_news_zr");
        }else if(cur_task_id==103){
            //show_newbie_assist_arrow(1,"#i_m_training");
            show_newbie_assist_arrow(3,"#i_news_zr");
            alert_box(msg_common_i18n.m27,1);
            return;
        }else if(tab=='tactics'&&cur_task_id==105){
            show_newbie_assist_arrow(1,"#sub_tactics_formation_research h4");
        }else if(cur_task_id==105){
            show_newbie_assist_arrow(1,"#i_m_tactics");
        }else if(tab=='tactics'&&cur_task_id==106){
            show_newbie_assist_arrow(1,"#sub_tactics_tactics_research h4");
        }else if(cur_task_id==106){
            show_newbie_assist_arrow(1,"#i_m_tactics");
        }else if(tab=='team'&&cur_task_id==107){
            show_newbie_assist_arrow(1,"#sub_team_team_index h4");
        }else if(cur_task_id==107){
            show_newbie_assist_arrow(1,"#i_m_training");
        }else if(tab=='team'&&cur_task_id==108){
            show_newbie_assist_arrow(1,"#sub_team_sp_training h4");
        }else if(cur_task_id==108){
            show_newbie_assist_arrow(1,"#i_m_training");
        }
    }
}
//切换tab
function lightbox_tab_change(module,action,plus){
    modless_box_close();
    operating_box_close();
     if(cfg_assist_help_list[module]==undefined){
        $('#once_lightbox_flash').addClass('hide');                        
    }else if(cfg_assist_help_list[module][action]==undefined){
        $('#once_lightbox_flash').addClass('hide');
    }else{
        $('#once_lightbox_flash').removeClass('hide');
    }
    $(".lightbox_header_content li").removeClass('active');
    $("#tab_"+action).addClass('active');
    $(".lightbox_content").addClass('hide');
    var url = '?m='+module+'&a='+action;
    if (plus!=undefined){
        url += '&'+plus;
    }
    var this_obj_a = $("#"+action);
    //与他人有关 不做tab缓存的
    var tab_load_flag = 0;
    if((module=='transfer'&&action=="player_loan")||(module=='transfer'&&action=="player_market")||(module=='team'&&action=='youth_team')
       ||(module=='match'&&(action=='league_index'||action=='match_tier'||action=='match_tour_pre'))||module=='union'||(module=='tacitcs'&&action=='tactics_research')){
        tab_load_flag = 1;
    }
    if(newbie_stat==1&&this_obj_a.attr('in_showing')==1&&tab_load_flag==0){
        this_obj_a.removeClass('hide');
        if(newbie_stat==1){
            $(".scroll_target .scroll_content").slider_use();
        }
        $(".use_hovertip").hovertip();
    }else{
        this_obj_a.removeClass('hide').attr('in_showing',1).load(url,function(){
            if(newbie_stat==1){
                $(".scroll_target .scroll_content").slider_use();
            }
            $(".use_hovertip").hovertip();
            //新手引导处理
            if(newbie_stat==0){
                if(module=='team'){
                    if(cur_task_id==101&&cur_step_id>=1){				
                        if(action!='team_index'){
                            show_newbie_assist_arrow(1,"#tab_team_index");                
                        }else{                 
                            var rand_index = user_uid%6+1;          
                            show_newbie_assist_arrow(1,"#newbie_task_btn_team_player_1"); 
                        } 
                    }else if(cur_task_id==107&&cur_step_id>=1){
                        if(action!='team_index'){
                            show_newbie_assist_arrow(1,"#tab_team_index");                
                        }else{                 
                            var rand_index = user_uid%6+1;          
                            show_newbie_assist_arrow(1,"#newbie_task_btn_team_player_1"); 
                        }
                    }else if(cur_task_id==108&&cur_step_id>=1){
                        if(action!='sp_training'){
                            show_newbie_assist_arrow(1,"#tab_sp_training");                
                        }else{   
                            show_newbie_assist_arrow(1,"#training_player_select_btn"); 
                        }
                    }
                }else if(module=='tactics'){
                    if(cur_task_id==105&&cur_step_id>=1){
                        if(action!='formation_research'){
                            show_newbie_assist_arrow(1,"#tab_formation_research");                
                        }else{
                            show_newbie_assist_arrow(1,'#formation_learn_new_task_btn');
                        } 
                    }else if(cur_task_id==106&&cur_step_id>=1){
                        if(action!='tactics_research'){
                            show_newbie_assist_arrow(1,"#tab_tactics_research");                
                        }else{
                            show_newbie_assist_arrow(1,"#learn_tactic_btn"); 
                        }
                    }
                }else if(module=='transfer'){
                    if(cur_task_id==102){
                        if(action=="player_refresh"){					
                            if(cur_step_id==2){            
                                show_newbie_assist_arrow(1,"#player_refresh_btn");
                            }else if(cur_step_id==3){
                                var rand_index =  user_uid%6+1;
                                show_newbie_assist_arrow(1,"#sign_player_btn_1");
                            }
                        }else{
                            show_newbie_assist_arrow(1,"#tab_player_refresh"); 
                        }
                    }
                }else if(module=='match'){
                    if(action!='league_index'){
                        clearInterval(timmer_league);
                    }
                }
            }
        });
    }
}

function change_option(id){
    var next_obj = $('#'+id).children('ul');
    if(next_obj.hasClass('hide')){
        next_obj.removeClass('hide');
        $('#'+id).children('.selectbox_close').removeClass('selectbox_close').addClass('selectbox_extend');
    }else{
        next_obj.addClass('hide');
        $('#'+id).children('.selectbox_extend').removeClass('selectbox_extend').addClass('selectbox_close');
    }
}
/*******************************通用部分***************************************/
var is_IE6 = 1;
var is_window_focus = true;
var timer_blur = 0;
var timer_goon = 0;
var focus_in_input = false;
$(function(){
    sync_time();
    need_time();
    show_time();
    
    $(".use_hovertip").hovertip();
    $('#confirm').draggable();
    $('#dialogCase').draggable();
    
    if(jQuery.browser.msie){
        if (parseInt(jQuery.browser.version)>6){
            is_IE6 = 0;
        } else {
            is_IE6 = 1;
        }
    } else {
        is_IE6 = 0;
    }
    if (is_IE6==1){
        window.setInterval(show_hide_ie_warn,20000);
    } else if (jQuery.browser.msie && jQuery.browser.version==7){
        window.setInterval(show_hide_ie_warn,30000);
    }
    if(!!window.console && !!window.console.firebug){
        //alert_box("please close your firebug.");
    }
    
    $('#chat_input').keydown(function(e){
            if(e.keyCode==13){
               send_chat()
            }
    }).focus(function(){
        focus_in_input = true;
    }).blur(function(){
        focus_in_input = false; 
    });
    
    $(window).blur(function(e){		
        if (is_window_focus){
                timer_blur = setTimeout(check_blur,5000);			
        }
            
    }).focus(function(e){
        if (!is_window_focus){
            if (timer_blur>0){
                    clearTimeout(timer_blur);
                    timer_blur = 0;
            }
            is_window_focus = true;
            if (!matchbox_flash_loading){
                match_swf.flash_on_active();
            }
            if(background_swf_readied==1){
            	thisMovie('bf_index_swf').flash_on_active();
            }
        }
    });
    $(document).keydown(function(e){
        handler_keydown(e)});
});
var ie_warn;
function show_hide_ie_warn(){
    if (newbie_stat==0){
        return;
    }
    if (ie_warn==undefined){
        ie_warn = $("#ie_warn");
    }
    ie_warn.toggle(200);
}

function handler_keydown(e){
    //my_debug(e.keyCode);
    if (focus_in_input){
        return;
    }
    switch (e.keyCode){
        case 27:
            //esc
            break;
        case 32:
            
            //空格
            if (matchbox_opened){
                return;
            }
            if (news_box_showing){
                $("#news_con_btn").click();    
            }
            
            break;
        case 13:
            //回车
            
            if(g_now_confirm){                
                g_now_confirm.click();
            }
            break;
        case 49:
            $("#event_choise_1").click();
            break;
        case 50:
            $("#event_choise_2").click();
            break;
    }
    e.keyCode=0;
    e.returnValue=false;
    e.stopPropagation();
    return false;
//    if(window.event&&window.event.keyCode==27){		 
//		lightbox_close();	 
//		window.event.keyCode=0;;  
//		window.event.returnValue=false;   
//    }else if(event&&event.keyCode==27){		 
//		lightbox_close();		 
//		event.keycode=0;
//		event.returnValue=false; 
//	}	
}

function check_blur(){
	//my_debug('check_blur'+$(window).outerHeight()+':'+$(window).innerHeight());
	//if (window.outerHeight<window.innerHeight) {
	is_window_focus = false;
    timer_blur = 0;  
}
var background_swf_readied = 0;
function background_swf_ready(){    
    if (background_swf_readied==1){
        return;
    }
    background_swf_readied = 1;
    $("#i_hearder").removeClass('hide');
    $("#i_bottom").removeClass('hide');
    $("#i_chat").removeClass('hide');
    $("#i_news").removeClass('hide');
    
    
    $("#sign_vip_box").removeClass('hide');
    
    if (qz_gift_act==1){
        tx_vip_box_open('vip','gzgift');
    } else if (need_get_player_gift==1) {
       // tx_vip_box_open('vip','sent_player_level');
    }
    auto_fit_swf({movie:res_url_prefix+'images/flash/Football.swf?ver='+g_res_version,
        id:'Football',
        wmode:'window',
        target_id:'match_swf',
        bg_color:'#000000',
        reset_bg:false
    });
    //TODO zhuxu 自动弹活动窗口
    if (newbie_stat!=0&&vip_act==1){
    	tx_vip_box_open('vip','vip_activity');
    }
    if (newbie_stat==0){
        
        thisMovie('bf_index_swf').unLockBuild(15);
        if (cur_task_id == -1){
            //msg1();
        }
        else if ( cur_task_id==0 || cur_task_id==104|| cur_task_id==109){
            news_box_open();
        } else {
            show_newbie_help();
        }
        if ($.browser.webkit || $.browser.mozilla || $.browser.safari){
            window.onbeforeunload = function(){
                return msg_common_i18n.m28;
            };
        } else {
            window.onunload = function(){
                alert(msg_common_i18n.m29);
            };
        }
        
        
    } else {
        //TODOZHUXU
        if (g_level<10){
            if ($.browser.webkit || $.browser.mozilla || $.browser.safari){
                window.onbeforeunload = function(){
                   return msg_common_i18n.m30;
                };
            }else {
                window.onunload = function(){
                    alert(msg_common_i18n.m31);
                };
            }
        }
        
        thisMovie('bf_index_swf').unLockBuild(100);
        g_i_task_list.removeClass('hide');
        g_friend_list.removeClass('hide');
        g_present_gift.removeClass('hide');
        g_i_vip_gift.removeClass('hide');
        //$("#i_club_right_box").removeClass('hide');
        if (g_level <=7){
            //8级以内，比较长时间没点继续游戏就点继续游戏
            timer_goon = setTimeout(show_go_on_help,1000);
        }
    }
    //if(now_mid>0){
    //    
    //} 
    
}
//计时器
var league_auto_reload = 0;
var tournament_auto_reload = 0;

 
var timmer_time = 0;
var timmer_flag = 0;
var g_obsession_alert = 0;

//倒计时，在span上加positionTimeValue=倒计时的结束时间戳和class=positionTime
function cmptime()
{
    sync_time();
    if (newbie_stat==0){
        real_show_newbie_assist_arrow();
    }
    var currentTime = Math.floor( Date.parse(new Date()) / 1000 )-differ_time;
    if (tour_next_match_zeit>0 && currentTime>tour_next_match_zeit-10 && currentTime%3==0){
        $.getJSON('?m=index&a=sync_match&format=json',function(json){
            if (json.rstno>0){                
                now_mid = json.now_mid;
                match_flag = json.flag;
                if (now_mid>0){
                    matchbox_open(now_mid);
                }
                if (json.typ==4){
                    tour_next_match_zeit = 0;
                }
            }
        });
    }
    //var obsession = 0;//临时todo
    var total_online_zeit = currentTime-last_login; 
    if(currentTime>=g_sunrise+22*60*60){
        if(g_gobility_num != 4){
            g_gobility_num = 4;
            //refresh_present_gift();
        }
    }else if(currentTime>=g_sunrise+18*60*60){
        if(g_gobility_num != 3){
            g_gobility_num = 3;
            //refresh_present_gift();
        }
    }else if(currentTime>=g_sunrise+13*60*60){
        if(g_gobility_num != 2){
            g_gobility_num = 2;
            //refresh_present_gift();
        }
    }else if(currentTime>=g_sunrise+8*60*60){
        if(g_gobility_num != 1){
            g_gobility_num = 1;
            //refresh_present_gift();
        }
    }
    if(g_version_op==1){
            
        if(total_online_zeit%60==0){
            //update_obsession_status();
        }
        //if(total_online_zeit%6000==0){
        //    sync_refresh_openkey();
        //}
        var refresh_openkey_num = Math.floor(total_online_zeit/6000);
        if(refresh_openkey_num>1){
            if(has_refresh_openkey[refresh_openkey_num]!=1){            
                sync_refresh_openkey();
                has_refresh_openkey[refresh_openkey_num] = 1;
            }
        }
    }
    obsession = 0;
//    if(false&&obsession!=undefined&&obsession!=0){         
//        var cur_online_zeit = currentTime-last_login+on_line_zeit;
//        //alert(cur_online_zeit);
//        if(g_lang=='zh_CN'){
//            var msg_obsession = '';
//            var obsession_obj = $("#obsession_warn");
//            if(obsession_status==1){ 
//                if(cur_online_zeit>=1*60*60&&cur_online_zeit<=1*60*60+60){
//                    msg_obsession = '您累计在线时间已满1小时'; 
//                    if(obsession_obj.hasClass('hide')){
//                        obsession_obj.removeClass('hide').html(msg_obsession);
//                    }
//                    if(cur_online_zeit>=1*60*60&&g_obsession_alert!=1){
//                        alert_box(msg_obsession,1);
//			g_obsession_alert = 1;
//                    } 
//		    if(cur_online_zeit==1*60*60+60){
//                        obsession_obj.addClass('hide').html('');
//                    }
//                }else if(cur_online_zeit>=2*60*60&&cur_online_zeit<=2*60*60+60){
//                    msg_obsession = '您累计在线时间已满2小时';
//                    if(obsession_obj.hasClass('hide')){
//                        obsession_obj.removeClass('hide').html(msg_obsession);
//                    }
//                    if(cur_online_zeit>=2*60*60&&g_obsession_alert!=2){
//                        alert_box(msg_obsession,1);
//			g_obsession_alert = 2;
//                    }
//		    if(cur_online_zeit==2*60*60+60){
//                        obsession_obj.addClass('hide').html('');
//                    }
//                } 
//            }else if(obsession_status==0.5){
//                if(cur_online_zeit>=3*60*60&&cur_online_zeit<3*60*60+60){
//                    msg_obsession = "您累计在线时间已满3小时，请您下线休息，做适当身体活动。";
//                    if(obsession_obj.hasClass('hide')){
//                        obsession_obj.removeClass('hide').html(msg_obsession);
//                    }
//					if(g_obsession_alert!=3){
//						alert_box(msg_obsession,1);
//						g_obsession_alert = 3;
//					}
//                      
//                }else if(cur_online_zeit>=3*60*60+60&&cur_online_zeit<5*60*60){
//                    msg_obsession = "您已经进入疲劳游戏时间，您的游戏收益将降为正常值的50％，为了您的健康，请尽快下线休息，做适当身体活动，合理安排学习生活";
//                    if(cur_online_zeit>=3*60*60+60&&cur_online_zeit<3.5*60*60&&g_obsession_alert!=3.1){
//                        alert_box(msg_obsession,1);
//						g_obsession_alert = 3.1;
//                        obsession_obj.removeClass('hide').html(msg_obsession);
//                    }
//                    if(cur_online_zeit>=3.5*60*60&&cur_online_zeit<4*60*60&&g_obsession_alert!=3.5){//||cur_online_zeit==4*60*60||cur_online_zeit==4.5*60*60){
//                        alert_box(msg_obsession,1);
//						g_obsession_alert = 3.5;
//                    }
//					if(cur_online_zeit>=4*60*60&&cur_online_zeit<4.5*60*60&&g_obsession_alert!=4){//||cur_online_zeit==4*60*60||cur_online_zeit==4.5*60*60){
//                        alert_box(msg_obsession,1);
//						g_obsession_alert = 3.5;
//                    }
//					if(cur_online_zeit>=4.5*60*60&&g_obsession_alert!=4.5){//||cur_online_zeit==4*60*60||cur_online_zeit==4.5*60*60){
//                        alert_box(msg_obsession,1);
//						g_obsession_alert = 4.5;
//                    }
//                    if(obsession_obj.hasClass('hide')){
//                        obsession_obj.removeClass('hide').html(msg_obsession);
//                    }
//                    
//                }else if(cur_online_zeit>=5*60*60){
//                    //msg_obsession = "您已进入不健康游戏时间，为了您的健康，请您立即下线休息。如不下线，您的身体将受到损害，您的收益已降为零，直到您的累计下线时间满5小时后，才能恢复正常";
//                    ////ajax_handler('account','update_obsession_status',0,'status=0',function(json){
//                    ////    obsession_status = 0;
//                    ////    alert(msg_obsession,1);
//                    ////});
//                    //obsession_obj.removeClass('hide').html(msg_obsession);
//                }
//            }else if(obsession_status==0){
//                msg_obsession = "您已进入不健康游戏时间，为了您的健康，请您立即下线休息。如不下线，您的身体将受到损害，您的收益已降为零，直到您的累计下线时间满5小时后，才能恢复正常";
//                var current_rest_zeit = cur_online_zeit-5*60*60;
//                if(current_rest_zeit%900==0){
//                    alert_box(msg_obsession,1);
//                }
//                if(obsession_obj.hasClass('hide')){
//                    obsession_obj.removeClass('hide').html(msg_obsession);
//                }
//            }
//        }		 
//    } 
    $("span[positionTimeValue]").each(function(j){
        var compTime = $(this).attr("positionTimeValue") - 0;
        var time_typ = $(this).attr('time_typ');
        if (compTime==0) {
            return;
        }
        if(currentTime - compTime >= 0)
        {
        //结束特殊处理
            if (currentTime - timmer_time>300)
            {
                    timmer_time = currentTime;
                    switch ($(this).attr("timmerclass"))
                    {
                            default:
                                    break;
                    }
            }
            //ajax_bar_info();
            if(time_typ!=undefined && time_typ==1){
                    var timeValue="<span>00</span>?";
            }else{
                    var timeValue="<span>0:00:0</span>?";
            }
            $(this).html(timeValue);
            switch ($(this).attr('timmerclass')) {				
                case 'player_refresh':
                    //window.location.reload();
                    $(this).attr("positionTimeValue",0);
                    $('#player_refresh').load('?m=transfer&a=player_refresh&need_refresh=1',function(){
                        $(".use_hovertip").hovertip();
                        if(newbie_stat==1){
                            $(".scroll_target .scroll_content").slider_use();
                        }
                    });                                       
                    break;
                case 'refresh_employees':
                    $(this).attr("positionTimeValue",0);
                    //lightbox_tab_show('office','team_employees');
                    $('#team_employees').load('?m=office&a=team_employees',function(){
                        $(".use_hovertip").hovertip();
                        if(newbie_stat==1){
                            $(".scroll_target .scroll_content").slider_use();
                        }
                    });
                    break;
                case 'player_train':
                    $(this).attr("positionTimeValue",0);
                    if($(this).attr('show_player_typ')=='player_big_card'){
                        $('#player_train_skill_content').load('?m=player&a=player_train&format=html&pid='+parseInt($(this).attr('pid')),function(){
                            $(".use_hovertip").hovertip();
                            if(newbie_stat==1){
                                $(".scroll_target .scroll_content").slider_use();
                            }
                        }); 
                    }else if($(this).attr('show_player_typ')=='player_train_list'){
                        $('#sp_training').load('?m=team&a=sp_training',function(){
                            $(".use_hovertip").hovertip();
                            if(newbie_stat==1){
                                $(".scroll_target .scroll_content").slider_use();
                            }
                        });
                       
                    }
                    break;
                case 'energy':
                    sync_energy();
                    break;
                case 'get_limit_gift':
		    $(this).attr("positionTimeValue",0);
		    $('#limit_gift_tip_time').text(msg_common_i18n.m32);
		    var tip = $('#limit_gift_tip').html();
                    var _html = "<div id=\"i_limit_gift_icon\" class=\"get_present_able\"></div><div id=\"limit_gift_tip\" class=\"hide\">"+tip+"</div>";
		 
                    $("#i_limit_gift").attr('typ',1);
                    $("#i_limit_gift").html(_html);
                    //alert(g_limit_gift.attr('typ'));
                    break;
         
                case 'league_end_zeit':
                    $(this).attr("positionTimeValue",0);
                    $('#league_index').load('?m=match&a=league_index');
                    break;
                case 'tier_user_challenge':
                    show_tier(now_tier_id);
                    break;
                case 'hang_up_end':
                    $(this).attr("positionTimeValue",0);
                    $("#hang_up_box").load('?m=match&a=ins_hang_up');
                    break;
                default:					
                    break;
            }
        }
        else
        {
            if(time_typ!=undefined && time_typ==1){
                var timeValue=compTime-currentTime;
            }else{
                var timeValue=formatTime(compTime-currentTime);
            }
            //var timeValue = formatTime(compTime-currentTime);
            $(this).html(timeValue);
        }
    });
}


var timmerID = window.setInterval(cmptime, 1000);

var op_uid = 0;
var op_player_process = 0;
 
function on_signal(signal_typ,signal_info){
    if (signal_typ=='[ch]'){//请求
        
    } else if(signal_typ=='[ca]'){//接受
        
    }
}
/*********************************各模块代码********************************/
function news_box_update_next_feed_then_open(){
    ajax_handler('news','news_read',0,'feed_id='+read_feed_id+'&next_feed_id=0',function(json){
        next_feed_id = json.next_feed_id;
        newsbox_opened = false;
        news_box_open();
    });
}

function show_next_feed(next_feed_id,obj){
    if(read_feed_id==next_feed_id){
        return;
    }
    if (obj!=undefined){
        $(obj).block();
        $(obj).attr('style','');
    }
    if(newbie_stat==0){
        var typ = $('#all_news_list').attr('typ');
        if(typ==401){
            if (cur_task_id == 104&&cur_step_id==2){
                if (obj!=undefined){
                    $(obj).unblock();
                }
                finish_newbie_task_step(104,2);
                return;
            } else if (cur_task_id == 109&&cur_step_id==2){
                if (obj!=undefined){
                    $(obj).unblock();
                }
                finish_newbie_task_step(109,2);
                return;
            }
        }        
    }
    if (need_get_player_gift==1) {
        //tx_vip_box_open('vip','sent_player_level');
    }
    //if (obj!=undefined){
    //    $(obj).block();
    //    $(obj).attr('style','');
    //}
    if(next_feed_id==undefined){
        next_feed_id = 0;
    }    
    ajax_handler('news','news_read',0,'feed_id='+read_feed_id+'&next_feed_id='+next_feed_id,function(json){
        if(json.rstno==5){
            if(json.mid!=0){
                matchbox_open(json.mid);
                return;
            }
        }
        if(next_feed_id==0){
            //不是点击列表的，是直接继续的
            read_feed_id = next_feed_id = json.next_feed_id;
            //判断是不是又向前走了一天
            if (json.is_next_day == 1){
                //向前走的动画处理
                g_load_news_count = json.load_news_count;
                $("#i_news_mask").removeClass('hide');
                $('#next_day').html(json.next_day);
                loading_bar_next_day();
                setTimeout(function(){
                    $('#news_container').html(json.data_html);
                    $(".scroll_target .scroll_content").slider_use();
                    $(".use_hovertip").hovertip();
                    
                    //news_feed_real_load(next_feed_id);
                    upd_energy_bar(json.new_energy);
                    change_next_day(json.next_day_int);
                },500);                
            } else {
                $('#news_container').html(json.data_html);
                $(".scroll_target .scroll_content").slider_use();
                $(".use_hovertip").hovertip();
                //news_feed_real_load(next_feed_id);
            }
        } else {
            $('#news_container').html(json.data_html);
            $(".scroll_target .scroll_content").slider_use();
            $(".use_hovertip").hovertip();
            //news_feed_real_load(next_feed_id);
        }
        //news_feed_real_load(next_feed_id);
        if (obj!=undefined){
                $(obj).unblock();
        }
    },function(){
        if (obj!=undefined){
                $(obj).unblock();
        }
    });
    return;
}

function news_feed_real_load(next_feed_id){
    $('#news_container').load('?m=news&a=news_content&format=html&feed_id='+next_feed_id,function(){        
        $(".scroll_target .scroll_content").slider_use();
        $(".use_hovertip").hovertip();
        $("#i_news_mask").addClass('hide');
    });
}

function change_next_day(next_day){
	if (next_day==0){
		next_day = 7;
	}
	var g_date_box = $("#date_box");
	$(".week_days").remove();
	var _html = '<div id="week_'+next_day+'" class="week_days"></div>';
	g_date_box.append(_html);
}

function choose_this_even(feed_id,choise_id){
    $('#news_event_content').html(refresh_loading_img('event'));
    ajax_handler('news','news_event_choise',0,'feed_id='+feed_id+'&choise_id='+choise_id,function(json){
        setTimeout(function(){
            $('#news_event_content').html('<div class="yellow_news">'+json.result_content+'</div>');
            upd_i_header_info(json.header_info);
        },500);
        $('#news_header_butt a').removeClass('disable');
    })
}

function choose_inj(feed_id,choise_id){
    $('#news_event_content').html(refresh_loading_img('event'));
    ajax_handler('news','inj_choise',0,'feed_id='+feed_id+'&choise_id='+choise_id,function(json){
        setTimeout(function(){
            $('#news_event_content').html('<div class="yellow_news">'+json.result_content+'</div>');
            upd_i_header_info(json.header_info);
        },500);
         upd_i_header_info(json.header_info);
        $('#news_header_butt a').removeClass('disable');
    })
}

function choose_equip_item(feed_id,choise_id){
    $('#news_event_content').html(refresh_loading_img('event'));
    ajax_handler('news','choose_equip_item',0,'feed_id='+feed_id+'&choise_id='+choise_id,function(json){
        setTimeout(function(){
            if(choise_id==1){
                $('#news_event_content').html('<div class="yellow_news"> '+msg_common_i18n.s2.str_supplant({player_name:json.player_name})+'</div>');
            }else{
                $('#news_event_content').html('<div class="yellow_news"> '+msg_common_i18n.m33+'</div>');
            }
            //upd_i_header_info(json.header_info);
        },500);
        if(choise_id==1){
            if(my_players_cache[json.pid]!=undefined){
                my_players_cache[json.pid] = '';
            }
        }else if(choise_id == 2){
            g_item_info = json.item_info;
        }
        //sync_exp_money();
        //$('#news_header_butt a').removeClass('disable');
    })
}
//豪门之路
function show_ins_club_info(club_id){
    $(".ins_club_info").addClass('hide');
    $("#ins_club_info_"+club_id).removeClass('hide');
}

function ins_extend_fixture(){
    if($('#ins_info_board').hasClass('show_detail')){
        $('#ins_info_board').removeClass('show_detail');
        $('#ins_tab_fixtures').removeClass('max_info').addClass('min_info');
        $('#ins_tab_tables').removeClass('max_info').addClass('min_info');
        $('.show_table_list').addClass('hide');
        $('.show_fixture_list').addClass('hide');
        for(var key in round_show_list){
            $('#ins_show_fixture_'+round_show_list[key]).removeClass('hide');
        }
        for(var key in order_show_list){
            $('#ins_show_order_'+order_show_list[key]).removeClass('hide');
        }        
    }else{        
        $('#ins_info_board').addClass('show_detail');
        $('#ins_tab_fixtures').removeClass('min_info').addClass('max_info');
        $('#ins_tab_tables').removeClass('min_info').addClass('max_info');
        $('.show_table_list').removeClass('hide');
        $('.show_fixture_list').removeClass('hide');
    }
}

function show_ins_detail_tab(typ){
    if($('#ins_board_label_'+typ).hasClass('active')){
        return;
    }else{
        $('#ins_board_label_'+typ).addClass('active').siblings().removeClass('active');
        if(typ==1){
            $('#ins_tab_fixtures').removeClass('hide');
            $('#ins_tab_tables').addClass('hide');
        }else if(typ==2){
            $('#ins_tab_fixtures').addClass('hide');
            $('#ins_tab_tables').removeClass('hide');
        }
    }
}
function show_ins_detail_tab_min(typ){
    if($('#ins_board_label_min_'+typ).hasClass('active')){
        return;
    }else{
        $('#ins_board_label_min_'+typ).addClass('active').siblings().removeClass('active');
        if(typ==1){
            $('#ins_tab_fixtures_min').removeClass('hide');
            $('#ins_tab_tables_min').addClass('hide');
        }else if(typ==2){
            $('#ins_tab_fixtures_min').addClass('hide');
            $('#ins_tab_tables_min').removeClass('hide');
        }
    }
}
//结束比赛
function end_match(mid,match_typ){ 
    //hack_finish_match(mid);
    ajax_handler('match','flash_finish_match',0,'mid='+mid,function(json){		 
        now_mid=0;
    });
}
//flash关闭比赛结束按钮
function flash_match_box_close(mid,is_skip){
    matchbox_flash_cleared = false;
    now_mid=0;
    news_box_open(mid);
    upd_task_list();   
    g_setting_from = 1;
    matchbox_close();	 
}
function hack_finish_match(mid){
    //end_match(mid);
    //flash_match_box_close(mid,is_skip);
    ajax_handler('hack','finish_match',0,'mid='+mid,function(json){
		//matchbox_close();
        matchbox_flash_cleared = false;
        matchbox_close();
        news_box_open(mid);
        upd_task_list();
        g_setting_from = 1;
        end_match(mid);
        if(my_players_cache.length!=0){
            for(var this_pid in my_players_cache){
                my_players_cache[this_pid] = '';
            }
        }	 
    });
}
function hack_start_match(){
    if(1==1){ 
        ajax_handler('hack','insert_match',0,'',function(json){
            now_mid = json.mid;
            matchbox_open(json.mid);
        });
    }else{
        alert_box(msg_common_i18n.m34,1);
    }
}

function select_train_time(pid,total_time,is_in_train,cost_price,can_train,in_lightbox){
    if(newbie_stat==0){
        if(cur_task_id<108){
            alert_box(msg_common_i18n.m35);
            return;
        }
    }
    if(is_in_train==0){
        if(can_train == 1){
                if(total_time<60){
                        var total_time_dis = total_time+msg_common_i18n.m36;
                }else{
                        var total_time_dis = Math.ceil(total_time/60)+msg_common_i18n.m37;
                }
                confirm_box(msg_common_i18n.s3.str_supplant({total_time_dis:total_time_dis,cost_price:cost_price}),function(){
                    player_start_train(pid,total_time,in_lightbox);
                        
                });
        }else{
                alert_box(msg_common_i18n.m38);
        }
    }else{
        if(is_in_train==1){
            alert_box(msg_common_i18n.m39);
            return;
			
        }else if(is_in_train==2){
            alert_box(msg_common_i18n.m40);
            return;
        }
    }  
}

function player_start_train(pid,total_time,in_lightbox){
    if(total_time==undefined){
        total_time = parseInt($('#train_select_time').attr('train_time'));
    }
	
    ajax_handler('player','train_player',0,'pid='+pid+'&contiue_time='+total_time,function(json){	 
	//sync_exp_money();
        upd_i_header_info(json.header_info);
        if(newbie_stat==0&&cur_task_id==108){
	    finish_newbie_task_step(108,2);
        }else{
            if(in_lightbox==1){
                modless_box_close();      
                $('#player_train_ul_content_list .no_player:first').html(json.data_html).removeClass('no_player').addClass('has_player').attr('id','train_sp_box_'+pid);                
            }else{
                $('#player_train_skill_content').load('?m=player&a=player_skill&format=html&pid='+pid,function(){
                    $(".use_hovertip").hovertip();
                    if(newbie_stat==1){
                        $(".scroll_target .scroll_content").slider_use();
                    }
                });
                $('#sp_training').attr('in_showing',0);
            }
        }
        if(json.rest_num<=0){
            if(my_players_cache.length!=0){
                for(var this_pid in my_players_cache){
                    my_players_cache[this_pid]='';
                }
                
            }
        }
    });
}

function clean_input_text(obj){    
    if($.trim($(obj).val())==$(obj).attr('blurName')){		 
        $(obj).val('');		
    }
}
function clear_input(id){
	$('#'+id).val('');
}
function return_input_text(obj){
    if($(obj).val()==''){
		//$(obj).css('color','#555555');
        $(obj).val($(obj).attr('blurName'));
		
    }
}

function show_friend_index(op_pp_uid){
	fusion2.nav.toFriendHome
	({
		// 必须。表示好友的openid。
		openid :  op_pp_uid,
		// 可选。为true则在当前窗口打开，为false或不指定则在新窗口打开。
		self : false
    });

}

function show_player_info(pid,cid){
    if(cid==user_uid){
        show_player_modless_box(pid);
    }else{
        show_op_player_modless_box(pid);
    }
}
//function show_new_player_modless_box(pid){
//	modless_box_open({url:'?m=player&a=player_sign_in_news&pid='+pid,size:'mml'});
//}

function update_player_cond(pid,source){
    $.getJSON('?m=player&a=update_cond&format=json&pid='+pid+'&source='+source,function(json){       
        $("#modless_box #player_cond_exp_bar").css({width:json.cond_len});
    });
}
function show_player_modless_box(pid,source,obj){
    if (my_players_cache[pid]!=undefined){
        var _html = my_players_cache[pid];
    } else {
        var _html = '';
    }
    //_html = '';
    modless_box_open({url:'?m=player&a=index&pid='+pid+'&source='+source,
        size:'xl',
        callback:function(){
           if (_html!=''){
               update_player_cond(pid,source);
               $("#skill_list li").hover(function(){
                    $(this).find('#forget_font').removeClass('hide');
                },function(){
                    $(this).find('#forget_font').addClass('hide');
                });
           }
       },
       _html:_html
    });
}

function player_skill_learn(pid){
    modless_box_open({url:'?m=player&a=skill_stone&pid='+pid,
        size:'xl'
    });
}
function set_error(err){
	$("#skill_help").html('<span class="important">'+err+'</span>');
	alert_box(err);
}
function player_skill_stone_set(){
    $(".skill_stone_set").addClass('hide');
    if (on_show_typ=='skill_set'){
        $("#stone_set").removeClass('hide');
        on_show_typ = 'stone_set';
		$("#skill_help").html('点击技能石可以装备或者卸掉。注意右上角不同技能石提供不同的技能点数。');
    } else {
        $("#skill_set").removeClass('hide');
        on_show_typ = 'skill_set';
		$("#skill_help").html('点击灰色技能即可学习。不要忘记点击完成来保存哦！');
    }
}
function show_op_player_modless_box(pid){    
    modless_box_open({url:'?m=player&a=op_player_info&pid='+pid,size:'mml'});
}
function show_club_box(cid,npc_rate){
    if(cid<0){
        open_club_box(cid,npc_rate);
    }else{
        show_op_club_box(cid);
    }    
}
function open_club_box(cid,npc_rate){     
    var plus = '&cid='+cid;
    if(npc_rate!=undefined){
        plus += '&npc_rate='+npc_rate;
    }
    modless_box_open({url:'?m=club_info&a=show_real_new'+plus,size:'xl',callback:function(){         
    }});
}

function show_op_club_box(cid){
    modless_box_open({url:'?m=club_info&a=show_op_club_info&cid='+cid,size:'xl'});
}

function formation_learn(formation_id,obj){
    if(newbie_stat==0){ 
        alert_box(msg_newbie_i18n.newbie_first,1);                
        return;        
    }
    $(obj).parent().block();
    ajax_handler('team','team_formation_learn',1,'formation_id='+formation_id,function(json){
        g_setting_from = 1;
        $('#formation_research').load('?m=tactics&a=formation_research',function(){
            $(".use_hovertip").hovertip();
            if(newbie_stat==1){
                $(".scroll_target .scroll_content").slider_use();
            }
        })
        //lightbox_tab_show('tactics','formation_research');
        if(json.need_refresh_task==1){
            upd_task_list();
        }
        //sync_exp_money();
	upd_i_header_info(json.header_info);
        $(obj).parent().unblock();
    },function(){
	$(obj).parent().unblock();
    });
}
var chat_counter = 1;
var old_chat = new Array();
function sync_chat(){
    if (now_mid<=0){
	chat_counter -- ;
	if (chat_counter<=0){
		chat_counter = 60;
		$.getJSON('?m=index&a=sync_chat&format=json',function(json){
			upd_chat(json.data);			
	   });
	}
    }
}
function send_chat(){
	var send_data = $("#chat_input").val().trim();
	if (send_data.length>20){
		alert_box(msg_common_i18n.m41);
		return;
	}
	if (send_data == $("#chat_input").attr('blurname')){
		return;
	}
	if (send_data != ''){
		plus = 'data='+encodeURI(send_data);		
		ajax_handler('chat','send_chat',0,plus,function(json){       
			upd_chat(json.data);
			chat_counter = 2;
		});
		$("#chat_input").val('');
	}
}

function upd_chat(chat){
    var chat_length = chat.length;
    if (chat_length==0){
        chat_counter = 60;
        return;
    }
    if (old_chat.length>20){
        old_chat = [];
        $("#chat_contents").html('');
    }
    var flag = 0;
    for (var i=0;i<chat_length;i++){
        if (old_chat.in_array(chat[i].chat_id)){
                continue;
        }
        old_chat.push(chat[i].chat_id);
        var chat_typ = '';
        switch (chat[i].typ){
            case 1:
                chat_typ = msg_common_i18n.m42;
                break;
            case 2:
                chat_typ = msg_common_i18n.m43;
                break;
            case 3:
                chat_typ = msg_common_i18n.m44;
                break;
            case 4:
                chat_typ = msg_common_i18n.m45;
                break;
            default:
                chat_typ = msg_common_i18n.m42;
                break;
        }
        var _html = "<li><span>["+chat_typ+"]"+chat[i].zeit_show+'</span>';
        if (chat[i].pf!=undefined && chat[i].pf!=g_pf){
            if (chat[i].pf=='pengyou'){
                _html += msg_common_i18n.m47;    
            } else if (chat[i].pf=='qzone'){
                _html += msg_common_i18n.m48;    
            } else if (chat[i].pf=='qplus'){
                _html += "Q+";    
            } else if (chat[i].pf=='3366'){
                _html += "3366";    
            }
        }
        if(chat[i].uid == 0)
		{
			_html += '<font><a href="javascript:void(0);">';
			_html += msg_common_i18n.m153+"</a>: "+chat[i].data+"</font></li>";		
		}else{
			_html += '<font><a href="javascript:void(0);" onclick="show_op_club_box('+chat[i].uid+')">';
			_html += chat[i].uname+"</a>: "+chat[i].data+"</font></li>";
		}
        $("#chat_contents").append(_html);
        flag = 1;
    }
    if (flag==0){
        chat_counter = 15;
    } else {
        chat_counter = 3;
        $("#i_chat_content .scroll_content").slider_use({goto_max:true});
    }
}
function sync_energy(){
    $.getJSON('?m=index&a=sync_energy&format=json',function(json){
        upd_energy_bar(json.energy,json.next_refresh_energy_zeit,json.energy_rat);
   });    
}
function upd_energy_bar(new_energy,next_refresh_energy_zeit){
    g_energy = new_energy;
    $('#energy_label').html(new_energy);
    $('#energy_tip_info').html(new_energy);
    limit_energy = 80+5*g_level;
    if(new_energy<limit_energy){
        energy_rat = Math.round(new_energy/limit_energy*20);
    }else{
        energy_rat = 20;
    }
    $('#i_xdl_expbox_now').animate({height:energy_rat},'slow');
    if (next_refresh_energy_zeit!=undefined){
	$('#energy_tip_cd').attr('positionTimeValue',next_refresh_energy_zeit);
    }    
}

function sync_exp_money(force_credits){
    if (force_credits!=undefined){
        var plus = '&need_real_credits=1'
    } else {
        var plus = '';
    }
    $.getJSON('?m=index&a=sync_exp_money&format=json'+plus,function(json){
        upd_i_header_info(json.header_info);
   });    
}
//无更新的字段传-1
function upd_i_header_info(rst){
	//new_exp,exp_rat,new_level,new_money,new_energy,new_credits,real_credits,next_refresh_energy_zeit,tip_message){
	var default_rst = {
            exp:-1,
            exp_rat:-1,
            level:-1,
            money:-1,
            energy:-1,
            honors:-1,
            attr_points_can_use:-1,
            credits:-1,
            real_credits:-1,
            next_refresh_energy_zeit:-1,
            tip_message:''
	};
	$.extend(default_rst,rst);

    if(default_rst.tip_message!='')
	{
	    $('#club_next_exp_info_hovertip').attr('tooltip',default_rst.tip_message);
	}
	if (default_rst.exp!=-1 && default_rst.g_exp != default_rst.exp){
        g_exp = default_rst.exp;
        $('#exp_label').html(default_rst.exp);
	if (default_rst.level!=-1 && g_level != default_rst.level){
	    $('#exp_bar').animate({width:53},'slow',function(){
		$('#exp_bar').css({width:0}).animate({width:default_rst.exp_rat},'slow');
	    });           
	} else {
	    $('#exp_bar').animate({width:default_rst.exp_rat},'slow');
	}
        //$('#energy_tip_info').html(new_exp);
    }
    if (default_rst.level!=-1 && g_level != default_rst.level){
        g_level = default_rst.level;
        $('#i_club_level').html(g_level);
        refresh_present_gift();
        sync_energy();
        if (default_rst.level==7){
            //tx_vip_box_open('vip','sent_player_level');
        }
        thisMovie('bf_index_swf').refreshLvGift(g_level);
    }
    if (default_rst.money!=-1 && g_money != default_rst.money){
        g_money = default_rst.money;
        $('#money_label').html(g_money);
    }
    if (default_rst.energy!=undefined && default_rst.energy!=-1){
	upd_energy_bar(default_rst.energy,default_rst.refresh_energy_zeit);
    }
    if(default_rst.credits!=undefined && default_rst.credits!=-1){
        g_credits = default_rst.credits;
        $('#credit_label').html(g_credits);
    }
    if(default_rst.honors!=undefined && default_rst.honors!=-1){
        g_honors = default_rst.honors;
        $('#index_honors_value').html(g_honors);
    }
    if(default_rst.attr_points_can_use!=undefined && default_rst.attr_points_can_use!=-1){
        g_attr_points_can_use = default_rst.attr_points_can_use;
        $('#index_points_value').html(g_attr_points_can_use);
    }
    if(default_rst.real_credits!=undefined && default_rst.real_credits!=-1){
        g_real_credits = default_rst.real_credits;
        $('#real_credit_label').html(g_real_credits);
    }
    if(g_item_info[37] != undefined){
    	g_item_num = g_item_info[37]['item_num'];
        $('#index_badge_value').html(g_item_num);
    }
}

function finish_ins_get_award(feed_id,typ,target_id){
    if(target_id==undefined){
        target_id = 0;
    }
    var plus = 'feed_id='+feed_id+'&typ='+typ+'&target_id='+target_id;
    ajax_handler('ins','finish_ins_get_award',0,plus,function(json){
        if(typ=='player'){
            modless_box_close();
            var _html = '<a class=\"link\" href=\"javascript:void(0);\" onclick=\"show_player_modless_box('+json.pid+')\">'+json.player_name+'</a>'
            $('#ins_award_'+typ).html(msg_common_i18n.m49);
            $('#ins_award_player_name').html(_html);
        }else if(typ=='formation_card'){
            modless_box_close();
             var _html = '<a class=\"link\">'+json.formation_name+'</a>'+msg_common_i18n.m49;
            $('#ins_award_'+typ).html(_html);
        }else{
            $('#ins_award_'+typ).html(msg_common_i18n.m49);
        }
        upd_i_header_info(json.header_info);
    });
}

function accept_dialy_task(task_id){
    accept_task(task_id,function(){
	$("#accept_task_span").show();
	$("#accept_task_btn").hide();
    });
}

function accept_newbie_task(task_id){
    accept_task(task_id,function(json){
        $("#accept_task_span").show();
        $("#accept_task_btn").hide();		
        cur_task_id = task_id;
        cur_step_id = 1;
        $('#all_news_list').attr('must_response','2');
        if (task_id==104 || task_id==109){
            show_next_feed();
        } else {
            news_box_close();
        }
        alert_box_close();
        show_newbie_help();
    });
    $('#newbie_assist_arrow').addClass('hide');
}

function accept_task(task_id,callback){
    ajax_handler('task','accept_task',0,'task_id='+task_id,function(json){        
        if(newbie_stat==0){
            newbie_task_list = json.task_list;            
        } else {
            upd_task_list();
        }
        callback.apply(this,arguments);
    });
}

function upd_task_list(){
    g_i_task_list.load('?m=index&a=sync_task&format=html',function(){
	$(".use_hovertip").hovertip();
        g_i_task_list.removeClass('short_tasks_list').addClass('long_tasks_list');
        if (g_lang=='zh_CN'){
            reset_task_size(1);
        } else {
            reset_task_size(0);
        }
    });
}
//var task_default_size = 0;
function reset_task_size(typ){
    //alert(typ);
    if(typ==0){
        g_i_task_list.removeClass('long_tasks_list').addClass('short_tasks_list').css({width:90});
        g_i_task_list.find(".long_task_desc").addClass('hide');
        $('#task_list').css({width:45});
        $('#task_list_icon_box').css({width:55});
        $('#close_task').addClass('hide');
        $('#open_task').removeClass('hide');
    }else{
        g_i_task_list.removeClass('short_tasks_list').addClass('long_tasks_list').css({width:219});
        g_i_task_list.find(".long_task_desc").removeClass('hide');
        $('#task_list').css({width:188});
        $('#task_list_icon_box').css({width:193});
        $('#close_task').removeClass('hide');
        $('#open_task').addClass('hide');
    }
}
function finish_task_get_all_award(feed_id){
    var plus = 'feed_id='+feed_id;
    ajax_handler('task','finish_task_get_award',0,plus,function(json){       
        $('#all_news_list').attr('must_response',json.must_response);
        if(json.must_response==2){
            $('#goon_game .goon_btn').removeClass('disable');
            show_newbie_assist_arrow(1,'#goon_game .goon_btn');
        }else{
            show_newbie_assist_arrow(1,'#ins_award_'+json.next_award_typ+'  a');
        }
        $('#news_container_content .ins_award_btn').html('<div class=\"share_alert_right_btn_font\">'+msg_common_i18n.m49+'</div>')
        upd_i_header_info(json.header_info);
        if(json.on_hang==0){
            show_next_feed();
        }
    });
}

function finish_tier_get_all_award(feed_id){
    var plus = 'feed_id='+feed_id;
    ajax_handler('match','finish_tier_get_award',0,plus,function(json){       
        $('#all_news_list').attr('must_response',json.must_response);
        
        g_item_info = json.item_info;
        upd_i_header_info(json.header_info);
        $("#news_container_content .ins_award_btn").html(msg_common_i18n.m51);
        alert_box(msg_common_i18n.m50);
        lightbox_tab_show('match','match_tier');
    });
}

function finish_tour_get_all_award(feed_id){
    var plus = 'feed_id='+feed_id;
    ajax_handler('match','finish_tour_get_award',0,plus,function(json){       
        $('#all_news_list').attr('must_response',json.must_response);
        
        g_item_info = json.item_info;
        upd_i_header_info(json.header_info);
        $("#news_container_content .ins_award_btn").html(msg_common_i18n.m51);
        alert_box(msg_common_i18n.m50);
        lightbox_tab_show('match','match_tour');
    });
}

//function finish_task_get_award(feed_id,typ,target_id){
//    if(target_id==undefined){
//        target_id = 0;
//    }
//    var plus = 'feed_id='+feed_id+'&typ='+typ+'&target_id='+target_id;
//    ajax_handler('task','finish_task_get_award',0,plus,function(json){
//        if(typ=='player'){
//            modless_box_close();
//            var _html = '<a class=\"link\" href=\"javascript:void(0);\" onclick=\"show_player_modless_box('+json.pid+')\">'+json.player_name+'</a>'
//            $('#ins_award_'+typ).html(msg_common_i18n.m49);
//            $('#ins_award_player_name').html(_html);
//        }else if(typ=='formation_card'){
//            modless_box_close();
//            var _html = '<a class=\"link\">'+json.formation_name+'</a>(已领取)'
//            $('#ins_award_'+typ).html(_html);
//        }else{
//            $('#ins_award_'+typ).html(msg_common_i18n.m49);
//        }
//        $('#all_news_list').attr('must_response',json.must_response);
//        if(json.must_response==2){
//            $('#goon_game .goon_btn').removeClass('disable');
//            show_newbie_assist_arrow(1,'#goon_game .goon_btn');
//        }else{
//            show_newbie_assist_arrow(1,'#ins_award_'+json.next_award_typ+'  a');
//        }
//        upd_i_header_info(json.header_info);
//    });
//}

function finish_newbie_task_step(task_id,step_id){
    if  (newbie_stat==0){		 
	if (newbie_task_list[task_id]!=undefined&&cur_task_id==task_id){			 
	    var this_task = newbie_task_list[task_id];
	    if (this_task.step_status!=undefined && this_task.step_status[step_id]!=undefined){				 
                ajax_handler('task','finish_step',0,'task_id='+task_id+'&step_id='+step_id,function(json){                 
                    if (json.finish_task==1){
                        if(task_id==103){
                            if(flashbox_opened_show){
                                flashbox_close();
                            }
                        }
                        if(task_id!=1){
                            news_box_update_next_feed_then_open();	
                            
                            if(newbie_stat==0){
                                $('#newbie_assist_arrow').addClass('hide');
                            }
                        }
                        newbie_task_list = json.new_newbie_info;
                        np_mask_state = 0; 
                        cur_task_id = 0;
                        cur_step_id = 0;
                    }else{
                        cur_task_id = task_id;
                        cur_step_id = json.cur_step_id;    
                    }				     
                    newbie_stat = json.new_newbie_stat;
                    if (newbie_stat==1){
                        thisMovie('bf_index_swf').unLockBuild(100);
                        g_i_task_list.removeClass('hide');
                        g_friend_list.removeClass('hide');
                        g_present_gift.removeClass('hide');
                        g_i_vip_gift.removeClass('hide');
                        //$("#i_club_right_box").removeClass('hide');
                        timer_goon = setTimeout(show_go_on_help,30000);
                    }
                });
	    }
	}
         
    } 
}
function finish_task_step(task_id,step_id){
    ajax_handler('task','finish_step',0,'task_id='+task_id+'&step_id='+step_id,function(json){ 
        upd_task_list();
    });
}
function show_newbie_help(){
    //alert(cur_task_id);
	//alert(cur_step_id);
    if (newbie_stat==1){
        return;
    }
    //当前任务 cur_task_id
    //当前步骤 cur_step_id
    if(cur_task_id==0||cur_task_id==-1||cur_step_id==0){
        return;
    }
   
    if(newbie_task_list[cur_task_id].info.step_xy[1]==undefined){
        return;
    }
    var step_xy_info = newbie_task_list[cur_task_id].info.step_xy[1];
     
    if (step_xy_info.arrow.type!=0){
        show_newbie_assist_arrow(step_xy_info.arrow.type,step_xy_info.arrow.arrow_id);        
    } else {
        $("#newbie_assist_arrow").addClass('hide');         
    }
}

var timer_goon_cancel = 0;
function show_go_on_help(){
    if (flashbox_opened_show || timer_goon_cancel>0){
        return;
    }
    if(lightbox_opened&&g_module!=''){
        return;
    }
    timer_goon = 0;
    typ = 4;
    var target = $("#goon_game");
    if (target.length==0){
        target = $("#cot_game");
        typ = 4;
    }
    var target_pos = target.offset();
    
    var arrow_left;
    var arrow_top;
    var img_w = 80;
    var img_h = 62;
    var top = parseInt(target_pos.top-2);
    var left = parseInt(target_pos.left-2);
    var w = parseInt(target.width()+4);
    var h = parseInt(target.height()+4);
    if(typ == 1){		 
        arrow_left = parseInt(left+w/2-img_w/2);
        arrow_top = parseInt(top+h+10); 
    }else if(typ==2){            
        arrow_left = parseInt(left-img_w-10);
        arrow_top = parseInt(top+h/2-img_h/2);
    }else if(typ==3){		
        arrow_left = parseInt(left+w/2-img_w/2);
        arrow_top = parseInt(top-img_h-10);
    }else if(typ==4){ 
        arrow_left = parseInt(left+w+10);
        arrow_top = parseInt(top+h/2-img_h/2);
    }
    
    $("#newbie_assist_arrow").removeClass('hide').css('left',arrow_left).css('top',arrow_top);
    $("#newbie_assist_arrow .arrow_real_img").attr('id','arrow_'+typ);
    
    var this_content = target.attr('content');
    if (target.attr('id')=='news_con_btn'){
        var _content=msg_common_i18n.m52;    
    } else {
        var _content=msg_common_i18n.m53;
    }
    
    
    $('#new_assist_content').removeClass('hide').html(_content);
    timer_goon_cancel = setTimeout(function(){
        close_go_on_help(10000);
    },5000);
}

function close_go_on_help(timeout){
    window.clearTimeout(timer_goon);
    window.clearTimeout(timer_goon_cancel);
    timer_goon = 0;
    timer_goon_cancel = 0;
    $("#newbie_assist_arrow").addClass('hide');
    timer_goon = window.setTimeout(
        function(){
         show_go_on_help();
        },timeout);
}

var g_newbie_arrow_typ;
var g_old_newbie_id;
var g_newbie_arrow_id;
var g_arrow_left=0;
var g_arrow_top = 0;
function real_show_newbie_assist_arrow(){
    //alert(arrow_id);
    if (cur_task_id==103 && bg_class=='bg_setting_form'){
        g_newbie_arrow.addClass('hide');
        return;
    } else {
        //$('#new_assist_content').removeClass('hide');
    }
    if (g_newbie_arrow_id=='null'){
        g_newbie_arrow.addClass('hide');
        return;
    }
    var target = $(g_newbie_arrow_id);
    var target_pos = target.offset();
   
    if( target.length<=0||(target_pos.top==0&&target_pos.left==0)) {		
        return;
    }
   
    
    var arrow_left;
    var arrow_top;
    var img_w = 80;
    var img_h = 80;
    var top = parseInt(target_pos.top-2);
    var left = parseInt(target_pos.left-2);
    var w = parseInt(target.width()+4);
    var h = parseInt(target.height()+4);
   
    if(g_newbie_arrow_typ == 1){		 
        arrow_left = parseInt(left+w/2-img_w/2);
        arrow_top = parseInt(top+h+10); 
    }else if(g_newbie_arrow_typ==2){            
        arrow_left = parseInt(left-img_w-10);
        arrow_top = parseInt(top+h/2-img_h/2+20);
    }else if(g_newbie_arrow_typ==3){		
        arrow_left = parseInt(left+w/2-img_w/2);
        arrow_top = parseInt(top-img_h-10);
    }else if(g_newbie_arrow_typ==4){ 
        arrow_left = parseInt(left+w+10);
        arrow_top = parseInt(top+h/2-img_h/2+16);
    }
    //alert(arrow_left);
    //alert(arrow_top);
    if(g_arrow_left==arrow_left&&g_arrow_top==arrow_top&&g_old_newbie_id==g_newbie_arrow_id){
        switch(g_newbie_arrow_typ) {
            case 1:
                g_newbie_arrow_arrow.animate({
                    marginTop:10
                },{
                    duration: 200,
                    queue:false,
                    complete:function(){
                        g_newbie_arrow_arrow.animate({
                            marginTop:0
                        },{
                            duration: 300,
                            queue:false
                        });
                    }
                });
                break;
            case 2:
                g_newbie_arrow_arrow.animate({
                    marginLeft:10
                },{
                    duration: 200,
                    queue:false,
                    complete:function(){
                        g_newbie_arrow_arrow.animate({
                            marginLeft:0
                        },{
                            duration: 200,
                            queue:false
                        });
                    }
                });
                break;
            case 3:
                g_newbie_arrow_arrow.css({marginTop:10});
                g_newbie_arrow_arrow.animate({
                    marginTop:0
                },{
                    duration: 200,
                    queue:false,
                    complete:function(){
                        g_newbie_arrow_arrow.animate({
                            marginTop:10
                        },{
                            duration: 300,
                            queue:false
                        });
                    }
                });
                break;
            case 4:
                g_newbie_arrow_arrow.animate({
                    marginLeft:0
                },{
                    duration: 200,
                    queue:false,
                    complete:function(){
                        g_newbie_arrow_arrow.animate({
                            marginLeft:10
                        },{
                            duration: 200,
                            queue:false
                        });
                    }
                });
                break;
            
        }
        
        return;
    }
    g_old_newbie_id = g_newbie_arrow_id;
    g_newbie_arrow.addClass('hide');
    $("#newbie_assist_arrow .arrow_real_img").attr('id','arrow_'+g_newbie_arrow_typ);
    g_newbie_arrow.removeClass('hide').animate({left:arrow_left,top:arrow_top},500,'easeInOutCubic');
    g_arrow_left = arrow_left;
    g_arrow_top = arrow_top;
    //if(typ == 1){
    //	$('#new_assist_content').addClass('hide');
    //}
    var _content = '';
    var select_num = user_uid%6+1;
    var cur_pid =  $('#train_player_block_all').attr('cur_pid');
    //if(arrow_id==)
    switch(g_newbie_arrow_id){
        case '#accept_task_btn':
            _content=msg_common_i18n.m54;
            break;
        case '#i_m_transfer':
            _content=msg_common_i18n.m55;
            break;
        case '#sub_transfer_player_refresh h4':
            _content=msg_common_i18n.m56;
            break;
        case '#player_refresh_btn':
            _content=msg_common_i18n.m57;
            break;
        case '#sign_player_btn_1':
            _content=msg_common_i18n.m58;
            break;
        case '#goon_game .goon_btn':
            var this_content = $('#goon_game .goon_btn').attr('content');
            _content=msg_common_i18n.s4.str_supplant({this_content:this_content});
            break;
        case '#news_con_btn':
            _content=msg_common_i18n.m59;
            break;
        case '#get_task_award_btn':
            _content=msg_common_i18n.m60;
            break;
        case '#i_m_team':
            _content=msg_common_i18n.m61;
            break;
        case '#news_con_btn':
            _content=msg_common_i18n.m62;
            break;
        case '#newbie_tactic':
            _content=msg_common_i18n.m63;
            break;
        case '#sub_tactics_formation_research h4':
            _content=msg_common_i18n.m64;
            break;
        case '#sub_tactics_tactics_research h4':
            _content=msg_common_i18n.m65;
            break;
        case '#formation_learn_new_task_btn':
            _content=msg_common_i18n.m66;
            break;
        case '#learn_tactic_btn':
            _content=msg_common_i18n.m67;
            break;
        case '#tactic_learn_btn_1':
            _content=msg_common_i18n.m68;
            break;
        case '#newbie_myteam':
            _content=msg_common_i18n.m69;
            break;
        case '#sub_team_sp_training h4':
            _content=msg_common_i18n.m70;
            break;
        case '#sub_team_team_index':
            _content=msg_common_i18n.m71;
            break;
        case '#newbie_task_btn_team_player_1':
            _content=msg_common_i18n.m72;
            break;
        case '#modless_box_close':
            _content=msg_common_i18n.m73;
            break;
        case '#add_point_btn_3':
            _content=msg_common_i18n.m74;
            break;
        case '#i_m_training':
        case '#tab_sp_training':
          _content=msg_common_i18n.m75;
          break;
        case '#train_player_btn_1':
            _content=msg_common_i18n.m76;
            break;
        case '#newbie_train_player_select_time_btn':
            _content=msg_common_i18n.m77;
            break;
        case '#training_player_select_btn':
            _content=msg_common_i18n.m78;
            break;
        case '#newbie_btn_in_train':
            _content=msg_common_i18n.m79;
            break;
        default:
            _content = msg_common_i18n.m73;
            break;	
    }
    $('#new_assist_content').html(_content);
}

function show_newbie_assist_arrow(typ,arrow_id){
    if (newbie_stat==1){
        return;
    }
    g_newbie_arrow_id = arrow_id;
    g_newbie_arrow_typ = typ;
    real_show_newbie_assist_arrow();
}

function ins_match_choose_line(stage_id,league_id,feed_id){
    if(feed_id==undefined||feed_id==0){
        feed_id = 0;
        confirm_box(msg_common_i18n.m81,function(){
            ajax_handler('ins','choose_new_line',0,'stage_id='+stage_id+'&league_id='+league_id+'&feed_id='+feed_id,function(json){
                newsbox_opened = false;
                news_box_open();
            },function(){
            });
        });
    }else{		 
        ajax_handler('ins','choose_new_line',0,'stage_id='+stage_id+'&league_id='+league_id+'&feed_id='+feed_id,function(json){         
            show_next_feed();
        },function(){
        }); 
    } 
}

function ins_choose_new_level(stage_id,level_id,feed_id){
    if(feed_id==undefined){
        feed_id = 0;
        confirm_box(msg_common_i18n.m81,function(){
            ajax_handler('ins','choose_new_level',0,'stage_id='+stage_id+'&level_id='+level_id+'&feed_id='+feed_id,function(json){
                newsbox_opened = false;
                news_box_open();
            },function(){
            });
        });
    }else{		 
        ajax_handler('ins','choose_new_level',1,'stage_id='+stage_id+'&level_id='+level_id+'&feed_id='+feed_id,function(json){         
            news_box_open();
        },function(){
        }); 
    }
    
}
function ins_load_new_choose(stage_id){
    $('#ins_match_stage_name').html(ins_stage_list[stage_id]['stage_name'])
    $("#ins_choose_loader").load('?m=ins&a=choose&format=html&stage_id='+stage_id,
    function(){
       $(".use_hovertip").hovertip();
    });
}
function ins_match_choose(ins_league_id){
	//$('#ins_match_name_a').css("color","red");
    $('.ins_match_alert_box').addClass('hide');
    $('#ins_match_box_'+ins_league_id).removeClass('hide');
}
function ins_match_alert_box_close(){
    $('.ins_match_alert_box').addClass('hide');
}
function sign_rp_player(rp_id,from_page){ 
    confirm_box(msg_common_i18n.m82,function(){
        ajax_handler('player','sign_rp_player',1,'rp_id='+rp_id,function(json){
            g_setting_from = 1;
            //sync_exp_money();
	    upd_i_header_info(json.header_info);
            if(newbie_stat==0&&cur_task_id==102){
                finish_newbie_task_step(102,3);
            }else{
                if (g_version_op==1 && json.need_feed>0){
                    qq_send_tweet({feed_typ:json.need_feed,info:json.info,source:'giantsTransfer',feed_count:json.feed_count,img_url:json.img_url});
                }
                if (from_page=='page'){
                    $("#player_refresh #box_"+rp_id).remove();
                    //    lightbox_tab_show('transfer','player_refresh');
                }else if(from_page=='player'){
                    modless_box_close();
                    if(g_module=='transfer'){
                        $("#player_refresh #box_"+rp_id).remove();
                        //lightbox_tab_show('transfer','player_refresh');
                    }
                }
            }
            
        });
    });        
}
function player_auto_add_point(pid){
    ajax_handler('player','player_auto_add_point',0,'pid='+pid,function(json){
        $("#playercard_att_defend").html(json.att_def_html);
        //$("#player_num_"+attr).html(old_value+1);
        $("#js_number"+pid).html(json.attr_points);
        $("#player_attr_points").html(json.attr_points);
        $('#player_mini_card_'+pid+ ' .player_star_bg').html(json.stars);
        for (var this_key in json.all_points){
            $("#player_num_"+this_key).html(json.all_points[this_key]);
            $('#'+this_key+'_cost_point').html(json.displayer_class[this_key+'_cost_point']); 
            $("#player_value_"+this_key).removeClass('player_1 player_2 player_3 player_4 player_5').addClass(json.displayer_class[this_key]);
            //$('#'+this_key+'_cost_point').html(json.displayer_class[this_key+'_cost_point']);
           
        }
	g_setting_from = 1;
    }); 
}
//球员修改页面
function player_alter_show(yid,id){
	if(id == "player_sub"){
            var player_name_alter_money = $('#player_name_alter').attr('player_name_alter_money');
            confirm_box(msg_common_i18n.s5.str_supplant({player_name_alter_money:player_name_alter_money}),function(){
                var pname = $('#play_name_sub').val();
                pname = encodeURIComponent(pname.replace(/[ ]/g,""));
                player_name_alter(yid,pname);
                 
            });
	}else if(id == "player_alter"){
            $("#player_name_alter").hide();
            $("#player_name_sub").show(); 
	}
}
function player_name_alter(yid,pname)
{
    ajax_handler('player','player_name_alter',0,'yid='+yid+'&pname='+pname,function(json){
        //sync_exp_money();
	upd_i_header_info(json.header_info);
        alert_box(json.error,0);
        $('#player_name_'+yid).html(json.pname);
        $('#player_gen_name_'+yid).html(json.pname);
        $('#youth_box_player_name_'+yid).html(json.pname);
        $("#player_name_sub").hide();
        $("#player_name_alter").show();
        g_setting_from = 1;
    });
}
//球员属性页面
function player_rating_show(id){
    if(id == "player_adddian"){
        $("#rating_tab_left").removeClass('hide');
        $("#player_adddian").show(); 
        $("#player_weizhi").hide();
        $("#player_back").hide();
        if(newbie_stat==0){
            if(cur_task_id==107&&cur_step_id==3){
                if(is_gk!=undefined){
                    if(is_gk==1){
                            var this_obj_id = "#add_point_btn_7";
                    }else{
                            var this_obj_id = "#add_point_btn_1";
                    }
                    show_newbie_assist_arrow(2,this_obj_id); 
                }
                
            }
        }
    }else if(id == "player_weizhi"){
        $("#player_back").show();
        $("#rating_tab_left").addClass('hide');
        $("#player_weizhi").show();  
        $("#player_adddian").hide();
        if(newbie_stat==0){
            if(cur_task_id==107&&cur_step_id==3){
                show_newbie_assist_arrow(1,"#player_back"); 
            }
        }        
    }
}
//球员加体力
function player_add_cond_point(pid,cond,player_name,typ){
    if(cond>=100){
        alert_box(msg_common_i18n.s6.str_supplant({player_name:player_name}),0);
        return;
    }
    var item_num = 0;
    if(g_item_info[1] != undefined){
        item_num = g_item_info[1]['item_num'];
    }
    var btn_list = new Array;
    btn_list[0] = new confirm_btn(msg_common_i18n.cancel,function(){alert_box_close();},'alert_wrong_btn mr_fr',false);
    if(typ == 0){
        //球员页面
        //btn_list[2] = new confirm_btn(msg_common_i18n.m85,function(){player_page_add_cond_point(2,pid)},'alert_right_btn mr_fr',false);
        btn_list[1] = new confirm_btn(msg_common_i18n.m83,function(){player_page_add_cond_point(4,pid)},'alert_right_btn mr_fr',true);
    }else if(typ == 1){
        //新闻页面
        //btn_list[2] = new confirm_btn(msg_common_i18n.m85,function(){new_page_add_cond_point(2,pid)},'alert_right_btn mr_fr',false);
        btn_list[1] = new confirm_btn(msg_common_i18n.m83,function(){new_page_add_cond_point(4,pid)},'alert_right_btn mr_fr',true);
    }
    _confirm_box(msg_common_i18n.s7.str_supplant({item_num:item_num}),3,btn_list);
}

function player_page_add_cond_point(cost_typ,pid){
    if(cost_typ == 2){
        //todo
        alert(msg_common_i18n.m84);
        return;
    }
    ajax_handler('player','add_cond_point',0,'cost_typ='+cost_typ+'&pid='+pid,function(json){             
        g_modless_content.load('?m=player&a=index&pid='+pid,function(){
            $(".use_hovertip").hovertip();
            if(newbie_stat==1){
                $(".scroll_target .scroll_content").slider_use(); 
                g_modless_box.draggable({opacity:0.8,scroll: false,handle:".box_header",cursor:"pointer"});
            }
            //sync_exp_money();
	    //upd_i_header_info(json.header_info);
            if(cost_typ == 4){
                g_item_info = json.item_info;
            }
        });        
    });
}
function new_page_add_cond_point(cost_typ,pid){
    if(cost_typ == 2){
        //todo
        alert(msg_common_i18n.m84);
        return;
    }
    ajax_handler('player','add_cond_point',0,'cost_typ='+cost_typ+'&pid='+pid,function(json){
        //sync_exp_money();
	upd_i_header_info(json.header_info);
        if(cost_typ == 4){
            g_item_info = json.item_info;
        }
        if(json.now_cond != undefined){
            $('#cond_'+pid).text(json.now_cond+'%');
        }
    });
}
//阵型内所有球员加体力
function player_add_all_reconery_cond_point(typ,count_item_num){

    var item_num = 0;
    if(g_item_info[1] != undefined){
        item_num = g_item_info[1]['item_num'];
    }
    var btn_list = new Array;
    btn_list[0] = new confirm_btn(msg_common_i18n.cancel,function(){alert_box_close();},'alert_wrong_btn mr_fr',false);
    if(typ == 0){
        //球员页面
        btn_list[2] = new confirm_btn(msg_common_i18n.m85,function(){player_page_add_all_reconery_cond_point(2)},'alert_right_btn mr_fr',true);
        btn_list[1] = new confirm_btn(msg_common_i18n.m83,function(){player_page_add_all_reconery_cond_point(4)},'alert_right_btn mr_fr',true);
    }else if(typ == 1){
        //新闻页面
        btn_list[2] = new confirm_btn(msg_common_i18n.m85,function(){new_page_add_all_reconery_cond_point(2)},'alert_right_btn mr_fr',true);
        btn_list[1] = new confirm_btn(msg_common_i18n.m83,function(){new_page_add_all_reconery_cond_point(4)},'alert_right_btn mr_fr',true);
    }
    _confirm_box(msg_common_i18n.s8.str_supplant({count_item_num:count_item_num,count_item_num20:Math.ceil(count_item_num/20),item_num:item_num}),3,btn_list);
}


function new_page_add_all_reconery_cond_point(cost_typ){
    
    ajax_handler('player','add_all_recovery_cond_point',0,'cost_typ='+cost_typ,function(json){
        
        if(cost_typ == 4){
            g_item_info = json.item_info;
        }else if(cost_typ==2){
            upd_i_header_info(json.header_info);
        }
        $('#news_reconery_player_cond').html('<div class="fl mb_10" style="height: 29px;line-height:29px;">'+
                    '<div style="padding-left:10px;"> '+msg_common_i18n.m152+'</div>'+
                '</div>');
        for (var pid in json.now_cond)
        {
            $('#cond_'+pid).text(json.now_cond[pid]+'%');
        }
    });
}

//刷新首页礼包
function refresh_present_gift(){
    return;
	var url = '?m=index&a=present_gift&format=html';
	$('#i_present_gift').load(url,function(){
		$(".use_hovertip").hovertip();
	});
}

function qq_build_pay(store_id,onSuccess_call,onClose_call){
    ajax_handler('shop','gen_qq_paycode',0,'store_id='+store_id,function(json){
        if (json.special_rstno==1){
                fusion2.dialog.buy({
                    disturb : true,
                    param : json.url_param,
                    sandbox : sandbox,
                    context :json.content_param,
                    onSuccess : function (opt) {
                        if ( onSuccess_call!= undefined){
                            onSuccess_call.apply(this,arguments);
                        }
                    },
                    onCancel : function (opt) {
                        if ( onClose_call!= undefined){
                            onClose_call.apply(this,arguments);
                        }
                    },
                    onSend : function(opt) {
                        my_debug(opt);
                    },
                    onClose : function () {
                        
                    }
               });
            }
        
    });
}

function qq_send_tweet(this_msg){
    if(newbie_stat == 0){
        return;
    }
    var real_msg = {
        info: '',
        feed_count:0,
        feed_typ:2,
        typ:'sendStory',
        receiver:'',
        source: 'giants_tweet',
        img_url: 'http://app100640938.imgcache.qzoneapp.com/app100640938/qq/app_ad_1.jpg',
        title: msg_common_i18n.m87,
        desc: msg_common_i18n.m88,
        dsc:msg_common_i18n.m89
    };
    
    if (g_pf=='qplus'){
        real_msg.img_url = 'http://app100640938.imgcache.qzoneapp.com/app100640938/qq/app_ad_2.jpg';
    }
    $.extend(real_msg, this_msg);
    if (real_msg.feed_typ==3){
        real_msg.typ = 'brag';
    }
    if (g_pf=='qplus' && real_msg.typ!='saveBlog'){
        qplus.app.share({
            msg: real_msg.info,
            title:real_msg.title,
            pic:real_msg.img_url,
            param: real_msg.source,     // 自定义参数，可实现内容定位
            shareBtnText: msg_common_i18n.m90,
            shareTo: ['buddy','qzone','wblog']
            },function (json) {
                if (json.errCode){
                    alert_box(msg_common_i18n.m91);
                } else {
                    ajax_handler('account','send_feed',0,'feed_typ=3&feed_from='+real_msg.source,function(json){
                        if (json.send_gift==1){
                        	thisMovie('bf_index_swf').hasTalkGift(json.talk_gift);
                            //refresh_present_gift();
                        }
                    });
                }
            }
        );
        
    } else {
        if (real_msg.typ=='brag' && g_pf=='pengyou'){
            real_msg.typ='sendStory';
        }
        if (real_msg.typ=='brag'){
            fusion2.dialog.brag
            ({
                 type : "brag",             
                 title : real_msg.title,            
                 msg : real_msg.info, 
                 img : real_msg.img_url,
                 receiver :[real_msg.receiver],
                 context : "brag", 
                 source :  "ref=brag",
                 dsc:   real_msg.dsc,
                 onSuccess : function (opt) 
                 {  
                    ajax_handler('account','send_feed',0,'feed_typ=3&feed_from='+real_msg.source,function(json){
                        if (json.send_gift==1){
                        	thisMovie('bf_index_swf').hasTalkGift(json.talk_gift);
                            //refresh_present_gift();
                        }
                    }); 		 
                 },
                onCancel : function (opt) 
                {  
                   if(real_msg.feed_count==0){
                    alert_box(msg_common_i18n.m91);
                }  
                }
              })
        } else if (real_msg.typ=='sendStory') {
            fusion2.dialog.sendStory
            ({
                title :real_msg.title,
              
                summary :real_msg.desc,
                
                receiver:[real_msg.receiver],
              
                msg:real_msg.info,
              
                img:real_msg.img_url,
              
                button :msg_common_i18n.m92,
              
                source :"ref=story",
              
                context:"sendStory",
              
                onSuccess : function (opt) 
                {  
                    ajax_handler('account','send_feed',0,'feed_typ=3&feed_from='+real_msg.source,function(json){
                        if (json.send_gift==1){
                        	thisMovie('bf_index_swf').hasTalkGift(json.talk_gift);
                            //refresh_present_gift();
                        }
                    });  
                },
                onCancel : function (opt) 
                {  
                   if(real_msg.feed_count==0){
                        alert_box(msg_common_i18n.m91);
                    } 
                }
            });
        } else {
            fusion2.dialog.saveBlog
            ({
                title : real_msg.title,
            
                content : real_msg.info,
                context : "blog", 
                onSuccess : function (opt) 
                {  ajax_handler('account','send_feed',0,'feed_typ=3&feed_from='+real_msg.source,function(json){
                        if (json.send_gift==1){
                        	thisMovie('bf_index_swf').hasTalkGift(json.talk_gift);
                            //refresh_present_gift();
                        }
                    });
                }, 
                onCancel : function (opt) 
                {
                    if(real_msg.feed_count==0){
                        alert_box(msg_common_i18n.m91);
                    }
                }
             })
        }
    }
}

function show_my_form(){
    ajax_handler('team','show_my_form',0,'',function(json){
        if (json.need_feed==1){
            qq_send_tweet({typ:json.feedtype,info:json.info,source:'giantsShowMyForm',feed_count:json.feed_count});
        } else {
            
        }
    });
}

function close_friend_out(){
    if ($("#i_friend_main").hasClass('hide') ){
    $("#i_friend_list").css({width:219});
        $("#i_friend_main").removeClass('hide');
        $("#i_friend_box .icon_f").removeClass('hide');
        $("#i_friend_box .icon_f_l").addClass('hide');
    } else {
        $("#i_friend_main").addClass('hide');
    $("#i_friend_list").css({width:30});
        $("#i_friend_box .icon_f").addClass('hide');
        $("#i_friend_box .icon_f_l").removeClass('hide');
    }
}
function qq_invite_friend(callback){
    if (g_pf=='qplus'){
        q_plus_invite();
    } else {
        fusion2.dialog.invite
        ({
		msg  :msg_common_i18n.m93,
		img :"http://app100640938.imgcache.qzoneapp.com/app100640938/qq/app_ico_100.png", 
		source :"domain="+zone_id,
		context :"invite",
		onSuccess : function (ret) 
		{
			var plus = ret.invitees.join('|');
			if (plus!=''){
				plus = 'invites='+plus;
				ajax_handler('account','invite_buddy',1,plus,function(json){
					//如果有邀请任务改这里
				});
			}
		},
    
		// 可选。用户取消操作后的回调方法。
		onCancel : function () {
			
		},
    
		// 可选。对话框关闭时的回调方法。
		onClose : function () {
			$.getJSON('?m=index&a=sync_buddy&format=json',function(){
				if (callback !=undefined){
                        callback.apply(this,arguments);
                }
			});
		}
        });
    }
    
}

function show_vip_info(vip_typ){
    tx_vip_box_open('vip','yellow_privilege');
}

//查看npc真实球员
function show_real_player_info(pid){
    if(newbie_stat==0){
        return;
    }
    modless_box_open({url:'?m=player&a=rp_player_info&pid='+pid,size:'mml'});
}

function show_real_player_info_lv1(pid){
    modless_box_open({url:'?m=player&a=transfer_player_info&pid='+pid,size:'mml'});
}

function load_refresh_employees(){ 
        ajax_handler('club','club_refresh_team_employees',0,'',function(json){
            $('#team_employees').load('?m=office&a=team_employees',function(){
                $(".use_hovertip").hovertip();
                if(newbie_stat==1){
                    $(".scroll_target .scroll_content").slider_use();
                }
            })
            //lightbox_tab_show('office','team_employees');
            //sync_exp_money();
	    upd_i_header_info(json.header_info);
        })
    }
    function sign_team_employees(){ 
        ajax_handler('club','sign_team_employees',0,'',function(json){
             $('#team_employees').load('?m=office&a=team_employees',function(){
                $(".use_hovertip").hovertip();
                if(newbie_stat==1){
                    $(".scroll_target .scroll_content").slider_use();
                }
            })
            //sync_exp_money();
	    upd_i_header_info(json.header_info);
        })
    }
function club_add_energy_point(){
    var item_num = 0;
    if(g_item_info[2] != undefined){
        item_num = g_item_info[2]['item_num'];
    }
    var btn_list = new Array;
    btn_list[0] = new confirm_btn(msg_common_i18n.cancel,function(){alert_box_close();},'alert_wrong_btn mr_fr',false);
    //btn_list[1] = new confirm_btn(msg_common_i18n.m85,function(){add_energy_point(2)},'alert_right_btn mr_fr',false);
    btn_list[1] = new confirm_btn(msg_common_i18n.m83,function(){add_energy_point(4)},'alert_right_btn mr_fr',true);
    //_confirm_box('本次恢复20点行动力需要：20点券 或 1行动力药水，你目前有 '+item_num+' 行动力药水,你确定恢复行动力?',3,btn_list);
    _confirm_box(msg_common_i18n.s9.str_supplant({item_num:item_num}),3,btn_list);
}
function add_energy_point(cost_typ){
    if(cost_typ == 2){
        //todo
        alert(msg_common_i18n.m84);
        return;
    }
    ajax_handler('club','add_energy_point',0,'cost_typ='+cost_typ,function(json){  
        if(cost_typ == 4){
            g_item_info = json.item_info;
        }
        upd_i_header_info(json.header_info);
        
    });
}
function send_pay(){
    if (g_version_op==1) {
        fusion2.dialog.pay(
            {
            sandbox : sandbox,
            zoneid:zone_id,
            onClose : function () {
                sync_exp_money(true);	
                }
            }
        );
    } else {
        alert_box(msg_common_i18n.m94);
    }
}
function open_present_gift(){
//    var typ = $("#i_limit_gift").attr('typ');
//    if(typ == 0){
//        alert_box(msg_common_i18n.m95);
//        return;
//    }
//    $(obj).parent().block();
    ajax_handler('shop','open_present_gift',1,'',function(json){
        //sync_exp_money();
	upd_i_header_info(json.header_info);
        //load_user_item();
        //alert_box(json.msg);
		//thisMovie('bf_index_swf').giftSuccess(1,1);
		thisMovie('bf_index_swf').limitGiftCountDown(json.limit_gift_zeit,json.gen_online_gift,json.online_keeps);
		
//        if(json.gen_online_gift>4){
//           // $("#i_limit_gift").html('').addClass('hide');
//        }else{
//            refresh_present_gift();
//        }
       // $(obj).parent().unblock();
    },function(){
        //$(obj).parent().unblock();
    });
}
function open_vip_gift(obj){
    var typ = $("#i_registration_gift_tx_vip").attr('typ');
    if(typ == 0){
        alert_box(msg_common_i18n.m95);
        return;
    }
    //$(obj).block();
    ajax_handler('shop','open_vip_gift',1,'',function(json){
        //sync_exp_money();
    //thisMovie('bf_index_swf').GiftBagIsSelected(2,1);
	upd_i_header_info(json.header_info);
        close_tx_vip_box();
        //load_user_item();
        //alert_box(json.msg);
        if(json.gen_online_gift>4){
            $("#i_limit_gift").html('').addClass('hide');
        }else{
            //refresh_present_gift();
        }
        //thisMovie('start_game').GiftBagIsSelected(2);
       $(obj).unblock();
    },function(){
        $(obj).unblock();
    });
}
function open_gobility_gift(gobility_num){
    var obj = $('#i_gobility_gift');    
    ajax_handler('shop','open_gobility_gift',0,'gobility_num='+gobility_num,function(json){
        alert_box(json.msg); 
        sync_energy(); 
        thisMovie('bf_index_swf').giftSuccess(0,1);
        //refresh_present_gift();
    });
}
function open_invitation_packs(typ,id,feed_id){
    if(feed_id==undefined){
        feed_id = 0;
    }    
    if(id != 0){
        ajax_handler('shop','open_gift_item',0,'id='+id+'&feed_id='+feed_id,function(json){
            //refresh_present_gift();
            //sync_exp_money();
	    upd_i_header_info(json.header_info);
            alert_box(json.msg);
            if(feed_id != 0){
                $('#btn_invite').text(msg_common_i18n.m49);
            }
        });
    }else{
        if(typ == 0){
            qq_invite_friend(function(){});
        }
    }
    //}else if(typ == 1){
    //    if(id != 0){
    //        ajax_handler('shop','open_gift_item',0,'id='+id+'&feed_id='+feed_id,function(json){
    //            refresh_present_gift();
    //            sync_exp_money();
    //            alert_box(json.msg);
    //            if(feed_id != 0){
    //                $('#btn_invite').text(msg_common_i18n.m49);
    //            }
    //        });
    //    }
    //}
    
}
function open_gift_packs(item_id,id){
    if(id != 0){
        ajax_handler('shop','open_gift_item',0,'id='+id+'&item_id='+item_id,function(json){
            //refresh_present_gift();
            //sync_exp_money();
            thisMovie('bf_index_swf').giftSuccess(4,1);
	    upd_i_header_info(json.header_info);	    
            alert_box(json.msg);
        });
    }
}
function ins_choose_rp_player(feed_id,rp_id){
    finish_ins_get_award(feed_id,'player',rp_id);
}
function show_other_stage_page_ins(num){
        var stage_page_count = parseInt($('#stage_choose').attr('page_count'));
        var page_id = parseInt($('#stage_choose').attr('page_id'))+num;
        if(page_id<1&&page_id>stage_page_count){
            return;
        }
        $(".stage_page").addClass('hide');
        $(".stage_page_"+page_id).removeClass('hide');
        $('#stage_choose').attr('page_id',page_id);
        if(page_id==1){
            $('#return_choose').addClass('hide');
            $('#next_choose').removeClass('hide');
        }else if(page_id==stage_page_count){
            $('#next_choose').addClass('hide');
            $('#return_choose').removeClass('hide');
        }else{
            $('#return_choose').removeClass('hide');
            $('#next_choose').removeClass('hide');
        }  
    }
function open_league_info(i){
    var can_go = $('#optional_league').attr('can_go');
    var flag = 0;
    for(var j=1;j<=5;j++){
        if($('#league_'+j).hasClass('join')){
            flag = j;
            break;
        }
    }
    $('#league_'+flag).removeClass('join');
    if(flag <= can_go){
        $('#league_'+flag).addClass('join_able');
    }else{
        $('#league_'+flag).addClass('join_disable');
    }
    if(i<=can_go){
        $('#league_'+i).removeClass('join_able');
    }else{
        $('#league_'+i).removeClass('join_disable');
    }
    //if(i==1){
    //    $('#league_'+i).attr('style','border-top:none;');
    //}
    $('#league_'+i).addClass('join');
    $('#league_info').load('?m=match&a=league_info&format=html&league_typ='+i);
    refresh_wait_team(i);
}
function refresh_wait_team(league_typ){
    //$('#wait_team').load('?m=match&a=wait_team&format=html&league_typ='+i);
    $.getJSON('index.php?m=match&a=match_team_refresh&format=json&league_typ='+league_typ,function(json){
        if(json.league_status==3){
            //lightbox_tab_show('match','league_index');
             $('#league_index').load('?m=match&a=league_index',function(){
                $(".use_hovertip").hovertip();
                if(newbie_stat==1){
                    $(".scroll_target .scroll_content").slider_use();
                }
            })
        }else{
            $('#wait_team').load('?m=match&a=wait_team&format=html&league_typ='+league_typ);
        }
    });    
}
function join_league(i,obj){
    $(obj).parent().block();
    ajax_handler('match','join_league',0,'league_typ='+i,function(json){
        if(json.need_refresh_task==1){
            upd_task_list();
        }
        if(json.league_status == 3){
            //$('#league_content').load('?m=match&a=league_index&format=html');
            $('#league_index').load('?m=match&a=league_index',function(){
                $(".use_hovertip").hovertip();
                if(newbie_stat==1){
                    $(".scroll_target .scroll_content").slider_use();
                }
            })
            return;
        }
        refresh_wait_team(i);
        $(obj).parent().unblock();
    },function(){
        $(obj).parent().unblock();
    });
}
function quit_league(i,obj){
    $(obj).parent().block();
    ajax_handler('match','quit_league',0,'league_typ='+i,function(json){
        refresh_wait_team(i);
        $(obj).parent().unblock();
    },function(){
        $(obj).parent().unblock();
    });
}
function refresh_wait_tour(tour_id){
    //$('#wait_team').load('?m=match&a=wait_team&format=html&league_typ='+i);
    $.getJSON('index.php?m=match&a=match_tour_refresh&format=json&tour_id='+tour_id,function(json){
        if(json.tour_status==0){
            $('#wait_tour_'+tour_id).load('?m=match&a=wait_tour&format=html&tour_id='+tour_id);
        }
    });    
}
function show_tour(i){
    $("#match_tour .lightbox_content_common_box").load('?m=match&a=match_tour_show&format=html&tour_id='+i,function(){
        $(".use_hovertip").hovertip();
    });
    
}
function show_tour_index(){
    $("#match_tour .lightbox_content_common_box").load('?m=match&a=match_tour_index&format=html',function(){
        $(".use_hovertip").hovertip();
    });
}

function tour_show_fixture(tour_id){
    modless_box_open({url:'?m=match&a=tour_fixture&format=html&tour_id='+tour_id,size:'xl'});
}
function join_tour(i,obj){
    $(obj).parent().block();
    ajax_handler('match','join_tour',0,'tour_id='+i,function(json){
        if(json.tour_status == 3){
            //$('#league_content').load('?m=match&a=league_index&format=html');
            //lightbox_tab_show('match','match_tour');
            $('#match_tour').load('?m=match&a=match_tour',function(){
                $(".use_hovertip").hovertip();
                if(newbie_stat==1){
                    $(".scroll_target .scroll_content").slider_use();
                }
            })
            return;
        }
        refresh_wait_tour(i);
        $(obj).parent().unblock();
    },function(){
        $(obj).parent().unblock();
    });
}
function quit_tour(i,obj){
    $(obj).parent().block();
    ajax_handler('match','quit_tour',0,'tour_id='+i,function(json){
        if(json.tour_status == 3){
            //$('#league_content').load('?m=match&a=league_index&format=html');
            $('#match_tour').load('?m=match&a=match_tour',function(){
                $(".use_hovertip").hovertip();
                if(newbie_stat==1){
                    $(".scroll_target .scroll_content").slider_use();
                }
            })
            return;
        }
        refresh_wait_tour(i);
        $(obj).parent().unblock();
    },function(){
        $(obj).parent().unblock();
    });
}

function start_league_match(feed_id){
    var plus = '';
    if(feed_id!=undefined){
        plus = 'feed_id='+feed_id;
    }
    //if(matchbox_flash_loading){
    //    alert_box('载入中，请稍后挑战！');
    //    return;
    //}
    ajax_handler('ins','begin_league_match',0,plus,function(json){       
        matchbox_open(json.mid);
        newsbox_opened = false;
    });  
}
function view_match_result(typ,num){
    var obj = $('#'+typ+num+'_h3 #button');
    var obj_content = $('#'+typ+'_'+num);
    if(typ=='event'){
        var obj_other = $('#performance'+num+'_h3 #button');
        var obj_other_content = $('#performance_'+num);
    }else{
        var obj_other = $('#event'+num+'_h3 #button');
        var obj_other_content = $('#event_'+num);
    }
    if(obj.hasClass('match_close')){
        obj.removeClass('match_close').addClass('match_extend');
        obj_content.show();
        obj_other.removeClass('match_extend').addClass('match_close');
        obj_other_content.hide();
        
    }else{
        obj.removeClass('match_extend').addClass('match_close');
        obj_content.hide();
        obj_other.removeClass('match_close').addClass('match_extend');
        obj_other_content.show();
    }
}
function talk_other(info,receivers,feed_count){
    if (g_version_op==1){
        //qq_send_tweet({feed_typ:2,info:info,source:'giantsWin','feed_count':feed_count});
        if (receivers==''){
            qq_send_tweet({feed_typ:2,info:info,source:'giantsWin','feed_count':feed_count});
        } else {
            qq_send_tweet({feed_typ:3,info:info,source:'giantsWin','feed_count':feed_count,receiver:receivers});
        }        
    }
}
function news_get_week_money_award(feed_id){
    ajax_handler('news','news_week_award',0,'feed_id='+feed_id,function(json){
        upd_i_header_info(json.header_info);
        $('#week_award_btn').hide();
        $('#week_award_span').show();
    })
}
function news_join_league(typ,feed_id,league_stage_id){
    if(typ==0){
        show_next_feed();
    }else{
        ajax_handler('match','join_league',0,'feed_id='+feed_id,function(json){
            if(json.need_refresh_task==1){
                upd_task_list();
            }
            show_next_feed();
        },function(){
            show_next_feed();
        });
    }
    
     
}
function league_get_honors(feed_id){
    ajax_handler('club','club_add_honors',0,'feed_id='+feed_id,function(json){
        $("#get_honors_btn").html(msg_common_i18n.m49);
    });
}
function join_new_league_stage(feed_id){
    //alert(feed_id+'==='+read_feed_id);
    if(feed_id != read_feed_id){
        alert_box(msg_common_i18n.m98,0);
        //alert(1);
        return;
    }
     ajax_handler('match','join_league',0,'feed_id='+feed_id,function(json){
        if(json.need_refresh_task==1){
            upd_task_list();
        }
        $("#feed_join_league").html(msg_common_i18n.m99);
    });
}
function add_point(attr,point,pid,obj){
    
    var points = parseInt($('#player_attr_points').text());
    if(points<=0){
        alert_box(msg_common_i18n.m100,0);
        return;
    }
    //var old_value = parseInt($("#player_num_"+attr).html());
    $(obj).parent().block();
    ajax_handler('player','player_add_point',0,'pid='+pid+'&att_name='+attr+'&point='+point,function(json){
        //lightbox_open(,'l');
        $("#playercard_att_defend").html(json.att_def_html);
        $("#player_num_"+attr).html(json[attr]);        
        $("#player_attr_points").html(json.attr_points);
        $('#player_mini_card_'+pid+ ' .player_star_bg').html(json.stars);
        $('#player_value_'+attr).removeClass().addClass('player_bar_value fl '+json.displayer_class);
        $('#'+attr+'_cost_point').html(json.dis_num); 
        g_setting_from = 1;
        $(obj).parent().unblock();
    },function(json){
        $(obj).parent().unblock();
    });
}
function player_auto_add_point_all(pid){
    var btn_list = new Array;
    btn_list[0] = new confirm_btn(msg_common_i18n.cancel,function(){alert_box_close();},'alert_wrong_btn mr_fr',false);
    btn_list[1] = new confirm_btn(msg_common_i18n.m101,function(){player_auto_add_point(pid);},'alert_right_btn mr_fr',true);
    _confirm_box(msg_common_i18n.m150,3,btn_list);
}

function select_opt(obj){
    alert_box($(obj).text());
    change_option('player_selectbox');
}


function change_player_main_position(pid,role_id){
    var main_position_typ = parseInt($('#player_display_main_position').attr('main_position_typ'));
    if(role_id==main_position_typ){
        return;
    }
    confirm_box(msg_common_i18n.m102,function(){
        ajax_handler('player','player_change_main_position',0,'main_position_typ='+role_id+'&pid='+pid,function(json){
            $('#player_display_main_position').attr('main_position_typ',role_id).html(json.main_position_name);
            $('#player_display_main_position_clone').html(json.main_position_name);
            $('#suitable_location').find('.player_location').removeClass('light_red').addClass('light');
            $('#suitable_location').find('#player_location_role_'+role_id).addClass('light_red');
            $('.player_star_hui').html(json.ca);
			g_setting_from = 1;
        },function(){});
    });
}
function player_buyout(pid){
    if(newbie_stat==0){
        alert_box(msg_common_i18n.m103);
        return;
    }
    confirm_box(msg_common_i18n.m104,function(){
        ajax_handler('player','player_buyout',0,'pid='+pid,function(json){
            modless_box_close();
            if(g_module=="team"){
                //lightbox_tab_show('team','team_index');
                $("#box_"+pid).remove();
                $("#team_player_list").quickPager({pageSize:8,id:'team_list_page'});
            } 	
            if(flashbox_opened_show){
                thisMovie('setting_form').send_reset_http_quest();
                g_setting_from = 0;
            }else{
                g_setting_from = 1;
            }
            if (json.get_dna>0){
                alert_box(json.get_dna_str);
            }
            //$.remove("#btn_buyout");
        });
    });
}
function skill_forget(pid,id){
    if(newbie_stat==0){
        alert_box(msg_common_i18n.m105);
        return;
    }
    confirm_box(msg_common_i18n.m151,function(){
        ajax_handler('player','player_skill_forget',0,'pid='+pid+'&id='+id,function(json){
            var url = '?m=player&a=player_skill&pid='+pid+'&format=html';
            $('#player_train_skill_content').load(url,function(){
                $(".use_hovertip").hovertip();
                if(newbie_stat==1){
                    $(".scroll_target .scroll_content").slider_use();
                }
            });
        });
    });
}
function player_washing_point(pid,cost_typ){   
    ajax_handler('player','player_washing_point',0,'pid='+pid+'&cost_typ='+cost_typ,function(json){
        g_modless_content.load('?m=player&a=index&pid='+pid,function(){
            $(".use_hovertip").hovertip();
            if(newbie_stat==1){
                $(".scroll_target .scroll_content").slider_use(); 
                g_modless_box.draggable({opacity:0.8,scroll: false,handle:".box_header",cursor:"pointer"});
            }
        });
	g_setting_from = 1;        
        if(cost_typ == 4){
            g_item_info = json.item_info;
        }else if(cost_typ==2){
            upd_i_header_info(json.header_info);
        }
    }); 
}
function player_washing_point_confirm(pid){
    if(newbie_stat==0){
        alert_box(msg_common_i18n.m106);
        return;
    }
    var item_num = 0;
    if(g_item_info[4] != undefined){
        item_num = g_item_info[4]['item_num'];
    }
    var btn_list = new Array;
    btn_list[0] = new confirm_btn(msg_common_i18n.cancel,function(){alert_box_close();},'alert_wrong_btn mr_fr',false);
    btn_list[2] = new confirm_btn(msg_common_i18n.m107,function(){player_washing_point(pid,2);},'alert_right_btn mr_fr',true);
    btn_list[1] = new confirm_btn(msg_common_i18n.m108,function(){player_washing_point(pid,4);},'alert_right_btn mr_fr',true);
    _confirm_box(msg_common_i18n.s10.str_supplant({item_num:item_num}),3,btn_list);
    //_confirm_box('本次洗点需要：1洗点药水，你目前有 '+item_num+' 洗点药水,你确定洗点?',3,btn_list);
}
var my_players_cache = new Array;
function close_player_box(pid){
    finish_newbie_task_step(101,3);
    
    my_players_cache[pid] = g_modless_content.html();
    modless_box_close();
}
function change_add_point_typ(pid,typ){
    ajax_handler('player','change_add_point_typ',0,'pid='+pid+'&typ='+typ,function(json){
        $("#player_need_manual_add_point_change .player_need_manual_add_point").addClass('hide');
        $("#player_need_manual_add_point_"+json.now_typ).removeClass('hide');
        if (json.now_typ == 1){
            $("#player_adddian .btn_add_box").removeClass('hide');
        } else {
            $("#player_adddian .btn_add_box").addClass('hide');
        }
        
    });
}
function train_tab_show(typ){
    $('.training').addClass('hide');
    $('#training_'+typ).removeClass('hide');
}

function tab_show_info(tab_id,target_id){
    $("#"+tab_id+" li").removeClass('active');
    $("#"+tab_id+" #choose_tab_"+target_id).addClass('active');
    $("#"+tab_id+"_info .tab_show_target").addClass('hide');
    $("#"+tab_id+"_info #"+target_id).removeClass('hide');
}

function reset_train(){
    $('#trains_content').load('?m=player&a=club_train_list&format=html');
}
function stop_train_player(){
    
}
function transfer_modless_box_close(){
    modless_box_close();
    if(cur_task_id==102){
        var rand_player_index =  user_uid%6+1;
        show_newbie_assist_arrow(1,"#sign_player_btn_1");        
    }
}
function change_youth_player_main_postion(yid,role_id){
    var main_position_typ = parseInt($('#youth_player_display_main_position').attr('main_position_typ'));
    if(role_id==main_position_typ){
        return;
    }
    confirm_box(msg_common_i18n.m109,function(){
        ajax_handler('player','youth_player_change_main_position',0,'main_position_typ='+role_id+'&yid='+yid,function(json){
            $('#player_display_main_position').attr('main_position_typ',role_id).html(json.main_position_name);
            $('#player_display_main_position_clone').attr('main_position_typ',role_id).html(json.main_position_name);
            $('#suitable_location').find('.player_location').removeClass('light_red').addClass('light');
            $('#suitable_location').find('#player_location_role_'+role_id).addClass('light_red');
            $('#player_ca').html(json.ca);
        });
    });
}
    
function get_gift_package(verify_num){
	if(verify_num==undefined)
	{
		var verify_num = $("#verify_num").val();
	}
    if(verify_num=="")
    {
        alert_box(msg_common_i18n.m110);
        return;
    }
            //验证码验证
    ajax_handler('shop','get_voucher',1,'verify_num='+verify_num,function(json){        
        //lightbox_tab_show('shop','our_items')
        $('#our_items').load('?m=shop&a=our_items',function(){
                $(".use_hovertip").hovertip();
                if(newbie_stat==1){
                    $(".scroll_target .scroll_content").slider_use();
                }
            })
        //sync_exp_money();
	upd_i_header_info(json.header_info);
        alert_box(msg_common_i18n.s11.str_supplant({item_name:json.item_name}));
        g_item_info = json.item_info;
    });
    $("#verify_num").val('');
}
function buy_item_confirm(typ,store_id,item_typ){
    var btn_list = new Array;
    btn_list[0] = new confirm_btn(msg_common_i18n.cancel,function(){alert_box_close();},'alert_wrong_btn mr_fr',false);       
    if(typ == 1){
        confirm_box(msg_common_i18n.m111,function(){buy_item(store_id,1,item_typ)});
    }else if(typ == 2){     
        btn_list[2] = new confirm_btn(msg_common_i18n.m112,function(){buy_item(store_id,5,item_typ)},'alert_right_btn mr_fr',false);
        btn_list[1] = new confirm_btn(msg_common_i18n.m113,function(){buy_item(store_id,3,item_typ)},'alert_right_btn mr_fr',true); 
        _confirm_box(msg_common_i18n.m114,3,btn_list);
    }else if(typ == 4){
        btn_list[1] = new confirm_btn(msg_common_i18n.m115,function(){buy_item(store_id,2,item_typ)},'alert_right_btn mr_fr',false);
        _confirm_box(msg_common_i18n.m114,3,btn_list);
    }else if (typ ==5){
        btn_list[1] = new confirm_btn(msg_common_i18n.m112,function(){buy_item(store_id,5,item_typ)},'alert_right_btn mr_fr',false);
        _confirm_box(msg_common_i18n.m114,3,btn_list);
    }
}
function buy_item_confirm_vip(typ,store_id,item_typ){
    var btn_list = new Array;
    btn_list[0] = new confirm_btn(msg_common_i18n.cancel,function(){alert_box_close();},'alert_wrong_btn mr_fr',false);       
    if(typ == 1){
        confirm_box(msg_common_i18n.m111,function(){buy_item(store_id,1,item_typ)});
    }else if(typ == 2){     
        btn_list[2] = new confirm_btn(msg_common_i18n.m112,function(){buy_item(store_id,5,item_typ)},'alert_right_btn mr_fr',false);
        btn_list[1] = new confirm_btn(msg_common_i18n.m113,function(){buy_item(store_id,3,item_typ)},'alert_right_btn mr_fr',true); 
        _confirm_box(msg_common_i18n.m114,3,btn_list);
    }else if(typ == 4){
        btn_list[1] = new confirm_btn(msg_common_i18n.m112,function(){buy_item(store_id,5,item_typ)},'alert_right_btn mr_fr',false);
        _confirm_box(msg_common_i18n.m114,3,btn_list);
    }
}
function honors_buy_item_confirm(price,item_name,store_id,item_typ){
    var honors = $('#btn_shop_buy_use_honors').attr('honors');
    confirm_box(msg_common_i18n.s12.str_supplant({item_name:item_name,price:price,honors:honors}),function(){buy_item(store_id,4,item_typ)});
}
//充值点卷
function charge_confirm(typ){
    ajax_handler('shop','buy_real_credits',0,'typ='+typ,function(json){ 
        if (json.special_rstno==1){
            if (g_pf=='qplus'){
                qplus.payment.trade({
                    platform:'unipay',
                    url_params: json.url_param
                });
            } else {
                fusion2.dialog.buy({
                    disturb : true,
                    param : json.url_param,
                    sandbox : sandbox,
                    context :json.content_param,
                    onSuccess : function (opt) {
			upd_i_header_info(json.header_info);
                        alert_box(this_desc_show);
                    },
                    onCancel : function (opt) {
                        
                    },
                    onSend : function(opt) {
			upd_i_header_info(json.header_info);
                        alert_box(this_desc_show);
                    },
                    onClose : function () {
                        
                    }
               });
            }
            
        } 
        
        
    });
}
function buy_item(store_id,buy_typ,item_typ){
    //alert(buy_typ);
    if(buy_typ == 1){
        //足球币购买
        ajax_handler('shop','buy_item',0,'store_id='+store_id+'&buy_typ='+buy_typ+'&item_typ='+item_typ,function(json){ 
            //sync_exp_money();
	    upd_i_header_info(json.header_info);
            if(item_typ==1){
                g_item_info = json.item_info;
            }
	    load_user_item(); 
            if(json.need_refresh_task==1 && json.is_hot_item == 1){
                upd_task_list();
            }
            alert_box(json.msg_desc);
        });
    }else if(buy_typ == 2){ 
        ajax_handler('shop','buy_item',0,'store_id='+store_id+'&buy_typ='+buy_typ+'&item_typ='+item_typ,function(json){
            var this_desc_show = json.msg_desc;
            if (json.special_rstno==1){
                if (g_pf=='qplus'){
                    qplus.payment.trade({
                        platform:'unipay',
                        url_params: json.url_param
                    });
                } else {
                    fusion2.dialog.buy({
                        disturb : true,
                        param : json.url_param,
                        sandbox : sandbox,
                        context :json.content_param,
                        onSuccess : function (opt) {
                            //sync_exp_money(true);
                            upd_i_header_info(json.header_info);
                            if(item_typ==9){
                                if(store_id==20){
                                    $('#shop_items_info_'+store_id).remove();
                                }
                                if(store_id==50){
                                    close_tx_vip_box();
                                }else{
                                    tx_vip_box_open('vip','pay_first');
                                }
                            }
                            load_user_item();
                            alert_box(this_desc_show);
                        },
                        onCancel : function (opt) {
                            
                        },
                        onSend : function(opt) {
                            //sync_exp_money(true);
                            upd_i_header_info(json.header_info);
                            if(item_typ==9){
                                if(store_id==20){
                                    $('#shop_items_info_'+store_id).remove();
                                }
                                if(store_id==50){
                                    close_tx_vip_box();
                                }else{
                                    tx_vip_box_open('vip','pay_first');
                                }
                            }
                            load_user_item();
                            alert_box(this_desc_show);
                        },
                        onClose : function () {
                            
                        }
                   });
                }
                
            } else {
                load_user_item();
                //sync_exp_money(true);
                upd_i_header_info(json.header_info);
                if(item_typ==1){
                    g_item_info = json.item_info;
                }
            }
            if(json.need_refresh_task==1 && json.is_hot_item == 1){
                upd_task_list();
            }
            
        });
        
        //alert_box(msg_common_i18n.m84,1);
        return;
    }else if(buy_typ == 3){
        //礼券购买
        ajax_handler('shop','buy_item',0,'store_id='+store_id+'&buy_typ='+buy_typ+'&item_typ='+item_typ,function(json){            
            //sync_exp_money();
	    upd_i_header_info(json.header_info);
            if(item_typ==1){
                g_item_info = json.item_info;
            }
            if(json.need_refresh_task==1 && json.is_hot_item == 1){
                upd_task_list();
            }
	    load_user_item();
            alert_box(json.msg_desc);
        });
    }else if(buy_typ == 4){
        //荣誉点购买
        ajax_handler('shop','buy_item',0,'store_id='+store_id+'&buy_typ='+buy_typ+'&item_typ='+item_typ,function(json){            
            //sync_exp_money();
	    upd_i_header_info(json.header_info);
            if(item_typ==1){
                g_item_info = json.item_info;
            }
            if(buy_typ==4){            
                $('#btn_shop_buy_use_honors').attr('honors',json.honors);
            }
	    load_user_item();
            if(json.need_refresh_task==1 && json.is_hot_item == 1){
                upd_task_list();
            }
            $("#stone_mix").attr('in_showing',0);
            alert_box(json.msg_desc);
        });
    }else if(buy_typ == 5){
         //点卷购买
        ajax_handler('shop','buy_item',0,'store_id='+store_id+'&buy_typ='+buy_typ+'&item_typ='+item_typ,function(json){            
            //sync_exp_money();
	    upd_i_header_info(json.header_info);
            if(item_typ==1){
                g_item_info = json.item_info;
            }
            if(json.need_refresh_task==1 && json.is_hot_item == 1){
                upd_task_list();
            } 
	    load_user_item();
            if(item_typ==9){
                if(store_id==20){
                    $('#shop_items_info_'+store_id).remove();
                }
                if(store_id==50){
                    close_tx_vip_box();
                }else{
                    tx_vip_box_open('vip','pay_first');
                }
                
            }
            //sync_exp_money(true);
	    upd_i_header_info(json.header_info);
	    $("#stone_mix").attr('in_showing',0);
            alert_box(json.msg_desc);
        });
    }
}
function load_user_item(){
    //lightbox_tab_show('shop','our_items');
    if(g_action=='our_items'){
        $('#our_items').load('?m=shop&a=our_items',function(){
            $(".use_hovertip").hovertip();
            if(newbie_stat==1){
                $(".scroll_target .scroll_content").slider_use();
            }  
        })
    }else{
        $('#our_items').attr('in_showing',0);
    }
}


function open_player_item(item_id,id,obj){
    //var target = $("#btn_open_player_item_"+id);
    $(obj).parent().block();
    //target.block();
    ajax_handler('shop','open_player_item',0,'id='+id+'&item_id='+item_id,function(json){
        alert_box(json.msg);
        $('#our_user_item_'+id).remove();
        $("#user_item_list").quickPager({pageSize:10,id:'user_item_page'});
        //sync_exp_money();
        upd_i_header_info(json.header_info);
        if (g_version_op==1 && json.need_feed>0){
            qq_send_tweet({feed_typ:json.need_feed,info:json.info,source:'giantsGiftbag',feed_count:json.feed_count,img_url:json.img_url});
        }
    
        g_setting_from = 1;
        //target.unblock();
        $(obj).parent().unblock();
    },function(){
        $(obj).parent().unblock();
    });
}
function open_gift_item(item_id,id,obj){
    //var target = $("#btn_open_player_item_"+id);
    if(obj!=undefined){
        $(obj).parent().block();
    }
    //target.block();
    ajax_handler('shop','open_gift_item',0,'id='+id+'&item_id='+item_id,function(json){
        alert_box(json.msg);
    //   if(item_id==28)
    //	   {
    //	   	thisMovie('bf_index_swf').GiftBagIsSelected(4,0);
    //	   }
       if(item_id==16)
	   {
	   		thisMovie('bf_index_swf').giftSuccess(2,1);
	   }
        //lightbox_tab_show('shop','our_items');
        $('#our_items').load('?m=shop&a=our_items',function(){
                $(".use_hovertip").hovertip();
                if(newbie_stat==1){
                    $(".scroll_target .scroll_content").slider_use();
                }  
            })
        //sync_exp_money();
	upd_i_header_info(json.header_info);
        g_item_info = json.item_info;
        //target.unblock();
        //refresh_present_gift();
        if(obj!=undefined){
            $(obj).parent().unblock();
        }
    },function(){
        if(obj!=undefined){
            $(obj).parent().unblock();
        }
    });
}
function open_gift_bag(){
    //$(obj).parent().block();
    ajax_handler('shop','open_gift_bage',0,'',function(json){
        alert_box(json.msg);         
        //refresh_present_gift();
        //sync_exp_money();
        thisMovie('bf_index_swf').giftSuccess(3,1);
	upd_i_header_info(json.header_info);
	g_item_info = json.item_info;
        close_tx_vip_box();
        //$(obj).parent().unblock();
    },function(){
        //$(obj).parent().unblock();
    });
}
function open_valued_user_gift_bag(obj){
    $(obj).parent().block();
    ajax_handler('shop','open_valued_user_gift_bage',0,'',function(json){
        alert_box(json.msg);         
        //refresh_present_gift();
        //sync_exp_money();
	upd_i_header_info(json.header_info);
        close_tx_vip_box();
        $(obj).parent().unblock();
    },function(){
        $(obj).parent().unblock();
    });
}
function open_rank_gift_bag(obj){
    $(obj).parent().block();
    ajax_handler('shop','open_rank_gift_bage',0,'',function(json){
        alert_box(json.msg);         
        //refresh_present_gift();
        //sync_exp_money();
	upd_i_header_info(json.header_info);
        close_tx_vip_box();
        $(obj).parent().unblock();
    },function(){
        $(obj).parent().unblock();
    });
}
function tactics_formation_learn(){
    if(cur_task_id==105){
        alert_box(msg_common_i18n.m116);
        return;
    }else if(cur_task_id==106){
        alert_box(msg_common_i18n.m18);
        return;
    }
    modless_box_open({url:'?m=tactics&a=formation_learn',size:'xl'});
}
function formation_level_up(formation_id,formation_level,obj){    
    if(formation_level>=25){
        alert_box(msg_common_i18n.m117,0);        
        return;
    }
    if(parseInt($('#attr_points_can_use').text())<1){
        alert_box(msg_common_i18n.m118,0);        
        return;
    }
    if(newbie_stat==0){
        if(cur_task_id==105&&cur_step_id==2){
            var now_formation = $('#research_form_list').attr('now_formation');
            //alert(now_formation);
            //alert(formation_id);
            if(formation_id!=now_formation){
                alert_box(msg_common_i18n.m119,1);                
                return;
            }
        }else{
            alert_box(msg_newbie_i18n.newbie_first,1);                
            return;
        }
        
        //$(obj).unblock();
    }
    //var target = $("#formation_learn_new_task_btn_"+formation_id);
    //target.block();
    //$(obj).block();
    $(obj).parent().block();
    ajax_handler('team','team_formation_level_up',0,'formation_id='+formation_id,function(json){
        $('#formation_level_num_'+formation_id).html(json.formation_level);
        $('#formation_level_num2_'+formation_id).html(json.formation_level);
        $('#attr_points_can_use').html(json.attr_points_can_use);
        if(newbie_stat==0){
            finish_newbie_task_step(105,2);
        }
        if(json.has_change==1){
            g_setting_from = 1;
        }
        upd_i_header_info(json.header_info);
        $(obj).parent().unblock();
        
        //target.unblock();
    },function(){
        $(obj).parent().unblock();
    });
    
}

function tactic_learn(tactic_id){
    confirm_box(msg_common_i18n.m120,function(){
        ajax_handler('team','team_tactic_learn',0,'tactic_id='+tactic_id,function(json){            
            if(newbie_stat==0&&cur_task_id==106){
                finish_newbie_task_step(106,3);
            }else{
                //lightbox_tab_show('tactics','tactics_research');
                $('#tactics_research').load('?m=tactics&a=tactics_research',function(){
                    $(".use_hovertip").hovertip();
                    if(newbie_stat==1){
                        $(".scroll_target .scroll_content").slider_use();
                    }  
                })
            }
            modless_box_close();
            upd_i_header_info(json.header_info);
            if (g_version_op==1 && json.need_feed>0){
                qq_send_tweet({feed_typ:json.need_feed,info:json.info,source:'giantsTac',feed_count:json.feed_count,img_url:json.img_url});
            }
            
        })
    });
}
function tactic_change(tactic_id,in_use){
    //var in_use = parseInt($('#team_tactic_operating_'+tactic_id).attr('in_use'));
    //if(in_use<0&&in_use>1){
    //    alert_box(msg_common_i18n.m98,0);
    //    return;
    //}
    ajax_handler('team','team_tactic_change',0,'tactic_id='+tactic_id+'&in_use='+in_use,function(){        
        //lightbox_tab_show('tactics','tactics_research');
        $('#tactics_research').load('?m=tactics&a=tactics_research',function(){
            $(".use_hovertip").hovertip();
            if(newbie_stat==1){
                $(".scroll_target .scroll_content").slider_use();
            }  
        })
    })
}
//合成老的js
function player_merge_select(typ){
    var target = $("#player_material_"+typ);
    var offset = target.offset();
    if(typ==1)
    {
        var m_top = offset.top+5;
        var m_left = offset.left-40;
    }else{
        var m_top = offset.top+5;
        var m_left = offset.left-400;
    }
    var main_pid = parseInt($('#player_material_1').attr('pid'));
    if(typ==2){
        if($('#player_material_1').attr('pid')==0){
            alert_box(msg_common_i18n.m121,0);
            return;
        }       
        $("#hc_btn").show();
        $("#xz_hc_player").hide();
        //$("#xz_hc_player2").hide();
    }
    var url = "?m=tactics&a=player_can_merge_list&format=html";
    if(typ==2){
        $('#player_material_2').hide();
        $('#player_material_22').show();
        url += '&main_pid='+main_pid;
    }
    //operating_box({url:url,top:m_top,left:m_left});
    modless_box_open({url:url,size:'xl'});
   
}
function player_merge_confirm(){
    
    var quality = parseInt($('#player_material_1').attr('quality'));
    var level = parseInt($('#player_material_1').attr('level'));
    var op_quality = parseInt($('#player_material_2').attr('quality'));
    var op_level = parseInt($('#player_material_2').attr('level'));
    var reincarnation_lev = parseInt($('#player_material_1').attr('reincarnation_lev'));
	var op_reincarnation_lev = parseInt($('#player_material_2').attr('reincarnation_lev'));
    var radio_attr = $('input[name="radio_attr"]:checked').val();
    var combine = $("#combine_"+radio_attr).val();
    var player_name = $("#player_name_1").val();
    if(combine>=7+reincarnation_lev)
    {
    	alert_box(msg_tactics_i18n.m1.str_supplant({att_typ_name:msg_common_i18n[radio_attr],player_name:player_name}));
    	return ;
    }
    
    if(op_quality>quality)
    {
        confirm_box(msg_tactics_i18n.m2,function(){player_merge_sub()});
    }else if(op_level>level){
        confirm_box(msg_tactics_i18n.m3,function(){player_merge_sub()});
    }else if(op_level>20){
		confirm_box(msg_tactics_i18n.m4,function(){player_merge_sub()});
	}else if(op_reincarnation_lev>0){
		confirm_box(msg_tactics_i18n.m5,function(){player_merge_sub()});
	}else{
        if($("#player_synthesis_lucky").attr('checked')=='checked'){
            confirm_box(msg_tactics_i18n.m6,function(){player_merge_sub()});
        }else{
        	player_merge_sub();
        }
    }
}
function player_merge_sub(){
	var btn_list = new Array;
    btn_list[0] = new confirm_btn(msg_common_i18n.cancel,function(){alert_box_close();},'alert_wrong_btn mr_fr',false);
    btn_list[1] = new confirm_btn(msg_common_i18n.m156,function(){player_merge(0)},'alert_wrong_btn mr_fr',true);
    btn_list[2] = new confirm_btn(msg_common_i18n.m155,function(){player_merge(1)},'alert_right_btn mr_fr',true);
    btn_list[3] = new confirm_btn(msg_common_i18n.m122,function(){player_merge(3)},'alert_right_btn mr_fr',true);
    var tip = msg_common_i18n.t27;
    _confirm_box(tip,3,btn_list);
}
function player_merge(sub_typ){
    var pid = parseInt($('#player_material_1').attr('pid'));
    var op_pid = parseInt($('#player_material_2').attr('pid'));
    var radio_attr = $('input[name="radio_attr"]:checked').val();
    var radio_item_typ = sub_typ;
    if($("#player_synthesis_lucky").attr('checked')=='checked'){
        var checkbox_synthesis_lucky = $('input[name="player_synthesis_lucky"]:checked').val();//幸运值
    }else{
        var checkbox_synthesis_lucky = -1;
    }
    ajax_handler('player','player_synthesis',1,'pid='+pid+'&op_pid='+op_pid+'&radio_attr='+radio_attr+'&radio_item_typ='+radio_item_typ+'&lucky='+checkbox_synthesis_lucky,function(json){
        //sync_exp_money();
    	upd_i_header_info(json.header_info);
        $('#player_material_2').html('').hide('');
        $('#player_material_22').show();
        $("#hc_btn a").removeClass('alert_right_btn').addClass('alert_wrong_btn');
        $('#money_success_rate').hide();
        $('#player_material_2').attr('pid',0);
        //var url = '?m=tactics&a=load_player_can_merge_list&pid='+pid+'&op_pid=0&radio_attr=undefined&is_selected=1&format=html';
        //$('#player_material_1').attr('pid',pid).show().load(url);
        $("#lucky_checkbox").load('?m=tactics&a=player_synthesis_lucky&format=html');
        if(json.rstno==1)
        {
            $('#r_bar_'+json.attr).html('+'+json.value);
        }
        $("#xz_hc_player").show();
        $("#xz_hc_player2").show();        
        g_setting_from = 1;
    });  
}
function player_exp_transfer_confirm(){
    
    var quality = parseInt($('#player_exp_transfer_1').attr('quality'));
    var level = parseInt($('#player_exp_transfer_1').attr('level'));
    var op_quality = parseInt($('#player_exp_transfer_2').attr('quality'));
    var op_level = parseInt($('#player_exp_transfer_2').attr('level'));
    if(op_quality>quality)
    {
    	confirm_box(msg_tactics_i18n.m7,function(){player_exp_transfer_sub()});
    }else if(op_level>level){
    	confirm_box(msg_tactics_i18n.m8,function(){player_exp_transfer_sub()});
    }else {
    	player_exp_transfer_sub();
    }
}
function player_exp_transfer_sub(){
	var btn_list = new Array;
    btn_list[0] = new confirm_btn(msg_common_i18n.cancel,function(){alert_box_close();},'alert_wrong_btn mr_fr',false);
    btn_list[1] = new confirm_btn(msg_common_i18n.m157,function(){player_exp_transfer(1)},'alert_right_btn mr_fr',true);
    btn_list[2] = new confirm_btn(msg_common_i18n.m122,function(){player_exp_transfer(3)},'alert_right_btn mr_fr',true);
    var tip = msg_common_i18n.t28;
    _confirm_box(tip,3,btn_list);
}

function player_exp_transfer(sub_typ){
    var pid = parseInt($('#player_exp_transfer_1').attr('pid'));
    var op_pid = parseInt($('#player_exp_transfer_2').attr('pid'));
    var radio_attr = $('input[name="radio_attr"]:checked').val();
    var radio_item_typ = sub_typ;
    
    ajax_handler('player','player_exp_transfer',1,'pid='+pid+'&op_pid='+op_pid+'&radio_attr='+radio_attr+'&radio_item_typ='+radio_item_typ,function(json){
    	//sync_exp_money();
	upd_i_header_info(json.header_info);
    	$('#player_exp_transfer_2').html('').hide('');
    	$("#hc_btn_exp_transfer").hide();
    	$('#money_success_rate_exp_transfer').hide();
    	$('#player_exp_transfer_2').attr('pid',0);
        if(my_players_cache[pid]!=undefined){
            my_players_cache[pid]='';
        }
        if(my_players_cache[op_pid]!=undefined){
            my_players_cache[op_pid]='';
        }
    	var url = '?m=tactics&a=load_player_can_exp_transfer_list&pid='+pid+'&op_pid=0&radio_attr=undefined&is_selected=1&format=html';
    	$('#player_exp_transfer_1').attr('pid',pid).show().load(url);
    	$("#xz_hc_player").show();
    	$("#xz_hc_player2").show();
    });  
}

function player_exp_transfer_select(typ,e){
    var target = $("#player_exp_transfer_"+typ);
    var offset = target.offset();
    if(typ==1)
    {
        var m_top = offset.top+5;
        var m_left = offset.left-40;
    }else{
        var m_top = offset.top+5;
        var m_left = offset.left-400;
    }
    var main_pid = parseInt($('#player_exp_transfer_1').attr('pid'));
    if(typ==2){
        if($('#player_exp_transfer_1').attr('pid')==0){
            alert_box(msg_tactics_i18n.m9,0);
            return;
        }
        $("#hc_btn_exp_transfer").show();
        $("#xz_hc_exp_player").hide();
        //$("#xz_hc_exp_player2").hide();
    }
    var url = "?m=tactics&a=player_can_exp_transfer_list&format=html";
    if(typ==2){
        $('#player_exp_transfer_2').hide();
        $('#player_exp_transfer_22').show();
        url += '&main_pid='+main_pid;
    }
    //operating_box({url:url,top:m_top,left:m_left});
    modless_box_open({url:url,size:'xl'});
   
}
function tacitc_modless_box_close(){
    if(cur_task_id==106&&cur_step_id==3){
        alert_box(msg_common_i18n.m17);
        return;
    }
    modless_box_close();
}
function learn_tactic(){        
    modless_box_open({url:'?m=tactics&a=tactic_learn',size:'xl',callback:function(){
    	sync_exp_money();
        finish_newbie_task_step(106,2);
    }});
}
function show_tactic_detail(tactic_id){
    if(newbie_stat==0){
        alert_box(msg_newbie_i18n.m2,1);
        return;
    }
    modless_box_open({url:'?m=tactics&a=tactic_detail&format=html&tactic_id='+tactic_id,size:'xl'});
}
function open_tactics(num){
    if(newbie_stat==0){
        alert_box(msg_newbie_i18n.m2,1);
        return;
    }
    var btn_list = new Array;
    btn_list[0] = new confirm_btn(msg_common_i18n.cancel,function(){alert_box_close();},'alert_wrong_btn mr_fr',false);
    btn_list[1] = new confirm_btn(msg_common_i18n.m122,function(){buy_tactics_slot(2)},'alert_right_btn mr_fr',true);
    //btn_list[1] = new confirm_btn('使用礼券',function(){buy_tactics_slot(3)},'alert_right_btn mr_fr',true);
    var money = '';
    if(num == 1){
        num++;
        //money = '40 点券 或 40 礼券';
        money = msg_common_i18n.m123;
    }else if(num == 2){
        num++;
        //money = '80 点券 或 80 礼券';
         money = msg_common_i18n.m126;
    }else if(num == 3){
        num++;
        //money = '120 点券 或 120 礼券';
        money = msg_common_i18n.m129;
    }
    var tip = msg_common_i18n.s13.str_supplant({money:money,num:num});
    _confirm_box(tip,3,btn_list);
}
function buy_tactics_slot(typ){ 
    ajax_handler('team','tactics_research_slot_unlock',1,'typ='+typ,function(json){
        //lightbox_tab_show('tactics','tactics_research');
        $('#tactics_research').load('?m=tactics&a=tactics_research',function(){
                $(".use_hovertip").hovertip();
                if(newbie_stat==1){
                    $(".scroll_target .scroll_content").slider_use();
                }  
            })
        upd_i_header_info(json.header_info);
    });
}
function reset_exp_transfer(){
    $('#player_exp_transfer_2').html('').hide('');
    $('#player_exp_transfer_22').show();
    $('#money_success_rate_exp_transfer').show();
    $("#xz_hc_exp_player").show();
    $("#xz_hc_exp_player2").show();
    $('#hc_btn_exp_transfer').show();
}
function reset_merge(){
    $('#player_material_2').html('').hide('');
    $('#player_material_22').show();
    //$('$hc_btn a').removeClass('alert_right_btn').addClass('alert_wrong_btn');
    $('#money_success_rate').hide();
    $("#xz_hc_player").show();
    $("#xz_hc_player2").show();
}
function hc_dj_box(num){    
    $('#hc_dj_box').attr('radio_item_typ',num);
    $('#hc_dj_box .hc_dj_ico').removeClass('active');
    $("#player_merge_radio"+num).addClass('active');
}
function hc_dj_box_exp(num){   
    $('#hc_dj_box_exp').attr('radio_item_typ',num);
    $('#hc_dj_box_exp .hc_dj_ico').removeClass('active');
    $("#player_radio_exp_"+num).addClass('active');
}
function player_select_merge(pid,typ,quality,level,reincarnation_lev){    
    var op_pid = parseInt($('#player_material_1').attr('pid'));
    var radio_attr = $('input[name="radio_attr"]:checked').val();
    var url = '?m=tactics&a=load_player_can_merge_list&pid='+pid+'&op_pid='+op_pid+'&radio_attr='+radio_attr+'&is_selected='+typ+'&format=html';
    var url_attr = '?m=tactics&a=player_merge_attr&pid='+pid+'&op_pid='+op_pid+'&radio_attr='+radio_attr+'&is_selected='+typ+'&format=html';
    $('#player_material_'+typ).attr('pid',pid).attr('quality',quality).attr('level',level).attr('reincarnation_lev',reincarnation_lev).show().load(url);
    if(typ==1){
    	$('#player_marge_attr').attr('pid',pid).attr('quality',quality).attr('level',level).attr('reincarnation_lev',reincarnation_lev).show().load(url_attr);
        $('#player_material_11').addClass('hide');
        $("#hc_btn_1").attr("onclick",""); 
        $('#hc_btn a').removeClass('alert_right_btn').addClass('alert_wrong_btn');
    }
    if(typ==2){
        var url_money = '?m=tactics&a=player_combin_money&pid='+pid+'&op_pid='+op_pid+'&radio_attr='+radio_attr+'&is_selected='+typ+'&format=html';
        $('#money_success_rate').show().load(url_money);
        $('#player_material_22').show();
        $("#hc_btn_1").attr("onclick","player_merge_confirm()"); 
        $('#hc_btn a').removeClass('alert_wrong_btn').addClass('alert_right_btn');
    } 
    modless_box_close();
}
function player_select_merge_inverse(op_pid,reincarnation_lev,radio_attr_typ,combine){
    //var player_domp = $('#box_'+pid).clone();
    //$("input[type=radio_attr][value=2]").attr("checked",'checked');
    var quality = parseInt($('#player_material_1').attr('quality'));
    $('input[name=radio_attr]').get(radio_attr_typ).checked = true;
    var pid = parseInt($('#player_material_2').attr('pid'));
    var radio_attr = $('input[name="radio_attr"]:checked').val();
    //$('#hc_tx_font').hide();
    var att_typ_name ='';
    if(combine >=parseInt(7+reincarnation_lev))
    {
        if(att_typ_name!='')
        {
            var hc_tx_font = msg_tactics_i18n.m10.str_supplant({att_typ_name:msg_common_i18n[radio_attr]});
            $('#hc_tx_font').show().html(hc_tx_font);
        }
    }
    if(pid!=0)
    {
        var url_money = '?m=tactics&a=player_combin_money&pid='+pid+'&op_pid='+op_pid+'&radio_attr='+radio_attr+'&is_selected=2&format=html';
        $('#money_success_rate').show().load(url_money);
        //operating_box_close();
        modless_box_close();
    }
}
function player_select_exp_transfer(pid,typ,quality,level){
    //var player_domp = $('#box_'+pid).clone();
    var op_pid = parseInt($('#player_exp_transfer_1').attr('pid'));
    var radio_attr = $('#player_exp_transfer_1 input[name="radio_attr"]:checked').val();
    var url = '?m=tactics&a=load_player_can_exp_transfer_list&pid='+pid+'&op_pid='+op_pid+'&radio_attr='+radio_attr+'&is_selected='+typ+'&format=html';
    $('#player_exp_transfer_'+typ).attr('pid',pid).attr('quality',quality).attr('level',level).show().load(url);
    if(typ==1){
       $('#player_exp_transfer_11').hide(); 
       $("#hc_btn_exp_transfer_1").attr("onclick",""); 
       $('#hc_btn_exp_transfer a').removeClass('alert_right_btn').addClass('alert_wrong_btn');
    }
    if(typ==2)
    {
        var url_money = '?m=tactics&a=player_exp_transfer_money&pid='+pid+'&op_pid='+op_pid+'&radio_attr='+radio_attr+'&is_selected='+typ+'&format=html';
        $('#money_success_rate_exp_transfer').show().load(url_money);
        $('#player_exp_transfer_22').hide(); 
        $("#hc_btn_exp_transfer_1").attr("onclick","player_exp_transfer_confirm()"); 
        $('#hc_btn_exp_transfer a').removeClass('alert_wrong_btn').addClass('alert_right_btn');
    }
    //operating_box_close();
    modless_box_close();
}

function tacitc_exp_modless_box_close(){
    modless_box_close();
    $('#player_exp_transfer_2').html('');
    $("#hc_btn_exp_transfer").hide();
    $("#xz_hc_player").show();
    $("#xz_hc_player2").show();
}



function open_youth(yid){
    dna_in_use = [];
    lock_attr = [];
    lock_attr = [];
    //lightbox_open('team','youth_gen','&yid='+yid);
    //lightbox_tab_show({url:'?m=team&a=youth_gen&yid='+yid,size:'xl'});
    //lightbox_open('?m=player&a=op_player_info&pid='+pid,'l');
    lightbox_open('?m=team&a=youth_gen&yid='+yid,'xl');
}

function new_youth(){
    cost_price = now_youth_count*100;
    if (cost_price==0){
        var msg = msg_common_i18n.m130.str_supplant({cost:cost_price});    
    } else {
        var msg = msg_common_i18n.s14.str_supplant({cost:cost_price});    
    }
    var btn_list = new Array;
    btn_list[0] = new confirm_btn(msg_common_i18n.cancel,function(){},'alert_wrong_btn mr_fr',false);
    btn_list[1] = new confirm_btn(msg_common_i18n.m131,function(){
        ajax_handler('team','create_youth',1,'is_gk=1',function(json){
            lightbox_tab_show('team','youth_team');
        });
    },'alert_right_btn mr_fr',true);
    btn_list[2] = new confirm_btn(msg_common_i18n.m132,function(){
        ajax_handler('team','create_youth',1,'is_gk=0',function(json){
            lightbox_tab_show('team','youth_team');
        });
    },'alert_right_btn mr_fr',true);
    _confirm_box(msg,3,btn_list); 
}

function special_train(pid,level,exp,vip_level){
    //礼券=离升级经验的差值/(等级^1.38+29)*99/40
//足球币=离升级经验的差值/(等级^1.38+29)*等级*50
    var vip_rate = 1;
    if(vip_level==2){
        vip_rate = 0.8;
    }else if(vip_level==3){
        vip_rate = 0.5;
    }
    var cost_price = Math.ceil(exp/(Math.pow(level,1.38)+29)*level*50*vip_rate);
    var cost_credits = Math.ceil(exp/(Math.pow(level,1.38)+29)*99/40);
    
    confirm_box(msg_common_i18n.s15.str_supplant({level:level+1,cost_price:cost_price,cost_credits:cost_credits}),function(){
        ajax_handler('player','special_train',1,'pid='+pid,function(json){
            upd_i_header_info(json.header_info);
            if(my_players_cache[pid]!=undefined){
                my_players_cache[pid]='';
            }
            modless_box_close();
        });
    });
}
//obj = undefined 表示在球员modless页面召回 else 表示在特训页面召回
function club_player_end_train(pid,typ,obj){
    if(obsession_status!=1){
        if(obsession_status==0.5){
            alert_box(msg_common_i18n.m133,0);
        }else{
            alert_box(msg_common_i18n.m134,0);
        }
        return;
    }
    if(typ==0){
        confirm_box(msg_common_i18n.m135,function(){
            ajax_handler('player','recall_train_players',0,'pid='+pid,function(json){
               
                if(obj == undefined){//球员页
                    g_modless_content.load('?m=player&a=index&pid='+pid,function(){
                        $(".use_hovertip").hovertip();                 
                        $(".scroll_target .scroll_content").slider_use(); 
                        g_modless_box.draggable({opacity:0.8,scroll: false,handle:".box_header",cursor:"pointer"});
                       
                    });
                }else{
                    var this_obj = $('#train_sp_box_'+pid);
                    this_obj.html(json.data_html).addClass('no_player').attr('id','');
                    $('#train_player_block_all').html(json.no_train_data_html).attr('cur_pid',0).attr('can_train',1);
                    if(newbie_stat==1){
                        $(".scroll_target .scroll_content").slider_use();
                    }
                    if(my_players_cache[pid]!=undefined){
                        my_players_cache[pid]='';
                    }
                    if(json.rest_num==1){
                        if(my_players_cache.length!=0){
                            
                            for(var this_pid in my_players_cache){
                                my_players_cache[pid]='';
                            }
                        }
                    }
                }
            });
        });
    }else{
        if(obj!=undefined){
            $(obj).parent().block();
        }
        ajax_handler('player','recall_train_players',1,'pid='+pid,function(json){
            if(obj == undefined){//球员页
                g_modless_content.load('?m=player&a=index&pid='+pid,function(){
                    $(".use_hovertip").hovertip();
                    g_modless_box.draggable({opacity:0.8,scroll: false,handle:".box_header",cursor:"pointer"});
                   
                });
            }else{
                var this_obj = $('#train_sp_box_'+pid);
                this_obj.html(json.data_html).addClass('no_player').attr('id','');
                $('#train_player_block_all').html(json.no_train_data_html).attr('cur_pid',0).attr('can_train',1);
                if(newbie_stat==1){
                    $(".scroll_target .scroll_content").slider_use();
                }
                if(my_players_cache[pid]!=undefined){
                    my_players_cache[pid]='';
                }
                if(json.rest_num==1){
                    if(my_players_cache.length!=0){
                        for(var this_pid in my_players_cache){
                            my_players_cache[this_pid]='';
                        }
                    }
                }
            }
            if(json.need_refresh_task==1){
                upd_task_list();
            }
          
            alert_box(json.msgs);
            if(obj!=undefined){
                $(obj).parent().unblock();
            }
        },function(){
            if(obj!=undefined){
                $(obj).parent().unblock();
            }
        });
    }
}

//function unlock_train_slot(){
//    confirm_box('您确定花费1000金币开启特训位?',function(){
//        ajax_handler('player','player_train_slot_unlock',1,'',function(json){
//            lightbox_tab_show('team','sp_training');
//        });
//    })
//}
function open_train(){
    var btn_list = new Array;
    btn_list[0] = new confirm_btn(msg_common_i18n.cancel,function(){alert_box_close();},'alert_wrong_btn mr_fr',false);
    btn_list[1] = new confirm_btn(msg_common_i18n.m122,function(){buy_train(2)},'alert_right_btn mr_fr',true);
    
    //btn_list[1] = new confirm_btn('使用礼券',function(){buy_train(3)},'alert_right_btn mr_fr',true);
    var money = '';
    var num = parseInt($('#player_train_ul_content_list').attr('train_num_count'));
    if(num == 2){
        num++;
        //money = '100 点券 或 100 礼券';
        money = msg_common_i18n.m123;
    }else if(num == 3){
        num++;
        //money = '200 点券 或 200 礼券';
        money = msg_common_i18n.m124;
    }else if(num == 4){
        num++;
        //money = '200 点券 或 200 礼券';
        money = msg_common_i18n.m125;
    }else if(num == 5){
        num++;
        //money = '200 点券 或 200 礼券';
        money = msg_common_i18n.m127;
    }else if(num == 6){
        num++;
        //money = '200 点券 或 200 礼券';
        money = msg_common_i18n.m128;
    }else if(num == 7){
        num++;
        //money = '200 点券 或 200 礼券';
        money = msg_common_i18n.m129;
    }
    var tip = msg_common_i18n.s16.str_supplant({money:money,num:num});
    _confirm_box(tip,3,btn_list);
}
function buy_train(typ){    
    ajax_handler('player','player_train_slot_unlock',1,'typ='+typ,function(json){
        $('#player_train_ul_content_list').attr('train_num_count',json.train_num_count);
        $('#player_train_ul_content_list #num_count_'+json.train_num_count).html(json.html_train).removeClass('un_player').addClass('no_player');
        upd_i_header_info(json.header_info);
    });
    
}
function finish_sp_training(pid,end_zeit,config_item_cost_time,is_yellow_vip){
    var item_num = 0; 
    var cur_zeit = Date.parse(new Date())/1000;
    $.getJSON('?m=index&a=sync_time&format=json',function(json){ 
        var cur_zeit = json.zeit;
        var need_item = Math.ceil((end_zeit - cur_zeit)/config_item_cost_time)
        if(g_item_info[14] != undefined){
            item_num = g_item_info[14]['item_num'];
        }
        var btn_list = new Array;
        btn_list[0] = new confirm_btn(msg_common_i18n.cancel,function(){alert_box_close();},'alert_wrong_btn mr_fr',false);
        btn_list[2] = new confirm_btn(msg_common_i18n.m122,function(){accelerate_sp_training(2,pid,need_item)},'alert_right_btn mr_fr',true);
        btn_list[1] = new confirm_btn(msg_common_i18n.m136,function(){accelerate_sp_training(4,pid,need_item)},'alert_right_btn mr_fr',true); 
        _confirm_box(msg_common_i18n.s17.str_supplant({need_item:need_item,need_item10:(need_item*10-1),item_num:item_num}),3,btn_list);
    });
}
function accelerate_sp_training(cost_typ,pid,need_item){ 
    ajax_handler('player','finish_sp_training',0,'pid='+pid+'&cost_typ='+cost_typ+'&need_item='+need_item,function(json){
        $('#train_sp_box_'+pid).html(json.data_html).find('#training_zh_btn_disable').addClass('hide');
        if(cost_typ==2){
            upd_i_header_info(json.header_info);
        }else if(cost_typ == 4){
            g_item_info = json.item_info;
        }        
    });
}

function youth_invite(){
    qq_invite_friend(function(){
        //lightbox_tab_show('team','youth_training_base');
        $('#youth_training_base').load('?m=team&a=youth_training_base',function(){
            $(".use_hovertip").hovertip();
            if(newbie_stat==1){
                $(".scroll_target .scroll_content").slider_use();
            }  
        })
        
    });
    
}
function blackmarket_player_refresh(pos_id,main_position_name,quality,player_name){
	var item_num = 0;
    if(g_item_info[3] != undefined){
        item_num = g_item_info[3]['item_num'];
    }
    if(quality == 5)
    {
    	confirm_box(msg_common_i18n.s18.str_supplant({main_position_name:main_position_name,player_name:player_name}),function(){
    		var btn_list = new Array;
    	    btn_list[0] = new confirm_btn(msg_common_i18n.cancel,function(){alert_box_close();},'alert_wrong_btn mr_fr',false);
    	    btn_list[1] = new confirm_btn(msg_common_i18n.m137,function(){black_player_refresh(1,pos_id)},'alert_right_btn mr_fr',true);
    	    btn_list[2] = new confirm_btn(msg_common_i18n.m136,function(){black_player_refresh(4,pos_id)},'alert_right_btn mr_fr',true);
    	    btn_list[3] = new confirm_btn(msg_common_i18n.m122,function(){black_player_refresh(2,pos_id)},'alert_right_btn mr_fr',true);
    	    _confirm_box(msg_common_i18n.s19.str_supplant({item_num:item_num,main_position_name:main_position_name}),3,btn_list);
    	});
    }else{
	    var btn_list = new Array;
	    btn_list[0] = new confirm_btn(msg_common_i18n.cancel,function(){alert_box_close();},'alert_wrong_btn mr_fr',false);
	    btn_list[1] = new confirm_btn(msg_common_i18n.m137,function(){black_player_refresh(1,pos_id)},'alert_right_btn mr_fr',true);
	    btn_list[2] = new confirm_btn(msg_common_i18n.m136,function(){black_player_refresh(4,pos_id)},'alert_right_btn mr_fr',true);
	    btn_list[3] = new confirm_btn(msg_common_i18n.m122,function(){black_player_refresh(2,pos_id)},'alert_right_btn mr_fr',true);
	    _confirm_box(msg_common_i18n.s20.str_supplant({item_num:item_num,main_position_name:main_position_name}),3,btn_list);
    }
}
var click_counter = 0;
function black_player_refresh(cost_typ,pos_id){
    click_counter++;
    ajax_handler('player','blackmarket_player_refresh',0,'pos_id='+pos_id+'&cost_typ='+cost_typ,function(json){           
        //sync_exp_money();
	upd_i_header_info(json.header_info);
        $("#js_blackmarket_holder #box_"+pos_id).html(json.data_html);
        if(cost_typ == 4){
            g_item_info = json.item_info;
        }
        if(json.need_refresh_task==1){
            upd_task_list();
        }
    });
}
function sign_rp_player_black(rp_id,id,pos_id){ 
    if(rp_id == ''){
        alert_box(msg_common_i18n.m138,0);		
    } else {
        confirm_box(msg_common_i18n.m139,function(){
            ajax_handler('player','sign_rp_blackmarket_player',1,'rp_id='+rp_id+'&id='+id+'&pos_id='+pos_id,function(json){          
                //sync_exp_money();
		upd_i_header_info(json.header_info);
                if(pos_id==undefined){
                    modless_box_close();
                    pos_id = json.pos_id;
                }
                $("#js_blackmarket_holder #box_"+pos_id).html(json.data_html);
                
                if (g_version_op==1 && json.need_feed>0){
                    qq_send_tweet({feed_typ:json.need_feed,info:json.info,source:'giantsBlackRefresh',feed_count:json.feed_count,img_url:json.img_url});
                }
                g_setting_from = 1;
            });
        });
    }        
}

function load_refresh_player(typ,obj){
    if(newbie_stat == 0){
        if(typ == 2){
            alert_box(msg_newbie_i18n.m2);
            return;
        }
    }
    if(typ == 1){		
        refresh_player(1,0,obj);		
        return;
    }
    
    var item_num = 0;
    if(g_item_info[3] != undefined){
        item_num = g_item_info[3]['item_num'];
    }
    var btn_list = new Array;
    btn_list[0] = new confirm_btn(msg_common_i18n.cancel,function(){alert_box_close();},'alert_wrong_btn mr_fr',false);
    btn_list[2] = new confirm_btn(msg_common_i18n.m140,function(){refresh_player(typ,2)},'alert_right_btn mr_fr',true);
    btn_list[1] = new confirm_btn(msg_common_i18n.m141,function(){refresh_player(typ,4)},'alert_right_btn mr_fr',true);
    _confirm_box(msg_common_i18n.s21.str_supplant({item_num:item_num}),3,btn_list);
    //_confirm_box('本次购买需要：4刷新券，你目前有 '+item_num+' 张刷新券，你确定购买名单?',3,btn_list);
    
}
function show_players(typ){
    if(newbie_stat==0){
        alert_box(msg_newbie_i18n.newbie_first,1);
        return;
    }
    $("#choose_pos_list li").removeClass('active');
    $("#choose_pos_list_"+typ).addClass('active');
    if (typ==0){
        $("#team_player_list .common_black_player_box").removeAttr('skipPager');
    } else {
        $("#team_player_list .common_black_player_box").attr('skipPager',1);
        $("#team_player_list .pos_typ_"+typ).removeAttr('skipPager');
    }
    $("#team_player_list").quickPager({pageSize:8,id:'team_list_page'});
}

function refresh_player(typ,cost_typ,obj){ 
    if(typ==1){
        $(obj).parent().block();
    }
    ajax_handler('player','refresh_rp_player',0,'typ='+typ+'&cost_typ='+cost_typ,function(json){        
        if(cost_typ == 4){
            g_item_info = json.item_info;			
        }else if(cost_typ==2){
            upd_i_header_info(json.header_info);  
        }
        if(json.need_refresh_task == 1){
            upd_task_list();
        }
        //lightbox_tab_show('transfer','player_refresh');
        var url = '?m=transfer&a=player_refresh';
        $("#player_refresh").removeClass('hide').load(url,function(){
            if(newbie_stat==1){
                $(".scroll_target .scroll_content").slider_use();
            }			
            $(".use_hovertip").hovertip();
            finish_newbie_task_step(102,2);           
            show_newbie_assist_arrow(1,"#sign_player_btn_1");
        });
        
        if(typ==1){
            $(obj).parent().unblock();
        }
        //$(obj).unblock();
    },function(){
        if(typ==1){
            $(obj).parent().unblock();
        }
    })
}


function match_tour_pre_check(cup_pre_level){
    var msg = '';
    ajax_handler('match','match_tour_pre_check',0,'cup_pre_level='+cup_pre_level,function(json){
        if(json.result.msg)
        {
            msg = json.result.zeit+'|'+json.result.mid+'|'+json.result.rand_index+'|'+json.result.token+'|1';
            thisMovie('match_tour_pre_fff').set_gameconfig(msg);
        }else{
            msg = json.result.zeit+'|'+json.result.mid+'|'+json.result.rand_index+'|'+json.result.token+'|0';
            thisMovie('match_tour_pre_fff').set_gameconfig(msg);
        }
    },function(){
        msg = -1;
        thisMovie('match_tour_pre_fff').set_gameconfig(msg);  
    });
 
}


function match_tour_pre_change_status(status){
	g_web_status = status;
}

function show_update_board(){
    modless_box_open({url:'?m=index&a=update_board',size:'xl'});
    //modless_box_close();
}

function show_msg(){
    modless_box_open({url:'?m=index&a=msg',size:'mml'});
    //modless_box_close();
}

function show_week_news(week_news_id){
    modless_box_open({url:'?m=news&a=show_week_news&week_news_id='+week_news_id,size:'mml'});
    //modless_box_close();
}

function msg1(){   
   newbie_box(1,0,msg_common_i18n.m142,msg2);
   //$('#alert_box_in').removeClass('alert_box_common');
   $('#alert_box_in').addClass('game_product_bg');
   
}

function msg2(){
    ajax_handler('account','newbie_log',0,'msg=101',function(){
        newbie_box(2,0,msg_common_i18n.m143,msg3);
    });
}

function msg3(){
    ajax_handler('account','newbie_log',0,'msg=102',function(){
        newbie_box(3,0,msg_common_i18n.m143,function(){
            ajax_handler('account','newbie_log',0,'msg=103',function(json){
                news_box_open();
            });
        });
    });
    
}

function new_reg_msg(msg){
    ajax_handler('account','newbie_log',0,'msg='+msg,function(json){
        if(msg==103){
            news_box_open();
        }
    });
}

function match_use_home_buff(home_buff_use_rest,feed_id,home_buff_use_count,cfg_home_buff_cost){
    var msg;
    if(home_buff_use_rest<=0){
        alert_box(msg_common_i18n.m144.str_supplant({home_buff_use_count:home_buff_use_count}),1);
        return;
    }else if(home_buff_use_count-home_buff_use_rest==0){
        msg = msg_common_i18n.s22.str_supplant({home_buff_use_rest:home_buff_use_rest,home_buff_use_count:home_buff_use_count});
    }else{
        msg = msg_common_i18n.s23.str_supplant({home_buff_use_rest:home_buff_use_rest,cfg_home_buff_cost:cfg_home_buff_cost,home_buff_use_count:home_buff_use_count});
    }
    confirm_box(msg,function(){
        sync_exp_money();
        start_master_match(feed_id,1);
    })     
}

function reload_login(){
    var btn_list = new Array;
    if(g_is_public==1){
        btn_list[0] = new confirm_btn(msg_common_i18n.cancel,function(){alert_box_close();},'alert_wrong_btn mr_fr',false); 
        btn_list[1] = new confirm_btn(msg_common_i18n.m145,function(){ window.location.reload();},'alert_right_btn mr_fr',true);  
        _confirm_box(msg_common_i18n.m146,2,btn_list);
    }
}

function player_reincarnation_confirm(reply){
    var reply_count =  parseInt($('#load_player_can_rein_list_content').attr('reincarnation_lev'));
    var btn_list = new Array;
    //pid,reply,need_item
    var obj = $('#player_rein_box');
    var pid = parseInt(obj.attr('pid'));
    if(reply == 0){
        var need_item = parseInt(obj.attr('need_item'));
    }else{
        var need_item = 10;        
    }
    btn_list[0] = new confirm_btn(msg_common_i18n.cancel,function(){alert_box_close();},'alert_wrong_btn mr_fr',false);
   
    btn_list[2] = new confirm_btn(msg_common_i18n.m122,function(){player_reincarnation(pid,reply,2,reply_count)},'alert_right_btn mr_fr',true);
    btn_list[1] = new confirm_btn(msg_common_i18n.m147,function(){player_reincarnation(pid,reply,1,reply_count)},'alert_right_btn mr_fr',true);
    var msg = '';
    if(reply==0){
        msg = msg_common_i18n.s24.str_supplant({need_item:need_item,need_item29:Math.floor(need_item*29.8)});
    }else{
        msg = msg_common_i18n.s25.str_supplant({need_item:need_item,need_item49:Math.floor(need_item*4.9)});
    }
    _confirm_box(msg,3,btn_list);
	//$("#rein_font_box_js").load('?m=tactics&a=load_player_can_rein_list&format=html');
    
}
function player_reincarnation(pid,reply,use_typ,reply_count){
    ajax_handler('player','player_reincarnation',1,'pid='+pid+'&reply='+reply+'&use_typ='+use_typ+'&reply_count='+reply_count,function(json){ 
        if(my_players_cache[pid]!=undefined){
            my_players_cache[pid] = '';
        }
        $('#player_rein_box').html(json.data_html);
        if(reply==0){
            $('#player_rein_box').attr('need_item',0);
        }
        $('#rein_box_btn_ids a').hide();
        if(json.can_rein_reload==1){
            $('#player_rein_reload_btn').show();
        }
        if(json.can_rein==1){
            $('#player_rein_btn').show();
        } 
        if(use_typ==1){
            g_item_info = json.item_info;             
            $('#player_rein_item_has_num').html(json.rest_item);
        }else{
            upd_i_header_info(json.header_info);
        }
    })
}
//流派弹出box
function show_union_box(union_id){     
    var plus = '&union_id='+union_id;
    modless_box_open({url:'?m=union&a=union_show'+plus,size:'xl',callback:function(){         
    }});
}
//删除好友
function del_friend(op_uid,$cid){
    var op_friend_name = $('#friend_name_'+op_uid).val();
    var plus = 'op_uid='+op_uid;

    confirm_box(msg_common_i18n.s26.str_supplant({op_friend_name:op_friend_name}),function(){
        ajax_handler('account','del_buddy',1,plus,function(json){
            $("#i_friend_list").load('?m=index&a=friend_list&format=html');
            setTimeout(refresh_had_del_friend_list,300);
        });
    });
}
function refresh_had_del_friend_list(){
    $("#i_friend_list").css({width:219});
    $("#i_friend_box .icon_f").removeClass('hide');
    $("#i_friend_box .icon_f_l").addClass('hide');
    $("#i_friend_main").removeClass('hide');
}

var real_begin_match_pre_wait_timer = 0;
function march_tour_pre_wait(cup_pre_level){
    if (g_energy<4){
        alert_box(msg_common_i18n.m148,1);
        return;
    }
   
    window.clearTimeout(real_begin_match_pre_wait_timer);
    g_web_status = 1;
    var this_obj =  $('#match_tourpre_'+cup_pre_level+' .alert_right_btn');
    if(matchbox_flash_loading){        
        real_begin_match_pre_wait_timer = window.setTimeout(function(){
            this_obj.html('loading...').attr('onclick','');            
            march_tour_pre_wait(cup_pre_level);
        },500);
    }else{  
        //alert(matchbox_flash_loading);
        match_swf.enterArenaer(cup_pre_level,match_pre_att_value,match_pre_def_value); 
        this_obj.html(60).attr('onclick',''); 
        timer_tour_pre = setInterval(function(){
            if(matchbox_flash_loading||g_web_status==0){
                mappingFail(cup_pre_level);
                clearInterval(timer_tour_pre);
            }else{
                var ab = parseInt(this_obj.html()); 
                if(ab>0){
                    this_obj.html(--ab);
                }else{
                    clearInterval(timer_tour_pre); 
                    this_obj.html(msg_common_i18n.m149);
                }
            }
        },1000);         
    } 
}

function players_list_filter(id,typ,page_option){
    $("#choose_"+id+" li").removeClass('active');
    $("#choose_"+id+"_"+typ).addClass('active');
    if (typ==0){
        $("#"+id+" .common_black_player_box").removeAttr('skipPager');
    } else {
        $("#"+id+" .common_black_player_box").attr('skipPager',1);
        $("#"+id+" .pos_typ_"+typ).removeAttr('skipPager');
    }
    if (page_option!=undefined){
        $("#"+id).quickPager(page_option);
    }
}

function show_player_train_time(pid){
    modless_box_close();
    modless_box_open({url:'?m=team&a=player_train_time&format=html&pid='+pid,size:'mml'});
}

function choose_equip_items(feed_id,choise_id){
    $('#news_event_content').html(refresh_loading_img('event'));
    ajax_handler('news','choose_equip_item',0,'feed_id='+feed_id+'&choise_id='+choise_id,function(json){
        setTimeout(function(){
            if(choise_id==1){
                $('#news_event_content').html('<div class="yellow_news">'+json.data_str+'</div>');
            }else{
                $('#news_event_content').html('<div class="yellow_news">'+json.data_str+'</div>');
            }
            
        },500);
        if(choise_id==1){
            if(my_players_cache[json.pid]!=undefined){
                my_players_cache[json.pid] = '';
            }
        }else if(choise_id == 2){
            g_item_info = json.item_info;
        }
         
    })
}
function go_to_pay_page(){
    if(g_version_op==2){
        window.open (g_config_pay_url, "newwindow");        
    }else if(g_version_op==1){
        lightbox_tab_show('shop','shop_index');
    }
}

function open_youth_dna_item_in_bage(item_id,id,obj){
    $(obj).parent().block();
    ajax_handler('shop','open_youth_dna_item',0,'id='+id+'&item_id='+item_id,function(json){
        alert_box(json.msg);
        $('#our_items').load('?m=shop&a=our_items',function(){
            $(".use_hovertip").hovertip();
            if(newbie_stat==1){
                $(".scroll_target .scroll_content").slider_use();
            }
        })
        upd_i_header_info(json.header_info);
        g_item_info = json.item_info;
        //refresh_present_gift();
        $(obj).parent().unblock();
    },function(){
        $(obj).parent().unblock();
    });
}

function youth_attr_lock(attr){ 
    if ($("#"+attr+'_holder').attr('lock')==1){            
        $("#"+attr+'_holder').addClass('hide').attr('lock',0);
        lock_attr.deleteOf(attr);
        base_counter--;
        if (base_counter==need_counter){
            $("#real_gen_btn").removeClass('common_alert_right_btn_hui').addClass('common_alert_right_btn');
        } else {
            $("#real_gen_btn").removeClass('common_alert_right_btn').addClass('common_alert_right_btn_hui');
        }
    } else {
        if (base_counter>=need_counter){
            return;
        }
        if (lock_attr.length>=max_lock){
            return;
        }
        $("#"+attr+'_holder').removeClass('hide').attr('lock',1);
        lock_attr.push(attr);
        base_counter++;
        if (base_counter==need_counter){
            $("#real_gen_btn").removeClass('common_alert_right_btn_hui').addClass('common_alert_right_btn');
        } else {
            $("#real_gen_btn").removeClass('common_alert_right_btn').addClass('common_alert_right_btn_hui');
        }
    }
    
}
function choose_this_dna(id,name){
    if (base_counter>=need_counter){
        return;
    }
    dna_in_use.push(id);
    $("#dna_can_use_"+id).attr('skipPager',1).addClass('hide');
    $("#player_dna_in_use").append('<li id="dna_in_use_'+id+'" class="like_a odd1" onclick="remove_this_dna('+id+')">'+name+'(-)</li>');
    base_counter++;
    if (base_counter==need_counter){
        $("#real_gen_btn").removeClass('common_alert_right_btn_hui').addClass('common_alert_right_btn');
    } else {
        $("#real_gen_btn").removeClass('common_alert_right_btn').addClass('common_alert_right_btn_hui');
    }
}
function remove_this_dna(id){
    base_counter--;
    $("#dna_can_use_"+id).attr('skipPager',0).removeClass('hide');
    $("#dna_in_use_"+id).remove();
    dna_in_use.deleteOf(id);
    if (base_counter==need_counter){
        $("#real_gen_btn").removeClass('common_alert_right_btn_hui').addClass('common_alert_right_btn');
    } else {
        $("#real_gen_btn").removeClass('common_alert_right_btn').addClass('common_alert_right_btn_hui');
    }
}
function youth_close(){
    lightbox_close(1);
    lightbox_tab_show('team','youth_team');
}
function real_gen_youth(yid){
    var dna_list = dna_in_use.join();
    var lock_attr_list = lock_attr.join();
    $("#real_gen_btn_holder").block();
    ajax_handler('team','real_gen_youth',0,'dna_list='+dna_list+'&yid='+yid+'&lock_attr_list='+lock_attr_list,function(json){
        $("#real_gen_btn_holder").unblock();
        if (json.rstno>=1){
            modless_box_close();
            open_youth(yid);
            my_players_cache[json.pid]='';
        }
    },function(){
        $("#real_gen_btn_holder").unblock();
    });
}

function gen_youth(yid){
    if (base_counter!=need_counter){
        return;
    }
    if (lock_attr.length>max_lock){
        return;
    }
    cost_gen=Math.pow(lock_attr.length,2)*20;
    if (cost_gen==0){
        real_gen_youth(yid);
    } else {
        var msg = msg_team_i18n.m1.str_supplant({cost:cost_gen});
        confirm_box(msg,function(){
            real_gen_youth(yid)
        },function(){});
    }
}


function beginArenaer(mid){
    g_web_status = 0;
    matchbox_open(mid);
}

function view_tour_fixture(home_cid,op_cid){
    var plus = 'cid='+home_cid+'&npc='+op_cid;
    ajax_handler('match','tour_fixture_view',1,plus,function(json){
        view_mid = json.mid;
        matchbox_open(view_mid);
    })
}

function show_op_assist_help(){
    tutorials_open(g_module,g_action);
}
/*赞助商js*/
function sponsor_sgin_sub(sponsor_id,sign_cost){
    var btn_list = new Array;
    btn_list[0] = new confirm_btn(msg_common_i18n.cancel,function(){alert_box_close();},'alert_wrong_btn mr_fr',false);
    if(sign_cost==0)
    {
            btn_list[1] = new confirm_btn(msg_common_i18n.m158,function(){sponsor_sgin(sponsor_id)},'alert_right_btn mr_fr',true);
            var tip = msg_common_i18n.t29;
    }else{
            btn_list[1] = new confirm_btn(msg_common_i18n.m122,function(){sponsor_sgin(sponsor_id)},'alert_right_btn mr_fr',true);
            var tip = msg_common_i18n.t30.str_supplant({cost_credits:sign_cost});
    }
    
    _confirm_box(tip,2,btn_list);
}
function sponsor_sgin(sponsor_id){
    ajax_handler('office','sponsor_sign',0,'sponsor_id='+sponsor_id,function(json){
            if (json.rstno==1){
                    $("#my_sponsor").load('?m=office&a=my_sponsor&format=html');
                    $("#office_sponsor_list").load('?m=office&a=sponsor_info&format=html',function(){
                        $(".use_hovertip").hovertip();
                    });
                    upd_i_header_info(json.header_info);
                    alert_box(msg_common_i18n.m161);
            }else{
                    alert_box(json.error);
        }
    });
}

function sponsor_cancel(sponsor_id){
    ajax_handler('office','sponsor_cancel',0,'sponsor_id='+sponsor_id,function(json){
        
        if (json.rstno==1){
            $("#my_sponsor").load('?m=office&a=my_sponsor&format=html');
            $("#office_sponsor_list").load('?m=office&a=sponsor_info&format=html',function(){
                $(".use_hovertip").hovertip();
            });
            alert_box(msg_common_i18n.m162);
        }else{
            alert_box(json.error);
        }
    });
}

function sponsor_get_money(sponsor_id){
    ajax_handler('office','sponsor_get_money',0,'sponsor_id='+sponsor_id,function(json){
            if (json.rstno==1){
                    $("#my_sponsor").load('?m=office&a=my_sponsor&format=html');
                    $("#office_sponsor_list").load('?m=office&a=sponsor_info&format=html',function(){
                        $(".use_hovertip").hovertip();
                    });
                    upd_i_header_info(json.header_info);
                    alert_box(json.error);
            }else{
                    alert_box(json.error);
        }
    });
}

function change_act(day){
	$("#open_game").load('?m=office&a=open_game&day='+day,function(){$(".use_hovertip").hovertip(); });
}

function open_lottery(){
    modless_box_open({url:'?m=act&a=lottery&obt_act_id=39',size:'xl'});
}

function stone_move_in_use(stone_typ,level){
    
    if (stone_list[stone_typ]!=undefined && stone_list[stone_typ][level]!=undefined){
        var flag = -1;
        for (var i = 0; i < max_count_of_stone; i++){
            if (stone_in_use[i].stone_typ==0){
                flag = i;
                stone_in_use[i].stone_typ=stone_typ;
                stone_in_use[i].stone_level=level;
                break;
            } 
        }
        if (flag==-1){
            alert(0);
            return;
        }
        
        stone_list[stone_typ][level]--;
        if (stone_list[stone_typ][level]<=0){
            $("#stone_list_"+stone_typ+"_"+level).addClass('hide');
        } else {
            $("#stone_list_lv_"+stone_typ+"_"+level).html(stone_list[stone_typ][level]);
        }
        
        $("#stone_in_use_"+flag).removeClass('skill_stone_0').addClass('skill_stone_'+stone_typ).html(
                '<div class="dark_stripe stone_padding">LV '+level+'</div>');
    } else {
        alert(1);
    }
    stone_recalc_skill_point();
}
function stone_move_off_use(id){
    if (stone_in_use[id].stone_typ!=0){
        stone_typ = stone_in_use[id].stone_typ;
        level = stone_in_use[id].stone_level;
        stone_in_use[id].stone_typ=0;
        stone_in_use[id].stone_level=0;
        $("#stone_in_use_"+id).removeClass().addClass('skill_stone_0').html('');
        if (stone_list[stone_typ]==undefined || stone_list[stone_typ][level]==undefined || stone_list[stone_typ][level]<=0){
            //$("#stone_list_"+stone_typ+"_"+level).remove();
            $("#stone_list_"+stone_typ+"_"+level).removeClass('hide');
            if (stone_list[stone_typ]==undefined){
                stone_list[stone_typ] = new Array();
            }
            stone_list[stone_typ][level] = 1;
        } else {                
            stone_list[stone_typ][level]++;
            
        }
        $("#stone_list_lv_"+stone_typ+"_"+level).html(stone_list[stone_typ][level]);
    } else {
        alert(1);
    }
    stone_recalc_skill_point();
}
function stone_recalc_skill_point(){
    player_point.skill_point_att_can_use=0;
    player_point.skill_point_org_can_use=0;
    player_point.skill_point_def_can_use=0;
    
    for (var i = 0; i < stone_in_use.length; i++){
        this_stone = stone_in_use[i];
        if (this_stone.stone_typ==1){
            player_point.skill_point_att_can_use += parseInt(this_stone.stone_level);
        } else if (this_stone.stone_typ==2){
            player_point.skill_point_org_can_use += parseInt(this_stone.stone_level);
        } else if (this_stone.stone_typ==3){
            player_point.skill_point_def_can_use += parseInt(this_stone.stone_level);
        } 
    }
    refresh_skill_point();
    
}
function refresh_skill_point(){
    $("#skill_point_att_can_use").html(player_point.skill_point_att_can_use);
    $("#skill_point_org_can_use").html(player_point.skill_point_org_can_use);
    $("#skill_point_def_can_use").html(player_point.skill_point_def_can_use);
    $("#skill_point_att").html(player_point.skill_point_att);
    $("#skill_point_org").html(player_point.skill_point_org);
    $("#skill_point_def").html(player_point.skill_point_def);
}
function stone_choose_mix(stone_typ,level){
	if (stone_list[stone_typ][level]!=undefined){
		if (stone_list[stone_typ][level]>=4 && (stone_typ!=select_info.stone_typ || level!=select_info.level)){
			//TODO
			stone_list[stone_typ][level]-=4;
			$("#stone_list_lv_"+stone_typ+"_"+level).html(stone_list[stone_typ][level]);
			if (select_info.stone_typ>0){
				stone_list[select_info.stone_typ][select_info.level]+=4;
				$("#stone_list_lv_"+select_info.stone_typ+"_"+select_info.level).html(stone_list[select_info.stone_typ][select_info.level]);
			}
			select_info.stone_typ=stone_typ;
			select_info.level=level;
			$("#select_stones li").removeClass().addClass('skill_stone_'+stone_typ);
			$(".stone_list_lv_target").html('LV '+level);
			
		} else {
			
		}
	}
}
function mix_this_stone(){
	if(select_info.stone_typ==0||select_info.level==0){
		alert_box("还没选您要合成的技能石！");
		return;
	}
	var url_plus= 'stone_typ='+select_info.stone_typ+'&level='+select_info.level;
	ajax_handler('shop','stone_combining',1,url_plus,function(json){
		if (json.rstno==1){
			$("#stone_mix").attr('in_showing',0);
			lightbox_tab_show('shop','stone_mix');
		}else{
			alert_box(json.error);
		}
	});
}
function add_skill(skill_id){
	if (skill_id==0){
		return;
	}
	if (player_skill_list[skill_id].skill_level==0 && skill_counter>=6){
		set_error('最多选择6个技能;');
		return;
	}
	if (config_skills_list[skill_id].skill_stage!=1){
		if (stage_counter[config_skills_list[skill_id].skill_stage-1]==undefined || stage_counter[config_skills_list[skill_id].skill_stage-1]==0){
			set_error('必须解锁上一级任意一个技能后才可解锁本级技能！');
			return;
		}
	}
	if (player_skill_list[skill_id].skill_level==10){
		return;
	}
	if (config_skills_list[skill_id].skill_typ==1){
		if (player_point.skill_point_att_can_use<=player_point.skill_point_att){
			set_error('点数不足');
			return;
		}
		player_point.skill_point_att++;
	} else if (config_skills_list[skill_id].skill_typ==2){
		if (player_point.skill_point_org_can_use<=player_point.skill_point_org){
			set_error('点数不足');
			return;
		}
		player_point.skill_point_org++;
	} else if (config_skills_list[skill_id].skill_typ==3){
		if (player_point.skill_point_def_can_use<=player_point.skill_point_def){
			set_error('点数不足');
			return;
		}
		player_point.skill_point_def++;
	}
	
	if (player_skill_list[skill_id].skill_level==0){
		$("#skill_list_"+skill_id).removeClass('gray_img');
		skill_counter++;
	}
	player_skill_list[skill_id].skill_level++;
	stage_counter[config_skills_list[skill_id].skill_stage]++;
	$("#skill_lv_"+skill_id).html(player_skill_list[skill_id].skill_level);
	refresh_skill_point();
}

function sub_skill(skill_id){
	if (skill_id==0 || player_skill_list[skill_id].skill_level<=0){
		return;
	}
	if (player_skill_list[skill_id].skill_level<=1 && stage_counter[config_skills_list[skill_id].skill_stage]<=1 && config_skills_list[skill_id].skill_stage!=4){
		//删除时检查更高级别的
		for (i=config_skills_list[skill_id].skill_stage+1;i<=4;i++){
			if (stage_counter[i]>0){
				set_error('当前层没有技能了，将无法学习下一层技能！');
				return;
			}
		}
	}
	if (config_skills_list[skill_id].skill_typ==1){
		
		player_point.skill_point_att--;
	} else if (config_skills_list[skill_id].skill_typ==2){
		
		player_point.skill_point_org--;
	} else if (config_skills_list[skill_id].skill_typ==3){
		
		player_point.skill_point_def--;
	}
	player_skill_list[skill_id].skill_level--;
	if (player_skill_list[skill_id].skill_level<=0){
		$("#skill_list_"+skill_id).addClass('gray_img');
		skill_counter--;
		stage_counter[config_skills_list[skill_id].skill_stage]--;
		
	}
	
	$("#skill_lv_"+skill_id).html(player_skill_list[skill_id].skill_level);
	refresh_skill_point();
}
function submit_all_player_skill(pid){
	var stone_pluses = [];
    var skill_pluses = [];
    //if(on_show_typ=='stone_set'){
        for (var i = 0; i < stone_in_use.length; i++){
            this_stone = stone_in_use[i];
            if (this_stone.stone_typ>0){
                stone_pluses.push(this_stone.stone_typ+':'+this_stone.stone_level);
            }            
        }
    //}else if(on_show_typ=='skill_set'){
	
        $.each(player_skill_list,function(index, value){
            if (value.skill_level>0){
                skill_pluses.push(index+':'+value.skill_level);
            }
        });
    //}
	
	var plus='pid='+pid+'&stone='+stone_pluses.join('|')+'&skill='+skill_pluses.join('|');
    var obj = $('#submit_all_player_skill');
    $(obj).parent().block();
	ajax_handler('player','set_skill',1,plus,function(json){
		my_players_cache[pid]='';
        $(obj).parent().unblock();
	},function(){
        $(obj).parent().unblock();
    });
}

function tier_get_pos(tier_id){
	if(newbie_stat==1){
	    plus = 'tier_id='+tier_id;
	    ajax_handler('match','tier_get_pos',0,plus,function(json){    
	    	if(json.rstno==1)
	        {                
                sync_exp_money();
                show_tier(tier_id);
                $('#tier_get_pos_'+tier_id).html(json.error);
                $('#tier_get_pos_'+tier_id).removeClass('tier_none');
                $('#tier_get_pos_'+tier_id).addClass('bold_center color_red');
                $("#my_tier_info").load('?m=match&a=my_tier_info&format=html');
                if(json.need_refresh_task==1){
                    upd_task_list();
                }
	        }else{
                    alert_box(json.error);
                }
	    });
	}else{
	    alert_box(msg_newbie_i18n.newbie_first);
	}
}

function tier_give_up(tier_today_holding_id){
	if(newbie_stat==1){
	    plus = 'tier_id='+tier_today_holding_id+'&typ=1';
	    ajax_handler('match','tier_give_up',0,plus,function(json){       
	        if(json.rstno==1 || json.rstno==2)
	        {
                    show_tier(tier_today_holding_id);
                    $("#my_tier_info").load('?m=match&a=my_tier_info&format=html');
                    if (json.rstno==2){
                        alert_box(msg_common_i18n.tier2);    
                    } else {
                        alert_box(msg_common_i18n.tier1);    
                    }
                    $('#tier_get_pos_'+tier_today_holding_id).removeClass('color_red');
                    $('#tier_get_pos_'+tier_today_holding_id).addClass('tier_none');
                    $('#tier_get_pos_'+tier_today_holding_id).html(msg_common_i18n.nobody);
		}else{
		    alert_box(json.error);
		}
	    });
	}else{
	    alert_box(msg_newbie_i18n.newbie_first);
	}
}
function tier_skip_level(tier_id,tier_today_index){
	if(newbie_stat==1){
	    plus = 'tier_id='+tier_id;
	    coin = (tier_id-tier_today_index)*3000;
	    confirm_box(msg_common_i18n.t5.str_supplant({coin:coin}),function(){
                ajax_handler('match','tier_skip',0,plus,function(json){    
                    if(json.rstno==1)
                    {
                        show_tier(tier_id);
                        $("#my_tier_info").load('?m=match&a=my_tier_info&format=html');
                        sync_exp_money();
                    }else{
                        alert_box(json.error);
                    }
                });
	    });
	}else{
	    alert_box(msg_newbie_i18n.newbie_first);
	}
}

function show_tier(tier_id){ 
	$('#tier_list .opt_tier').addClass('disabled');
	$('#tier_'+tier_id).removeClass('disabled'); 
    $("#tier_info").html(refresh_loading_img('modless')).load('?m=match&a=tier_info&format=html&tier_id='+tier_id);
}

function start_tier_match(tier_id,typ){
    if(newbie_stat==1){
        //if(matchbox_flash_loading){
        //    alert_box('载入中，请稍后挑战！');
        //    return;
        //}
        plus = 'tier_id='+tier_id+'&typ='+typ;
        ajax_handler('match','begin_tier_match',0,plus,function(json){
            upd_energy_bar(json.new_energy);
            matchbox_open(json.mid);
        });
    }else{
        alert_box(msg_newbie_i18n.newbie_first);
    }
}
