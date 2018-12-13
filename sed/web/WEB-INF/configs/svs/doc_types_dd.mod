svs/doc_types_dd.mod

[comments]
descr=Модуль вывода 2-х уровнего drop-down фильтра (тип документа по группам)
input=
output=
parents=
childs=
testURL=?c=svs/doc_types_dd
author=Куняев
[end]

[parameters]
request_name=U:фильтр по типу док-а
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
         <select name=f_doc_type_id class=norm onChange="submitForm(true);"><option value="">все</option>#DOC_TYPES_LIST#</select> ??
     <input type=hidden size=4 value="#f_doc_type_id#" id="f_doc_type_id" name="f_doc_type_id">
     <div id="f_doc_type" 
         class="filter_dd_input pt big ellipsis" 
         style="display: inline-block; width:350px; height:20px; border:solid 1px gray; 
             margin: 0 7px -8px 0;
         " 
         onClick="showDD('f_doc_type', 'svs/doc_types_dd&selected_id=#f_doc_type_id#', 'pasteDocType');"
     >
         все ??!f_doc_type
         #f_doc_type#
     </div>

    <script type="text/javascript">
        var pasteDocType=function(id,text){
            log(2,"pasteDocType: " + id + " / " + text); 
            $("##f_doc_type_id").val(id);
            $("##f_doc_type").html(text);
            resetSort(); 
            submitForm(true);
        }
    </script>
[end]


[report header]
    <table border=0 cellpadding=0 cellspacing=1 class="big" style="margin:1px 1px 10px 1px; border-bottom:solid 1px grey;">
    <tr><td class="pt big" style="padding-top:3px;" colspan=2 onClick="#callback#('', 'все'); " > --- все ---</td></tr>
[end]


============== Вывод одного поля  ======= ??
[item]
    <tr><td style="padding-top:3px; border-top:solid 1px grey;" colspan=2><b>#group_name#:</b></td></tr>  ??!OLD_GROUP_NAME=#group_name#
    <tr><td style="width:20px;">&nbsp;</td>
        <td class="pt
            bg_yellow ??type_id=#selected_id#
            " 
            onClick="#callback#('#type_id#', '#short_name#'); " 
            style="white-space:normal; border-top:dotted 1px ##c0c0c0;"
        ><div style="max-width:400px;  font-size:10pt; white-space:normal;">
            <img src="#imgPath#level-down.png" style="margin-left:5px;">     ??is_independed=0
            #doc_type#
        </div></td>
    <td><small>#type_id#</small></td> ??USER_ID=2309
    </tr>
    $SET_PARAMETERS OLD_GROUP_NAME=#group_name#;
[end]


[report footer]
    </table>

    <script type="text/javascript">
        $('##dd_info').show();
    </script>

[end]


***************************** Шаблоны SQL запросов ***************************


[SQL]
    select distinct grp.group_name, dtp.id as "type_id"
        , dtp.name as "doc_type"
        , dtp.short_name 
        , curr_doc_type_version
        , dtp.is_active, dtp.is_independed, dtp.rights_to_create_doc
        , grp.sort, dtp.sort
    from doc_groups grp 
         join d_types dtp on dtp.group_id=grp.id
    where 
    (   dtp.is_active=1 
        and dtp.group_id<80
    )
    or dtp.group_id=98 ??AR_SYS_ADMIN

    order by grp.sort, dtp.sort
[end]

