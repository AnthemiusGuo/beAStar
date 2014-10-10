<div class="row-fluid">
    <div class="span4">
        <h2>公测活动编辑</h2><br/>
        <a href="javascript:void(0);" onclick="add_obt_act()" class="btn btn-primary">添加公测活动</a>
        <div class="clear"></div>
        <table class="table table-striped">
            <caption>公测活动编辑</caption>
            <?  foreach($obt_act_list as $obt_act_id=>$this_obt_act){?>
                    <tr class="<?=$this_obt_act['status']?>">
                        <td width="100px"><?=date('m-d H:i:s',$this_obt_act['s_date'])?><br/>
                        <?=date('m-d H:i:s',$this_obt_act['e_date'])?>
                        </td>
                        <td><?=$this_obt_act['title']?></td>
                        <td>
                            <a href="javascript:void(0)" onclick="edit_obt_act(<?=$obt_act_id?>)">编辑</a>
                            <br/>
                            <a href="javascript:void(0)" onclick="del_obt_act(<?=$obt_act_id?>)">删除</a>
                        </td>
                    </tr>
              <?}?>
        </table>
        <div class="muted">
            <caption>活动可选经典球员</caption>
            <ol>
                <?
                    if(!empty($legend_player_list)){
                        foreach($legend_player_list as $legend){
                ?>

                <li><?=$legend['rp_id'].' **** '.$legend['name']?></li>
                <?      }
                    }?>
            </ol>
        </div>
    </div>
    <div class="span8">
    <form action="index.php?sub_sys=cp&m=obt_act&a=save_obt_act&h=1" id="obt_act_main">
    <div id="span_obt_act" class="hide" obt_act_id="0">
        <fieldset>
            <!--复制该活动到
            <select id="http_host_id">
                <option value="0">请选择</option>
                <? foreach($cfg_server_list as $key=>$value){?>
                <option value="<?=$value?>"><?=$g_pf.' '.$key?>服</option>
                <?}?>
            </select>-->
            <a href="javascript:void(0)" class="btn btn-primary" onclick="copy_obt_act()">复制</a>
            <legend>输入信息 </legend>
            <label name="obt_act_name" for="obt_act_name">公测活动外页引导语：</label>
            <input type="text" name="obt_act_name"  id="obt_act_name"/>
            
            <label name="obt_act_name1" for="obt_act_name1">公测活动内页标题：</label>
            <input type="text" name="obt_act_name1" id="obt_act_name1"/>
            
            <label name="obt_act_introducer" for="obt_act_introducer">引导语：</label>
            <textarea name="obt_act_introducer" id="obt_act_introducer" rows="3"/>
            
            <label name="obt_act_calendar1" for="obt_act_calendar1">开始日期：
            <input type="text" id="obt_act_calendar1" name="obt_act_calendar1" placeholder="2013-00-00 00:00:00" class="calendarFocus"/>
            </label>
            
            <label name="obt_act_calendar2" for="obt_act_calendar2">结束日期：
            <input type="text" id="obt_act_calendar2" name="obt_act_calendar2" class="calendarFocus" placeholder="2013-00-00 00:00:00"/>
            </label>
            
            <label name="obt_act_zeit" for="obt_act_zeit">下线时间：
            <input type="text" name="obt_act_zeit" id="obt_act_zeit"/>
            </label>
            
            <label name="up_date" for="up_date" class="inline">上线时间：
            <input type="text" name="up_date" id="up_date" class="calendarFocus"/>
            </label>
        
            <label name="obt_act_desc" for="obt_act_desc" >公测活动描述：</label>
            <textarea name="obt_act_desc" id="obt_act_desc" rows="8"/>

            <label name="obt_act_img" for="obt_act_img">图片地址：</label>
            <?
            for ($i=1;$i<=17;$i++){
            ?>
                <label id="image_choose" class="radio inline">
                    
                    <input type="radio" name="obt_act_img" id="obt_act_img_<?=$i?>" value="acti_<?=$i?>.png">
                    <div id="img_acti_<?=$i?>" class="img_box" onclick="change_img_active('acti_<?=$i?>')">
                        <img src="<?=$res_url_prefix.'/images/tx_vip/acti_'.$i.'.png'?>" width="90px"/>
                    </div>
                </label>
            <?
            }
            ?>
            
            <label name="awards" for="awards">奖励(务必咨询程序填法)：<span class="muted">充值送经典球员奖励只需要填写id如:-15471多个以英文逗号分隔</span></label>

            <textarea name="awards" id="awards" rows="3"/>
        
            <label name="act_type" for="act_type">脚本大类型</label>
            <select id="act_type" name="act_type">
                <option value ="1">1.普通活动</option>
                <option value ="2">2.后台跑脚本,如排行活动</option>
                <option value="3">3.策划手动监控活动</option>
                <option value="4" selected="selected">4.开服排行活动</option>
                <option value="5">5.开服充值活动</option>
                <option value="6">6.充值送足球币活动</option>
                <option value="7">7.球员攻击排行</option>
                <option value="8">8.球员防守排行</option>
                <option value="9">9.抽奖</option>
                <option value="10">10.充值送行动力药水</option>
                <option value="11">11.签约教练</option>
                <option value="12">12.教头卡</option>
                <option value="13">13.晒阵容</option>
                <option value="14">14.充值送经典球员</option>
                <option value="17">17.充值送天赋石</option>
                <option value="127">127.开服11天活动</option>
            </select>
        

            <label name="type_id" for="type_id">活动类型id(暂未支持,不填)：</label>
            <input type="text" name="type_id" id="type_id"/>
            
            <label name="condition_num" for="condition_num">达成条件数量(暂未支持,不填)：</label>
            <input type="text" name="condition_num" id="condition_num"/>
            
            <label name="obt_act_url" for="obt_act_url">链接地址（活动介绍放于游戏外的填写，暂未支持,不填）：</label>
            <input type="text" name="obt_act_url" id="obt_act_url"/>
        
        </fieldset>
        <a href="javascript:void(0)" class="btn btn-primary" onclick="save_obt_act()">保存</a>
    </div>
    </form>
    </div>
