JINR/doc_13_protocol_ZK_Word.mod

[comments]
descr=Печать протокола заседания закупочной комиссии.
input=doc_id - ID документа (из таблицы d_list)
output=Открытие html-формы в приложении MS Word.
parents=JINR/doc_13_settings.cfg
childs=JINR/doc_13_protocol_ZK_Word.mod
testURL=?c=JINR/doc_13_protocol_ZK&doc_id=
author=Яковлев, Куняев
[end]

[description]
Модуль вызова MS Word для отображения печатной формы протокола закупочной комиссии.
[end]


[parameters]
request_name=U:Печать протокола заседания закупочной комиссии.
service=jinr.sed.ServiceMimeData 
LOG=ON
contentType=application/msword ??of=word_ZZZ
mimeType=application/msword  ??of=word_ZZZ
inline=true  ??для загрузки в браузер
file_name=SED_protokol_ZK_#NUMBER#.doc 
[end]


[report]
    <HTML><HEAD><TITLE>#fileName#</TITLE>
    <META http-equiv=Content-Type content="text/html; charset=utf-8">
    <style>
        td {vertical-align:top;}
    </style>
    </head><body>
        $SET_PARAMETERS srn=1; rpp=9999;
        $CALL_SERVICE c=JINR/doc_13_protocol_ZK;
    </body></html>
[end]

[preSQLs]
select PID from d_list where id=#doc_id#
select NUMBER from d_list where id=#PID#  ??PID
[end]