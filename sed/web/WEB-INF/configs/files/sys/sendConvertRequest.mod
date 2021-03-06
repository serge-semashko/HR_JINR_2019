files/sys/sendConvertRequest.mod

[comments]
descr=S: Посылка запроса в сервис растеризации на конвертирование файла
input=file_id - id исходного файла в таблице doc_files, [verbose] - вывод информации, [width] -  требуемая ширина изображения
parents=files/sys/convertDocFiles.cfg
testURL=?c=files/sys/sendConvertRequest&file_id=541&verbose=3
author=Куняев
[end]

[parameters]
service=jinr.sed.viewer.ServiceSendConvertRequest
LOG=ON
[end]



$SET_PARAMETERS serviceUrl=http://159.93.41.37:8080/converter/convert?id=#file_id#&width=900&type=1574&title=f_#file_id#.#file_ext#&size=#file_size#&usePDF=false; ??USER_ID=95
$SET_PARAMETERS serviceUrl=http://159.93.153.102:8083/converter/convert?id=#file_id#&width=900&type=1574&title=f_#file_id#.#file_ext#&size=#file_size#&usePDF=false;  ??!USER_ID=95
$SET_PARAMETERS serviceUrl=http://192.168.33.215:8083/converter/convert?id=#file_id#&width=900&type=1574&title=f_#file_id#.#file_ext#&size=#file_size#&usePDF=false; ??ServerName=ak0211

[report header]
    $SET_PARAMETERS ERROR=; FILE_IS_IMAGE=; file_ext=; FILE_IS_ZIP=;
    $SET_PARAMETERS width=900; ??!width
    $SET_PARAMETERS width=1500; ??!width=900&!width=1500
    $GET_DATA [get file param]
    <b>#file_name#</b> (file_size=#file_size#, id=#file_id#)  ??verbose>0
    doc: <b>#doc_id#</b>  ??verbose>2
    
    $SET_PARAMETERS NUM_MARKUPS=0;  ??
    $INCLUDE [send request]     ??!FILE_IS_IMAGE&!FILE_IS_ZIP&!NUM_MARKUPS>0|width>900

    $GET_DATA [register image]  ??FILE_IS_IMAGE
    $LOG <b>===> COPY_FILE  #file_storage_path##fs_file_name#; #FILE_PATH#f#file_id#_page_1.#file_ext#; Host=#Host#;</b>  ??FILE_IS_IMAGE
    $COPY_FILE  #file_storage_path##fs_file_name#; #FILE_PATH#f#file_id#_page_1.#file_ext#;  ??FILE_IS_IMAGE

    $SET_PARAMETERS ERROR=Файл не подлежит конвертированию!;  ??FILE_IS_IMAGE|FILE_IS_ZIP
    $INCLUDE [register error] ??NUM_MARKUPS>0&width=900
[end]

[send request]  ***** Посылка запроса на конвертирование. Вызывается только если нет заметок к файлу.
    Удаление старых страниц... ??verbose>2
    $CALL_SERVICE c=files/sys/deleteFilePages; 
     ??
    $SET_PARAMETERS host=http://192.168.33.215:8083    ??
    $SET_PARAMETERS host=http://159.93.33.64:8083      ??W7(1C)
    $SET_PARAMETERS host=http://192.168.33.216:8083   
  ??W7(NEW)
 
     ??ServerName=ak0211&!p=y
    $SET_PARAMETERS host=http://159.93.41.37:8080 ??USER_ID=95

    <br>id=#file_id#&width=900&type=1574&title=f_#file_id#.#file_ext#&size=#file_size#&usePDF=false&file_name=#file_name#;</br> ??verbose=3
        &file_name=#file_name# ??-cyrillic

    $SET_PARAMETERS serviceUrl=#host#/converter/convert?id=#file_id#&width=#width#&type=1574&title=f_#file_id#.#file_ext#&size=#file_size#&usePDF=false; 

    $SET_PARAMETERS url=http://ak0211.jinr.ru:8084/sed/dubna?c=files/download_file&id=#file_id#; ??back_url=https://sed.jinr.ru/sed/dubna_ZZZ
    $SET_PARAMETERS urlOut=http://ak0211.jinr.ru:8084/sed/dubna?c=files/sys/getPage;  ??back_url=https://sed.jinr.ru/sed/dubna_ZZZ
    $SET_PARAMETERS url=http://sed.jinr.ru:8080/sed/dubna?c=files/download_file&id=#file_id#; ??back_url=https://sed.jinr.ru/sed/dubna
    $SET_PARAMETERS urlOut=http://sed.jinr.ru:8080/sed/dubna?c=files/sys/getPage;  ??back_url=https://sed.jinr.ru/sed/dubna
    ??Host=sed.jinr.ru

    $SET_PARAMETERS url=#ServerPath##ServletPath#?c=files/download_file&id=#file_id#;  ??!back_url=https://sed.jinr.ru/sed/dubna 
    $SET_PARAMETERS urlOut=#ServerPath##ServletPath#?c=files/sys/getPage;    ??!back_url=https://sed.jinr.ru/sed/dubna 
     ??!Host=sed.jinr.ru&ZZZ
    $LOG <b>===> CONVERT_FILE  url=#url#; urlOut=#urlOut#; Host=#Host#;</b><br>;

    $GET_DATA [register request]
    Посылка запроса... ??verbose>1
    <br>Запрос: #serviceUrl#&url=#url#&urlOut=#urlOut#;<br> ??verbose>2
    $LOG3 <b>Convert request:</b> serviceUrl=#serviceUrl#; <br>url=#url#;<br>urlOut=#urlOut#;<br>
