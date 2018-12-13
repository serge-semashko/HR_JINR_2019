JINR/info/comp_configuration.mod


[comments]
descr=Модуль вывода данных древовидного справочника конфигураций компьютерной техники и выбора пункта.
input=requesterId - ID элемента для результата, info_id - ID справочника; view - № представления. По умолчанию - 1 (все поля по порядку); searchFor - строка поиска.
output=Pop-up окно с данными справочника с фильтром и с выбором записи
parents=svs/info_show
childs=
testURL=?c=JINR/info/comp_configuration&info_id=1017&view=1
author=Устенко, Яковлев
[end]


[description]
Модуль вывода данных справочника участников закупочных конкурсов.<br>
<ul><li>Выводит форму поиска и вызывает модуль вывода таблицы<br>
(JINR/info_tender_participant_data).</li>
<li>Предоставляет возможность добавления нового участника закупочного конкурса<br>
(вызывает модуль JINR/info_tender_participant_add).</li>
<li>а также возможность редактирования уже имеющихся записей<br>
(JINR/info_tender_participant_edit_data).</li>
</ul>
[end]


[parameters]
service=jinr.sed.ServiceTreeInfoData
request_name=S:просмотр данных справочника конфигураций компьютерной техники
KeepLog=true
ClearLog=false
SYS_FIELDS=is_folder as "IS_FOLDER", selectable as "SELECTABLE", id as "RECORD_ID", pid as "PARENT_RECORD_ID"
CRITERIA=where IS_DELETED=0 and view#view#=1 and begin_date < now() and ((end_date IS NULL) OR (end_date >= DATE(now())))
DATA_SEPARATOR=<br>
INFO_TREE_MODE=select
orderByField=sort, name
orderByField=sort  ??
[end]


[report header]
$INCLUDE svs/info_show_tree.cfg[report header]
[end]


[item]
$INCLUDE svs/info_show_tree.cfg[item]
[end]


[footer script]
    ]
    , "check_callback" : true
    , "animation" : 0
    , "multiple" : false
}


    ,'types' : {
        "default" : {
            "icon" : 'jstree-folder'
        },
        "00" : {
            "icon" : 'jstree-file'
        },
        "01" : {
            "icon" : 'jstree-file'
        },
        "10" : {
            "icon" : 'jstree-folder'  ??
            "icon" : "fa fa-folder-open clr-sandybrown"
        },
        "11" : {
            "icon" : 'jstree-folder'
        }
    
    }


,'plugins' : [ "search",  "types" ]
 });
      
    $(jst).on('ready.jstree', function (event, data) { 
            //если нечего селектить и корень один, раскрываем корень
            if(!$('###requesterId#_id').val()){
               jsonContent = $(jst).jstree(true).get_json();
               if(jsonContent.length===1){
               for (i = 0; i < jsonContent.length; i++) {
                    log(3,jsonContent[i].id);
                    $(jst).jstree(true).open_node(jsonContent[i].id);
                }
                }
            }else{
                //селектим то, что стоит в инпуте id на форме
                $(jst).jstree(true).select_node("#requesterId#"+$('###requesterId#_id').val());
            }
       });
       $(jst).on('changed.jstree', function (e, data) {
        // пока ничего
       });
        $(jst).bind("select_node.jstree", function (e, data) {
            // раскрытие нод по клику на тексте
            return data.instance.toggle_node(data.node);
        });
        //до лучших времён
        //$(jst).bind("dblclick.jstree", function (e, data) {
            //// двойной клик - выбор значений и вставка в инпуты на форме
            //var nodeId = $(e.target).closest("li")[0].id;
            //var nodeData =  $(jst).jstree(true).get_node(nodeId);
            //var selId = nodeData.id.replace("#requesterId#","");
            //var selText = nodeData.text;
            //pasteInfoResult("#requesterId#", selId, selText);
        //});
// это для поиска по дереву
 var to = false;
  $(sf).keyup(function () {
    if(to) { clearTimeout(to); }
    to = setTimeout(function () {
      var v = $(sf).val();
      $(jst).jstree(true).search(v);
    }, 250);
  });
});
function pasteback(){
    var search='#DATA_SEPARATOR#';
    var replacement ='';
    var selText = $(jst).jstree().get_selected(true)[0].text;
    var selId = $(jst).jstree().get_selected(true)[0].id.replace("#requesterId#","");
    var selType = $(jst).jstree().get_selected(true)[0].type;
    
    if ((selType==01) || (selType==11)) {
        pasteInfoTreeResult("#requesterId#", selId, selText);
        try{
            hideSprav();
        }catch(e){}

    } else {
        alert( 'Конкретизируйте Ваш выбор' );
    }

}



</script>
</div> ??
</div> ??
<script> ??
// window.parent.doShowSprav();	??!stanalone=yes&ZZZ
window.parent.getResult("d_spravCont", document.getElementById("result")); ??
</script> ??
[end]


[report footer]
$INCLUDE svs/info_show_tree.cfg[report footer]
[end]


[preSQLs]
$INCLUDE svs/info_show_tree.cfg[preSQLs]
[end]


