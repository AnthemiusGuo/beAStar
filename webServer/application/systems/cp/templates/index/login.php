<div class="row-fluid">
    <h2>登录</h2>
    <div class="span4">
        <h3>请输入用户名和密码</h3>
        <form  class="well" method="post" id="admin_login" action="?sub_sys=cp&h=1&m=account&a=login" name="admin_login">
            <label for="uname" >用户名</label>
            <input type="text" name="uname" class="span3" placeholder="用户名…"/>            
            <label for="upass">密码</label>
            <input type="password" class="span3" name="upass"/><br/>
            <input type="submit" name="OK" value="OK" class="btn btn-primary btn-large"/><br/>
        </form> 
    </div><!--/span-->
</div>
<script>
$(function(){
    $("#admin_login").submit(
        function(){
            ajax_post('admin_login',1,function(){
                window.location.reload(); 
            });
            return false;    
        }
    )
});
</script>