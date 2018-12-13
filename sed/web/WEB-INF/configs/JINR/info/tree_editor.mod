JINR/info/tree_editor.mod

[comments]
descr=U: Редактор иерархического справочника
input=info_id - ID справочника (из таблицы i_infos); 
view - № представления из справочника (view1, view2 view3)
output=Pop-up форма редактирования справочника, 
parents=
childs=JINR/info/tree_panel.ajm, JINR/info/tree_item_panel.ajm
test_URL=?c=JINR/info/tree_editor&info_id=1017&view=1
author=Яковлев, Куняев
[end]


[parameters]
request_name=U: Редактирование иерархического справочника
tableCfg=table_no
KeepLog=false
ClearLog=true
divider=<tr><td colspan=2 class="bg_white" style="height:10px; border-top:solid 1px gray;"></td></tr>
[end]


[report]
$GET_DATA [getInfoSQL]

<small>#c#</small> ??debug=on
<input type=hidden name=info_id value='#info_id#'>
<input type=hidden name=view value='#view#'>

<input type=hidden id='info_tree_edit_id' name='info_tree_edit_id' size=4 value='' >
<input type=hidden id='info_tree_edit' name='info_tree_edit' value='' >


<table border=0 bgcolor=white style="border:solid 1px gray;">  ??
<table border=0 
width="100%" 
style="background-color:whitesmoke; ">

<tr><td style="width:400">

<div id="info_tree_panel">Справочник...</div>

</td><td 
style="width:780"
>

<div id="info_item_panel">Элемент справочника...</div>


</td></tr>
</table>

+++++ Скрипт возврата результатов в вызывавшую страницу ++++ ??
<script>
AjaxCall('info_tree_panel', 'c=JINR/info/tree_panel&info_id=#info_id#&view=#view#&requesterId=info_tree_edit');
AjaxCall('info_item_panel', 'c=JINR/info/tree_item_panel&info_id=#info_id#&view=#view#&requesterId=info_tree_edit');
window.parent.ShowDialog(true); 
window.parent.showMsg('##dialog_title', "Справочник #INFO_NAME#");
window.parent.centerDialog();  ??

</script>

[end]



***************************** Шаблоны SQL запросов ***************************

[getInfoSQL]
try: select i.ID
, i.name as INFO_NAME, i.IS_EXTERNAL
, ed.SRC_TYPE, ed.CONN_ID, ed.REQUEST
, ec.DB_TYPE, ec.CONN_NAME, ec.DB as DB_SCHEMA
, i.IS_TREE, i.IS_ACTIVE
, ec.SERVER, ec.PORT, ec.PARAM, ec.USR as CONN_USR, ec.PW as CONN_PW
, i.TABLE_NAME, i.CUSTOM_MODULE, i.CUSTOM_UPDATER
, i.do_favorites, i.rpp as "irpp"
, data_updated 
from i_infos i
left join i_external_data ed on ed.info_id=i.id
left join i_ext_connections ec on ec.id=ed.conn_id
where i.Id=#info_id#
[end]

