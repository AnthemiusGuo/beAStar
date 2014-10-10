<?php

$ubbcodes = array(
	'pcodecount' => -1,
	'codecount' => 0,
	'codehtml' => '',
	'searcharray' => array(),
	'replacearray' => array(),
);

mt_srand((double)microtime() * 1000000);

function parsetable($width, $bgcolor, $message) {
	if(!in_array(substr($message, 0, 4), array('[tr]', '<tr>'))) {
		return $message;
	}
	$width = substr($width, -1) == '%' ? (substr($width, 0, -1) <= 98 ? $width : '98%') : ($width <= 560 ? $width : '98%');
	return '<table cellspacing="0" '.
		($width == '' ? NULL : 'width="'.$width.'" ').
		'align="center" class="t_table"'.($bgcolor ? ' style="background: '.$bgcolor.'">' : '>').
		str_replace('\\"', '"', preg_replace(array(
				"/\[tr(?:=([\(\)%,#\w]+))?\]\s*\[td(?:=(\d{1,2}),(\d{1,2})(?:,(\d{1,4}%?))?)?\]/ie",
				"/\[\/td\]\s*\[td(?:=(\d{1,2}),(\d{1,2})(?:,(\d{1,4}%?))?)?\]/ie",
				"/\[\/td\]\s*\[\/tr\]/i"
			), array(
				"parsetrtd('\\1', '\\2', '\\3', '\\4')",
				"parsetrtd('td', '\\1', '\\2', '\\3')",
				'</td></tr>'
			), $message)
		).'</table>';
}

function parsetrtd($bgcolor, $colspan, $rowspan, $width) {
	return ($bgcolor == 'td' ? '</td>' : '<tr'.($bgcolor ? ' style="background: '.$bgcolor.'"' : '').'>').'<td'.($colspan > 1 ? ' colspan="'.$colspan.'"' : '').($rowspan > 1 ? ' rowspan="'.$rowspan.'"' : '').($width ? ' width="'.$width.'"' : '').'>';
}

