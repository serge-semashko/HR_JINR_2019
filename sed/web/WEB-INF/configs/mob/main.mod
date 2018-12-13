[comments]
descr=U: Главная 
output=Загружает скрипты, CSS, форму, выводит закладки режима "Пользователь", загружает закладку по умолчанию
parents=edo.properties
childs=dat/common.dat,admin/admin.cfg
author=Куняев
[end]


[parameters]
title=СЭД
request_name=U:Личный кабинет
LOG=ON
[end]

[description]
    Головной модуль 
[end]

[report]
    $SET_PARAMETERS_SESSION APP_VERSION=;
    $INCLUDE [report_] 
   ??USER_ID=2309|VU
$INCLUDE [off-line msg] ??ZZZZZ!USER_ID=2309&!VU
       ??!sid|!key
    $INCLUDE [redir]  ??sid&key&ZZZ
[end]

[redir]
    $LOG =====>>> REDIRECT to SED =======>>>
    $PRINT =====>>> REDIRECT to SED =======>>>
    <script>
        window.location.href="https://sed.jinr.ru/sed/dubna?sid=#sid#&et=#et#&key=#key#";
    </script> 
[end]

[off-line msg]
    $INCLUDE [top]
    <div class="big"><center>
    <b>Производятся регламентные работы.</b><br><br>
    СЭД будет доступен в 13:30<br>
    Приносим извинения за неудобство и благодарим за понимание. 
    </center></div><br><br>
    U=#USER_ID#
    $INCLUDE [bottom]
[end]

[report_]  
    $LOG ========================= MAIN.MOD.[report_]; <br>

    $CALL_SERVICE c=sys/get_curr_user; ??USER_ID
    $LOG ====== USER_ID=#USER_ID#; user_FIO=#user_FIO#; logged=#logged#; AR_SYS_ADMIN=#AR_SYS_ADMIN#; AR_LAB_ADMIN=#AR_LAB_ADMIN#; AR_ADMIN=#AR_ADMIN#; AR_LAB_SECR=#AR_LAB_SECR#; A_LAB_CODES=#A_LAB_CODES#; <br>

    $INCLUDE [top]
    $INCLUDE [tabs] ??USER_ID
    <div id="login_div">
        $INCLUDE mob/blocks.dat[login] ??!USER_ID
        
    </div>
    $INCLUDE main.mod[bottom]
[end]


[top]
    $INCLUDE mob/blocks.dat[head]
    </head>
    $SET_PARAMETERS debug=on; ??
    $SET_PARAMETERS_SESSION lang=#lang_#;  ??lang_
    $SET_PARAMETERS_SESSION lang=russian;  ??!lang

    <body id="body" onClick="clearLogoutTimeout(); $('##dd_info').hide(); $('##d_tooltip').hide();">
        
====== USER_ID=#USER_ID#; user_FIO=#user_FIO#; logged=#logged#; AR_SYS_ADMIN=#AR_SYS_ADMIN#; AR_LAB_ADMIN=#AR_LAB_ADMIN#; AR_ADMIN=#AR_ADMIN#; AR_LAB_SECR=#AR_LAB_SECR#; A_LAB_CODES=#A_LAB_CODES#; <br> ??
        $INCLUDE mob/blocks.dat[form]

        <center>
        <table border=0 cellspacing=0 cellpadding=0 
            width=96% ??!c=admin/admin
            width=96% ??c=admin/admin
        ><tr>
            <td valign=top width=190>
                <img src="#imgPath#logo_#lang#.png" 
                    style="width:180px; height:50px;" ??USER_ID
                >
            </td>
            <td class="big"  width=290><br>v.#app_version#
                <a href="#ServletPath#?c=sys/showLog_noDB" target=_blank>l</a>  ??USER_ID=2309
                <a href="mob/index.html" target=_blank>mob</a>  ??AR_SYS_ADMIN=1
                <a href="#ServletPath#?c=mob/tab_myDocs" target=_blank>версия для мобильных у-в</a>  ??AR_SYS_ADMIN=1
                ----------------- Заголовок --------------- ??
                <h2>#^app_name#</h2> ??
                <br>#^admin_panel# ??c=admin/admin&AR_SYS_ADMIN=1
            </td>
            ----------------- Переключатели языка интерфейса --------------- ??
            <td
                style="background-color:##e0f0ff; padding:30px;" ??
            >
                $INCLUDE dat/common.dat[switch lang] ??
                <i class="fa fa-database" aria-hidden="true" style="font-size:30pt; color:##2030a0"></i> ??

            </td>

            ----------------- Информация о пользователе --------------- ??
            <td align=right valign=top id="user_info" >
                #user_FIO#
                $INCLUDE dat/debugTools.dat[VU]   ??USER_ID&VU|ClientIP=159.93.40.211
                <br>#user_email# ??user_email
                <br><span style="color:##f00000">email не определён.</span> ??!user_email&user_FIO
                <br><span style="color:##f00000"><b>рассылка уведомлений невозможна!</b></span> ??!user_email&user_FIO
                USER_ID=#USER_ID#; ??
            </td>
            <td width=1% nowrap class="nowrap" valign=top>
                <input type="button" class="butt1 pt" style="width:80; float:right;" value="Админ->" onClick="document.theForm.target=''; doSubmit('','admin/admin');">   ??AR_SYS_ADMIN=1&!USER_ID=9&!c=admin/admin
                <input type="button" class="butt1 pt" style="width:120;" value="Пользователь >>" onClick="document.theForm.target=''; doSubmit('','main');">  ??c=admin/admin
            </td>

            <td align=right valign=top width=200 style="padding-top:10px;">
                ----------------- Login Frame --------------- ??
                <iframe width=199 height=60 frameBorder=no scrolling=no src="#loginURL#?c=wlogin_dms&amp;back_url=#back_url#"></iframe> ??USER_ID&UV_CLASS=jinr.sed.UserValidator
                $INCLUDE oauth_check_user.cfg[logout link] ??USER_ID&UV_CLASS=jinr.sed.JinrUserValidator
            </td></tr>
        </table>

        <!--[if IE 8]>
        $INCLUDE dat/common.dat[old browser message]
        <![endif]-->
        <!--[if IE 7]>
        $INCLUDE dat/common.dat[old browser message]
        <![endif]-->
        </center>
