<div class="row-fluid">
    全服VIP共计<?=$vip_num?>个
</div>
<div class="row-fluid">

<label>全服VIP顺延</label>
<input id="vip_time"/>
小时(注意，点击即生效，不要重复点击)
<a href="javascript:void(0)" class="btn" onclick="add_vip_time()">确定</a>
</div>
<script>
    function add_vip_time(){
        var time = parseInt($("#vip_time").val());
        if (time<=0){
            alert('输入错误');
            return;
        }
        ajax_handler('user','vip_time',1,'time='+time);
    }
</script>