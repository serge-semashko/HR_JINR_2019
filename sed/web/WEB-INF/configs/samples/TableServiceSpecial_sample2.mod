samples/TableServiceSpecial_sample2.cfg

[comments]
testURL=?c=samples/TableServiceSpecial_sample2
author:Фуряева
[end]

[description]
    Пример применения сервиса TableServiceSpecial.
    <ol>
        <li>Создает форму с фильтрами, получает данные из базы для формирования выпадающих списков</li>
        <li>Выводит заголовок таблицы </li>
        <li>Выполняет запрос в БД</li>
        <li>Выводит результат в виде таблицы</li>
    </ol>
[end]

[parameters]
    service=dubna.walt.service.TableServiceSpecial
    tableCfg=table_no
[end]

[head]
    <head>
    <meta charset="utf-8">
    <title>TableServiceSpecial_sample2</title>
    <style>
        td {border:1px solid white}
        tr:nth-child(2n) {
            background: #E0FFFF;
           } 
        tr:nth-child(1) {
           background: #B0E0E6; 
           }
    </style>
    </head>
[end]

[report header]
    <html>
    $INCLUDE [head] 
    <body>
    <center>
    +++++ Форма (фильтры) +++++ ??
    <form name="theForm" method="post">
        +++++ с - путь к текущему модулю +++++ ??
        <input type=hidden name="c" value="#c#">
        <table border="0" cellpadding="7">
            <tbody>
            <tr> 
                <td>Фамилия: <input size=15 name="f" value="#f#"></td>
                <td>Имя:<input size=15 name="i" value="#i#"></td>
                <td>Отчество:<input size=15 name="o" value="#o#"></td>
            </tr>
            <tr>
            +++++++ Директива выполнения запроса в бд +++++++++ ??
                $GET_DATA [get dropdowns]
                <td>Страна: 
                    <select name=country class=norm>
                        <option value="">любая</option>
                        #COUNTRIES#
                    </select>
                <td>
                    Город: 
                    <select name=city class=norm>
                        <option value="">любой</option>
                        #CITIES#
                    </select>
                </td>
                <td>
                    <input type="submit" style="width:130;" value="Выполнить"> </br>
                </td>
            </tr>
            </tbody>
        </table>
    </form>

    +++++++ Шапка таблицы +++++ ??
    <table class="tlist tgreen" cellspacing=0 border="1">
        <tr>
            <th>ID</th>
            <th>ФИО</th>
            <th>Страна</th>
            <th>Город</th> 
            <th>Профессия</th> 
        </tr>
[end]

[get dropdowns] ***** Получение данных из базы в выпадающий список
    select distinct concat('<option value="', country, '" '
        , case when country='#country#' then 'selected' else '' end
        , '>' , country, '</option>') as COUNTRIES
    from test_persons
    ;
    select distinct concat('<option value="', city, '" '
        , case when city='#city#' then 'selected' else '' end
        , '>' , city, '</option>')as CITIES
    from test_persons
[end]

[item] ***** Шаблон вывода одной строки таблицы - 1 записи
    <tr>
        <td>#id#</td> 
        <td>#F# #I# #O#</td> 
        <td>#country#</td>
        <td>#city#</td>
        <td>#profession#</td>
    </tr>
[end]

[SQL]  ***** Шаблон SQL-запроса 
    select id, F, I, O, country, city, profession
    from test_persons
    where 1=1
        and F like '#f#%' ??f
        and I like '#i#%' ??i
        and O like '#o#%' ??o
        and city like '#city#%' ??city
        and country like '#country#%' ??country
[end]

[report footer]
                </table>
            </center>
        </body>
    </html>
[end]
