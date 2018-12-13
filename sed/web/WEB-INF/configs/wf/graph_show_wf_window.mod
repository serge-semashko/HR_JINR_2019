wf/graph_show_wf_window.mod


[comments]
descr=S: Показать в графическом виде рабочее workflow для документа. 

input=doc_id - ID документа (из таблицы d_list)
output=HTML форма представляющая рабочее workflow для документа в графическом виде.

parents=docs/view_doc_wf.cfg
childs=wf/graph_show_wf_step_detail.cfg
testURL=?c=wf/graph_show_wf_for_doc&doc_id=1
author=Яковлев, Куняев
[end]

[description]
Обертка для wf/graph_show_wf_for_doc.ajm для показа в отдельном окне
[end]

[parameters]
request_name=U:графическое отображение wf док. #doc_id#
LOG=ON
[end]


[report]
    $INCLUDE dat/common.dat[head]
    <style>
    table.tlist tr.bold td{font-weight:bold;}
    table.tlist tr.gray td, table.tlist tr.gray td a{color:##808080;}
    table.doc tr td {padding:5px;}
    table.doc tr td {padding:7px 7px 10px 5px;}
    table.doc tr td.label {padding:10px 7px 10px 0;} ??
    </style>
    </head> 

$CALL_SERVICE c=wf/graph_show_wf_for_doc

[end]

