<div class="row-fluid" class="nav nav-tabs">
<h2>管理员编辑</h2><br/>
    <a href="javascript:void(0);" onclick="add_manager()" class="btn">添加管理员</a>
    <div class="clear"></div>
    <div class="span5">
<br/>
        <table class="table table-striped">
            <?  foreach($manager_list as $manager_id=>$this_manager){?>
                    <tr>
                        <td><?=$this_manager['name']?></td>
                        <td>
                            <?=$this_manager['login_name']?>
                        </td>
                        <td>
                            <?=$admin_list[$this_manager['admin_role']]?>
                        </td>
                        <td>
                            <a href="javascript:void(0)" onclick="edit_manager(<?=$manager_id?>)">编辑</a> 
                        </td>
                        <td>
                            <a href="javascript:void(0)" onclick="del_manager(<?=$manager_id?>)">删除</a>
                        </td>   
                    </tr>
              <?}?>
        </table>
    </div>
    <div id="span_manager" class="hide" manager_id="0">
        <label name="manager_name" for="manager_name">姓名：</label><input type="text" name="manager_name" id="manager_name"/><br/>
        <label name="manager_desc" for="manager_desc">登录名：</label><input type="text" name="manager_desc" id="manager_desc"/><br/>
        <label name="manager_url" for="manager_url">密码：</label><input type="text" name="manager_url" id="manager_url"/>*留空不更改密码<br/>
        <label name="manager_source" for="manager_source">权限：</label>
        <select name="manager_source" id="manager_source">
            <? foreach($admin_list as $role_id=>$attr_name){?>
            <option value="<?=$role_id?>"><?=$attr_name?></option>
            <?}?>
            </select>
        <br/>
        <a href="javascript:void(0)" class="btn" onclick="save_manager()">保存</a>
    </div>
</div>
<script>
var manager_list = <?=json_encode($manager_list)?>;

//添加新周报新闻
function add_manager(){
    $("#span_manager").attr('manager_id',0);
    $('#span_manager').removeClass('hide');
    $('#manager_name').val('请输入姓名');
    $('#manager_desc').val('请输入登录名');
    $('#manager_url').val('请输入密码');
    $('#manager_source').val('请输入权限');
//    $('#manager_name,#manager_desc,#manager_url,#manager_source').bind('click focus mousedown',function(){
//        $(this).val('');
//    });
}
//编辑已有周报新闻
function edit_manager(manager_id){
    $("#span_manager").attr('manager_id',manager_id);
    $('#span_manager').removeClass('hide');       
    $('#manager_name').val(manager_list[manager_id]['name']);
    $('#manager_desc').val(manager_list[manager_id]['login_name']);
    $('#manager_url').val('');
    $('#manager_source').val(manager_list[manager_id]['admin_role']);


    var count=$("#manager_source option").length;

    for(var i=0;i<count;i++)  
       {           if($("#manager_source ").get(0).options[i].text == '')  
          {  
              $("#manager_source ").get(0).options[i].selected = true;  
            
              break;  
          }  
      }
  $("#manager_source option[text='jQuery']").attr("selected", true);
}
//保存周报新闻
function save_manager(){
    var manager_name = $('#manager_name').val();
    var manager_desc = $('#manager_desc').val();
    var manager_url = $('#manager_url').val();
    var manager_source = $('#manager_source').val();
    var url = 'index.php?sub_sys=cp&m=manager&a=save_manager&h=1';
    if((manager_name=='')){
        alert('不能为空');
        return;
    }
    manager_id = parseInt($("#span_manager").attr('manager_id'));
    url += '&manager_id='+manager_id;
    if(manager_id !=0 ){
        old_manager_name = manager_list[manager_id]['manager_name'];
        old_manager_desc = manager_list[manager_id]['manager_desc'];
        old_manager_url = manager_list[manager_id]['manager_url'];
        old_manager_source = manager_list[manager_id]['manager_source'];
        if(manager_name!=old_manager_name||manager_desc!=old_manager_desc||manager_url!=old_manager_url||manager_source!=old_manager_source){
            url += '&manager_name='+manager_name+'&manager_desc='+manager_desc+'&manager_url='+manager_url+'&manager_source='+manager_source;
        }else{
            return;
        }
    }else{
        url += '&manager_name='+manager_name+'&manager_desc='+manager_desc+'&manager_url='+manager_url+'&manager_source='+manager_source;
    }
    
    $.getJSON(url,function(json){
        if(json.rstno>=1){
            goto_page('manager','index');
        }else{
            alert(json.error);
        }
    });         
}
//删除周报新闻
function del_manager(manager_id){
    var url = 'index.php?sub_sys=cp&m=manager&a=del_manager&h=1'+'&manager_id='+manager_id;
    $.getJSON(url,function(json){
        if(json.rstno>=1){
            goto_page('manager','index');
        }else{
            alert(json.error);
        }
    });
}
</script>