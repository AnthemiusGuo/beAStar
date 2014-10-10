var group_chat={};
var private_chat={};
var world_chat={};
var connected = 0;
//chat_typ: 私聊 :1;群聊:2;全服:3
function chat_window_list(chat_typ,chat_id){
    this.chat_typ = chat_typ;
    this.chat_id = chat_id;
    this.opened = 0;
    this.chat_div_obj = null;
    this.last_msg_timestamp = 0;//=new date().xxx/1000;
    this.title = '';//对方的名字，或者工会名
}

chat_window_list.prototype.open = function(){
    //widget open
    if(this.chat_typ==1){
        if(private_chat_widget_opened[this.chat_id]==1){
            this.chat_div_obj = $("#chat_widget_content_"+this.chat_id);
            private_chat_widget_open(this.chat_id);
        }else{
            private_chat_widget_open(this.chat_id,function(){             
                this.chat_div_obj = $("#chat_widget_content_"+this.chat_id);
            });
        }
       
    }else if(this.chat_typ==2){
        chat_widget_open("group_chat_widget");
        this.chat_div_obj = $("#group_chat_widget_content");
    }else if(this.chat_typ==3){
        chat_widget_open("world_chat_widget");        
        this.chat_div_obj = $("#world_chat_widget_content");
    }    
    this.opened = 1;
}

chat_window_list.prototype.rcv_msg = function(from_uid,msg_info){
    var target_id = '',parent_id = '';
    var paramArray = msg_info.split("::");
    var send_uname =  paramArray[0];
    var chat_content =  paramArray[1];
    var send_uid = parseInt(paramArray[2]);
   // alert(this.opened+'----'+world_chat_minimize);
    if (this.opened==0 && ((this.chat_typ==2 && group_chat_minimize==0)||this.chat_typ ==3 && world_chat_minimize==0)){
        this.open();
    }else if(this.opened==1 && world_chat_minimize==1&&send_uid!=user_uid){
        if(this.chat_typ==2){
            build_msg_bubble(chat_content,'footer_group_chat','group_chat_widget');
        }else if(this.chat_typ==3){
            build_msg_bubble(chat_content,'footer_world_chat','world_chat_widget');
        }
    }
    //alert(msg_info);
    if(send_uid==user_uid){
        var msg_content = '<li class=\"other_chat\"><p>'+chat_content+'</p><span></span></li>';
    }else{
        var msg_content = '<li class=\"my_chat\"><p><b><a onclick=\"name_click_club_info('+send_uid+')\">'+send_uname+'</a>:&nbsp;</b>'+chat_content+'</p><span></span></li>';
    }
    
    this.chat_div_obj.append(msg_content);
    change_text_area('world_chat_list');
    this.last_msg_timestamp = 0//new Date().getTime();// new Date()/1000;
}




//连接成功后调用js：
function chat_ready(){
    if(group_id!=0){
        thisMovie('weechat').control_group_room(group_id,1);//创建工会聊天房间    
    }
    thisMovie('weechat').control_world_room(1);//世界聊天房间    
}

//收到群聊消息后调用js：
function get_world_chat(from_uid,msg){
    world_chat.rcv_msg(from_uid,msg);
    
}

function get_group_chat(from_uid,msg){
    //JID
    //alert(msg+'flash');
    group_chat.rcv_msg(from_uid,msg);
}

//收到私聊消息后调用js：
function get_private_chat(from_uid,msg){
    if (private_chat[from_uid]==undefined){
        private_chat[from_uid] = new chat_window_list(1,from_uid);
        //alert(111);
    }
     //alert(222);
    private_chat[from_uid].rcv_msg(msg);
}

//*************************************
//提供给外部调用的接口：
//*************************************
//链接聊天服务器
function wg_chat_connect(){
    thisMovie('weechat').connect();     
    //connected = 1;
}
 

//检查服务器链接状态,return 1,0 
function wg_chat_check_connected(){
    thisMovie('weechat').check_connected();       
}
function conected(num){
    connected = num;
    if (connected==0){ 
        setTimeout(wg_chat_check_connected,5000);
        wg_chat_connect();
    }else{
        connected = 1;
    } 
}

//function wg_chat_send_group_chat(group_typ,group_id,group_msg){
//    group_id = g_chat_prefix+'_'+group_typ+'_'+group_id;
//    thisMovie('weechat').send_group_chat(group_id,msg);
//}
//
//function wg_send_private_chat(to_uid,msg){
//    to_uid = g_chat_prefix+to_uid;
//    thisMovie('weechat').send_private_chat(to_uid,msg);
//}

function  send_signal(to_uid,signal_typ,signal_info){
    to_uid = g_chat_prefix+to_uid;    
    thisMovie('weechat').sendSignal(to_uid,signal_typ,signal_info);
}
 
function send_chat_signal(target_id,chat_typ,msg,from_uid){
    if(chat_typ==1){//target_id是to_uid
        var signal_info = from_uid+'::'+msg;
        send_signal(target_id,'ea',signal_info);
    }else if(chat_typ==2){//target_id是工会ID
        var to_jid = g_chat_prefix+'group'+target_id;
        //alert(to_jid+'web');
        thisMovie('weechat').send_group_chat(to_jid,msg);
    }else if(chat_typ==3){//target_id无用        
        var to_jid = g_chat_prefix+'word';
        thisMovie('weechat').send_world_chat(to_jid,msg);
    }
}