files/sys/svs/checkPages.mod


[comments]
descr=S: Проверка растрированных страниц файла
input=[file_id] - id файла в таблице doc_files, [fix]=Y - удалить из базы ошибочные записи, =I - переконвертить файлы-изображения
output=none
parents=
author=Куняев
test_URL=?c=files/sys/svs/checkPages&file_id=6550
[end]

[parameters]
service=dubna.walt.service.TableServiceSpecial
tableCfg=table_no
LOG=ON
[end]

[report header]
<html><head><title>Check Pages</title></head><body>
    <br>
    Проверка страниц 
    файла #file_id# ??file_id
    ВСЕХ файлов ??!file_id
    file_pages_path=#file_pages_path# <br>
    file_id=#file_id#; show_ALL=#show_ALL# (Y), fix=#fix# (Y, I, S); limit=#limit#<hr>
    $SET_PARAMETERS OK_COUNTER=0; ERR_COUNTER=0;
[end]

[item]
    $GET_FILE_SIZE #file_pages_path##fs_file_name#
    $INCLUDE [msg] ??show_ALL=Y
    $INCLUDE [ERR msg]   ??!FILE_SIZE>0|!FILE_SIZE=#file_size#|!IS_PAGE
    $GET_DATA [increase OK]  ??FILE_SIZE>0&FILE_SIZE=#file_size#&IS_PAGE
    ERROR: #ERROR#<br> ??ERROR

    $SET_PARAMETERS ERROR=; FILE_SIZE=; file_size=; IS_PAGE=; FILE_IS_IMAGE=;
    <br> ??show_ALL=Y
[end]

    $GET_DATA [delete non-existing docs files]  ??!id

[msg]
    doc_id=#id#. 
    <a target="blank" href="#ServletPath#?c=docs/view_doc&doc_id=#doc_id#&mode=ext">#doc_id#</a> &nbsp;
    file: <a target="blank" href="#ServletPath#?c=viewer/show_file&id=#file_id#">#file_id#</a> 
    / #PAGE_ID#:  #fs_file_name#; size=#file_size#
    - OK ??FILE_SIZE>0&FILE_SIZE=#file_size#&IS_PAGE
[end]


[ERR msg]
    $INCLUDE [msg]  ??!show_ALL=Y
    <b>/ #FILE_SIZE#. 
    IMAGE ??FILE_IS_IMAGE
    not _page_ ??!IS_PAGE
    ERROR!</b>

    reparing... ??fix=I&FILE_IS_IMAGE
    $CALL_SERVICE c=files/sys/sendConvertRequest;  ??FILE_IS_IMAGE&fix=I

    $GET_DATA [delete page]  ??fix=Y&IS_PAGE
    $DELETE_FILE #file_pages_path##fs_file_name#    ??fix=Y&IS_PAGE
        deleted ??fix=Y&IS_PAGE
    <br>  ??!show_ALL=Y

    $GET_DATA [fix size]  ??fix=S&FILE_SIZE>0
    $GET_DATA [increase ERR]
[end]

[fix size]
update doc_file_pages set file_size=#FILE_SIZE# where id=#PAGE_ID#
[end]

[report footer]
    $INCLUDE [update files info] ??fix=Y
    $GET_DATA [update files info] ??fix=Y
    <hr><b>
        Без ошибок: #OK_COUNTER#,  Ошибок: #ERR_COUNTER#; 
    </b>
</body></html>
[end]


============================================================================
============================================================================
============================================================================

[SQL]
    select dh.id, f.doc_id, p.file_id, p.id as "PAGE_ID"
        , p.fs_file_name, p.file_size
        , case when p.fs_file_name like '%_page_%' then 'Y' else '' end as "IS_PAGE"       
        , case when lower(f.file_ext) in ('jpg', 'png', 'jpeg') then 'Y' else '' end as "FILE_IS_IMAGE" 

    from doc_file_pages p 
        left join doc_files f on f.id=p.file_id
        left join d_list dh on dh.id=f.doc_id
    where 
        f.is_deleted=0
        and p.file_id=#file_id# ??file_id
        and p.file_size is null ??fix=S
    order by p.file_id desc
    limit #limit# ??limit
[end]

[increase OK]
    select 1+#OK_COUNTER# as "OK_COUNTER"
[end]

[increase ERR]
    select 1+#ERR_COUNTER# as "ERR_COUNTER"
[end]


[delete page]
    delete from doc_file_pages where file_id=#file_id# ??file_id
    ;
    delete from doc_file_pages where id=#PAGE_ID# ??!file_id
[end]

[delete non-existing docs files]
    delete from doc_files where doc_id=#doc_id#  ??doc_id
[end]

[update files info]
    update doc_file_convert c
    set NUM_PAGES=(select count(*) from doc_file_pages where file_id=c.file_id and width=900)
[end]

    ;
    delete from doc_file_pages where file_id=#file_id# ??file_id
