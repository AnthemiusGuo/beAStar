//slider usage
(function(){
	function slider_use(elem,conf){
		var p = elem.parent();
		var t_lng = parseInt(elem.height()),u_lng = 0;
		var p_lng = parseInt(p.innerHeight())-2;
		var p_p = p.css('position');
		var num = conf.num;
		
		if(conf.reload!=0){
			var elem_top = parseFloat(elem.css('top'));
			var new_value = num+parseInt(num*elem_top/t_lng);
			//elem.children('.slider_line').find('.ui-slider-vertical').slider( "value",new_value);
			elem.data('value',new_value);
		}
		if (conf.goto_max){
			var new_value = 0;
		}
		function _init(){
			if(elem.children('.slider_line').find('.ui-slider-vertical').length==0){
				elem.data('scroll',0).data('value',num);
				(p_p == 'relative'||p_p == 'absolute')?p.css('position',p_p):p.css('position','relative');
			}
			add_sliderbar();
			elem.children('.slider_line').find('.ui-slider-vertical').slider({
				animate: false,
				orientation: 'vertical',
				value:new_value||num,
				max:num,
				min:0,
				step:1,
				change: function(event,ui){
					changeScrollbar(event,ui);
				},
				slide: function(event, ui) {
					changeScrollbar(event,ui);
				}
			})
			if (conf.goto_max){
				elem.children('.slider_line').find('.ui-slider-vertical').slider( "option", "value", 0);
			}
		}
		function check_lng(){
			//my_debug(t_lng);
			//my_debug(p_lng);
			return (t_lng>p_lng)?1:0;
		}
		function changeScrollbar(event,ui){
			var sl = elem.children('.slider_line');
			elem.css('top',(ui.value-num)/num*t_lng);
			elem.data('value',ui.value).attr('value',ui.value);
			sl.css('top',-parseFloat(elem.css('top')));
			sl.find('.ui-slider-handle').addClass('slider_hover');
		}
		function add_sliderbar(){
			if(check_lng()){
				if((elem.children('.slider_line').length==0&&elem.children('.slider_line').find('.ui-slider-vertical').length==0)){
					elem.append(conf.insert_div);
				}else{
					elem.children('.slider_line').replaceWith(conf.insert_div);
				}
				elem.css({width:p.innerWidth()-10,paddingRight:'10px'});
				u_lng = parseInt(p_lng/t_lng*p_lng);
				var sl = elem.children('.slider_line');
				sl.find('.ui-slider-handle').css({height:u_lng,marginBottom:-parseFloat(u_lng/2)+'px'});
				sl.find('.ui-slider-vertical').height(p_lng-u_lng).css('margin-top',parseFloat(u_lng/2)+'px');
				if(conf.reload!=0 && conf.reload==1){
					elem.children('.slider_line').css('top',-parseFloat(elem.css('top')));
					conf.reload++;
				}
				
				t_lng = t_lng-p_lng;
			}else{
				t_lng = 0;
			}
			elem.children('.slider_line').height(p_lng);
			if(conf.table){
				var tbody = p.find('table'),
					thead = p.prev('table'),
					th_num = thead.find('th').length,col=new Array(),col_append1='<colgroup>',col_append2='';
				for(var i=1;i<=th_num;i++){
					var a = thead.find('th:nth-child('+i+')').innerWidth();
						b = tbody.find('td:nth-child('+i+')').innerWidth();
					var c = (a>b?a:b);
					if(i==th_num){
						col_append1 += '<col width="'+(c+14)+'px"></col>';
					}else{
						col_append1 += '<col width="'+c+'px"></col>';
					}
					col_append2 += '<col width="'+c+'px"></col>';
				}
				col_append1 += '</colgroup>';
				col_append2 += '</colgroup>';
				thead.prepend(col_append1);
				tbody.prepend(col_append2);
			}
		}
		_init();
		
		elem.mouseover(function(e){
			elem.data('scroll',1);
			e.stopPropagation();
			if(newbie_stat!=0){
				if(document.addEventListener){
					document.addEventListener('DOMMouseScroll',scrollFunc,false);
				}
				window.onmousewheel = document.onmousewheel = scrollFunc;
			}
		}).mouseout(function(e){
			elem.children('.slider_line').find('.ui-slider-handle').removeClass('slider_hover');
			elem.data('scroll',0);
			e.stopPropagation();
		});
		var scrollFunc=function(e){
			e = e||window.event;
			var _value = elem.data('value');
			function changeScrollMouse(op){
				(op==1)?(++_value):(--_value);
				elem.children('.slider_line').find('.ui-slider-vertical').slider("value",_value);
				elem.data('value',_value);//alert(elem.data('value'));
			}
			if(elem.data('scroll')==1&&elem.children('.slider_line').find('.ui-slider-vertical').length!=0){
				var changed_num = elem.height()-p_lng;
				var current_top = parseFloat(elem.css('top'));
				if(changed_num>0){
					var current_top = parseFloat(elem.css('top'));
					if(e.wheelDelta||e.detail){//IE/Opera/Chrome
						if(e.wheelDelta<0 || e.detail>0){//mouse down
							if(current_top<=0&&current_top>-changed_num){
								if($.browser.msie){
									e.returnValue=false;
								}else{
									e.preventDefault();
									e.stopPropagation();
								}
								changeScrollMouse(2);
							}
						}else if(e.wheelDelta>0 ||e.detail<0){//mouse up
							if(current_top<0){
								if($.browser.msie){
									e.returnValue=false;
								}else{
									e.preventDefault();
									e.stopPropagation();
								}
								changeScrollMouse(1);
							}
						}
					}
				}
			}else{
				return;
			}
		}
		
		
	}
	$.fn.slider_use = function(conf){
		var defaultConf = {
			reload:0,
			num:50,
			table:false,
			prevent:false,
			goto_max:false,
			insert_div :'<div class="slider_line"><div class="ui-slider-vertical"><a class="ui-slider-handle"><span class="slider_mid"></span></a></div></div>'
		};
		$.extend(defaultConf, conf);
		this.each(function(){
			if ($.browser.webkit){
				var p = $(this).parent();
				p.css('overflow-y','auto');
				if (defaultConf.goto_max){
					p.scrollTop($(this).height());
				}
			} else {
				var su = new slider_use($(this),defaultConf);
				$(this).data('slider_use',su);
			}
			
		})
	}
})(jQuery);