function ubbcode($message, $htmlon = 0, $allowimgcode = 0, $allowhtml = 0, $allowflash = 0) {
	global $ubbcodes;
	if ($allowhtml==0) {
		$message = strip_tags($message);
	}
		if(empty($ubbcodes['searcharray'])) {
			$ubbcodes['searcharray']['bbcode_regexp'] = array(
				"/\[url\]\s*(www.|https?:\/\/|ftp:\/\/|gopher:\/\/|news:\/\/|telnet:\/\/|rtsp:\/\/|mms:\/\/|callto:\/\/|bctp:\/\/|ed2k:\/\/|thunder:\/\/|synacast:\/\/){1}([^\[\"']+?)\s*\[\/url\]/ie",
				"/\[url=www.([^\[\"']+?)\](.+?)\[\/url\]/is",
				"/\[url=(https?|ftp|gopher|news|telnet|rtsp|mms|callto|bctp|ed2k){1}:\/\/([^\[\"']+?)\](.+?)\[\/url\]/is",
				"/\[email\]\s*([a-z0-9\-_.+]+)@([a-z0-9\-_]+[.][a-z0-9\-_.]+)\s*\[\/email\]/i",
				"/\[email=([a-z0-9\-_.+]+)@([a-z0-9\-_]+[.][a-z0-9\-_.]+)\](.+?)\[\/email\]/is",
				"/\[color=([#\w]+?)\]/i",
				"/\[size=(\d+?)\]/i",
				"/\[size=(\d+(\.\d+)?(px|pt|in|cm|mm|pc|em|ex|%)+?)\]/i",
				"/\[font=([^\[\<]+?)\]/i",
				"/\[align=(left|center|right)\]/i",
				"/\[float=(left|right)\]/i"
			);
			$ubbcodes['replacearray']['bbcode_regexp'] = array(
				"cuturl('\\1\\2')",
				"<a href=\"http://www.\\1\" target=\"_blank\">\\2</a>",
				"<a href=\"\\1://\\2\" target=\"_blank\">\\3</a>",
				"<a href=\"mailto:\\1@\\2\">\\1@\\2</a>",
				"<a href=\"mailto:\\1@\\2\">\\3</a>",
				"<font style=\"color:\\1\">",
				"<font size=\"\\1\">",
				"<font style=\"font-size: \\1\">",
				"<font face=\"\\1 \">",
				"<p align=\"\\1\">",
				"<br style=\"clear: both\"><span style=\"float: \\1;\">"
			);

			$ubbcodes['searcharray']['bbcode_regexp'][] = "/\[table(?:=(\d{1,4}%?)(?:,([\(\)%,#\w ]+))?)?\]\s*(.+?)\s*\[\/table\]/ies";
			$ubbcodes['replacearray']['bbcode_regexp'][] = "parsetable('\\1', '\\2', '\\3')";
			$ubbcodes['searcharray']['bbcode_regexp'][] = "/\[table(?:=(\d{1,4}%?)(?:,([\(\)%,#\w ]+))?)?\]\s*(.+?)\s*\[\/table\]/ies";
			$ubbcodes['replacearray']['bbcode_regexp'][] = "parsetable('\\1', '\\2', '\\3')";

				$ubbcodes['searcharray']['bbcode_regexp'][] = "/\s*\[quote\][\n\r]*(.+?)[\n\r]*\[\/quote\]\s*/is";
				$ubbcodes['searcharray']['bbcode_regexp'][] = "/\s*\[free\][\n\r]*(.+?)[\n\r]*\[\/free\]\s*/is";
				$ubbcodes['replacearray']['bbcode_regexp'][] = "<br><br><div class=\"msgbody\"><div class=\"msgheader\">QUOTE:</div><div class=\"msgborder\">\\1</div></div><br>";
				$ubbcodes['replacearray']['bbcode_regexp'][] = "<br><br><div class=\"msgbody\"><div class=\"msgheader\">FREE:</div><div class=\"msgborder\">\\1</div></div><br>";
			

			$ubbcodes['searcharray']['bbcode_regexp'] = array_merge($ubbcodes['searcharray']['bbcode_regexp'], $ubbcodes['searcharray']['bbcode_regexp']);
			$ubbcodes['replacearray']['bbcode_regexp'] = array_merge($ubbcodes['replacearray']['bbcode_regexp'], $ubbcodes['replacearray']['bbcode_regexp']);

			$ubbcodes['searcharray']['bbcode_str'] = array(
				'[/color]', '[/size]', '[/font]', '[/align]', '[b]', '[/b]',
				'[i]', '[/i]', '[u]', '[/u]', '[list]', '[list=1]', '[list=a]',
				'[list=A]', '[*]', '[/list]', '[indent]', '[/indent]', '[/float]'
			);

			$ubbcodes['replacearray']['bbcode_str'] = array(
				'</font>', '</font>', '</font>', '</p>', '<b>', '</b>', '<i>',
				'</i>', '<u>', '</u>', '<ul>', '<ul type=1>', '<ul type=a>',
				'<ul type=A>', '<li>', '</ul>', '<blockquote>', '</blockquote>', '</span>'
			);
		}

		@$message = str_replace($ubbcodes['searcharray']['bbcode_str'], $ubbcodes['replacearray']['bbcode_str'],
				preg_replace(
					$ubbcodes['searcharray']['bbcode_regexp'],
					$ubbcodes['replacearray']['bbcode_regexp'],
					$message));

		$message = preg_replace(array(
					($allowflash == 1 ? "/\[swf\]\s*([^\[\<\r\n]+?)\s*\[\/swf\]/ies" : "//"),
					"/\[img\]\s*([^\[\<\r\n]+?)\s*\[\/img\]/ies",
					"/\[img=(\d{1,4})[x|\,](\d{1,4})\]\s*([^\[\<\r\n]+?)\s*\[\/img\]/ies"
				), $allowimgcode ? array(
					($allowflash == 1 ? "bbcodeurl('\\1', ' <img src=\"images/attachicons/flash.gif\" align=\"absmiddle\" alt=\"\" /> <a href=\"%s\" target=\"_blank\">Flash: %s</a> ')" : ""),
					"bbcodeurl('\\1', '<img src=\"%s\" border=\"0\" onload=\"if(this.width>screen.width*0.7) {this.resized=true; this.width=screen.width*0.7; this.alt=\'Click here to open new window\\nCTRL+Mouse wheel to zoom in/out\';}\" onmouseover=\"if(this.width>screen.width*0.7) {this.resized=true; this.width=screen.width*0.7; this.style.cursor=\'hand\'; this.alt=\'Click here to open new window\\nCTRL+Mouse wheel to zoom in/out\';}\" onclick=\"if(!this.resized) {return true;} else {window.open(this.src);}\" onmousewheel=\"return imgzoom(this);\" alt=\"\" />')",
					"bbcodeurl('\\3', '<img width=\"\\1\" height=\"\\2\" src=\"%s\" border=\"0\" alt=\"\" />')"
				) : array(
					($allowflash == 1 ? "bbcodeurl('\\1', ' <img src=\"images/attachicons/flash.gif\" align=\"absmiddle\" alt=\"\" /> <a href=\"%s\" target=\"_blank\">Flash: %s</a> ')" : ""),
					"bbcodeurl('\\1', '<a href=\"%s\" target=\"_blank\">%s</a>')",
					"bbcodeurl('\\3', '<a href=\"%s\" target=\"_blank\">%s</a>')"
				), $message);

	for($i = 0; $i <= $ubbcodes['pcodecount']; $i++) {
		$message = str_replace("[\tubb_CODE_$i\t]", $ubbcodes['codehtml'][$i], $message);
	}

	return $htmlon || $allowhtml ? $message : nl2br(str_replace(array("\t", '   ', '  '), array('&nbsp; &nbsp; &nbsp; &nbsp; ', '&nbsp; &nbsp;', '&nbsp;&nbsp;'), $message));
}

function cuturl($url) {
	$length = 65;
	$urllink = "<a href=\"".(substr(strtolower($url), 0, 4) == 'www.' ? "http://$url" : $url).'" target="_blank">';
	if(strlen($url) > $length) {
		$url = substr($url, 0, intval($length * 0.5)).' ... '.substr($url, - intval($length * 0.3));
	}
	$urllink .= $url.'</a>';
	return $urllink;
}

function bbcodeurl($url, $tags) {
	if(!preg_match("/<.+?>/s", $url)) {
		if(!in_array(strtolower(substr($url, 0, 6)), array('http:/', 'https:', 'ftp://', 'rtsp:/', 'mms://'))) {
			$url = 'http://'.$url;
		}
		return str_replace(array('submit', 'logging.php'), array('', ''), sprintf($tags, $url, addslashes($url)));
	} else {
		return '&nbsp;'.$url;
	}
}

function format_description($desc, $line_limit)
{
	$result = '';
	$i = 0;
	$sum = mb_strlen($desc);
	while( $sum>0 )
	{
		$result .='<p>'.mb_substr($desc,$i,$line_limit).'</p>'."\r\n";
		$i += $line_limit;
		$sum -= $line_limit;
	}

	return $result;
}
?>