JINR/info/tender_participant_edit_data.mod

[comments]
descr=Ручное редактирование записи справочника участников закупочных конкурсов
input=info_id - ID выбранного справочника, record_id - ID записи в справочнике
output=HTML форма редактирования записи справочника, 
parents=JINR/info/tender_participant, JINR/info/tender_participant_add, JINR/info/tender_participant_kontragent_data
childs=
testURL=?c=JINR/info/tender_participant_edit_data&cop=edit&info_id=1014&record_id=1
author=Куняев, Яковлев
[end]

[description]
Модуль редактирования данных участников закупочных конкурсов
[end]


[parameters]
request_name=U:редактир. данных справочника
service=jinr.sed.ServiceEditInfoData
tableCfg=table_no
KeepLog=false
ClearLog=true
divider=<tr><td colspan=2 class="bg_white" style="height:10px; border-top:solid 1px gray;"></td></tr>
SYS_FIELDS=IS_DELETED, IS_MANUAL, DATE_FORMAT(changed,'#dateTimeFormat#') as MODIFIED
SYS_FIELDS_UPDATE=IS_DELETED, IS_MANUAL, CHANGED
SYS_FIELDS_TYPES=boolean,boolean,sysdate
[end]


[report header]
+++++++ временно - открыто всем. Потом - проверить R и RW права пользователя +++ ??
$SET_PARAMETERS RWACC=Y; RACC=Y;
$INCLUDE [set defaults]  ??cop
$INCLUDE [OK report header]  ??RACC&!cop=save
[end]

[set defaults]
$SET_PARAMETERS VIEW1=0; ??!VIEW1
$SET_PARAMETERS VIEW2=0; ??!VIEW2
$SET_PARAMETERS VIEW3=0; ??!VIEW3
$SET_PARAMETERS IS_DELETED=0; ??!IS_DELETED
$SET_PARAMETERS IS_MANUAL=0; ??!IS_MANUAL
[end]

[OK report header]
--------------------------------------------- ??
------------ возвращаемые результаты --------- ??
--------------------------------------------- ??
$GET_DATA [CreateNewRecordSQL] ??cop=new
$INCLUDE [add record from i_kontragent]  ??cop=add
<div id="result">
<small>#c#</small> ??debug=on
<form name="popupForm" method="POST" enctype="multipart/form-data" target="wf">
<input type=hidden name="c" value="#c#">
<input type=hidden name="info_id" value="#info_id#">
<input type=hidden name="cop" value="">
<input type=hidden name=record_id value='#record_id#'>
<center>
++++++++++++++++++ Шапка таблицы  +++++++++++++++++++++ ??
<table border=0 bgcolor=white cellpadding=4 >
<tr><td class=center><b>
Создание нового участника  ??cop=new
Добавление из справочника контрагентов  ??cop=add&REAL_ID_COUNT=0
Такой участник уже существует :  ??cop=add&REAL_ID_COUNT=1
Редактирование участника закупочного конкурса  ??cop=edit
</b></td></tr></table>

<table border=0 class="tlist" cellpadding=0 cellspacing=0>
$SET_PARAMETERS RO=readonly;
[end]

[CreateNewRecordSQL]
select 
ifnull(min(id), 0) - 1 as "record_id" from #TABLE_NAME# 
;
insert into #TABLE_NAME# (id) values (#record_id#)
;
[end]


[add record from i_kontragent]
$SET_PARAMETERS REAL_ID_COUNT=0;
$GET_DATA [getCountIdInfoSQL]
$GET_DATA [getFeelInfoFromKontragentSQL]  ??REAL_ID_COUNT=0
[end]

[getCountIdInfoSQL]
select count(id) as REAL_ID_COUNT
    from #TABLE_NAME# 
    where id = #record_id#
[end]

[getFeelInfoFromKontragentSQL]    
insert into #TABLE_NAME# (id, name, full_name, inn, 1C_GUID) 
    select 
    i_kontragent.id
    , i_kontragent.name
    , i_kontragent.name
    , i_kontragent.inn
    , i_kontragent.1C_GUID
        from i_kontragent 
        where i_kontragent.id = #record_id#
