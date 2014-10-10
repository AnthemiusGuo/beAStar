//kaz function version 0.9
/**
* rid 资源id 
* uid 用户id 
* act 自定义的网页行为
* ver 分区id，如果等于undefined或者null表示没有分区
* domain 主域名，如果没有分区可以不写
* 页游分服 kingnetaz(1015001,300,'index',32,'appxxxxxx.qqopenapp.com');
* 社区游戏不分服 kingnetaz(1015001,300,'index');
*
*/
function kingnetaz(rid,uid,act,ver,domain){
	old_uid = uid;
	uid = uid+"";
	uid = uid.replace(/_/g, '－');
	if(act==undefined){
		act='index';
	}
	if(ver==undefined&&ver==null){
		ver=0;
	}
	var kaz_uid = rid+'_'+uid;
	var kaz_ed=new Date();
	var kaz_now=parseInt(kaz_ed.getTime());
	var kaz_ref=document.referrer;
	if (navigator.appName == 'Netscape')
		var language = navigator.language;
	else
		var language = navigator.browserLanguage;
	var kaz_data='&refer='+escape(kaz_ref.substr(0,512))+'&lg='+escape(language);

	//按照用户id
	var kaz_rt=parseInt(gc_kaz("rtime",rid,uid));
	var kaz_lt=parseInt(gc_kaz("ltime",rid,uid));

	if(kaz_lt<1000000){kaz_rt=0;kaz_lt=0;}
	if(kaz_rt<1) kaz_rt=0;
	if(((kaz_now-kaz_lt)>1000*86400/24)&&(kaz_lt>0)) kaz_rt++;
	
	if(ver!=0){
		//按照分区id
		var kaz_ver_rt=parseInt(gc_kaz("rtime",rid,uid,ver));
		var kaz_ver_lt=parseInt(gc_kaz("ltime",rid,uid,ver));
		if(kaz_ver_lt<1000000){kaz_ver_rt=0;kaz_ver_lt=0;}
		if(kaz_ver_rt<1) kaz_ver_rt=0;
		if(((kaz_now-kaz_ver_lt)>1000*86400/24)&&(kaz_ver_lt>0)) kaz_ver_rt++;
		
	}else{
		kaz_ver_rt = 0;
	}
	
	var flashver = get_flash_ver();
	kaz_data=kaz_data+'&rtime='+kaz_rt+'&verrtime='+kaz_ver_rt+'&fenbianlv='+escape(screen.width+'x'+screen.height)+'&flashver='+flashver;

	var img = new Image();
	img.src = 'http://zz.kingnet.com/fenxi.gif?rid='+rid+'&uid='+old_uid+'&ver='+ver+'&act='+act+kaz_data +'&rand='+Math.random();
	
	var kaz_et=(86400-kaz_ed.getHours()*3600-kaz_ed.getMinutes()*60-kaz_ed.getSeconds());
	//kaz_ed.setTime(kaz_now+1000*(kaz_et-kaz_ed.getTimezoneOffset()*60));
	//document.cookie="kaz_"+rid+uid+'='+kaz_a+";expires="+kaz_ed.toGMTString()+ "; path=/";
	kaz_ed.setTime(kaz_now+1000*86400*182);
	
	cookie_doamin = '';
	if(domain!=undefined && domain!=null && domain!=''){
		cookie_doamin = ";domain="+domain;
	}
	document.cookie="kaz_rtime"+'-'+rid+'-'+uid+'='+kaz_rt+";expires="+kaz_ed.toGMTString()+ ";path=/" + cookie_doamin;
	document.cookie="kaz_ltime"+'-'+rid+'-'+uid+'='+kaz_now+";expires=" + kaz_ed.toGMTString()+ ";path=/" + cookie_doamin;
	
	if(ver!=0){
		document.cookie="kaz_rtime"+'-'+rid+'-'+uid+'-'+ver+'='+kaz_ver_rt+";expires="+kaz_ed.toGMTString()+ ";path=/";
		document.cookie="kaz_ltime"+'-'+rid+'-'+uid+'-'+ver+'='+kaz_now+";expires=" + kaz_ed.toGMTString()+ ";path=/";
	}
	
	
}

function gv_kaz(of){
	var es = document.cookie.indexOf(";",of);
	if(es==-1) es=document.cookie.length;
	return unescape(document.cookie.substring(of,es));
}
function gc_kaz(n,rid,uid,ver){
	//var arg=n+"=";
	var arg='';
	if(ver==undefined){
		arg='kaz_'+n+'-'+rid+'-'+uid+'=';
	}else{
		arg='kaz_'+n+'-'+rid+'-'+uid+'-'+ver+'=';
	}
	
	var alen=arg.length;
	var clen=document.cookie.length;
	var i=0;
	while(i<clen){
	var j=i+alen;
	if(document.cookie.substring(i,j)==arg) return gv_kaz(j);
	i=document.cookie.indexOf(" ",i)+1;
	if(i==0)	break;
	}
	return -1;
}
function get_flash_ver(){
	var UNDEF = "undefined",
		OBJECT = "object",
		SHOCKWAVE_FLASH = "Shockwave Flash",
		SHOCKWAVE_FLASH_AX = "ShockwaveFlash.ShockwaveFlash",
		FLASH_MIME_TYPE = "application/x-shockwave-flash",
		EXPRESS_INSTALL_ID = "SWFObjectExprInst",
		ON_READY_STATE_CHANGE = "onreadystatechange",

		win = window,
		doc = document,
		nav = navigator;

		p = nav.platform.toLowerCase(),
		windows = p ? /win/.test(p) : /win/.test(u),
		mac = p ? /mac/.test(p) : /mac/.test(u),
		playerVersion = [0,0,0];

	if (typeof nav.plugins != UNDEF && typeof nav.plugins[SHOCKWAVE_FLASH] == OBJECT) {
		d = nav.plugins[SHOCKWAVE_FLASH].description;
		if (d && !(typeof nav.mimeTypes != UNDEF && nav.mimeTypes[FLASH_MIME_TYPE] && !nav.mimeTypes[FLASH_MIME_TYPE].enabledPlugin)) { // navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin indicates whether plug-ins are enabled or disabled in Safari 3+
			plugin = true;
			ie = false; // cascaded feature detection for Internet Explorer
			d = d.replace(/^.*\s+(\S+\s+\S+$)/, "$1");
			playerVersion[0] = parseInt(d.replace(/^(.*)\..*$/, "$1"), 10);
			playerVersion[1] = parseInt(d.replace(/^.*\.(.*)\s.*$/, "$1"), 10);
			playerVersion[2] = /[a-zA-Z]/.test(d) ? parseInt(d.replace(/^.*[a-zA-Z]+(.*)$/, "$1"), 10) : 0;
		}
	}
	else if (typeof win.ActiveXObject != UNDEF) {
		try {
			var a = new ActiveXObject(SHOCKWAVE_FLASH_AX);
			if (a) { // a will return null when ActiveX is disabled
				d = a.GetVariable("$version");
				if (d) {
					ie = true; // cascaded feature detection for Internet Explorer
					d = d.split(" ")[1].split(",");
					playerVersion = [parseInt(d[0], 10), parseInt(d[1], 10), parseInt(d[2], 10)];
				}
			}
		}
		catch(e) {}
	}

	var flash_pl = windows ? "WIN" : (mac ? "MAC" : "UNKNOWN");
	return escape(flash_pl+' ')+playerVersion[0]+','+playerVersion[1]+','+playerVersion[2];
}