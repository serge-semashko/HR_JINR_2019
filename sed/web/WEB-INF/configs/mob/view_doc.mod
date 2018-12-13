mob/view_doc.mod

[comments]
descr=U: Просмотр документа

input=doc_id - ID документа (из таблицы d_list)
output=HTML форма просмотра документа, 
parents=docs/docs_in_progress_table.cfg
childs=docs/view_doc_no_wf.cfg, docs/view_doc_wf.cfg
test_URL=?c=docs/view_doc&doc_id=985
author=Куняев
[end]

[description]
Общая часть:
<ul>
<li>Получение информации о структуре документа</li>
<li>Вывод шапки документа</li>
<li>Вызов docs/view_doc_no_wf.cfg для документов без WF</li>
<li>Вызов docs/view_doc_wf.cfg для документов с WF</li>
<li>Вызов obj/view_object.cfg для отображения объекта</li>
<li>Вывод завершения</li>
</ul>

[end]

[parameters]
request_name=U:Просмотр документа
LOG=ON
SYS_FIELDS=DOC_ID, IS_ACTIVE, DATE_FORMAT(modified,'#dateTimeFormat#') as DOC_MODIFIED, VERSION
SYS_FIELDS_TYPES=int,int,varchar,int
divider=<tr><td colspan=2 class="divider"></td></tr> 
[end]

[report]
    $INCLUDE dat/common.dat[check login]
    $INCLUDE mob/blocks.dat[head]
    $LOG1 <b>============== view_doc: doc_id=#doc_id#; USER_ID=#USER_ID#; ==================</b><br>
    $CALL_SERVICE c=sys/getARUD; ??!AR_R=Y&USER_ID
    $SET_PARAMETERS WF_ID=#WF_ID_INACT#;  CURR_STEP=0; ??!WF_ID

    $INCLUDE [OK report]  ??AR_R=Y
    $CALL_SERVICE c=sys/log_doc_access; doc_id=#doc_id#; rejected=1;   ??!AR_R=Y
[end]

[OK report]
    $SET_PARAMETERS request=read;
    <link rel="stylesheet" href="#cssPath#font-awesome-4.7.0/css/font-awesome.min.css">
    
    $INCLUDE dat/common.dat[head]  ??
