tmp/setNicaComment_doc7.mod


calc_zajavka_usd.cfg

[comments]
descr=S: NICA=>коммент в ист.фин.
testURL=?c=tmp/calc_zajavka_usd
author=Куняев
[end]

[parameters]
service=dubna.walt.service.TableServiceSpecial
tableCfg=table_no
KeepLog=true
[end]

[preSQLs]
[end]

[report header]
<table border=1>
<tr>
    <td>pid</td>
    <td>doc_id</td>
    <td>project_item</td>
    <td>platezh</td>
    <td>platezh_id</td>
</tr>
[end]


[item]
$GET_DATA [get parent]
<tr>
    <td>#pid#</td>
    <td>#doc_id#</td>
    <td>#project_item#</td>
    <td>#platezh#</td>
    <td><div style="max-width:400px;">#comment#</div></td>
<td>
$INCLUDE [set comment]
$GET_DATA [set comment] 
</td>
</tr>
[end]

[report footer]
</table>
[end]


[get parent]
select pid from d_list where id=#doc_id#
[end]

[set comment]
update d_list set comment=concat('#project_item# ', ifnull(comment,''))
where id=#doc_id#
[end]

[SQL]
    select
        d.doc_id, d.project_item, d.platezh, d.platezh_id, dh.comment
    from d_data_7 d
    join d_list dh on dh.id=d.doc_id
    join d_list dp on dp.id=dh.pid
    where
        dp.type_id=1
        and not d.project_item is null  
        and d.project_item<>''
        and (d.platezh_id is null or d.platezh_id ='')   
        and (dh.comment is null or dh.comment='')  ??
        and not  dh.comment like 'NICA:%'
        and extract(year from dp.created) >2016
        and dp.is_deleted=0
    order by d.doc_id desc
limit 200 ??
[end]


dh.is_deleted=0 