admin/monitor/tmp_set_docs_started.mod
monitor_table.cfg

[comments]
descr=S: Установка поля "d_list.started"
input=[cop](SHOW,CHECK,SET), limit[100], [f_doc_number]
output=
parents=
childs=
testURL=?c=admin/monitor/tmp_set_docs_started&cop=SET&limit=100&f_doc_number=1802
author=Куняев
[end]


[parameters]
service=dubna.walt.service.TableServiceSpecial
request_name=S:Установка поля "d_list.started"
LOG=ON
tableCfg=table_no
$INCLUDE dat/common.dat[rowLinks]
[end]


[report header]
    $GET_DATA main.cfg[checkAdmin]
    $INCLUDE [OK report header]  ??AR_ADMIN=1|AR_LAB_SECR=1
    $CALL_SERVICE c=sys/log_doc_access; doc_id=0; access_type=10; rejected=1;   ??!AR_ADMIN=1&!AR_LAB_SECR=1
[end]


[OK report header]
    $SET_PARAMETERS rpp=3;  ??
    $INCLUDE dat/common.dat[head]
    <style>
    table.tlist tr.bold td{font-weight:bold;}
    table.tlist tr.gray td, table.tlist tr.gray td a{color:##808080;}
    table.doc tr td {padding:5px;}
    table.doc tr td {padding:7px 7px 10px 5px;}
    table.doc tr td.label {padding:10px 7px 10px 0;} ??
    </style>
    </head> 
<body>

    ++++++++++++++++++ Шапка таблицы документов +++++++++++++++++++++ ??
    <table border=0 class="tlist tblue" cellspacing="0">
    <tr>
        <th>id</th>  
        <th>Документ</th>
        <th>Статус</th>
        <th>Дата<br>создания</th> 
        <th>Дата запуска</th>
        <th>Дата<br>изменения</th>
        <th>Дата<br>завершения</th>
        <th>Содержание</th>
        <th>Подразд.</th>
        <th >wf_id</th>
    </tr>
[end]

[item]
    $GET_DATA [get started]  ??wf_id&!cop=SHOW
    $GET_DATA [set started]   ??wf_id&cop=SET&STARTED
    <tr class="pt 
        oddRow ??oddRow=1
    " 
        onClick="openWindow('c=docs/view_doc&doc_id=#ID#&mode=ext',1000,800);" 
    >
        <td class=small>
            #ID#
        </td>
        <td class="nowrap" nowrap>
            Заявка ??TYPE_ID=1
            Договор ??!TYPE_ID=1
            №#NUMBER# от #DOC_DATE#</td>
        <td>#STATUS#</td>
        <td class="nowrap" nowrap>
            #CREATED# 
        </td>
        <td>
            #STARTED_#<br>  ??STARTED_
            #STARTED# 
        </td>

        <td>
            #MODIFIED# 
            #STATUS#  ??!STATUS=3&ZZZ
        </td>
        <td>
        #STARTED# </td>

        <td class="tt" tt_text='#TITLE#'><div class="ellipsis"  style="max-width:300px;">#TITLE#</div></td>
        <td>#DIVS#</td> 
        <td>#wf_id#</td> 
    </tr>

[end]


[report footer]
    $SET_PARAMETERS NumTableCols=10;
</body></html>
[end]


***************************** SQLs ***************************

[get started]
    select 
     DATE_FORMAT(min(finished),'#dateTimeFormat#') as "STARTED"   

    from wf 
    where wf_id=#wf_id#
        and not wf.finished is null 
        and wf.step_type<3 
        and wf.is_active=1
        and result_code=1
[end]

[set started]
    update d_list dh set dh.started=
       (select min(wf.finished)
        from wf 
        where wf_id=#wf_id#
            and not wf.finished is null 
            and wf.step_type<3 
            and wf.is_active=1
            and result_code=1
       )
    where dh.id=#doc_id#
[end]


[SQL]
$INCLUDE [SQL_] ??AR_ADMIN=1|AR_LAB_SECR=1
[end]


[SQL_]
select distinct
    dh.ID, dh.ID as "doc_id"
    , dh.id as "pid"  ??f_type_id=1
    , dh.TYPE_ID
    , dh.DIVS
    , dh.NUMBER
    , DATE_FORMAT(dh.created,'#dateTimeFormat#') as CREATED   
    , DATE_FORMAT(dh.doc_date,'#dateFormat#') as DOC_DATE 
    , DATE_FORMAT(dh.started,'#dateTimeFormat#') as STARTED_   

    , dh.TITLE
    
    , DATE_FORMAT(dh.MODIFIED,'#dateFormat#') as MODIFIED 
    , wl.id as "wf_id"

    , dh.status as "STATUS"
    , dh.wf_status
    , dh.doc_date, dh.created, dh.modified    
from d_list dh
    left join wf_list wl on wl.doc_id=dh.id

    where dh.ID>0 
    and dh.status>0
    and dh.TYPE_ID in(1,8,9,11)
    and extract(year from dh.created) in(2018) ??
    and dh.is_deleted=0
    and dh.id in(select doc_id from d_divs where div_id in(#f_div_id#)) ??f_div_id
    and (dh.NUMBER like '#f_doc_number#%' or dh.NUMBER like '%-#f_doc_number#') ??f_doc_number&!f_doc_id
    and dh.started is null ??cop=SET|cop=CHECK
order by dh.ID desc
limit #limit#  ??limit
limit 100  ??!limit
[end]


    , getWaiting(getWorkHours(ifnull(dh.doc_date, dh.created), now())) AS TOTAL_TIME 
    , getWaiting(getWorkHours(ifnull(dh.doc_date, dh.created), dh.modified )) AS TOTAL_TIME_FINISHED

     , getWorkDays(ifnull(dh.doc_date, dh.created), now()) as "WORK_DAYS"
