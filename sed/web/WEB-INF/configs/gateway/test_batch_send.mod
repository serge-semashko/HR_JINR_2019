gateway/test_batch_send.mod

[comments]
descr=U: Тест пакетной посылки в шлюз
input=[type_id] - тип документа или [info_id] - ID справочника, который необходимо послать, [info_view] - представление (для справочника), [criteria] - дополнительный специфический критерий отбора
output=
parents=
childs=
testURL=?c=gateway/test_batch_send&info_id=1017&info_view=3&criteria=id in(15,16)
author=Куняев
[end]


[parameters]
service=dubna.walt.service.TableServiceSpecial
request_name=U:Batch-посылка документов
LOG=ON 
tableCfg=table_no
[end]


[report header]
$INCLUDE dat/common.dat[head]
</head><body style="padding:30px;">

$GET_DATA [get info table]  ??info_id&!group_id

++++++++++++++++++ Шапка таблицы ПОСЫЛКИ документов +++++++++++++++++++++ ??
$SET_PARAMETERS srn=1; rpp=9999;
tm=#tm#
<table class="tlist tblue" cellspacing=0>
<tr>
<th>id</th> 
<th>Документ</th>
<th>Статус</th> 
<th>Содержание</th>
<th>+++</th>
<th>Результат</th> 
<th>Dest.ID</th> 
</tr>
[end]

[item]
++++++++++++++++++ Строка таблицы - 1 документ +++++++++++++++++++++ ??
$CALL_SERVICE c=gateway/post_doc; doc_id=#doc_id#; silent=Y;  ??type_id
$CALL_SERVICE c=gateway/post_info; doc_id=#doc_id#; silent=Y;  ??info_id&!group_id
<tr class="pt
oddRow ??oddRow=1
"> <td style="padding:0;">#doc_id# </td>
<td>#DOC_TYPE# №#NUMBER# от #DOC_DATE#</td> 
<td>
В процессе согласования ??STATUS=1
На этапе завершения ??STATUS=2
Завершен ??STATUS=3
</td>
<td>#TITLE#</td>
<td>#DIVS#</td>
<td>#ResultCode#: #Result#</td> 
<td>#DestObjectID#</td> 
</tr>
[end]


[report footer]
</table>
tm=#tm#
[end]

***************************** Шаблон SQL запроса ***************************

[get info table]
    select table_name
    from i_infos
    where id=#info_id#
[end]

[SQL]
$INCLUDE [SQL-docs] ??type_id
$INCLUDE [SQL-info] ??info_id&!group_id
[end]

[SQL-docs]
    select
        dh.ID as doc_id
        , dh.TYPE_ID, dh.STATUS
        , dh.NUMBER, dh.TITLE, DATE_FORMAT(dh.doc_date,'#dateFormat#') as DOC_DATE 
        , dtp.NAME AS DOC_TYPE 
    from d_list dh
    where type_id=#type_id#
        and dh.STATUS>0
        and #criteria#   ??criteria
    and dh.id=533 ??
    order by dh.modified 
    desc  ??
[end]

input=info_id - ID справочника, info_view - представление, rec_id - ID записи

[SQL-info]
    select id as "rec_id"
    from #table_name#
    where is_deleted=0
        and view#info_view# > 0 
        and #criteria#   ??criteria
    order by changed
[end]