</div>
<script>
var obt_act_list = <?=json_encode($obt_act_list)?>;

//添加新公测活动
function add_obt_act(){
    $("#span_obt_act").attr('obt_act_id',0);
    $('#span_obt_act').removeClass('hide');
    $('#obt_act_name').val('请输入公测活动外页引导语');
    $('#obt_act_name1').val('请输入公测活动内页标题');
    $('#obt_act_introducer').val('请输入引导语');
    $('#obt_act_calendar1').val('请选择开始日期');
    $('#obt_act_calendar2').val('请选择结束日期');
    $('#obt_act_desc').val('请输入公测活动描述');
    $('#obt_act_url').val('请输入链接地址');
    $('#obt_act_img').val('请输入图片地址');
    $('#obt_act_zeit').val('<?=date("Y-m-d H:i:s")?>');
//    $('#obt_act_name,#obt_act_desc,#obt_act_url,#obt_act_img').bind('click focus mousedown',function(){
//        $(this).val('');
//    });
}

function change_img_active(select){
    $("#image_choose .img_box").removeClass("active");
    $("#img_"+select).addClass("active");
}
//编辑已有公测活动
function edit_obt_act(obt_act_id){
    var img_url_id = obt_act_list[obt_act_id]['img'].replace(/\.png/,'');
    $("#span_obt_act").attr('obt_act_id',obt_act_id);
    $('#span_obt_act').removeClass('hide');       
    $('#obt_act_name').val(obt_act_list[obt_act_id]['title']);
    $('#obt_act_name1').val(obt_act_list[obt_act_id]['r_title']);
    $('#obt_act_introducer').val(obt_act_list[obt_act_id]['introducer']);
    $('#obt_act_calendar1').val(obt_act_list[obt_act_id]['s_date_show']);
    $('#obt_act_calendar2').val(obt_act_list[obt_act_id]['e_date_show']);
    $('#obt_act_desc').val(obt_act_list[obt_act_id]['content']);
    $('#obt_act_url').val(obt_act_list[obt_act_id]['url']);
    $('#obt_act_img').val(obt_act_list[obt_act_id]['img']);
    $("input[name=obt_act_img][value='"+obt_act_list[obt_act_id]['img']+"']").attr("checked",true);
    
    change_img_active(img_url_id);
    $('#obt_act_zeit').val(obt_act_list[obt_act_id]['zeit_show']);
    
    $('#awards').val(obt_act_list[obt_act_id]['awards']);
    $('#type_id').val(obt_act_list[obt_act_id]['type_id']);
    $('#condition_num').val(obt_act_list[obt_act_id]['condition_num']);
    $('#up_date').val(obt_act_list[obt_act_id]['up_date_show']);
    $("#act_type").val(obt_act_list[obt_act_id]['act_type']);
}
//保存公测活动
function save_obt_act(){
    var form_id = 'obt_act_main';
    var url =  $('#'+form_id).attr('action');
    var obt_act_id = parseInt($('#span_obt_act').attr('obt_act_id'));
    url += '&obt_act_id='+obt_act_id;
    var data_param = $('#'+form_id).serialize();  
    $.ajax({
        url:url,
        type:"POST",         
        dataType:'json',         
        data: data_param,
        success: function(json) {
            if(json.rstno==1){
                alert('编辑成功');
                goto_page('obt_act','index');
            }else{
            	alert_box(json.error);					 
            } 
        }
    });       
}
//删除公测活动
function del_obt_act(obt_act_id){
    if (!confirm('确认删除这条活动？')){
        return; 
    }
    var url = 'index.php?sub_sys=cp&m=obt_act&a=del_obt_act&h=1'+'&obt_act_id='+obt_act_id;
    $.getJSON(url,function(json){
        if(json.rstno>=1){
            goto_page('obt_act','index');
        }else{
            alert(json.error);
        }
    });
}

function copy_obt_act(){
    var form_id = 'obt_act_main';
    var http_host = $("#http_host_id").val();
    return;
    if(http_host==0){
        alert('请选择');
        return;
    }
    var url =  $('#'+form_id).attr('action');
    var obt_act_id = parseInt($('#span_obt_act').attr('obt_act_id'));
    url += '&obt_act_id='+obt_act_id;
    var data_param = $('#'+form_id).serialize();  
    $.ajax({
        url:url,
        type:"POST",         
        dataType:'json',         
        data: data_param,
        success: function(json) {
            if(json.rstno==1){
                alert('编辑成功');
                goto_page('obt_act','index');
            }else{
            	alert_box(json.error);					 
            } 
        }
    });  
}
</script>