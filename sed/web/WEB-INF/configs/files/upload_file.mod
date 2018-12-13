files/upload_file.mod

[comments]
descr=U: Загрузка файла к документу
author=Устенко, Куняев
input=new_file - файл, doc_id = id документа, field_id - ID поля документа
output=сообщение о загрузке или об ошибке
parents=docs/edit_doc.cfg
[end]

[description]
<ul>
 <li>Проверяем права на загрузку файла (AR_W=Y|AR_R=Y)</li>
 <li>Определяем очередной номер файла-приложения (номер версии файла-поля) и ID нового файла в doc_files</li>
 <li>Определяется путь файла в хранилище, его имя в ФС, путь относительно хранилища</li>
<ul>
 <li> ##file_storage_path## - путь к хранилищу файлов,</li>
 <li> FILE_NAME - Имя файла в ФС составляется на основе его ID: filename = "f##NEW_FILE_ID##";</li>
 <li> /DOC_YEAR/DOC_MONTH/FILE_ID/FILE_NAME - путь от хранилища на основе года и месяца создания документа</li>
 /ul>
 <li>Обновляется запись о файле в doc_files и в d_data_##DOC_TYPE_ID## для файлов-полей и стека.</li>
 <li>Возвращает:</li>
<ul>
 <li>строку файла при заргузке поля-файл</li>
 <li>Сообщение "NO_ACCESS" если нет прав загружать файл</li>
 <li>Сообщение "ERROR: текст ошибки" при ошибке загрузки</li>
</ul>
 <li>При успешной загрузке вызывает  jinr.sed.viewer.ConvertMonitor для посылки запроса на конвертирование файла.</li>
</ul>
[end]

[parameters]
service=jinr.sed.ServiceUploadFile2
LOG=ON
[end]

[report header]  ****** Проверка прав юзера и регистрация файла до записи файла в ФС
$CALL_SERVICE c=sys/getARUD; doc_id=#doc_id#; 
$SET_PARAMETERS ERROR=Нет прав для загрузки файла!; ??!AR_W=Y&!AR_R=Y
$SET_PARAMETERS file_comment=; ??file_comment=undefined
$SET_PARAMETERS form_field_type=666; ??!form_field_type
$GET_DATA [check file type]
$SET_PARAMETERS ERROR=Неверный тип файла: .#new_file_TYPE#; ??FILE_NOT_ALLOWED
$GET_DATA [register file]  ??!ERROR
[end]


[report footer]  ****** после записи файла в ФС
$INCLUDE [finish]  ??!ERROR
$INCLUDE [err msg]  ??ERROR
[end]

[finish]  ******* Успешная загрузка
    $GET_DATA [update registration]
    $LOG1 Файл загружен field_id=#field_id#; NEW_FILE_ID=#NEW_FILE_ID#; form_field_type=#form_field_type#;<br>

    $SET_PARAMETERS form_hidden=Y; AR_X=Y; ??form_field_type=666|form_field_type=1009
    $INCLUDE files/field_file.cfg[file row]  ??form_field_type=666|form_field_type=1009
    $GET_DATA [register page] ??FILE_IS_IMAGE=Y_ZZZ
[end]

[err msg]  ******* Сообщение об ошибке
ERROR: Ошибка загрузки файла: #ERROR#
$LOG_ERROR ОШИБКА загрузки файла: #ERROR#
$LOG <br><b>ОШИБКА загрузки файла: #ERROR#; </b><hr>
[end]


=============================================================================
=============================================================================
=============================================================================
[check file type]
 select 
    case when '#new_file_TYPE#' in ('jpg', 'png', 'jpeg') then 'Y' else '' end as "FILE_IS_IMAGE" , ??
    case when '#new_file_TYPE#' in ('lnk', 'exe', 'bat') then 'Y' else '' end as "FILE_NOT_ALLOWED" 
[end]


[register file] ***** Очередной номер файла (для стека-версия), путь в ФС к документу, регистрируем файл, получаем NEW_FILE_ID, FILE_PATH, FILE_NAME
    select IFNULL(max(f.norder)+1,0) as norder, date_format(d.created,'%Y/%m') as "DOC_PATH"
    from doc_files f join d_list d on d.id=f.doc_id
    where f.doc_id = #doc_id#
        and f.field_id='#field_id#' ??field_id
        and f.field_id is null ??!field_id
        ;
    insert into doc_files(doc_id, norder, file_name, file_ext, file_content_type
        , field_id
        , comment, upload_date, uploader_id)
    values(#doc_id#, #norder#, '#new_file#', '#new_file_TYPE#', '#new_file_CONTENT_TYPE#'
        , '#field_id#' ??field_id
        , null         ??!field_id
        , '#file_comment#', now(), #USER_ID#)
    ;

    select LAST_INSERT_ID() as "NEW_FILE_ID"
    ;

    select '#file_storage_path##DOC_PATH#/#doc_id#/' as "FILE_PATH"
        , '#file_copy_path##DOC_PATH#/#doc_id#/' as "FILE_COPY_PATH" ??file_copy_path
        , 'f#NEW_FILE_ID#.#new_file_TYPE#' as "FILE_NAME"
        , '#DOC_PATH#/#doc_id#/f#NEW_FILE_ID#.#new_file_TYPE#' as "FILE_REL_PATH"
[end]


[update registration]  ****** ставим относительный путь к файлу и его размер
update doc_files set file_size=#file_size#, fs_file_name='#FILE_REL_PATH#'
where id=#NEW_FILE_ID#
;
update d_data_#DOC_TYPE_ID# set #field_id#_id=#NEW_FILE_ID#, #field_id#='#file_comment#' where doc_id = #doc_id# ??field_id
[end]

[register page]
    replace into doc_file_pages (file_id, page_nr, fs_file_name, file_size, err, uploaded)
    values(#NEW_FILE_ID#, 1, '#FILE_REL_PATH#', #file_size#, '', now())
    ;
    replace into doc_file_convert (file_id, doc_id, sent, finished, time, num_pages, responce)
    values(#NEW_FILE_ID#, #doc_id#, now(), now(), 0, 1, 'Ok')
[end]