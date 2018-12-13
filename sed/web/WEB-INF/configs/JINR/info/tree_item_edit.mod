[comments]
descr=А: Ручное редактирование записи справочника.

input=info_id - ID выбранного справочника, record_id - ID записи в справочнике
output=HTML форма редактирования записи справочника, 
parents=admin/infos/info_viewData.cfg
childs=
test_URL=?c=admin/infos/info_editRecord&info_id=10&record_id=2000
[end]

[parameters]
request_name=A:редактир. данных справочника
service=jinr.sed.ServiceEditInfoData
tableCfg=table_no
KeepLog=false
ClearLog=true
SYS_FIELDS=IS_DELETED, IS_MANUAL, DATE_FORMAT(changed,'#dateTimeFormat#') as MODIFIED, MODIFIER_ID
SYS_FIELDS_UPDATE=IS_DELETED, IS_MANUAL, CHANGED, MODIFIER_ID
SYS_FIELDS_TYPES=boolean,boolean,sysdate,int
[end]


[report header]
$GET_DATA [getChildren]  ??!cop=add
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
$SET_PARAMETERS parent_id=-1;  ??!parent_id&cop=add
$GET_DATA [addNewRecord] ??cop=add
<div id="result">
<small>#c#</small> ??debug=on
<form name="popupForm" method="POST" enctype="multipart/form-data" target="wf">
<input type=hidden name="c" value="#c#">
<input type=hidden name="info_id" value="#info_id#">
<input type=hidden name=view value='#view#'>
<input type=hidden name="requesterId" value="#requesterId#">

<input type=hidden name="cop" value="">
<input type=hidden name="record_id" value="#record_id#">
<input type=hidden name="parent_id" value="#parent_id#">
<input type=hidden name="init_id_value" id="init_id_value" value="#init_id_value#">

$INCLUDE [init id value] ??cop=add|cop=edit


INFO_TREE_CHILDREN = #INFO_TREE_CHILDREN#  ??

<center>
++++++++++++++++++ Шапка таблицы  +++++++++++++++++++++ ??
<b>Создание новой записи</b> parent_id=#parent_id# ??cop=add
<b>Редактирование записи</b>  ??cop=edit
<table border=0 class="tlist" cellpadding=0 cellspacing=0>

<tr><td style="width:35%">Поле:</td>
<td style="width:65%">Значение:</td></tr>

$SET_PARAMETERS RO=readonly;  ??
$SET_PARAMETERS RO=;
[end]


[addNewRecord]
select 
ifnull(max(id), 0) + 1 ??!IS_EXTERNAL=1
ifnull(min(id), 0) - 1 ??IS_EXTERNAL=1
as "record_id" from #TABLE_NAME# 
;
insert into #TABLE_NAME# (id) values (#record_id#)  ??
insert into #TABLE_NAME# (id, pid) values (#record_id#, #parent_id#)
;
[end]

[init id value]
<script type="text/javascript">
    $('##init_id_value').val('#record_id#');
</script>
[end]

============== Вывод одного поля для редактирования ======= ??
[item]
    $INCLUDE [hidden field]  ??!IS_VISIBLE=1
    $INCLUDE [visible field]  ??IS_VISIBLE=1
[end]


[hidden field]
    <input type=hidden name=#FIELD_DB_NAME# value="^#FIELD_DB_NAME#">
    #FIELD_DB_NAME# = ^#FIELD_DB_NAME#  ??USER_ID=4790
[end]


[visible field]
    <tr><td class=label>
    #NAME#  ??
    #COMMENT# ??COMMENT
    : </td>

    <td>
        $INCLUDE [set editable rights]
        $INCLUDE [editable]  ??EDITABLE_FIELD=1
        $INCLUDE [not editable]  ??EDITABLE_FIELD=0
        
    </td>
[end]

=============== установка прав на редактирование поля ==================== ??
=============== по умолчанию права открыты ==================== ??

[set editable rights]
    $SET_PARAMETERS EDITABLE_FIELD=1;
    $INCLUDE [set 1017 editable rights]  ??info_id=1017
[end]

