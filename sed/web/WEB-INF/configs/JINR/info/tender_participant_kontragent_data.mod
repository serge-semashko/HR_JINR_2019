JINR/info/tender_participant_kontragent_data.mod

[comments]
descr=Модуль вывода данных справочника контрагентов (непосредственно вывод таблицы)
input=requesterId - ID элемента для результата, info_id - ID справочника; view - № представления. По умолчанию - 1; searchFor - строка поиска.
output=html-таблица заданного представления справочника. По клику возвращает 1-е (код записи или ID) и 2-е (текст) поля представления. 
parents=JINR/info/tender_participant_add.cfg
childs=JINR/info/tender_participant_edit_data
testURL=?c=JINR/info/tender_participant_data
author=Куняев, Яковлев
[end]

[description]
Модуль вывода данных справочника контрагентов (непосредственно вывод таблицы).<br>
<ul><li>Выводит в виде таблицы контрагентов из справочника.<br>
По выбору контагента открывается форма редактирования данных участников закупочных<br>
конкурсов с данными, полученными от выбранного контрагента<br>
(вызывает модуль JINR/info/tender_participant_edit_data).</li>
</ul>
[end]

[parameters]
request_name=U:вывод данных справочника контрагентов
service=dubna.walt.service.TableServiceSpecial
tableCfg=table_no
KeepLog=true
ClearLog=false
info_src=false
[end]


[report header]
$GET_DATA [get num records]

$SET_PARAMETERS callback=pasteInfoResult; ??!callback
<div id="result_table">
info_src=#info_src#; ??
<small>c=JINR/info/tender_participant_data</small> ??debug=on
<center>
============ Начало таблицы =============== ??
irpp=#irpp#; isrn=#isrn#; ??
<table border=0 class="tlist dd_info" id = "#requesterId#_info_table" cellpadding=0 cellspacing=0>

<tr>
<th>ID</th>  ??
<th>ИНН</th>
<th>Наименование</th>
<th>1C GUID</th>  ??
</tr>

[end]


============ Строка таблицы =============== ??
[item]

$SET_PARAMETERS returnValue=#returnValue#  ??
<tr class="pt" 
onClick="
AjaxCall('d_spravCont', 'c=JINR/info/tender_participant_edit_data&cop=add&info_id=1014&record_id=#CODE#');" >

<td class="marked-cell"></td> ??
<td>#CODE#</td>  ??
<td>#INN#</td>
<td>#NAME#</td>
<td>#1C_GUID#</td>  ??
</tr>
[end]

[prevLink]
<span class="pt" onClick="showSpecialNext(-1);"> << </span>
[end]

[nextLink]
<span class="pt" onClick="showSpecialNext(1);"> >> </span>
[end]


[report footer]
<tr><td colspan=3 class="divider"></td><td colspan=2 class="divider">
$SET_PARAMETERS HAS_PREV=Y; ??START_REC>1
$SET_PARAMETERS HAS_NEXT=Y; ??END_REC<#TOT_NUM_RECS#
$INCLUDE [prevLink] ??HAS_PREV=Y
строки #START_REC#-#END_REC# из #TOT_NUM_RECS#  ??TOT_NUM_RECS>0
#TOT_NUM_RECS#: <b>Нет данных</b>  ??!TOT_NUM_RECS>0
$INCLUDE [nextLink] ??HAS_NEXT=Y
</center>
<b>ОШИБКА:</b> #ERROR# ??ERROR
</td></tr>
</table>
</div>

<script type="text/javascript">
window.parent.getResult("info_result_data", document.getElementById("result_table"));
</script>
[end]


==============================================================
==============================================================
==============================================================

[preSQLs]
select #START_REC#-1 as "isrn", #START_REC#+#irpp#-1 as END_REC
;
[end]

[get num records]
select count(*) as TOT_NUM_RECS
$INCLUDE [criteria]
[end]

[SQL]
select ik.id as "CODE", ik.name as "NAME"
    , tp.name as "returnValue"  ??
    , ik.inn as "INN", ik.1C_GUID as "1C_GUID" 

$INCLUDE [criteria]
order by ik.id
LIMIT #isrn#,#irpp#
[end]

[criteria]
from i_kontragent ik
where 1=1
and ik.name like '%#f_k_name#%'  ??f_k_name
and ik.inn = '#f_k_INN#' ??f_k_INN
[end]
