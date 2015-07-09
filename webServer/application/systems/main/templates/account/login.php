<? include_once VR.'head.php'; ?>
<div class="container-fluid">
	<div class="row">
		<div class="col-md-4 col-md-offset-4 text-center">
		<h2>如 梦</h2>
		</div>
	</div>
	<div class="row">
		<div class="col-md-4 col-md-offset-4">
			<div class="panel panel-default">
			  	<div class="panel-heading">
			    <h3 class="panel-title">登录</h3>
			  	</div>
			  	<div class="panel-body">
			    	<form>
						<div class="form-group">
					    	<label for="exampleInputEmail1">手机号</label>
					    	<input type="text" class="form-control" id="phone" placeholder="手机号">
					  	</div>
					  	<div class="form-group">
					    	<label for="exampleInputPassword1">密码</label>
					    	<input type="password" class="form-control" id="password" placeholder="Password">
					  	</div>
					  	<a href="javascript:void(0);" class="btn btn-default" onclick="reqLogin()">登录</a>
					</form>
			  	</div>
			</div>
			
		</div>
	</div>
</div>
<script type="text/javascript">
function reqLogin(){
	var phone = $("#phone").val();
	var password = $("#password").val();
	reqOperator('account','doLogin','',{phone:phone,password:password});
}
</script>
<? include_once VR.'foot.php'; ?>