<!DOCTYPE html>
<html lang="en">
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>TEST</title>
	
<script type="text/javascript" src="js/swfobject.js"></script>
<script type="text/javascript" src="js/web_socket.js"></script>
<script type="text/javascript" src="js/jquery-2.1.0.min.js"></script>
<script type="text/javascript" src="js/lib.js"></script>
<script type="text/javascript" src="js/test.js"></script>

<style type="text/css" media="screen">
	body {
		font-size: 12px;
		word-wrap:break-word; 
	}	
	.red {
		color:#FF0000;
	}
	
	.clear{
		clear:both;
	}
</style>
</head>
<body style="background:#EEE;">
<div>
	<div id="userInfo"></div>
</div>
<div class="clear">
</div>

<div>
	<div id="send" style="width:28%;float:left;margin:10px;border:1px solid #DDD;padding:10px;">

	<h2>req</h2>
	<a href="javascript:void(0);" onclick="demo_req_get({m:'user',a:'getAttr'})">getAttr</a>
	</div>
	<div id="recv" style="width:28%;float:left;margin:10px;border:1px solid #DDD;padding:10px;">
	<h2>RECV</h2>
	</div>
	<div id="console" style="width:28%;float:right;margin:10px;border:1px solid #DDD;padding:10px;">
	<h2>INFO</h2>
	</div>
</div>

</body>
</html>