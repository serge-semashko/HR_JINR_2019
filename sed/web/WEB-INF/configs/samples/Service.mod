samples/Service.mod

[comments]
descr=Описание использования Service
input=
output=
parents=tab_samples.cfg
childs=
testURL=?c=samples/include&ajax=Y
author=Куняев
[end]

[description]
Описание Service
[end]


[parameters]
title=$INCLUDE
[end]

[report]
    $INCLUDE samples/common.dat[start]

    <h3>Service</h3>

    <fieldset class="code bg_white"><legend>Описание:</legend>
        Базовый сервис Service предназначен для работы с одной записью таблицы БД<br><br>
        <ul>
            <li>...</li>
            <li>...</li>
            <li>...</li>
        </ul>
        </p>
    </fieldset>


    <fieldset class="code"><legend>Примеры:</legend>
        <ol>
            <li class="m20 bg_white">
                <a href="#ServletPath#?c=sys/cfgdoc/module_src_noDB&dir=samples/&name=Service_sample1" target=_blank>
                    Вывод данных одной строки из БД по ID в отдельное окно (простой вариант для просмотра данных)
                </a>
            </li>
            <li class="m20 bg_white">
                Добавлено:
                <a href="#ServletPath#?c=sys/cfgdoc/module_src_noDB&dir=samples/&name=Service_sample2" target=_blank>
                    Вывод данных одной строки из БД по ID в отдельное окно с формой (для изменеия данных в БД) 
                </a>
            </li>                        
        </ol>
        <hr>
    </fieldset>

    $INCLUDE samples/common.dat[bottom]

[end]