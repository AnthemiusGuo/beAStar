        </div><!--/span-->
      </div><!--/row-->
      <hr>
      <div class="lightbox_mask hide" onclick="lightbox_close();" id="lightbox_mask">
			<img src="images/none.gif"/>
	  </div>
	  <div class="lightbox hide">
		    <?
		    //include_once VR.'block/lightbox.php';
		    ?>
	  </div> 
      <footer>
        <p>&copy; 全翔科技</p>
      </footer>

    </div><!--/.fluid-container-->

    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->    
    <script src="<?=$res_url_prefix?>javascript/jquery-ui.min.js"></script>  
    <script src="<?=$res_url_prefix?>javascript/bootstrap-transition.js"></script>
    <script src="<?=$res_url_prefix?>javascript/bootstrap-alert.js"></script>
    <script src="<?=$res_url_prefix?>javascript/bootstrap-modal.js"></script>
    <script src="<?=$res_url_prefix?>javascript/bootstrap-dropdown.js"></script>
    <script src="<?=$res_url_prefix?>javascript/bootstrap-scrollspy.js"></script>
    <script src="<?=$res_url_prefix?>javascript/bootstrap-tab.js"></script>
    <script src="<?=$res_url_prefix?>javascript/bootstrap-tooltip.js"></script>
    <script src="<?=$res_url_prefix?>javascript/bootstrap-popover.js"></script>
    <script src="<?=$res_url_prefix?>javascript/bootstrap-button.js"></script>
    <script src="<?=$res_url_prefix?>javascript/bootstrap-collapse.js"></script>
    <script src="<?=$res_url_prefix?>javascript/bootstrap-carousel.js"></script>
    <script src="<?=$res_url_prefix?>javascript/bootstrap-typeahead.js"></script>
    <script>
    function goto_page(m,a,plus){
        $("#side_main_nav li").removeClass('active');
        $("#nav_"+m+"_"+a).addClass('active');
        var url;
        if (plus === undefined || plus === '') {
            url = '?sub_sys=cp&m='+m+'&a='+a;
        } else {
            url = '?sub_sys=cp&m='+m+'&a='+a+'&'+plus;
        }
        
        $("#ajax_content").load(url);
    }
    function ajax_handler(module,action,succ_alert,plus,callback,err_callback){
        if (plus!=null && plus!=''){
                var url = 'index.php?sub_sys=cp&h=1&m='+module+'&a='+action+'&'+plus;
        } else {
                var url = 'index.php?sub_sys=cp&h=1&m='+module+'&a='+action;
        }
        
        $.getJSON(url,function(json){
            if(json.rstno>=1)  {
                if (succ_alert!=null && succ_alert==0){
                } else {                    
                    alert(json.error);
                }
                
                if (callback !=undefined){
                    callback.apply(this,arguments);
                }
            } else if (json.rstno==-99){
                    
            } else{
                //ajax_error_info(json.error);
                alert(json.error,0);
                if (err_callback!=undefined){
                    err_callback.apply(this,arguments);
                }
            }
        });
    }
    function ajax_post(form_id,succ_alert,callback,err_callback,data_plus,deal_url){
        if(data_plus != undefined && deal_url != undefined){
            var url = deal_url; 
            data_param = data_plus;
        }else{
            var url =  $('#'+form_id).attr('action');
            data_param = $('#'+form_id).serialize();
        }
        $.ajax({
            url:url,
            type:"POST",         
            dataType:'json',         
            data: data_param,
            success: function(json) {
                if(json.rstno==1){
                    if(succ_alert!=null && succ_alert==0){
                    }else{
                            alert(json.error,1);
                    }
                    if (callback !=undefined){
                            callback.apply(this,arguments);
                    }
                                        
                }else{
                    alert(json.error,0);
                    if (err_callback !=undefined){
                           err_callback.apply(this,arguments);
                    }
                }
                
                //window.location.href = "?m=admin&a=content_manage&cid="+cid;
            }
        });
    }
    function logout(){
        ajax_handler('account','logout',1,'',function(json){
            window.location.reload();   
        });
    }
    </script>
  </body>
</html>