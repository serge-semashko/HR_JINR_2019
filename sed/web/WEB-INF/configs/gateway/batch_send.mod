gateway/batch_send.mod

[comments]
descr=S: Пакетная посылка в шлюз
input=do=Y - слать, иначе - тест, [type_id] - тип документа или [info_id] - ID справочника, который необходимо послать, [info_view] - представление (для справочника), [criteria] - дополнительный специфический критерий отбора
output=
parents=
childs=
testURL=?c=gateway/batch_send&info_id=1017&info_view=3&criteria=id in(15,16)
author=Куняев
[end]


[parameters]
service=dubna.walt.service.TableServiceSpecial
request_name=U:Batch-посылка документов
LOG=ON 
tableCfg=table_no
[end]


[report header]
$INCLUDE [header]  ??!silent=Y
[end]

[header]
    $INCLUDE dat/common.dat[head]
    </head><body style="padding:30px;">

    $GET_DATA [get info table]      ??info_id&!type_id
    <b>Посылка ВКЛЮЧЕНА! (do=#do#)</b>  ??do=Y
    <b>Посылка ВЫКЛЮЧЕНА! (do != Y / #do#)</b> ??!do=Y

    $SET_PARAMETERS srn=1; rpp=9999;
    <table class="tlist tblue" cellspacing=0>
        <tr>
            $INCLUDE [header-doc] ??type_id
            $INCLUDE [header-info] ??info_id&!type_id
        </tr>
[end]


[header-doc]
    <th>id</th> 
    <th>Документ</th>
    <th>Статус</th> 
    <th>Содержание</th>
    <th>+++</th>
    <th>Результат</th> 
    <th>Gate.ID</th> 
    <th>Dest.ID</th> 
[end]

[header-info]
    <th>id</th> 
    <th>name</th>
    <th>+++</th>
    <th>Результат</th> 
    <th>Gate.ID</th> 
    <th>Dest.ID</th> 
[end]


[item]
    $CALL_SERVICE c=gateway/post_doc; doc_id=#doc_id#; silent=Y;  ??do=Y&type_id
    $CALL_SERVICE c=gateway/post_info; doc_id=#doc_id#; silent=Y;  ??do=Y&info_id&!type_id
    $INCLUDE [item-doc] ??!silent=Y&type_id
    $INCLUDE [item-info] ??!silent=Y&info_id&!type_id
[end]

[item-doc]
    <tr class="pt
        oddRow ??oddRow=1
    "> <td style="padding:0;">#doc_id# </td>
    <td>#DOC_TYPE# №#NUMBER# от #DOC_DATE#</td> 
    <td>
        Черновик ??STATUS=0
        В процессе согласования ??STATUS=1
        На этапе завершения ??STATUS=2
        Завершен ??STATUS=3
        #STATUS# ??STATUS<0|STATUS>3
    </td>
    <td>#TITLE#</td>
    <td>#DIVS#</td>
    <td>#ResultCode#: #Result#</td> 
    <td>#GateObjectID#</td>
    <td>#DestObjectID#</td> 
    </tr>
[end]

[item-info]
    <tr class="pt
        oddRow ??oddRow=1
    "> 
        <td style="padding:0;">#rec_id# </td>
        <td>#name#</td> 
        <td>
        </td>
        <td>#ResultCode#: #Result#</td> 
        <td>#GateObjectID#</td>
        <td>#DestObjectID#</td> 
    </tr>
[end]

[report footer]
    </table><hr>  ??!silent=Y
[end]

***************************** Шаблон SQL запроса ***************************

[get info table]
    select table_name
    from i_infos
    where id=#info_id#
[end]

[SQL]
    $INCLUDE [SQL-docs] ??type_id
    $INCLUDE [SQL-info] ??info_id&!type_id
[end]

[SQL-docs]
    select
        dh.ID as doc_id
        , dh.TYPE_ID, dh.STATUS
        , dh.NUMBER, dh.TITLE, DATE_FORMAT(dh.doc_date,'#dateFormat#') as DOC_DATE 
        , dtp.NAME AS DOC_TYPE 
    from d_list dh
        join d_types dtp on dtp.id=dh.TYPE_ID
    where type_id=#type_id#
        and dh.STATUS>0     ??!criteria
        and #criteria#      ??criteria
    and dh.id=533 ??
    order by dh.modified 
    desc  ??
    limit 2
[end]


[SQL-info]
    select id as "rec_id", name
    from #table_name#
    where is_deleted=0
        and view#info_view# > 0 
        and not (name is null or name='')
        and #criteria#   ??criteria
    order by changed
    limit 2  ??
[end]

