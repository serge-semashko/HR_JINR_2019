viewer/show_file.mod

[comments]
descr=U: Постраничный просмотр растеризованного файла по его id
input=id - id файла из таблицы doc_files
output=Отдельное окно простмотра файла 
parents=files/file_list.cfg
children=viewer/show_file_body.cfg,viewer/common_blocks.dat
testURL=?c=viewer/show_file&id=662
author=Куняев
[end]

[description]
Головной модуль вьювера файла.
<ul>
<li>Определяет разрешение экрана и записывает куку smallScreen для ширины < 1300</li>
<li>Загружает скрипты и основные css (viewer/common_blocks.dat[head])</li>
<li>Вызывает viewer/show_file_body - отображение соержимого</li>
</ul>
[end]


[parameters]
request_name=U:Просмотр файла
LOG=OFF
[end]


[report]
    $INCLUDE dat/common.dat[check login]
    $SET_PARAMETERS ERROR=HACK!;    ??!id
    $GET_DATA [get file param]      ??id
    $SET_PARAMETERS file_id=#id#;
    $CALL_SERVICE c=viewer/check_AR;  ??doc_id>0&file_name&!ERROR&!id=23267
    $SET_PARAMETERS AR_R=Y;  ??doc_id=0
    $SET_PARAMETERS AR_R=Y;  ??id=23267
    $LOG <b>***** viewer/show_file.mod: doc_id=#doc_id#; file_id=#file_id#; file_name=#file_name#; AR_R=#AR_R#;</b><br>
    $SET_PARAMETERS ERROR=Файл не найден!; NOT_FOUND=Y; ??!ERROR&!file_name|!doc_id
    $SET_PARAMETERS ERROR=Нет прав для просмотра файла!; ??!AR_R=Y&!ERROR
    $INCLUDE [report_]  ??NOT_FOUND=Y|AR_R=Y&!ERROR
    $LOG_ERROR  #ERROR#;  ??ERROR
[end]


[report_]
$INCLUDE viewer/common_blocks.dat[head]  *** Блок <head>...</head> 

<body>
<div id="content"><center><br><br><br><br>
    <img src="#imgPath#loading.gif">   ??doc_id&file_name&!ERROR
    $SET_PARAMETERS ERROR=Ошибка - файл не найден.<br>  ??!doc_id|!file_name
    #ERROR#  ??ERROR
    </center>
<br> doc_id=#doc_id#; id=#id#; file_name=#file_name#; AR_R=#AR_R#;
</div>

<script type="text/javascript">
    if(window.screen.width < 1300) 
      setCookie('smallScreen', 'true');
    else
      setCookie('smallScreen', '');
--- AJAX-вызов модуля вывода контента ---   ??
    AjaxCall("content", "c=viewer/show_file_body&file_id=#file_id#"); ??doc_id&file_name&!ERROR
</script>
</body></html>

$GET_DATA [register download] ??!USER_ID=#uploader_id#&!ERROR&!USER_ID=2309
[end]
  
&active_page_id>0

================================================================================

[register download]
update doc_files set downloaded=downloaded+1 where id = #file_id#
[end]



[get file param]
    SELECT f.doc_id, f.file_name
    from doc_files f
    where f.id = #id#
    ;
    select distinct width, concat(',',width) as "WIDTHS"
    from doc_file_pages 
    where file_id= #id# 
    order by width
    ;
    select substr('#WIDTHS#',2) as "WIDTHS"

[end]
