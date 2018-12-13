svs/wf_templates_dd.mod

[comments]
descr=Модуль вывода 2-х уровнего drop-down фильтра (шаблоны маршрутов по типам документа)
input=
output=
parents=
childs=
testURL=?c=svs/wf_templates_dd
author=Куняев, Яковлев
[end]

[parameters]
request_name=U:фильтр по шаблонам маршрута
service=dubna.walt.service.TableServiceSpecial
service=jinr.sed.ServiceShowInfoData ??
tableCfg=table_no

rpp=9999
LOG=ON
[end]



[description]
    <ul>
        <li></li>
    </ul>
[end]

[filter]
     <input type=hidden size=4 value="#f_prototype_template_id#" id="f_prototype_template_id" name="f_prototype_template_id">
     <div id="f_prototype_template" 
         class="filter_dd_input pt big ellipsis" 
         style="display: inline-block; width:500px; height:20px; border:solid 1px gray; margin: 0 7px -8px 0;" 
         onClick="showDD('f_prototype_template', 'svs/wf_templates_dd&curr_d_type=#type_id#', 'pasteTemplate');"
     >
         --- не копировать --- ??!f_prototype_template
         #f_prototype_template#
     </div>

    <script type="text/javascript">
        var pasteTemplate=function(id,text){
            log(2,"pasteTemplate: " + id + " / " + text); 
            $("##f_prototype_template_id").val(id);
            $("##f_prototype_template").html(text);
        }

    </script>
[end]


[report header]
    <table border=0 cellpadding=0 cellspacing=1 class="big" style="margin:1px 1px 10px 1px; border-bottom:solid 1px grey;">
    <tr><td class="pt big" style="padding-top:3px;" colspan=2 onClick="pasteTemplate('', '--- не копировать ---'); " > --- не копировать ---</td></tr>
[end]


============== Вывод одного поля  ======= ??
[item]

    <tr><td style="padding-top:3px; border-top:solid 1px grey;" colspan=2><b>#group_name#:</b></td></tr>  ??!OLD_GROUP=#group_name#
    <tr><td style="padding-top:3px; border-top:solid 1px grey;" colspan=2> - #doc_type#:</td></tr>  ??!OLD_DOC_TYPE=#doc_type#
    <tr><td style="width:20px;">&nbsp;</td>
        <td class="pt" 
            style="white-space:normal; border-bottom:dotted 1px ##c0c0c0;"
            onClick="pasteTemplate('#wf_template_id#', '#wf_name#' 
            + '(#wf_description#)'  ??wf_description_ZZZ
            + ' #div_ids#'   ??
            );"             
        ><div style="max-width:400px;  font-size:10pt; white-space:normal;">
            #wf_name# 
            (#wf_description#) ??wf_description
            #div_ids#
        </div></td>
    <td><small>#wf_template_id#</small></td> ??USER_ID=2309
    </tr>
    $SET_PARAMETERS OLD_DOC_TYPE=#doc_type#; OLD_GROUP=#group_name#;
[end]


[report footer]
    </table>

    <script type="text/javascript">
        $('##dd_info').show();
    </script>

[end]


***************************** Шаблоны SQL запросов ***************************


[SQL]
    select 
distinct ??
        dg.group_name 
        , dtp.name as "doc_type"
        , wftl.id as "wf_template_id"
        , wftl.wf_name as "wf_name"
        , wftl.wf_description as "wf_description"
        , wftl.div_ids as "div_ids"
        , wftl.is_active
        ,dtp.id, dtp.sort, dg.sort
    from d_types dtp 
         join wf_templates_list wftl on wftl.doc_type_id=dtp.id
         join doc_groups dg on dg.id=dtp.group_id
    where 
        wftl.is_active=1 
    order by 
        case when dtp.id=#curr_d_type# then 0 else 1 end,
        dg.sort, dtp.sort

[end]

