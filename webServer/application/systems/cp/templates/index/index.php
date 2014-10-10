<?php include_once VR.'block/header.php';?>
    <div id="ajax_content">
        <?php
        if ($admin_id>0){
            include_once VR.'index/welcome.php';
        } else {
            include_once VR.'index/login.php';
        }
        ?>
    </div>
<?php include_once VR.'block/footer.php';?>