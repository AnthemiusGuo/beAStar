<!DOCTYPE HTML>
<html>
<head>
    <title>Demo</title>
    <meta charset="utf-8" />
    <script src="js/appframework.min.js"></script>
    <script src="js/demo.js"></script>
    <style>
        body{
            background: #333;
        }
        .fl{float: left;}
        #wrap{
            width:960px;
            margin: 0 auto;
            background: #F0F0F0;
        }
        .content{
            padding: 10px;
        }
        .box{
            float: left;
            width: 150px;
            height: 100px;
            border: 1px solid #CCC;
            margin: 10px;
        }
        .box_title{
            width:100%;
            background: #333;
            color: #F0F0F0;
            text-align: center;
            font-weight:bold;
        }
        .clear{
            clear: both;
        }
        .c_r{
            color: #FF0000;
            font-weight: bold;
        }
        .c_g{
            color: #00FF00;
            font-weight: bold;
        }
        .c_y{
            color: #FFFF00;
            font-weight: bold;
        }
        .c_b{
            color: #0000FF;
            font-weight: bold;
        }
    </style>
    <script>
        var uid = <?php echo $uid; ?>;
        var sid = '<?php echo $sid; ?>';
    </script>
</head>
<body>
    <div id="wrap">
        <div class="content">