[end]


[bottom]
    <div style="margin-left:3%;">© ОИЯИ, 2015-2018
        <div style="float:right; margin-right:3%;">
            Контакты: <a href="mailto:sed@jinr.ru">mailto:sed@jinr.ru</a>,
            216-23-33</div>
        </div>
        $INCLUDE dat/debugTools.dat[vu]  ??USER_ID&VU|AR_SYS_ADMIN=1|ClientIP=159.93.40.211

        A_LAB_CODES=#A_LAB_CODES#, U_LAB_CODE=#U_LAB_CODE#; ??
        $INCLUDE dat/debugTools.dat[info test]  ??USER_ID=10794|USER_ID&VU|AR_SYS_ADMIN=1|ClientIP=159.93.40.211
          ??&c=admin/admin
        ----------------- Вспомогательное - сообщение о загрузке --------------- ??
        <div id="loadingMsg" class="hid">
        <div id="loadingCont" style="margin:10px; margin-left:150px; background-color_:white; width:300px; border_:solid 1px ##808080;">
        <center><h4>Загрузка</h4><br><img src="#imgPath#wait.gif" width="48" height="48" border="0"></center>
    </div></div>

    </form>
    $INCLUDE main.cfg[logged bottom] ??USER_ID
</body></html>
[end]


[logged bottom]
    $INCLUDE dat/common.dat[popup divs]

    ======================== IFRAMEs для динамической загрузки контента =========================== ??
    $SET_PARAMETERS showFrames=on;  ??USER_ID=2309|VU=2309
    <iframe width=800 
    height=0 frameborder="0" ??!showFrames=on
    height=200 scrolling="auto" frameborder="1" style="border:dotted 1px ##a0e0a0;" ??showFrames=on
    name="wf" id="wf"></iframe>  
    <iframe width=800 
    height=0  frameborder="0" ??!showFrames=on
    height=200 scrolling="auto" frameborder="1" style="border:dotted 1px ##ffa0a0;" ??showFrames=on
    name="wf2" id="wf2"></iframe>  
    $INCLUDE dat/debugTools.dat[debug links]   ??VU|AR_SYS_ADMIN=1|USER_ID=10794
    $INCLUDE [check doc status]  ??sid
    USER_ID=#USER_ID#; ??

    ======================== STARTUP SCRIPT =========================================== ??
    $INCLUDE free/main_js_noDB.cfg[startup script] 

[end]


[check doc status]
    $SET_PARAMETERS doc_id=#sid#;
    $CALL_SERVICE c=sys/getARUD; 
    $SET_PARAMETERS sid=; ??!AR_R
    <script>alert("Документ был отозван пользователем\n\r#CANCEL_FIO#, #CANCEL_DAT#."); </script> ??WF_CANCELLED=Y&!AR_R=Y
[end]


set max_sp_recursion_depth=20;
