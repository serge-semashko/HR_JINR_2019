wf/print_wf_old.cfg

wf/print_wf.cfg

[comments]
descr=S: Показать рабочее workflow для документа. 
input=doc_id - ID документа
output=Показывает рабочее workflow документа.
parents=
childs=
testURL=?c=wf/print_wf&doc_id=1
author=Куняев
[end]


[parameters]
service=dubna.walt.service.TableServiceSpecial
request_name=A:отображение wf для док. #doc_id#
tableCfg=table_no
LOG=ON
[end]


[report header]
$CALL_SERVICE c=svs/get_user_info; requested_user_id=#USER_ID#  ??



$GET_DATA [get wf id]  

$INCLUDE [table headers] ??WF_ID
[end]

[table headers]
$GET_DATA docs/view_doc.cfg[getDocInfo]

<html>
<head>
<style type="text/css">
##acceptlisttable{ border-spacing:0px; border-collapse: collapse; max-width:900px;}
##acceptlisttable td, th{border:1px solid black; padding:6px;}
##acceptlisttable th{background:#EEE;}
.printrow td{ text-align:center; } ??
##acceptlisttable td.printheader {max-width:900px; text-align:center; font-size:14pt;}
td { padding: 5px; vertical-align:top;}
</style>

<script type="text/javascript" language="javascript">
window.print();  
</script>
</head>
<body>


<div style="margin:10px 0 20px 200px; font-size:13pt;">
#DOC_TYPE#
№#number# ??number_ZZZ
#NUMBER# ??NUMBER
от #DOC_DATE# ??DOC_DATE
<br>#title#
</div>

<table id = "acceptlisttable" width="90%">

<tr><td class="printheader" colspan=4>Маршрут документа</td></tr>

<tr>
<th>Дата</th> 
<th>Пользователь</th>
<th>Результат</th>
<th>Комментарий</th></tr>
[end]


[item]
$SET_PARAMETERS st=style="border-top:solid 1px gray&##59"; ??!PREV_STEP=#step#
$SET_PARAMETERS st=; ??PREV_STEP=#step#&prev_role_id=#role_id#

$SET_PARAMETERS cl=;
$SET_PARAMETERS cl=#cl# step_waiting; ??STARTED&!result_code&is_active=1
$SET_PARAMETERS cl=#cl# inactive; ??!is_active=1

<tr><td colspan=4 style="border:none;">&nbsp;</td></tr>??step_type=#~wf_step_process#

<tr class="#cl#">

<td class="center" #st#>
#FINISHED#</td>

$CALL_SERVICE c=svs/get_user_info; requested_user_id=#user_id#  ??!ROLE_NAME&user_id>0&ZZZ
$SET_PARAMETERS ROLE_NAME=#u_roles#; ??!ROLE_NAME&ZZZ
$SET_PARAMETERS ROLE_NAME=#u_posts#; ??!ROLE_NAME&ZZZ

<td #st#>
#USER_IOF# 
<br><small>
#ROLE_NAME# ??ROLE_NAME&!prev_role_id=#role_id#
$GET_DATA [get target name] ??role_target_id&INFO_ID
#TARGET_NAME# ??!PREV_TARGET_NAME=#TARGET_NAME#
<br>(информирование) ??step_type=#~wf_step_information#&st
<br>(утверждение) ??step_type=#~wf_step_signed#&st
<br>(исполнение) ??step_type=#~wf_step_process#&st
(#role_comment#) ??role_comment

<br><span class="bg_yellow" style="color:##000080;">#modifier_comment#</span> ??modifier_comment
</small></td>

<td #st#>
#result#  
<br>(возвращено инициатору) ??result_code=#~doc_action_reject#
</td>

<td #st#>
#step_id#: ??
#comment# 
</td>

$SET_PARAMETERS NEXT_STEP_ID=#step_id#;  ??!NEXT_STEP_ID&STARTED&!result_code
$SET_PARAMETERS prev_role_id=#role_id#; prev_role_target_id=#role_target_id#; PREV_TARGET_NAME=#TARGET_NAME#; PREV_STEP=#step#;
$SET_PARAMETERS role_id=; ROLE_NAME=; INFO_ID=; role_target_id=; user_id=; u_FIO=; result_code=; result=; STARTED=; TARGET_NAME=; PREV_STEP=#step#; criteria=;
$SET_PARAMETERS u_roles=; u_posts=;
</tr>
[end]



[report footer]
</table>
</td></tr></table>
#ERROR#
</body></html>
[end]


==============================================================
==============================================================
==============================================================

[get wf id]
select id as "WF_ID" from wf_list where doc_id=#doc_id#;
[end]

[SQL]
$INCLUDE [SQL_] ??WF_ID
[end]

[SQL_]
select wf.id as step_id, wf.step, wf.role_id, wf.role_target_type_id, wf.role_target_id, wf.role_comment
, wf.step_type, wf.criteria, wf.is_active
, r.name as "ROLE_NAME", tt.type as "TARGET_TYPE"
 ,i.name as "INFO_NAME", i.id as "INFO_ID", i.table_name as "INFO_TABLE"
, wf.user_id, wf.modifier_id, wf.modifier_comment
, iof(u.F, u.I, u.O) as "USER_IOF"   
, iof(um.F, um.I, um.O) as "MODIFIER_IOF"   
, concat(LEFT(um.I,1),'.',LEFT(um.O,1),'.',um.F) as "MODIFIER_IOF"    ??
, result_code, result
, if(wf.started is null, '', DATE_FORMAT(wf.started,'#shortDateTimeFormat#')) as "STARTED" ??
, if(wf.finished is null, '', replace(DATE_FORMAT(wf.finished,'%d.%m.%Y %H:%i'),' ','&nbsp;')) as "FINISHED"
, wf.comment
from wf
left join a_roles r on r.id=wf.role_id
left join a_target_types tt on tt.id=wf.role_target_type_id
left join i_infos i on i.id = tt.info_id
left join #table_users_full# u on u.id=wf.user_id
left join #table_users_full# um on um.id=wf.modifier_id
where wf.wf_id=#WF_ID# 
    and not wf.started is null 
    and not wf.result='не требуется'
order by wf.step, wf.is_active desc, wf.id
 , started desc ??
[end]

[get target name]
select field_db_name as "INFO_FIELD_NAME" from i_fields where info_id=#INFO_ID# and view1=1
;
select #INFO_FIELD_NAME# as "TARGET_NAME" from #INFO_TABLE# where id=#role_target_id#
[end]
