<div class="row-fluid">
    <h2>短消息发送</h2>
    <div>
		消息uid: <input type="text" name="user_uid" id="user_uid" value="<?=$user_uid?>"/> <a href="javascript:void(0)" class="btn" onclick="search_user()">搜索短消息</a> *发送多个uid请逗号分隔<br/>
                  消息类型:<input type="text" name="typ" id="typ" value="1"/> *0普通,1验证码<br/>
                特殊内容:<input type="text" name="special_content" id="special_content" value=""/> *用于传递验证码等特殊参数<br/>
                消息内容:<textarea name="msg_content" id="msg_content"></textarea><br/>
        <a href="javascript:void(0)" class="btn" onclick="send_msg()">发送</a>
    </div>
    <div>
    <? 
    if($user_uid !=0){
        var_dump($msg_list);
    }
    ?>
    </div>
</div>
<script>
function search_user(){
	var user_uid = $("#user_uid").val();
    goto_page('msg','index','user_uid='+user_uid);
}
function send_msg(){
	var user_uid = $("#user_uid").val();
	var typ = $("#typ").val();
	var special_content = $("#special_content").val();
	var msg_content = $("#msg_content").val();
	if(msg_content =='' || user_uid =='')
	{
		alert('发送uid或消息内容不能为空!');
		return;
	}
    var url = '?sub_sys=cp&m=msg&a=send_msg&h=1&user_uid='+user_uid+'&typ='+typ+'&special_content='+special_content+'&msg_content='+msg_content;
    $.getJSON(url,function(json) {
    	if(json.rstno>=1){
    		alert("发送成功!");
    		goto_page('msg','index','user_uid='+user_uid);
        }else{
            alert(json.error);
        }
    });
}
</script>