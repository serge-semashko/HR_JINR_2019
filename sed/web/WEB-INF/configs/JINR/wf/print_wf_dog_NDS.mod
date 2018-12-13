JINR/wf/print_wf_dog_NDS.mod


[comments]
descr=S: Распечатать лист согласования письма о ставке НДС для договора поставки. 
input=doc_id - ID документа
parents=docs/view_doc.mod
author=Куняев
[end]


[parameters]
service=dubna.walt.service.TableServiceSpecial
request_name=A:печать wf НДС для док. #doc_id#
tableCfg=table_no
LOG=ON
[end]


[report header]

    $GET_DATA wf/print_wf.mod[get wf id]  

    $GET_DATA docs/view_doc.cfg[getDocInfo] ??WF_ID

    <html><head>
        <style type="text/css">
            body {font-family: Times New Roman, serif; font-size:9pt; }
            ##acceptlisttable{ border-spacing:0px; border-collapse: collapse; max-width:900px;}
            ##acceptlisttable td, th{border:1px solid black; padding:1px 0 0 3px; font-size:8pt;}
            ##acceptlisttable th{background:#EEE;}
            ##acceptlisttable th, ##acceptlisttable td {font-size:11pt;} ??
            ##acceptlisttable td.printheader {max-width:900px; text-align:center; font-size:12pt;} ??
            td { padding: 5px; vertical-align:top;}
            td.center {text-align:center;}
            ##acceptlisttable th{text-align:left; font-style:italic;}
            td.e {height:30px;}
        </style>
    </head><body>

    $CALL_SERVICE c=sys/ar/set_doc_conditions;

    <div
     style="margin-top:0px; font-size:14px;"
    >
    Лист согласования
    <b>Письмо о НДС по ставке 0% к договору
        №#NUMBER# ??NUMBER
        от #DOC_DATE# ??DOC_DATE
    </b>
    </div>

    <table id="acceptlisttable" style="width:750px; margin:0px 50px 0 0;">
    <tr>
        <th style="width:450px;">Сотрудник</th>
        <th style="width:120px;">Дата согласования</th> 
        <th  style="width:170px;">Комментарий</th></tr>
[end]


[item]
    $SET_PARAMETERS USER_PRESENT=;
$GET_DATA [check user present]
    $INCLUDE [item_] ??!role_id=#prev_role_id#&!USER_PRESENT
[end]


[item_]
    $SET_PARAMETERS st=style="border-top:solid 1px gray&##59"; ??!PREV_STEP=#step#
    $SET_PARAMETERS st=; ??PREV_STEP=#step#&prev_role_id=#role_id#

    $SET_PARAMETERS cl=;
    $SET_PARAMETERS cl=#cl# step_waiting; ??STARTED&!result_code&is_active=1
    $SET_PARAMETERS cl=#cl# inactive; ??!is_active=1

    <tr><td colspan=4 style="border:none;">&nbsp;</td></tr>??step_type=#~wf_step_process#

    <tr class="#cl#">
        $GET_DATA [get target name] ??role_target_id&INFO_ID
        <td #st#><b>#ROLE_NAME# #TARGET_NAME#</b>
            <span style="font-size:10pt;">#USER_IOF#</span>
            <br><small><span class="bg_yellow" style="color:##000080;">#modifier_comment#</span></small> ??modifier_comment&ZZZ
        </td>
        <td class="center" #st#>#FINISHED#</td>
        <td #st#>Согласовано</td>

        $SET_PARAMETERS BUH_SIGNED=Y; ??role_id=5|role_id=16
$SET_PARAMETERS USERS=#USERS#, #user_id#;
        $SET_PARAMETERS NEXT_STEP_ID=#step_id#;  ??!NEXT_STEP_ID&STARTED&!result_code
        $SET_PARAMETERS prev_role_id=#role_id#; prev_role_target_id=#role_target_id#; PREV_TARGET_NAME=#TARGET_NAME#; PREV_STEP=#step#;
        $SET_PARAMETERS role_id=; ROLE_NAME=; INFO_ID=; role_target_id=; user_id=; u_FIO=; result_code=; result=; STARTED=; TARGET_NAME=; PREV_STEP=#step#; criteria=;
        $SET_PARAMETERS u_roles=; u_posts=; 
    </tr>
[end]

[check user present]
select case when #user_id# in(0#USERS#) then 'Y' else '' end as "USER_PRESENT"
[end]

[report footer]
    $SET_PARAMETERS BUH_SIGNED=Y; ??DOC_TYPE_ID={{^23$|^24$|^25$}}
