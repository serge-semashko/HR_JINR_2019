files/sys/svs/checkFiles.mod


[comments]
descr=S: Проверка соответствия файлов регистрации в БД
input=[doc_id] - id документа, [fix]=Y - удалить из базы ошибочные записи, =D - удалить ошибочную регистрацию файлов удаленных документов
output=none
parents=
author=Куняев
test_URL=?c=files/sys/svs/checkFiles&doc_id=6498
[end]

[parameters]
service=dubna.walt.service.TableServiceSpecial
tableCfg=table_no
LOG=ON
[end]

[report header]
<html><head><title>Check Files</title></head><body>
    <br>
    Проверка файлов 
    документа #doc_id# ??doc_id
    ВСЕХ документов ??!doc_id
    <br>file_storage_path=#file_storage_path#; file_copy_path=#file_copy_path#;
    doc_id=#doc_id#; show_ALL=#show_ALL# (Y), fix=#fix# (Y, D); limit=#limit#;<br><hr>
    $SET_PARAMETERS OK_COUNTER=0; ERR_COUNTER=0;
[end]

[item]
    $GET_FILE_SIZE #file_copy_path##fs_file_name#  ??file_copy_path
    $SET_PARAMETERS COPY_SIZE=#FILE_SIZE#;  
    $GET_FILE_SIZE #file_storage_path##fs_file_name#
    $SET_PARAMETERS COPY_SIZE=#FILE_SIZE#;  ??
            ??pid
    $LOG3  doc_id=#id#. #doc_id# #file_id# size=#file_size# / #FILE_SIZE# / #COPY_SIZE# ; #fs_file_name# / #file_name# 
    $SET_PARAMETERS OK=Y;  ??FILE_SIZE>0&FILE_SIZE=#file_size#&COPY_SIZE=#file_size#|!file_copy_path
    $LOG3 - OK<br>  ??OK=Y
    $GET_DATA [increase OK]  ??OK=Y

    $INCLUDE [msg] ??show_ALL=Y
    $INCLUDE [ERR msg]   ??!OK=Y
    ERROR: #ERROR#<br> ??ERROR
    $SET_PARAMETERS FILE_SIZE=; file_size=; COPY_SIZE=; OK=;  ERROR=; pid=;
    <br> ??show_ALL=Y
[end]

    $GET_DATA [delete non-existing docs files]  ??!id
/home/tomcat/fs/sed/files/

[msg]
    doc_id=#id#. 
    <a target="blank" href="#ServletPath#?c=docs/view_doc&doc_id=#doc_id#&mode=ext">#doc_id#</a> 
    <a target="blank" href="#ServletPath#?c=viewer/show_file&id=#file_id#">#file_id#</a>: 
    size=#file_size# / #FILE_SIZE# / #COPY_SIZE#; <small> #fs_file_name#; 
     #file_name# </small>
    - OK  ??OK=Y
[end]


[ERR msg]
    $INCLUDE [msg]  ??!show_ALL=Y
    <b> / ERROR!
    file size=#FILE_SIZE#    ??!FILE_SIZE=#file_size#
    file copy syze=#COPY_SIZE#    ??!COPY_SIZE=#file_size#
    </b>
    $GET_DATA [delete file]  ??fix=Y|fix=D
    $DELETE_FILE #file_storage_path##fs_file_name#    ??fs_file_name&fix=Y|fix=D
    $CALL_SERVICE c=files/sys/deleteFilePages;      ??fix=Y|fix=D
        deleted ??fix=Y|fix=D
    $GET_DATA [increase ERR]
    <br>  ??!show_ALL=Y
[end]

[report footer]
    <hr><b>
        Без ошибок: #OK_COUNTER#,  Ошибок: #ERR_COUNTER#; 
    </b>
    <hr>
</body></html>
[end]


============================================================================
============================================================================
============================================================================

[SQL]
    select dh.id, dh.pid, f.doc_id, f.id as "file_id", f.file_name
        , f.fs_file_name, f.file_size      
    from doc_files f 
        left join d_list dh on dh.id=f.doc_id
    where 1=1
        and f.is_deleted=0  ??!fix=D
        and dh.is_deleted=0 ??!fix=D
        and dh.id is null   ??fix=D        
        and f.doc_id=#doc_id# ??doc_id
    order by f.doc_id desc
    limit #limit#  ??limit
[end]

[increase OK]
    select 1+#OK_COUNTER# as "OK_COUNTER"
[end]

[increase ERR]
    select 1+#ERR_COUNTER# as "ERR_COUNTER"
[end]


[delete file]
    update doc_files set is_deleted=1 where id=#file_id# 
[end]

[delete non-existing docs files]
    delete from doc_files where doc_id=#doc_id#
[end]

