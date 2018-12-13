sys/indexDocs.mod

[comments]
descr=S: Индексация документов
input=
output=
parents=
childs=sys/indexDoc.mod
test_URL=?c=sys/indexDocs
author=Куняев
[end]

[description]
<ul>
<li>...</li>
</ul>
[end]


[parameters]
request_name=S:индексация документов
service=dubna.walt.service.TableServiceSpecial
LOG=ON
tableCfg=table_no
[end]


[report header]
    $SET_PARAMETERS srn=1; rpp=100000; 
    $SET_PARAMETERS limit=100; ??!limit
    limit=#limit#
    <br>
[end]


[item]
    #currentRow#: #doc_id#:
    $CALL_SERVICE c=sys/indexDoc; verbose=3;
[end]


[report footer]
    <hr>
    DONE!
[end]



*****************************  ***************************

[SQL]
    select dh.ID as "doc_id"
    from d_list dh
        left join d_types dtp on dtp.Id = dh.type_id
    where dtp.group_id<99
        and extract(year from dh.created) in(2018)
        and dh.is_deleted=0
        and dh.status in(1,2,3)
    order by dh.created desc
    limit #limit#
[end]


, dh.TYPE_ID, dtp.NAME AS DOC_TYPE
        , dh.NUMBER, dh.TITLE, dh.DIVS
        , DATE_FORMAT(dh.doc_date,'#dateFormat#') as DOC_DATE 
        , DATE_FORMAT(dh.created,'#dateTimeFormat#') as CREATED 
        , dh.creator_id
        , concat(ucr.F, ' ', left(IFNULL(ucr.I,''),1), '.', left(IFNULL(ucr.O,''),1),'.') as CREATOR
        , DATE_FORMAT(dh.modified,'#dateTimeFormat#') as MODIFIED
        , dh.modifier_id 
        , concat(umr.F, ' ', left(IFNULL(umr.I,''),1), '.', left(IFNULL(umr.O,''),1),'.') as MODIFIER
        , fyi.cnt, wfh.cnt as hist_cnt
        , dh.pid, dh.num_children
        , dm.mark as "MARKED"
        , a.user_id as "VIEWED" 
        , dh.status, dh.wf_status
 , getWaiting(getWorkHours(dh.modified, now())) AS WAITING 
        , concat(FORMAT(TIMESTAMPDIFF(day, dh.modified, now()), 0), 'д' ??
        , FORMAT(TIMESTAMPDIFF(hour, dh.modified, now())-TIMESTAMPDIFF(day, dh.modified, now())*24,0)) AS WAITING ??
        , case when TIMESTAMPDIFF(day, dh.modified, now()) > 1 then 'LONG'
        else 'SHORT'
        end
        AS WAITING_LEVEL

    $INCLUDE docs/docs_in_progress_table[access criteria]
        and dh.status in(1,2)

        and dh.TYPE_ID=#f_prog_doctype# ??f_prog_doctype
        and (dh.NUMBER like '%-#f_prog_req_nr#' or dh.NUMBER like '#f_prog_req_nr#') ??f_prog_req_nr
        and dh.TITLE like '%#f_prog_title#%' ??f_prog_title
