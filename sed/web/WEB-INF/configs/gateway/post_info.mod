gateway/post_info.mod


[comments]
descr=S: Посылка записи справочника в gateway
input=info_id - ID справочника, info_view - представление, rec_id - ID записи
parents=docs/view_doc
test_URL=?c=gateway/post_info&info_id=1017&rec_id=1&info_view=13
author=Куняев
[end]

[description]
<ol>
<li>Запросы в БД [getDocInfo] для получения данных объекта</li>
<li>Проверка: если gateway_object_id=0 (ObjectType в терминах шлюза), то объект не посылается в шлюз (через сброс DOC_DATA_RECORD_ID) </li>
<li>.....</li>
<li></li>
</ol>
[end]


[parameters]
request_name=S:Посылка элемента справочника
service=jinr.sed.gateway.ServicePostDoc
tableCfg=table_no
LOG=ON
SYS_FIELDS=IS_DELETED, DATE_FORMAT(CREATED,'%d.%m.%Y %H:%i:%S') as CREATED, DATE_FORMAT(changed,'%d.%m.%Y %H:%i:%S') as MODIFIED
SYS_FIELDS_TYPES=int,varchar,varchar
encoding=utf-8 
[end]


[report header]
    $LOG <b>============== post_doc: doc_id=#doc_id#; USER_ID=#USER_ID#; ==================</b><br>
    $CALL_SERVICE c=sys/getARUD;  ??
    $SET_PARAMETERS AR_R=Y; 
        silent=; ??
    $SET_PARAMETERS request=read;
    $SET_PARAMETERS host=#GatewayHost#;
    $SET_PARAMETERS ObjectType=31; DOC_TYPE_ID=31; DOC_TYPE=Типовая конфигурация орг.техники;  ??info_id=1017

    $GET_DATA [getInfo]
    $SET_PARAMETERS DOC_DATA_RECORD_ID=#rec_id#; 
    $INCLUDE docs/custom_settings[set custom object data] ??ObjectType>0&ZZZ
    <html><body><div style="padding:20px;"> ??!silent
[end]


============== Вывод одного поля  ======= ??
[item]
    <br>#NAME# (#FIELD_DB_NAME#): ^#FIELD_DB_NAME# ??!silent
[end]

[report footer]
    </div>  ??!silent
    $INCLUDE [print request] ??mode=print
    <script>
    alert('Запись послана в шлюз.\n\rОтвет: #ResultCode#: #Result#; ID: #DestObjectID#'); ??!silent&ResultCode=0&USER_ID=2309|USER_ID=413|USER_ID=4790|USER_ID=8329|USER_ID=9635
    alert('Ошибка посылки записи в шлюз!\n\rКод ошибки: #ResultCode# #Result#'); ??!silent&!ResultCode=0&responce
    alert('Ошибка посылки записи в шлюз!\n\rНе получен ответ из шлюза!'); ??!silent&!ResultCode=0&!responce
    </script>
    $LOG <b>Encoded Data:</b>#encodedData#<br> ??
    </body></html>  ??!silent
[end]

[print request]
    <hr>
    <b>Request:</b><xmp>
    $INCLUDE [post params]
    <hr> ??
    Object=#objectJSON#;</xmp>
    <hr><b>Encoded Data:</b>#encodedData#<br> ??
    <hr><b>==> #GatewayHost#:<br> Responce:</b><xmp>#responce#</xmp>
[end]

Ver=1 

ClientID=3
ClientID=211

[post params]
    ClientID=#GW_CLIENT_ID#
    Command=PutObject
    ObjectType=#ObjectType#
    ClientObjectID=#rec_id#
    Time=#MODIFIED# 
[end]

LINK=#ServerPath##ServletPath#?sid=#doc_id#&mode=ext

[object header]
    DOC_TYPE=#DOC_TYPE#
    DOC_TYPE_ID=#DOC_TYPE_ID#
    CREATED=#CREATED#
    MODIFIED=#MODIFIED#
    IS_DELETED=#IS_DELETED#
[end]

    CREATOR=#CREATOR#
    MODIFIER=#MODIFIER#


#JSON#
}

==============================================================================
***************************** Шаблоны SQL запросов ***************************
==============================================================================
[getInfo]
    try: select i.TABLE_NAME
    from i_infos i
    where i.Id=#info_id#
    ;
    select view, type as INFO_TYPE, multi, editable
    from infos_views where id=#info_view#
    ;
    select concat(field_db_name, ',') as FIELDS
     , concat(name, ',') as FIELDS_NAMES 
     , concat(type, ',') as FIELDS_TYPES
     , concat(case when type='date' then '5' else '2'   end, ',') as FORM_FIELDS_TYPES
     , concat(view#view#, ',') as FIELDS_ORDER
    from i_fields
    where info_id=#info_id#
    and view#view# > -1
    order by view#view#, nr
    ;
    select count(field_db_name) as NUM_FIELDS, count(field_db_name)+ 1 as NUM_COLUMNS
    from i_fields where info_id=#info_id# and view#view# >-1
[end]


    select field_db_name as FIELD_1, type as FIELD_1_TYPE
    from i_fields
    where info_id=#info_id#
    and view#view# > 0
    order by view#view#, nr
     LIMIT 0,1
    ;


[SQL]
    select NAME, TYPE, SIZE, FIELD_DB_NAME
    from i_fields
    where info_id=#info_id#
    and view#view# > 0
    order by nr
[end]

select /* doc data fields description */
  dtf.NR, dtf.NAME, dtf.TYPE, dtf.SIZE, dtf.FORM_FIELD_TYPE, dtf.FIELD_DB_NAME, dtf.NULLS
, dtf.INFO_ID, dtf.info_view_nr as INFO_VIEW
, ifnull(dtf.lx, 400) as LX, ifnull(dtf.ly, 40) as LY, ROUND((ifnull(dtf.ly, 40) + 5)/15) as ROWS
, ft.src_file as "FIELD_SRC_FILE"
, ft.section_r  ??request=read
, ft.section_w  ??request=write 
  as "FIELD_SECTION"
from d_fields dtf
left join d_form_fields_types ft on (ft.id = dtf.form_field_type)
left join d_list dh on dtf.type_id = dh.type_id
where dh.Id = #doc_id# 
    and dtf.is_visible=1 
    and dtf.is_active=1
order by nr
[end]

    and dtf.min_doc_type_version <= #DOC_TYPE_VERSION#  
    and dtf.max_doc_type_version >= #DOC_TYPE_VERSION#  
    and dtf.form_field_type not in(1004, 1006) ??