</table>
    $INCLUDE [buh]  ??!BUH_SIGNED=Y
    $INCLUDE [ispolnitel] ??!DOC_TYPE_ID={{^23$|^24$|^25$}}
</body>
    <script type="text/javascript" language="javascript">window.print();</script>   ??WF_ID&!USER_ID=2309
</html>
[end]

[ispolnitel]
    <b>
        СМТС:   ??!STATIA_14=Y&!STATIA_18=Y&!STATIA_19=Y
        УХОиКС:   ??STATIA_14=Y
        ОКС:   ??STATIA_18=Y|STATIA_19=Y
    </b>
    <table id="acceptlisttable" style="width:750px; margin:0;">
        <tr><th  style="width:300px;">Сотрудник</th><th  style="width:270px;">Подпись, Дата</th><th  style="width:170px;">Комментарий</th></tr>
        <tr><td class="e">&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
    </table>
[end]


[buh]
    <table id="acceptlisttable" style="width:750px; margin:0;">
        <tr><td colspan=3 style="border:none;"><b>Бухгалтерия:</b></td></tr>
        <tr><th  style="width:300px;">Сотрудник</th><th  style="width:270px;">Подпись, Дата</th><th  style="width:170px;">Комментарий</th></tr>
        <tr><td class="e">&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
        <tr><td class="e">&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
    </table>
[end]


==============================================================
==============================================================
==============================================================


[SQL]
    select wf.id as step_id, wf.step, wf.role_id, wf.role_target_type_id, wf.role_target_id, wf.role_comment
        , wf.step_type, wf.criteria, wf.is_active
        , r.name as "ROLE_NAME", tt.type as "TARGET_TYPE"
         ,i.name as "INFO_NAME", i.id as "INFO_ID", i.table_name as "INFO_TABLE"
        , wf.user_id, wf.modifier_id, wf.modifier_comment

        , iof(u.F, u.I, u.O) as "USER_IOF"   
        , iof(um.F, um.I, um.O) as "MODIFIER_IOF"   
        , concat(LEFT(um.I,1),'.',LEFT(um.O,1),'.',um.F) as "MODIFIER_IOF"    ??

        , wf.result_code, wf.result
        , if(wf.started is null, '', DATE_FORMAT(wf.started,'#shortDateTimeFormat#')) as "STARTED" ??
        , if(wf.finished is null, '', replace(DATE_FORMAT(wf.finished,'%d.%m.%Y'),' ','&nbsp;')) as "FINISHED"
          %H:%i ??
        , wf.comment ??
    from wf
        left join a_roles r on r.id=wf.role_id
        left join a_target_types tt on tt.id=wf.role_target_type_id
        left join i_infos i on i.id = tt.info_id
        left join #table_users_full# u on u.id=wf.user_id
        left join #table_users_full# um on um.id=wf.modifier_id
    where wf.wf_id=#WF_ID# 
        and wf.step_type not in(#~wf_step_process#) ??
        and not wf.started is null 
        and wf.result_code=1
        and (step=0 or (wf.step_type>-1 and not wf.user_id=#CREATOR_ID#)) ??
        and wf.step_type>-1 and (not wf.user_id=#CREATOR_ID# or wf.role_id>0)
Скитин - wf.user_id=3765 ??
        and (wf.result not like 'Уже согласовано на шаге%' or wf.user_id=3765) ??
        and (wf.result not like 'Уже согласовано на шаге%' or not wf.role_id is null)
----- Оставляем только центральную бухгалтерию, экономиста, дир.лаб. ??
        and wf.role_id in(5, 10, 16, 62, 6, 8)
        and not (wf.role_id in(10) and role_target_type_id=1)

    ... убираем Гусарову по просьбе Довгун, бух.-дог лаб. МТС лаб. ??
    ... 51 - УХОиКС (контроль), 55 - ОКС-договоры  ??
        and (not wf.role_id in(10, 25, 23, 55)  or wf.user_id=3765) ??
        and (not wf.role_id in(25, 23) or wf.user_id=8357) ??
    ... убираем Панкратову, как дублирующего экономиста ??
        and not wf.user_id=8260
    ... убираем леснинову, как дублирующего экономиста ??
        and not wf.user_id=2436

        and wf.is_active=1 ??
        and not wf.result='не требуется' ??
    order by wf.step, wf.is_active desc, wf.id
     , started desc ??
[end]

[get target name]
    select field_db_name as "INFO_FIELD_NAME" from i_fields where info_id=#INFO_ID# and view1=1
    ;
    select #INFO_FIELD_NAME# as "TARGET_NAME" from #INFO_TABLE# where id=#role_target_id#
[end]

