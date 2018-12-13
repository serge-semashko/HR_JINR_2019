samples/TableServiceSpecial.ajm


[comments]
descr=Описание использования TableServiceSpecial
input=
output=
parents=tab_samples.ajm
childs=
testURL=?c=samples/include&ajax=Y
author=Куняев
[end]

[description]
Описание TableServiceSpecial
[end]


[parameters]
title=$INCLUDE
[end]

[report]
    $INCLUDE samples/common.dat[start]

    <h3>TableServiceSpecial</h3>

    <fieldset class="code bg_white"><legend>Описание:</legend>
        Сервис TableServiceSpecial предназначен для ...<br><br>
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
                <a href="#ServletPath#?c=sys/cfgdoc/module_src_noDB&dir=samples/&name=TableServiceSpecial_sample1" target=_blank>
                    Выполнение SQL-запроса в базу данных и отображение результатов в виде таблицы (простейший вариант)
                </a>
            </li>
            <li class="m20 bg_white">
                Добавлено:
                <a href="#ServletPath#?c=sys/cfgdoc/module_src_noDB&dir=samples/&name=TableServiceSpecial_sample2" target=_blank>
                    ввод фильтров и включение их в SQL-запрос
                </a>
            </li>
            <li class="m20 bg_white">
                Добавлено:
                <a href="#ServletPath#?c=sys/cfgdoc/module_src_noDB&dir=samples/&name=TableServiceSpecial_sample3" target=_blank>
                    постраничный вывод и сортировка таблицы
                </a>
            </li> 
            <li class="m20 bg_white">
                Добавлено:
                <a href="#ServletPath#?c=sys/cfgdoc/module_src_noDB&dir=samples/&name=TableServiceSpecial_sample4" target=_blank>
                    кликабельность строк таблицы с выводом информации в модальное окно
                </a>
            </li>
            <li class="m20 bg_white">
                Добавлено:
                <a href="#ServletPath#?c=sys/cfgdoc/module_src_noDB&dir=samples/&name=TableServiceSpecial_sample5" target=_blank>
                    кликабельность строк таблицы с выводом информации в модальное окно с помощью библиотеки Bootstrap
                </a>
            </li>     
        </ol>
        <hr>
    </fieldset>

    $INCLUDE samples/common.dat[bottom]

[end]


