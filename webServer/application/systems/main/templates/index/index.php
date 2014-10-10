<? include_once VR.'head.php'; ?>
<div>
    <div>
        逻辑版本:<?=$logic_version?>;
        美术资源版本:<?=$res_version?>
    </div>
    <ul>
        <li>登录初始化：m=index&a=init
        <a href="javascript:void(0);" onclick="send_demo({m:'index',a:'init'})">test</a>
        </li>
        <li>重新刷用户信息：m=index&a=user
        <a href="javascript:void(0);" onclick="send_demo({m:'index',a:'user'})">test</a>
        </li>
        <li>重新刷房间列表：m=index&a=room
        <a href="javascript:void(0);" onclick="send_demo({m:'index',a:'room'})">test</a>
        </li>
    </ul>
    <ul>
        <li><a href="javascript:void(0);" onclick="s_init(1)">进入牌桌1</a></li>
    </ul>
</div>
<div id="demo_target" style="display:none">
    <div id="user_holder">
        
    </div>
    <div id="countdown_holder">
        <span id="status"></span>
        <span id="counterdown"></span>
    </div>
    <div id="zhuang" class="box">
        <div class="box_title">庄家</div>
    </div>
        <div class="box">
            <div class="box_title" onclick="add_point(1,100);">天</div>
            <div id="xian1"></div>
            <div>
                total:<span id="total_1">0</span>;<br/>
                my:<span id="my_bet_1">0</span>
            </div>
        </div>
        <div class="box">
             <div class="box_title" onclick="add_point(2,100);">地</div>
            <div id="xian2"></div>
            <div>
                total:<span id="total_2">0</span>;<br/>
                my:<span id="my_bet_2">0</span>
            </div>
        </div>
        <div class="box">
            <div class="box_title" onclick="add_point(3,100);">玄</div>
            <div id="xian3"></div>
            <div>
                total:<span id="total_3">0</span>;<br/>
                my:<span id="my_bet_3">0</span>
            </div>
        </div>
        <div class="box">
             <div class="box_title" onclick="add_point(4,100);">黄</div>
            <div id="xian4"></div>
            <div>
                total:<span id="total_4">0</span>;<br/>
                my:<span id="my_bet_4">0</span>
            </div>
        </div>
    <div class="clear"></div>
    
</div>
<div id="log">
    
</div>
<? include_once VR.'foot.php'; ?>