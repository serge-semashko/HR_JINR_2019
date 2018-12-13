JINR/info/tender_participant_data.mod

[comments]
descr=Модуль вывода данных справочника участников закупочных конкурсов (непосредственно вывод таблицы)
input=requesterId - ID элемента для результата, info_id - ID справочника; view - № представления. По умолчанию - 1; searchFor - строка поиска.
output=html-таблица заданного представления справочника. По клику возвращает 1-е (код записи или ID) и 2-е (текст) поля представления. 
parents=JINR/info/tender_participant.cfg
childs=JINR/info/tender_participant_edit_data
testURL=?c=JINR/info/tender_participant_data&info_id=1014&view=2
author=Куняев, Яковлев
[end]

[description]
Модуль вывода данных справочника участников закупочных конкурсов (непосредственно вывод таблицы).<br>
<ul><li>Выводит в виде таблицы участников закупочных конкурсов из справочника.</li>
<li>Также предоставляет возможность редактирования данных участников закупочных конкурсов<br>
(вызывает модуль JINR/info/tender_participant_edit_data).</li>
</ul>
[end]

[parameters]
request_name=U:вывод данных справочника участников закупочных конкурсов
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
<th>Id</th>  ??
<th>Название</th>
<th>ИНН</th>
<th>Контактное лицо</th>
<th></th>
</tr>
[end]


============ Строка таблицы =============== ??
[item]

$SET_PARAMETERS returnValue=#returnValue#  ??
<tr class="pt" 
onClick="selectInfoItem(this,'#returnValue#'); hideSprav();"  ??
info_id=#info_id# view=3 returnId="#CODE#" recordId="#CODE#"  ??
>
<td class="marked-cell"></td> ??
<td>#CODE#</td>  ??
<td
onClick="selectInfoItem(this,'#returnValue#'); hideSprav();"
info_id=#info_id# view=3 returnId="#CODE#" recordId="#CODE#"
>#NAME#</td>
<td
onClick="selectInfoItem(this,'#returnValue#'); hideSprav();"
info_id=#info_id# view=3 returnId="#CODE#" recordId="#CODE#"
>#INN#</td>
<td
onClick="selectInfoItem(this,'#returnValue#'); hideSprav();"
info_id=#info_id# view=3 returnId="#CODE#" recordId="#CODE#"
>#CONTACT_PERSON#</td>
<td onClick="
AjaxCall('d_spravCont', 'c=JINR/info/tender_participant_edit_data&cop=edit&info_id=1014&record_id=#CODE#');">
<i class="fa fa-pencil-square-o" aria-hidden="true"></i></td>

</tr>
[end]

[prevLink]
<span class="pt" onClick="showNext(-1);"> << </span>
[end]

[nextLink]
<span class="pt" onClick="showNext(1);"> >> </span>
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
select tp.id as "CODE", tp.name as "NAME"
    , replace(tp.name,'"','``') as "returnValue"
    , tp.inn as "INN", tp.contact_person as "CONTACT_PERSON" 
$INCLUDE [criteria]
order by tp.name
LIMIT #isrn#,#irpp#
[end]

[criteria]
from i_jinr_tender_participant tp
where 1=1
and tp.name like '%#f_name#%'  ??f_name
and tp.inn = '#f_INN#' ??f_INN
[end]