Там же все скрипты повторно грузятся!!! ??
Я оставил оттуда только css, хотя и его лучше бы к себе взять (только то, что нужно) ??
    $INCLUDE free/main_css_noDB.cfg[css] 
    $INCLUDE free/main_js_noDB.cfg[js]
    <style>
        table.tlist tr.bold td{font-weight:bold;}
        table.tlist tr.gray td, table.tlist tr.gray td a{color:##808080;}
        table.doc tr td {padding:5px;}
        table.doc tr td {padding:7px 7px 10px 5px;}

        .big, td.big, table.tlist td.big {
            font-size: 12px;
        }
       .mw1000 {max-width:inherit;}

    </style>
    </head>

    $SET_PARAMETERS DOC_DATA_RECORD_ID=;
    $GET_DATA [getDocInfo]

    $INCLUDE docs/custom_settings.cfg[set custom parameters]
    $SET_PARAMETERS AR_T=; AR_E=; AR_S=; AR_X=; ??is_deleted=1
    $GET_DATA docs/set_doc_number[auto set doc number SQL] ??SET_NUMBER_AT_STEP=1&!NUMBER&AR_S=Y|AR_X=Y

    $INCLUDE [doc title] ??!mode=popup&!doc_mode=object&!mode=print
    $INCLUDE [doc head]  ??!doc_mode=object

    $LOG2 ===== HAS_WF=#HAS_WF#; doc_mode=#doc_mode#; DOC_DATA_RECORD_ID=#DOC_DATA_RECORD_ID#; =============<br>
    $CALL_SERVICE c=mob/view_doc_no_wf;     ??!HAS_WF=1&DOC_DATA_RECORD_ID&!doc_mode=object
    $CALL_SERVICE c=mob/view_doc_wf;        ??HAS_WF=1&!doc_mode=object
    $CALL_SERVICE c=mob/view_doc_wf_1;        ??HAS_WF=1&!doc_mode=object&ZZZ
    $CALL_SERVICE c=obj/view_object.ajm;    ??doc_mode=object
    $INCLUDE [doc not found]            ??!DOC_DATA_RECORD_ID

    $INCLUDE [doc bottom]               ??!doc_mode=object

[end]

[doc not found]
    <br><br><br><br><b>ОШИБКА: Документ не найден!</b><br>
    <input type="button" class="butt1 pt" style="width:120px; margin:40px 0 30px 0;" onClick="showDoc(false); " value='Закрыть'> 
    $SET_PARAMETERS ERROR=Документ #doc_id# не найден!
[end]

[doc title]
++++++++++++++++++ Верхний заголовок - ссылка на главную  +++++++++++++++++++++ ??
    <div class="container-fluid name-doc">
            <div class="row">
                <div class="col-xs-6" ><img src="#rootPath#images/logo_russian.png" width="90" height="30"></div>
                <div class="col-xs-6 logg">#user_IOF#</div> 
            </div>
        </div>
[end]


[doc head]
++++++++++++++++++ Шапка документа  +++++++++++++++++++++ ??
    $INCLUDE JINR/colors.dat[set colors]
    <center>
    <div class="container-fluid name-doc">
        <div class="row">
            <div class="col-xs-2">
                $INCLUDE [mark doc important]  ??!mode=ext                        
            </div>
            <div class="col-xs-8 zagolovok">                    
                #DOC_TYPE#                    
                №#NUMBER# ??NUMBER
                от #DOC_DATE# ??DOC_DATE
                $SET_PARAMETERS DO_SET_NUMBER=Y;  ??!mode=print&number_type=4&AR_W=Y
                $SET_PARAMETERS DO_SET_NUMBER=Y;  ??!mode=print&SET_NUMBER_AT_STEP=3&AR_S=Y|AR_X=Y
                $INCLUDE [set doc number field] ??DO_SET_NUMBER=Y
                <br>#TITLE#</br>
            </div>
            <div class="col-xs-2">
                $INCLUDE [linked docs]                        
            </div>
        </div>            
    </div>
        <div class="doc wrapperRek grey">
        <center>
            <div class="rowRek">
                <div class="colRek" colspan=2 style="text-align:right;"><i><u>конфиденциально</u></i></div></div> ??DOC_IS_CONFIDENTIAL=1
                    
[end]

[allocate doc]
    <tr><td></td><td id="allocate_msg" style="text-align:right;">+++</td></tr>
    <script type="text/javascript" language="javascript">
        AjaxCall('allocate_msg', 'c=wf/allocateDoc&doc_id=#doc_id#&cop=check', true, '', false);      ??!doEdit=Y

        var doAllocate=function(take) {
            AjaxCall('allocate_msg', 'c=wf/allocateDoc&doc_id=#doc_id#&cop=' + take, true, '', false);  
        }
    </script>
[end]

[mark doc important]
    <div style="float:left;">
    <input type=checkbox onClick='AjaxCall("c_settings", "c=docs/markImportant&doc_id=#doc_id#&imp=" + this.checked, true);
        if(this.checked) $(".mark").removeClass("clr-gray").addClass("clr-red"); 
        else $(".mark").removeClass("clr-red").addClass("clr-gray");'
    checked ??MARKED=1
    ><i class="fa fa-flag mark
    clr-gray ??!MARKED=1
    clr-red  ??MARKED=1
    " aria-hidden="true"></i>
    </div>
[end]

[linked docs]
    <div id="d_linked_docs" style="float:right; border:none 1px gray;">
    <span class="pt bottom_dotted" onClick="showLinkedDocs();">Связанные документы  <img src="#imgPath#show.gif"></span> ??DOC_PID|NUM_LINKED>0
(#NUM_LINKED#) ??    
    </div>
    $INCLUDE [linked docs div]  ??DOC_PID|NUM_LINKED>0
    NUM_LINKED=#NUM_LINKED#; ??
[end]

[linked docs div]
    <div id="linked_cont"></div>
    <script>
    var showLinkedDocs=function(){
      var cont = $("##linked_cont");
      if(cont.css('display') != 'none') cont.hide(100)
      else {
        var obj = $('##d_linked_docs'); 
        var top = obj.offset().top + obj.height(); //Y-координата вызывающего элемента 
        cont.css({'top': top}); //ставим координаты pop-up окна

        cont.show(200); 
        AjaxCall('linked_cont', 'c=mob/show_linked_docs&doc_id=#doc_id#&mode=#mode#', true);
      }
    }
    </script>
[end]



[WF cancelled]
    $GET_DATA docs/view_doc.cfg[get cancel info]
    <tr><th class="center bg_white big" colspan=2>
    Документ <b>отозван</b> пользователем #TERMINATOR#, #WHEN_TERMINATED#<br>
    <small>(#TERMINATOR_ROLE#)</small><br> ??TERMINATOR_ROLE
    комментарий: #TERMINATOR_COMMENT#  ??TERMINATOR_COMMENT
    </th></tr>
[end]


[set doc number button]
    <button type="button" class="butt1 pt" id="register_button" onclick = "event.preventDefault(); event.stopPropagation(); 
    if(confirm('Присвоить документу номер и дату?')) {
        AjaxCall('doc_reg_number', 'c=docs/set_doc_number&doc_id=#doc_id#&auto=y', true); $('##register_button').hide(200);
    }">Зарегистрировать</button>
[end]

[set doc number field]
    $CALL_SERVICE c=docs/set_doc_number; doc_id=#doc_id#
[end]



[doc bottom]

    $CALL_SERVICE c=sys/log_doc_access; version=#VERSION#; 

    <script type="text/javascript" language="javascript">
        showDoc(true, "Просмотр документа"); 
    </script>
 
[end]



==============================================================================
***************************** Шаблоны SQL запросов ***************************
==============================================================================
[getDocInfo]
$INCLUDE docs/view_doc.mod[getDocInfo]
[end]

    select 
      dtp.NAME as "DOC_TYPE", dtp.ID as "DOC_TYPE_ID", dtp.number_type, dtp.gateway_object_id
        , concat('d_data_', cast(dtp.id as char)) as TABLE_NAME
        , dh.type_version as "DOC_TYPE_VERSION"
        , dh.pid as PARENT_DOC_ID
        , dh.TITLE, dh.NUMBER, dh.STATUS
        , dh.comment as "INITIATOR_COMMENT"
        , dh.pid as "DOC_PID"

        , u.FIO as CREATOR, u.email as "CRE_MAIL", u.phone as "CRE_PHONE", u.ID as CREATOR_ID
        , uu.FIO as MODIFIER
        , ifnull(DATE_FORMAT(dh.doc_date,'#dateFormat#'),'') as DOC_DATE
        , ifnull(DATE_FORMAT(dh.created,'#dateTimeFormat#'),'') as CREATED
        , ifnull(DATE_FORMAT(dh.modified,'#dateTimeFormat#'),'') as MODIFIED
        , dg.has_wf as "HAS_WF", dh.is_deleted, dm.mark as "MARKED"
    from d_list dh 
        left join d_types dtp on dtp.Id = dh.type_id
        left join doc_groups dg on dg.Id = dtp.group_id
        left join #table_users_full# u on u.Id = dh.creator_id
        left join #table_users_full# uu on uu.Id = dh.modifier_id
        left join d_marked dm on (dm.mark=dh.id and dm.user_id=#USER_ID#)
    where dh.Id = #doc_id#
    limit 0,1 
    ; 

    try: select /* LAST doc data record ID */ id as DOC_DATA_RECORD_ID 
    from #TABLE_NAME# 
    where doc_id = #doc_id# and is_active=1
        and version=#DOC_VERSION# ??DOC VERSIONS NOT IMPLEMENTED
    order by modified desc
    limit 0,1
    ;

    try: select concat(dtf.field_db_name, ',') as FIELDS
        , concat(dtf.name, ',') as FIELDS_NAMES 
        , concat(dtf.type, ',') as FIELDS_TYPES
        , concat(dtf.form_field_type, ',') as FORM_FIELDS_TYPES
    from d_fields dtf
    where dtf.type_id = #DOC_TYPE_ID#
        and dtf.is_visible=1 ??
        and dtf.is_active=1 
        and dtf.min_doc_type_version <= #DOC_TYPE_VERSION#  
        and dtf.max_doc_type_version >= #DOC_TYPE_VERSION#  
        and dtf.field_category>1  ??request=write 
    order by nr
    ;
    try: select count(dl.id) 
      + 1 ??DOC_PID
       as NUM_LINKED 
    from d_list dl 
        join d_types dt on dt.id=dl.type_id and dt.group_id<>99 
    where dl.pid=#doc_id# 
        and dl.is_deleted=0 
    ;
    try: select count(id) as NUM_CHILD_TYPES from d_types_children where type_id=#DOC_TYPE_ID#
    ;
    try: select type_id as "PARENT_DOC_TYPE" from d_list where id=#PARENT_DOC_ID#  ??PARENT_DOC_ID
    [end]


[SQL_]
$INCLUDE docs/view_doc.mod[SQL_]
[end]

    select /* doc data fields description */
        dtf.id as "FIELD_ID", dtf.NR, dtf.NAME, dtf.TYPE, dtf.SIZE, dtf.FORM_FIELD_TYPE, dtf.FIELD_DB_NAME, dtf.field_category as FIELD_CATEGORY
      , dtf.NULLS, dtf.mand
      , dtf.IS_ACTIVE, dtf.IS_VISIBLE, dtf.rw_4_roles
      , dtf.INFO_ID, dtf.info_view_nr as INFO_VIEW
      , case when dtf.ly is null then 'Y' else '' end as "AUTORESIZE" ??
      , case when dtf.autoResize=1 then 'Y' else '' end as "AUTORESIZE" 
      , ifnull(dtf.lx, 400) as LX, ifnull(dtf.ly, 40) as LY, ROUND((ifnull(dtf.ly, 40) + 5)/15) as ROWS
      , dtf.maxWidth
      , ft.src_file as "FIELD_SRC_FILE"

      , ft.section_r  ??request=read
      , ft.section_w   ??!request=read 
          as "FIELD_SECTION"
      , ft.section_w  as "FIELD_SECTION_RW"

    from d_fields dtf
        left join d_form_fields_types ft on (ft.id = dtf.form_field_type)
        left join d_list dh on dtf.type_id = dh.type_id
    where dh.Id = #doc_id# 
        and dtf.is_visible=1 
        and dtf.is_active=1 ??!IS_CONSTRUCTOR=Y
        and dtf.min_doc_type_version <= #DOC_TYPE_VERSION#  
        and dtf.max_doc_type_version >= #DOC_TYPE_VERSION#  
        and dtf.field_category>1  ??request=write 
    order by nr
[end]


[get added comments]
    select concat('<tr><td>&nbsp;&nbsp;</td><td class="small nowrap">'
        , DATE_FORMAT(wf.finished,'#shortDateTimeFormat#')
        , case when wf.user_id=wf.modifier_id then ', <b>' else ', ' end
        , iof(u.F, u.I, u.O)
        , case when wf.user_id=wf.modifier_id then '' else concat('<b> (', iof(um.F, um.I, um.O), ')') end
        , ':</b></td><td class="bg_white">', wf.comment, '</td></tr>') as ADDED_COMMENTS
    from wf 
        left join #table_users_full# u on u.id=wf.user_id
        left join #table_users_full# um on um.id=wf.modifier_id
    where wf.wf_id=#WF_ID# and not wf.comment is null and not wf.comment='' 
        and wf.step_type=#~wf_step_in_progress#
        and not wf.step_type=#~wf_step_signed# ??
    order by wf.finished
    ;
[end]


[get FYI comments]
    select concat('<tr><td>&nbsp;&nbsp;</td><td class="small nowrap">'
        , DATE_FORMAT(s.dat,'#shortDateTimeFormat#')
        ,', <b>', iof(u.F, u.I, u.O), '=>', iof(uu.F, uu.I, uu.O), ':</b></td><td class="bg_white">',s.comments,'</td></tr>') as FYI_COMMENTS
    from d_sent_FYI s 
        left join #table_users_full# u on u.id=s.from_id
        left join #table_users_full# uu on uu.id=s.user_id
    where s.doc_id=#doc_id# and not s.comments is null and not s.comments=''
       and (s.from_id=#USER_ID# or s.user_id=#USER_ID#)
    order by s.dat
    ;
[end]


[check sent FYI]
    select /* Was sent FYI? */ count(*) as "NUM_SENT_FYI" from d_sent_FYI s where s.doc_id=#doc_id#;
[end]


[check print forms]
    select count(id) as NUM_PRINT_FORMS from doc_out_files where doc_id=#doc_id#;
[end]


[get cancel info]
    select wfh.user_fio as TERMINATOR, wfh.user_role as TERMINATOR_ROLE
        ,DATE_FORMAT(wfh.processed, '#dateTimeFormat#') as WHEN_TERMINATED
        ,wfh.comment as TERMINATOR_COMMENT
    from wf_history wfh
      left join #table_users_full# u on u.id=wfh.user_id ??
    where wfh.doc_id=#doc_id# and wfh.result_code=#~doc_action_terminate#
    order by id desc
    limit 1
[end]