[set 1017 editable rights]
    $SET_PARAMETERS EDITABLE_FIELD=0;  ??is_final=1&FIN_EDITABLE=0
    $SET_PARAMETERS EDITABLE_FIELD=0;  ??FIELD_DB_NAME=begin_date&INFO_TREE_CHILDREN
    $SET_PARAMETERS EDITABLE_FIELD=0;  ??FIELD_DB_NAME=end_date&INFO_TREE_CHILDREN
[end]

=============== Тип : Int, varchar ==================== ??

[editable]
    $INCLUDE [input] ??TYPE=int|SIZE<64
    $INCLUDE [text] ??TYPE=varchar&SIZE>63
    $INCLUDE [date_write] ??TYPE=date
    $INCLUDE [cb_write] ??TYPE=boolean
[end]

[not editable]
    $INCLUDE [text_read]  ??TYPE=int|TYPE=varchar
    $INCLUDE [date_read]  ??TYPE=date
    $INCLUDE [cb_read]  ??TYPE=boolean
[end]


=============== Тип : Int, varchar ==================== ??
[input]
    <input size=#SIZE# class="#RO#" #RO# name=#FIELD_DB_NAME# value="^#FIELD_DB_NAME#">  
[end]

[text]
    <textarea cols=85 name=#FIELD_DB_NAME# rows=3>^#FIELD_DB_NAME#</textarea>
[end]

[text_read]
    <input type=hidden size=#SIZE# class="#RO#" #RO# name="#FIELD_DB_NAME#" id="#FIELD_DB_NAME#" value="^#FIELD_DB_NAME#">
    ^#FIELD_DB_NAME#
[end]

    
=============== Тип : date (календарь) ==================== ??
[date_read]
    $SET_PARAMETERS curr_val=^#FIELD_DB_NAME#; DATE_VALUE=^#FIELD_DB_NAME#;
    $GET_DATA dat/doc_fields.dat[convert date]  ??curr_val
    #DATE_VALUE# 
    <input type=hidden size=#SIZE# class="#RO#" #RO# name="#FIELD_DB_NAME#" id="#FIELD_DB_NAME#" value="#DATE_VALUE#">
[end]

[date_write]
    $INCLUDE dat/doc_fields.dat[date field w]  ??!info_id=1017
    $INCLUDE [1017 date]  ??info_id=1017
[end]

[1017 date]
    $INCLUDE dat/doc_fields.dat[date field w]
    $INCLUDE [1017 epmty_date]  ??FIELD_DB_NAME=begin_date
[end]


[1017 epmty_date]
    $SET_PARAMETERS curr_val=^#FIELD_DB_NAME#;
    <div style='color:red;'><b>Не введена дата. Запись недоступна пользователям.</b></div>  ??!curr_val
[end]


=============== Тип : boolean (checkbox) ==================== ??

[cb_read]
    $SET_PARAMETERS val= ^#FIELD_DB_NAME#;
    <input type=hidden size=#SIZE# class="#RO#" #RO# name="#FIELD_DB_NAME#" id="#FIELD_DB_NAME#" value="^#FIELD_DB_NAME#">
    Да  ??val=1
    Нет  ??!val=1
[end]

[cb_write]
    $SET_PARAMETERS val=^#FIELD_DB_NAME#;

    <input type=hidden size=#SIZE# class="#RO#" #RO# name="#FIELD_DB_NAME#" id="#FIELD_DB_NAME#" value="^#FIELD_DB_NAME#">
    <input type=checkbox name="#FIELD_DB_NAME#_chbx" id="#FIELD_DB_NAME#_chbx" onclick = "setCBValue('#FIELD_DB_NAME#');"
    checked  ??val=1
    >

<script type="text/javascript">
    var setCBValue = function(infoField)
    {
        if ($("##" + infoField + "_chbx").prop('checked')) {
            $("##" + infoField).val('1');
        }
        else {
            $("##" + infoField).val('0');
        }
    }

</script>

[end]

==================================================== ??

[report footer]
    </form>
    $INCLUDE [view footer]  ??!cop=save
    $INCLUDE [save footer]  ??cop=save
[end]

