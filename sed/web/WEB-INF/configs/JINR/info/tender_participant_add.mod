JINR/info/tender_participant_add.mod

[comments]
descr=Добавление участников закупочных конкурсов в соответствующий справочник.
input=requesterId - ID элемента для результата, info_id - ID справочника; view - № представления. По умолчанию - 1 (все поля по порядку); searchFor - строка поиска.
output=Pup-up окно с данными справочника с фильрами по колонкам представления и с выбором записи
parents=JINR/info/tender_participant
childs=JINR/info/tender_participant_kontragent_data, JINR/info/tender_participant_edit_data, JINR/info/tender_participant
testURL=?c=JINR/info/tender_participant_add&irpp=30&START_REC=1
author=Куняев, Яковлев
[end]

[description]
Модуль добавления новых участников закупочных конкурсов в справочник.<br>
Добавление новых участников закупочных конкурсов возможно двумя способами:<br>
<ul><li>Выбор из справочника контрагентов<br>
Для этого выводится форма поиска по справочнику контрагентов и вызывает модуль<br>
вывода соответсвующей таблицы (JINR/info/tender_participant_kontragent_data).<br>
При выборе из списка требуемого контрагента открывается форма редактирования участника<br>
закупочных конкурсов с данными, полученными от выбранного контрагента<br>
(вызывает модуль JINR/info/tender_participant_edit_data).</li>
<li>Создание нового нового участника закупочного конкурса<br>
В этом случае открывается форма редактирования участника закупочных конкурсов<br>
(вызывает модуль JINR/info/tender_participant_edit_data).</li>
</ul>
[end]

[parameters]
request_name=U:Добавление участников закупочных конкурсов
KeepLog=true
ClearLog=false
[end]


[report]
$SET_PARAMETERS irpp=30;
$SET_PARAMETERS searchFor=; ??searchFor=none|searchFor=undefined
$SET_PARAMETERS START_REC=1; ??!START_REC

<style>table.tlist td, table.tlist th{font-size:8pt;}
fieldset.border {border:solid 1px ##a0a0a0; padding:0;}
##d_sprav_window {background-color:##606060;}
##d_spravCont {background-color:white; margin: 0px 3px 3px 3px;}
table.tlist td, table.tlist th {font-size: 10pt;}
</style>

$SET_PARAMETERS ERROR=;

============ SEARCH FORM =============== ??
<div style="border:solid 1px red;"> ??
<form name="infoSpecialForm" method="POST" enctype="multipart/form-data" 
onSubmit="return false;" 
target="wf2"    
>
<input type=hidden name=c value="JINR/info/tender_participant_kontragent_data">
<input type=hidden name=requesterId value="#requesterId#"> 
<input type=hidden name=info_id value="#info_id#"> 
<input type=hidden name=multi id = "multi" value="#multi#"/> 
<input type=hidden name=view value="#view#"> 
<input type=hidden name=TABLE_NAME value="#TABLE_NAME#"> 
<input type=hidden name=START_REC value="#START_REC#"> 
<input type=hidden name=irpp value="#irpp#"> 
<input type=hidden name=standalone value="yes">    ??standalone=yes

<fieldset class="border">
<table border=0 cellpadding=5 cellspacing=0 style="border:none 1px gray; background-color:##efefef; width:100%;">

<tr><td><center>
<input type="submit" class="butt1 pt" style="width:250;  margin:5px 50px 10px 10px;" value="Добавить нового участника" onClick="
AjaxCall('d_spravCont', 'c=JINR/info/tender_participant_edit_data&cop=new&info_id=1014');" >

</center></td></tr>

</table>
</fieldset>

<fieldset class="border"><legend><b>Выбрать из справочника контрагентов:</b></legend>
<table border=0 cellpadding=5 cellspacing=0 style="border:none 1px gray; background-color:##efefef; width:100%;">

<tr><td class="label">Наименование:&nbsp;</td><td class="nowrap"><input size=50 name="f_k_name"> 
</td>
<td></td></tr>

<tr><td class="label">ИНН:&nbsp;</td><td class="nowrap"><input size=25 name="f_k_INN"> 
</td>
<td>
<input type="submit" class="butt1 pt" style="width:100;  margin:5px 50px 10px 10px;" value="Искать" onClick="doIt();" > 
</td></tr>

</table>
</fieldset>

<div id="info_result_data" style="overflow-y:scroll; height:500px; padding:10px; margin:2px; border:solid 1px ##a0a0a0;"></div>
<center>
<input type="button" class="butt1 pt" style="width:280; margin:5px;" value="В справочник участников конкурса" onClick="
AjaxCall('d_spravCont', 'c=JINR/info/tender_participant&info_id=1014&requesterId=provider&multi=0&view=2&TABLE_NAME=i_jinr_tender_participant&irpp=30&START_REC=1');" > 
</center>
</form>

$INCLUDE svs/info_show_plain_script.dat[css]  ??!INFO_CSS_LOADED
$INCLUDE svs/info_show_plain_script.dat[script] 

<script type="text/javascript">
var infoSpecialForm = document.infoSpecialForm;
infoSpecialForm.searchFor.focus();  ??

/**
 * Загрузка данных справочника БК ОИЯИ
 * Submit document.infoForm
 */
var doIt=function()
{
log(3, "JINR/info/tender_participant.cfg.doIt...");  ??
    document.infoSpecialForm.START_REC.value=1;
    document.infoSpecialForm.submit();
}

/**
 * Перегрузка стандартной функции поиска по плоскому справочнику
 */
var doSearch=function(){
    log(3, "JINR/info/tender_participant.cfg.doSearch()");
    document.infoSpecialForm.submit();
}

var showSpecialNext  = function(shift){
	var start_rec = Number(document.infoSpecialForm.START_REC.value);
	var irpp = Number(document.infoSpecialForm.irpp.value);
	
	if(shift > 0)
		start_rec = start_rec + irpp;
	else if(shift < 0)
		start_rec = start_rec - irpp;
	else
		start_rec = 1;
	if(start_rec < 1) start_rec = 1;
	
	document.infoSpecialForm.START_REC.value = start_rec;
	doSearch();
}


doIt();

    $('##d_spravCont').css({
        width: 900
    });
    $( "##d_sprav_window" ).resizable();  ??

</script>
============ Контейнер для данных =============== ??
</center>
<b>ОШИБКА:</b> #ERROR# ??ERROR
[end]