[end]


[register error]
    $SET_PARAMETERS ERROR=Ошибка подготовки файла. К файлу есть заметки: #NUM_MARKUPS# !; ??NUM_MARKUPS>0
    $SET_PARAMETERS ERROR=;  RESPONCE=Ok; PREPARING=Y; ??FILE_IS_IMAGE
    $LOG_ERROR #ERROR#  ??ERROR
    <b>#ERROR#</b>  ??verbose>1&ERROR
    $GET_DATA [register error SQL]  ??ERROR
[end]

 
[report footer]
    $SET_PARAMETERS ERROR=;  RESPONCE=Ok; PREPARING=Y; ??FILE_IS_IMAGE
    $GET_DATA [register responce]
    Ответ:  ??verbose>1
    #RESPONCE# (#TIME#мс.)<br> ??verbose>0
    $LOG1 <b>Convert responce: #RESPONCE#;</b>  TIME=#TIME#;<hr>
[end]


[get file param]
    select doc_id, file_name, fs_file_name, file_ext, file_size from doc_files where id=#file_id#
    ;
    select count(*) as NUM_MARKUPS from doc_data_markups where file_id=#file_id#
    ;
    select case when lower('#file_ext#') in ('jpg', 'png', 'jpeg') then 'Y' else '' end as "FILE_IS_IMAGE" 
    ;
    select case when lower('#file_ext#') in ('rar', 'zip', '7z', 'mp3', 'mp4', 'lnk') then 'Y' else '' end as "FILE_IS_ZIP" 
[end]

[register request]
    replace into doc_file_convert(file_id, width, doc_id, sent)
    values(#file_id#, #width#, #doc_id#, now())
[end]


[register responce]
    select count(*) as num_pages from doc_file_pages where file_id=#file_id# and width=#width#
    ;
    update doc_file_convert set finished=now(), responce='#RESPONCE#'
        ,time=#TIME#  ??TIME
        ,num_pages=#num_pages# ??num_pages
    where file_id=#file_id#
        and width=#width#
[end]

[register image]
    select date_format(d.created,'%Y/%m') as "DOC_PATH"
    from d_list d
    where d.id = #doc_id#
    ;
    select '#file_pages_path##DOC_PATH#/#doc_id#/' as "FILE_PATH"
     , 'f#file_id#.#new_file_TYPE#' as "FILE_NAME" ??
     , '#DOC_PATH#/#doc_id#/f#file_id#_page_1.#file_ext#' as "FILE_REL_PATH"
    ;
    replace into doc_file_pages (file_id, page_nr, width, fs_file_name, file_size, err, uploaded)
    values(#file_id#, 1, #width#, '#FILE_REL_PATH#', #file_size#, '', now())
    ;
    replace into doc_file_convert (file_id, width, doc_id, sent, finished, time, num_pages, responce)
    values(#file_id#, #width#, #doc_id#, now(), now(), 0, 1, 'Ok')
[end]


[register error SQL]
    insert into doc_file_errors (doc_id, file_id, comments, dat)
    values (#doc_id#, #file_id#, '#ERROR#', now())
[end]