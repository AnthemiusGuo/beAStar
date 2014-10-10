/*
 * Copyright (c) 2009 Cameron Zemek
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */
var TipAutoHideID = 0;
(function($) {
    function hovertip(elem, conf) {
	
	
	
	var flag = 0;
	
        function setPosition(posX, posY) {
            g_tool_tip.css({ left: posX, top: posY });
        }

        function updatePosition(event,hover_typ) {
            var tooltipWidth = g_tool_tip.outerWidth();
            var tooltipHeight = g_tool_tip.outerHeight();
            var $window = $(window);
			//tooltip.attr('outerwidth',tooltipWidth).attr('width',tooltip.width());
            var windowWidth = $window.width() + $window.scrollLeft();
            var windowHeight = $window.height() + $window.scrollTop();
	    //var posX = event.pageX;
	    //var posY = event.pageY+ conf.offset[1];;
            //var posX = elem.offset().left+elem.width()/2;
            //var posY = elem.offset().top +elem.height()+ conf.offset[1];
	    
	    //conf.hover_typ: 1上2右3下4左
	    //先修正最右边的朝左
	    if ((windowWidth - elem.offset().left -elem.width() < tooltipWidth+conf.offset[0]) && hover_typ==2){
			hover_typ=4;
			flag = 1;
	    }
	    
	    if (hover_typ==1){
		var posX = elem.offset().left+elem.width()/2 - tooltipWidth/2;
		var posY = elem.offset().top -  conf.offset[1] - tooltipHeight;
	    } else if (hover_typ==2){
		
		if (elem.width()<100){
		    var posX = elem.offset().left + elem.width() + 20 + conf.offset[0];
		} else {
		    var posX = elem.offset().left + elem.width() + conf.offset[0];
		}
		
		var posY = elem.offset().top  + elem.height()/2- tooltipHeight/2;
	    } else if (hover_typ==3){
		var posX = elem.offset().left+elem.width()/2 - tooltipWidth/2;
		var posY = elem.offset().top + elem.height() +  conf.offset[1];
	    } else if (hover_typ==4){
			if (flag == 1){
				var posX = elem.offset().left - tooltipWidth - conf.offset[0];//x轴20120806修改
				var posY = elem.offset().top + elem.height()/2- tooltipHeight/2;//Y轴20120806修改
			}else{
				var posX = elem.offset().left - tooltipWidth - conf.offset[0]-20;//x轴20120806修改
				var posY = elem.offset().top + elem.height()/2- tooltipHeight/2;//Y轴20120806修改
			}
	    } 
	    
            if (posX > windowWidth) {
                posX = windowWidth - tooltipWidth;
            }
            
	    if (posY <0){
		posY = elem.offset().top +elem.height() +  conf.offset[1];
	    }
	    if (posY + tooltipHeight > windowHeight) {
                // Move tooltip to above cursor
                posY = elem.offset().top - tooltipHeight;
            }
            setPosition(posX, posY);
	    return hover_typ;
        }
		
	function updateContent(elem) {
	    if (elem.attr('tooltip_id')!=undefined && elem.attr('tooltip_id')!=''){
		g_tooltip_content.html($(elem.attr('tooltip_id')).html());
	    } else {
		g_tooltip_content.html(elem.attr('tooltip'));
	    }	    
	}
	
	function updateCont(special) {
		g_tooltip_content.html($(special).html());
	}
	function updateContentBack(elem) {
		g_tooltip_content.html('');
	}
        elem.hover(
            // Show
            function(event) {		
		if (elem.attr('hover_typ')!=undefined && elem.attr('tooltip_id')!=''){
		    hover_typ = parseInt(elem.attr('hover_typ'));
		    if (hover_typ == 0){
			hover_typ = conf.hover_typ;
		    } 
		} else {
		    hover_typ = conf.hover_typ;
		}
		if (conf.special==''){
			updateContent(elem);
		} else {
			updateCont(conf.special);
		}
		hover_typ = updatePosition(event,hover_typ);
		
		conf.show(g_tool_tip);
		tooltip_arrow.hide();
		tooltip_arrows[hover_typ].show();
		if (TipAutoHideID>0){
			clearTimeout(TipAutoHideID);
			TipAutoHideID = 0;
		}
		TipAutoHideID = setTimeout("g_tool_tip.hide()",10000);
            },
            // Hide
            function() {
		updateContentBack(elem);
                conf.hide(g_tool_tip);
		if (TipAutoHideID>0){
			clearTimeout(TipAutoHideID);
			TipAutoHideID = 0;
		}
            }
        );
    }

    $.fn.hovertip = function(conf) {
        var defaultConf = {
            offset: [10, 10],
            className: 'hovertip',
	    special:'',
            show: function(tooltip) {
                tooltip.show();		
            },
            hide: function(tooltip) {
                tooltip.hide();
            },
	    hover_typ: 1
        };
		
        $.extend(defaultConf, conf);
        if (g_tool_tip!=undefined){
            g_tool_tip.hide();
        }
		
        this.each(function() {
            var el = new hovertip($(this), defaultConf);
            $(this).data("hovertip", el);
        });
    }
})(jQuery);
