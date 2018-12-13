files/sys/svs/movePages.mod


[comments]
descr=S: Перемещение растрированных страниц файла или всех файлов
input=[file_id] - id файла в таблице doc_files, [limit]
output=none
parents=
author=Куняев
test_URL=?c=files/sys/svs/movePages&file_id=12380&limit=1
[end]

[parameters]
service=dubna.walt.service.TableServiceSpecial
tableCfg=table_no
LOG=ON
[end]

[report header]
$SET_PARAMETERS limit=2; ??
    <br>
    Перемещение страниц 
    файла #file_id# ??file_id
    ВСЕХ файлов ??!file_id
     <b>#file_pages_path# => #new_file_pages_path#</b> <br><hr>
[end]

[item]
    $SET_PARAMETERS ERROR=;
    $GET_FILE_SIZE #file_pages_path##fs_file_name#
    PAGE_ID=#PAGE_ID#;  #fs_file_name#; size=#FILE_SIZE# / #file_size#
    $LOG  MOVE_FILE: #file_pages_path##fs_file_name# => #new_file_pages_path##fs_file_name#;  ??!ERROR
    $SET_PARAMETERS ERROR=NOT PAGE!     ??!IS_PAGE=Y
    $SET_PARAMETERS ERROR=FILE SIZE ERROR!   ??!FILE_SIZE=#file_size#
    $SET_PARAMETERS ERROR=FILE NOT FOUND!   ??!FILE_SIZE>0

    => #new_file_pages_path##fs_file_name#;   ??!ERROR
    $MOVE_FILE #file_pages_path##fs_file_name#; #new_file_pages_path##fs_file_name#;  ??!ERROR
    OK  ??!ERROR
    <b>#ERROR#</b> ??ERROR
    $LOG  OK;<br>  ??!ERROR
    $LOG  <b>#ERROR#;</b><br>  ??ERROR
    <br>
[end]

    $COPY_FILE #file_pages_path##fs_file_name#; #new_file_pages_path##fs_file_name#;  ??!ERROR&ZZZ
    $GET_FILE_SIZE #new_file_pages_path##fs_file_name#; ??FILE_SIZE>0
    $SET_PARAMETERS   CAN_DELETE_FILE=Y;  ??FILE_SIZE=#file_size#
    $DELETE_FILE #file_pages_path##fs_file_name#;  ??CAN_DELETE_FILE=Y&!ERROR


[report footer]
[end]


============================================================================
============================================================================
============================================================================

[SQL]
    select id as "PAGE_ID", fs_file_name, file_size
        , case when fs_file_name like '%_page_%' then 'Y' else '' end as "IS_PAGE"
    from doc_file_pages
    where file_id=#file_id# ??file_id
    limit #limit#  ??limit
[end]