[view footer]
++++++++++++ Конец формы редактирования записи ++++++++++ ??
<tr><td>
<div style='color:red'><b>Запись помечена на удаление</b></div>  ??IS_DELETED=1
</td><td>

<input type=hidden name="IS_DELETED" id="IS_DELETED" value="#IS_DELETED#">
$INCLUDE [delete button]  ??
  ??!IS_DELETED=1
$INCLUDE [restore button]  ??
  ??IS_DELETED=1

<input type=hidden name="MODIFIER_ID" value="#USER_ID#">

</td></tr>

<tr><td class=label style='color:red'><b>Запись финализирована :</b></td><td style='color:red'><b>Редактирование полей невозможно</b></td></tr>  ??is_final=1

$GET_DATA [getModifierFIOInfo]

<tr><td colspan=2 class="right small">Запись обновлена: #MODIFIER# #MODIFIED#</td></tr>
</table>
$INCLUDE [close button]  ??!cop=add
<input type="button" class="butt1" style="width:120;" value="Сохранить" onClick="document.popupForm.cop.value='save'; document.popupForm.submit();">  ??RWACC

+++++++++ Скрипт отображения pop-up окна ++++ ??
<script>
window.parent.showMsg("##dialog_title", "Редактирование данных справочника #INFO_NAME#");
</script>
[end]



[close button]
    <input type="button" class="butt1" style="width:120;" value="Отмена" onClick="window.parent.AjaxCall('info_tree_panel', 'c=JINR/info/tree_panel&info_id=#info_id#&view=#view#&requesterId=#requesterId#'); ">  ??RACC
[end]

[delete button]
<input type="button" class="butt1" style="width:130;" value="Удалить запись" 
    onClick="
    if(confirm('Удалить эту запись? \nУдаленная запись будет недоступна пользователям при выборе значений из справочника.'))
        pressDeleteButton();" >  

<script type="text/javascript">

    var pressDeleteButton = function() 
    {
        $('##IS_DELETED').val('1');
        document.popupForm.cop.value='save'; document.popupForm.submit();
    }

</script>

[end]

[restore button]
    <input type="button" class="butt1" style="width:160;" value="Восстановить запись" 
        onClick="$('##IS_DELETED').val('0'); document.popupForm.cop.value='save'; document.popupForm.submit();">

[end]



+++++++++ Скрипт обновления таблицы данных в вызывавшей странице ++++ ??
+++++++++ (Pop-up окно уже закрыто по кнопке на предыд. шаге) +++ ??
[save footer]
    $SET_PARAMETERS rec_id=#record_id#;
    $GET_DATA [update views] ??
    $GET_DATA [updateParentsDates]  ??record_id&info_id=1017&ZZZ
    $CALL_SERVICE c=JINR/info/info_1017_comp_update_dates;  ??record_id&info_id=1017

    <script type="text/javascript">
        window.parent.AjaxCall('info_item_panel', 'c=JINR/info/tree_item_panel&info_id=#info_id#&view=#view#&record_id=#record_id#&requesterId=#requesterId#');  ??
        window.parent.AjaxCall('info_tree_panel', 'c=JINR/info/tree_panel&info_id=#info_id#&view=#view#&init_id_value=#init_id_value#&requesterId=#requesterId#');
    </script>

    $CALL_SERVICE c=gateway/post_info; info_view=2; silent=Y; ??record_id&info_id=1017
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
[end]


[SQL]
select NR, NAME, TYPE, SIZE, COMMENT, FIELD_DB_NAME, IS_VISIBLE, FIN_EDITABLE
from i_fields i
where info_id=#info_id#
order by nr
[end]


[update views]
[end]

[getModifierFIOInfo]
select
concat(umr.F, ' ', left(IFNULL(umr.I,''),1), '.', left(IFNULL(umr.O,''),1),'.') as MODIFIER
from #table_users_full# umr 
where umr.id=#MODIFIER_ID# 
[end]


[getChildren]
select 
'Y' as "INFO_TREE_CHILDREN" 
from #TABLE_NAME# 
where pid=#record_id#
limit 0,1
[end]


[updateParentsDates]
call set_comp_configuration_parent_dates(#record_id#)
;
[end]
