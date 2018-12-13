JINR/export/configuration_22.mod

[comments]
descr=U: Модуль экспорта в шлюз для 1С всего справочника типовых конфигураций.
input=
output=
childs=gateway/post_info.mod
author=Куняев
[end]


[parameters]
service=dubna.walt.service.TableServiceSpecial
request_name=U:Эекпорт конфигураций
LOG=ON 
tableCfg=table_no
[end]


[report header]
$INCLUDE dat/common.dat[check login]
$INCLUDE [OK report header]  ??USER_ID=1
[end]


[OK report header]
[end]


[item]
$CALL_SERVICE c=gateway/post_info; info_id=1017; rec_id=#ITEM_ID#; info_view=13; silent=Y;
[end]



[report footer]
[end]


***************************** Шаблон SQL запроса ***************************

[SQL]
    select id as "ITEM_ID"
    from i_jinr_comp_configuration
where id<11 ??
    order by pid, id
[end]
