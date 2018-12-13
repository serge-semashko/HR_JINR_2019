files/sys/svs/moveFies.mod


[comments]
descr=S: Перемещение файлов документа или всех файлов
input=[doc_id] - id документа, [limit]
output=none
parents=
author=Куняев
test_URL=?c=files/sys/svs/moveFies&doc_id=8561&limit=1
[end]

[parameters]
service=dubna.walt.service.TableServiceSpecial
tableCfg=table_no
LOG=ON
[end]

[report header]
$SET_PARAMETERS limit=2; ??
    <br>
    Перемещение 
    файлов документа #doc_id# ??doc_id
    ВСЕХ файлов ??!doc_id
     <b>#file_storage_path# => #new_file_storage_path#</b> <br><hr>
[end]


[item]
    $SET_PARAMETERS ERROR=;
    $GET_FILE_SIZE #file_storage_path##fs_file_name#
    FILE_ID=#FILE_ID#;  #fs_file_name#; size=#FILE_SIZE# / #file_size#
    $LOG  MOVE_FILE: #file_storage_path##fs_file_name# => #new_file_storage_path##fs_file_name#;  ??!ERROR
    $SET_PARAMETERS ERROR=FILE SIZE ERROR!   ??!FILE_SIZE=#file_size#
    $SET_PARAMETERS ERROR=FILE NOT FOUND!   ??!FILE_SIZE>0

    => #new_file_storage_path##fs_file_name#;   ??!ERROR
    $MOVE_FILE #file_storage_path##fs_file_name#; #new_file_storage_path##fs_file_name#;  ??!ERROR
    OK  ??!ERROR
    <b>#ERROR#</b> ??ERROR
    $LOG  OK;<br>  ??!ERROR
    $LOG  <b>#ERROR#;</b><br>  ??ERROR
    <br>
[end]


[report footer]
[end]


============================================================================
============================================================================
============================================================================

[SQL]
    select id as "FILE_ID", fs_file_name, file_size
    from doc_files
    where is_deleted=0
        and doc_id=#doc_id# ??doc_id
    limit #limit#  ??limit
[end]

