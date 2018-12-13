wf/print_wf.mod

[comments]
descr=S: Распечатать лист согласования документа. 
input=doc_id - ID документа
parents=
childs=
testURL=?c=wf/print_wf&doc_id=1
author=Куняев
[end]


[parameters]
request_name=A:печать wf для док. #doc_id#
LOG=ON
[end]


[report]
    $CALL_SERVICE c=svs/get_user_info; requested_user_id=#USER_ID#  ??

    $GET_DATA [get wf id]  

    $GET_DATA docs/view_doc.cfg[getDocInfo] ??WF_ID

<html><head>
    <style type="text/css">
    body {font-family: Times New Roman, serif; font-size:10pt; }
    ##acceptlisttable{ border-spacing:0px; border-collapse: collapse; max-width:900px;}
    ##acceptlisttable td, th{border:1px solid black; padding:3px; font-size:9pt;}
    ##acceptlisttable th{background:#EEE;}
    ##acceptlisttable th, ##acceptlisttable td {font-size:11pt;} ??
    ##acceptlisttable td.printheader {max-width:900px; text-align:center; font-size:12pt;} ??
    td { padding: 5px; vertical-align:top;}
    td.center {text-align:center;}
    </style>
</head><body>

$INCLUDE docs/view_doc.mod[print links]  ??Здесь поставить тип документа
    $CALL_SERVICE c=JINR/wf/print_wf_dp;  ??DOC_TYPE_ID=6
    $CALL_SERVICE c=JINR/wf/print_wf_dog;  ??DOC_TYPE_ID={{^8$|^9$|^10$|^11$|^12$|^20$|^34$|^23$|^24$|^25$|^37$}} 
    $CALL_SERVICE c=JINR/wf/print_wf_doc;  ??DOC_TYPE_ID=26
    $CALL_SERVICE c=JINR/wf/print_wf_dog_27;  ??DOC_TYPE_ID=27
  ??|DOC_TYPE_ID=37
    $CALL_SERVICE c=JINR/wf/print_wf_priem;  ??DOC_TYPE_ID=15

    #ERROR#

    <script type="text/javascript" language="javascript">window.print();</script>   ??WF_ID&!USER_ID=2309

</body></html>
[end]


==============================================================
==============================================================
==============================================================

[get wf id]
select id as "WF_ID" from wf_list where doc_id=#doc_id#;
[end]
