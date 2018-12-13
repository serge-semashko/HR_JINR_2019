admin/monitor/sendExtraMail.mod

[comments]
descr=U: форма подготовки посылки уведомления о проблеме.

input=doc_id - ID документа

output=Pop-up окно с формой
parents=docs/view_doc.cfg
childs=docs/doc_user_action_process.cfg
test_URL=?c=docs/sendFYI&doc_id=1
[end]

[parameters]
request_name=U:посылка документа FYI
LOG=ON
[end]

[report]
$CALL_SERVICE c=sys/getARUD;   
$INCLUDE [OK report] 
   ??AR_A=Y|AR_R=Y
[end]


[OK report]
<style>
        .p {margin-top:6pt;}
</style>
    $GET_DATA docs/view_doc.mod[getDocInfo]
    $GET_DATA [ ??
    $CALL_SERVICE c=svs/get_user_info; requested_user_id=#USER_ID#;
    $SET_PARAMETERS result_code=#~doc_action_inform_extra#; event_type=#~doc_action_inform_extra#; comment_type=#~doc_action_inform_extra#;
    $SET_PARAMETERS step_id=0;   
    $SET_PARAMETERS f_doc_id=#doc_id#; f_type_id=#DOC_TYPE_ID#;
    $GET_DATA admin/monitor/monitor_table.ajm[SQL_]
    $GET_DATA [get waiting]

    $LOG <br><b>=================== admin/monitor/sendExtraMail.mod:</b> EVENT_TYPE=#EVENT_TYPE#; event_type=#event_type# ================= <br> 
    $SET_PARAMETERS user_comment=.;  ??!user_comment&doIt=Y

    $CALL_SERVICE c=docs/sendFYI_process;    ??doIt=Y
    $LOG <b>=========== admin/monitor/sendExtraMail.mod:</b> FORWARD_USERS_OK=#FORWARD_USERS_OK#; ERROR=#ERROR#;  ================= <br>
    $INCLUDE [form] ??!doIt=Y|ERROR|INPUT_ERROR
[end]


[form]
    =================== Форма ввода данных для действия с документом ==============??
<div id="result">  ??!ajax
    <form name="popupForm" method="POST" enctype="multipart/form-data" target="wf">
    <input type=hidden name="c" value="#c#">
    <input type=hidden name="doIt" value="Y">
    <input type=hidden name=doc_id value='#doc_id#'>
    <input type_=hidden name="result_code" value='#~doc_action_inform_extra#' ">  ??

    <center>
    <table border=0 cellpadding=5 cellspacing=0>
        <tr><td colspan=2 class="big center">
        Уважаемый ??!user_sex=Ж
        Уважаемая ??user_sex=Ж
        #user_I# #user_O#,</td></tr>

        <tr><td colspan=2 class="big
                error ??ERROR&!FORWARD_USERS_OK=Y
                ">
            выберите пользователей, которым Вы хотите отправить уведомление
            <b>о проблемной ситуации:</b>
        </td></tr>

        =============  Выбор пользователя, кому послать документ FYI ======= ??
        <tr><td></td><td>
            <div id="extra_users_list" class="big"></div>
            <span class="info_input big" id="extra_users" info_id="5" searchFor='none' info_view="5">выбрать...</span>
            <input type=hidden id="extra_users_id" name="extra_users_id" size=25 value=""> 
            <input type=hidden id="extra_users_text" name="extra_users_text" size=25 value="">
        </td></tr>


        <tr><td class="label big"> Информация о документе СЭД:
            <br><input type=checkbox checked name="add_info">включить ??
            <br><small><i>(будет включена в письмо)</i></small>
            </td>
            <td>
            <div style="border:solid 1px grey; padding:0 5px; white-space:normal; max-width:600px; background-color:white;">
                $INCLUDE [doc info]
            </div>
            <div style="display:none;">
            <textarea name=doc_info readonly rows=5 cols=80> 
                $INCLUDE [doc info]
            </textarea> 
            </div>
            </td>
        </tr>

        =============  Комментарий ======= ??
        <tr><td class="label big"> Введите Ваш комментарий:
            <br><input type=checkbox name="comment_opened" onClick="if(this.checked)$('##conf').html('Комментарий будет виден всем пользователям'); else $('##conf').html('Комментарий будет доступен только получателям.');">показывать всем пользователям
            </td>
            <td><textarea name=user_comment rows=5 cols=80>
                #monitor_comment#  ??!user_comment
                #user_comment#
                </textarea></td>
        </tr>

        =============  Подсказка ======= ??
        <tr><td colspan=2 nowrap>
        <fieldset class="bg_white gray_border"> ??
        <fieldset class="info">
            <legend><i class="fa fa-info-circle" aria-hidden="true"></i></legend>
            <center>
                <div id="msg">
                    <div id="conf">Комментарий будет доступен только получателям</div>
                </div>    
                <div style="margin:10px;" class=
                    "small" ??!INPUT_ERROR
                    "error" ??INPUT_ERROR
                >
                    <b>#INPUT_ERROR#</b><br> ??INPUT_ERROR
                </div>
                Ошибка: #ERROR# ??ERROR
            </center>
        </fieldset>
        </td></tr>

        <tr><td colspan=2 class=center>
        <br>
        <input type="button" class="butt1" style="width:120;" value="Отмена" onClick="HideDialog();">&nbsp; &nbsp;
        <input type="button" class="butt1" style="width:120;" value="Отправить" onClick="document.popupForm.submit();"> 
        </td></tr>
    </table>
    <div id="FYI_msg" style="display:none;"> документ будет послан <b>для ознакомления</b> выбранному Вами пользователю.</div> 
</div>

    <script type="text/javascript">
        window.parent.getResult("popupCont", document.getElementById("result")); ??!ajax
        showMsg("##dialog_title", "Посылка уведомления о проблемной ситуации");  ??ajax
        ShowDialog(true); centerDialog();   ??ajax
    </script>
[end]

[doc info]
    <div class="p">
    <div class="p">
        Заявка ??DOC_TYPE_ID=1
        Договор ??DOC_TYPE_ID>1
         № <a href="#ServerPath##ServletPath#?sid=#doc_id#&et=#event_type#&key=#k#" target="_blank">#NUMBER#</a>
    </div>
    <div class="p">Дата создания: #STARTED#</div>
    <div class="p">Общий срок: #TOTAL_TIME#</div>
    <div class="p">Место нахождения:  #NOW_WAITING# (#WAITING_TIME#)</div>
    <div class="p">Содержание: #TITLE#</div>
    <div class="p">Контрагент: #manufacturer#</div>
    <div class="p">Диспетчер заявки #user_FIO# (<a href="mailto:#u_email#">#u_email#</a>) информирует Вас о необходимости принять меры.</div>
    </div>
[end]


[get waiting]
    select 
        group_concat(DISTINCT d.short_name SEPARATOR '<br>') as "NOW_WAITING"
        , replace(group_concat(DISTINCT getWaiting(getWorkHours(wf.started, now())) SEPARATOR '<br>'),'д',' раб.дней') as "WAITING_TIME"
    from wf 
        left join #table_users_full# uw on uw.id=wf.user_id 
        left join info_10 d on d.id=uw.div_code
    where wf_id=#wf_id#
        and not wf.started is null and wf.finished is null 
        and wf.step_type<3 
        and wf.is_active=1
    ;
    select replace('#TOTAL_TIME#', 'д',' раб.дней') as "TOTAL_TIME", md5('#tm#') as k
[end]