[end]


============== Вывод одного поля для редактирования ======= ??
[item]
<tr><td class=label>#NAME#
(#COMMENT#) ??COMMENT
: </td>
$INCLUDE [input] ??TYPE=int|SIZE<64
$INCLUDE [text] ??TYPE=varchar&SIZE>63
$INCLUDE [date field] ??TYPE=date
</tr>
[end]

[input]
<td><input size=#SIZE# class="#RO#" #RO# name=#FIELD_DB_NAME# value="^#FIELD_DB_NAME#"></td>
$SET_PARAMETERS RO=;
[end]

[text]
<td><textarea cols=60 name=#FIELD_DB_NAME# rows=2>^#FIELD_DB_NAME#</textarea>
[end]


[date field]
<td>
$INCLUDE dat/doc_fields.dat[date field w]
</td>
[end]


[report footer]
</form>
$INCLUDE [view footer]  ??!cop=save
$INCLUDE [save footer]  ??cop=save
[end]

[view footer]
++++++++++++ Конец формы редактирования записи ++++++++++ ??
<tr><td></td><td>
<input type=checkbox name="IS_DELETED" value="1"
checked ??IS_DELETED=1
>Помечена на удаление

</td></tr>
<tr><td colspan=2 class="right small">Запись обновлена: #MODIFIED#</td></tr>
</table>
<input type="button" class="butt1" style="width:100;" value="Отмена" onClick="
AjaxCall('d_spravCont', 'c=JINR/info/tender_participant_add&irpp=30&START_REC=1');"  ??cop=new|cop=add
AjaxCall('d_spravCont', 'c=JINR/info/tender_participant&info_id=1014&requesterId=provider&multi=0&view=2&TABLE_NAME=i_jinr_tender_participant&irpp=30&START_REC=1');"  ??cop=edit
>

<input type="button" class="butt1" style="width:120;" value="Сохранить" onClick="document.popupForm.cop.value='save'; document.popupForm.submit();">

+++++++++ Скрипт отображения pop-up окна ++++ ??
<script>
window.parent.ShowDialog(true);  ??
window.parent.showMsg("##dialog_title", "Редактирование данных справочника #INFO_NAME#");
window.parent.centerDialog();  ??
</script>
[end]


+++++++++ Скрипт обновления таблицы данных в вызывавшей странице ++++ ??
+++++++++ (Pop-up окно уже закрыто по кнопке на предыд. шаге) +++ ??
[save footer]

<script>
+++++ Сабмит родительской формы. +++ ??
window.parent.AjaxCall('d_spravCont', 'c=JINR/info/tender_participant&info_id=1014&requesterId=provider&multi=0&view=2&TABLE_NAME=i_jinr_tender_participant&irpp=30&START_REC=1&f_name=#name#');  ??!ERROR
alert(" Ошибка при создании новой записи!"); ??ERROR
</script>
[end]


***************************** Шаблоны SQL запросов ***************************
[preSQLs]
select i.ID as "INFO_ID"
, i.name as INFO_NAME, i.IS_EXTERNAL
, i.IS_TREE, i.IS_ACTIVE
, i.TABLE_NAME
, data_updated 
from i_infos i
where i.Id=#info_id#
;
select concat(field_db_name, ',') as FIELDS
 , concat(name, ',') as FIELDS_NAMES ??
 , concat(type, ',') as FIELDS_TYPES
from i_fields
where info_id=#info_id#
order by nr
;
select count(field_db_name) as NUM_FIELDS, count(field_db_name)+ 1 as NUM_COLUMNS
from i_fields where info_id=#info_id#
;
[end]


[SQL]
select NR, NAME, TYPE, SIZE, COMMENT, FIELD_DB_NAME
from i_fields i
where info_id=#info_id#
order by nr
[end]
