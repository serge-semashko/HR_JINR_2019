samples/Service_sample1.mod

[comments]
testURL=?c=samples/Service_sample1
author:Белякова О.В.
[end]

[description]
    Пример применения сервиса Service.
    <p>Выводит информацию одной строки из базы данных по ID в отдельное окно.</p>
    
[end]

[parameters]
    service=dubna.walt.service.Service
    tableCfg=table_no
[end]

[head]
    <head>
    <meta charset="utf-8">
    <title>Service_sample1</title>
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

[report]
    <html>
    $INCLUDE [head]
    <body>
    <center>
    $GET_DATA [get person]
        <table border="1" cellpadding="7">
            <tbody>
            <tr><td>ID:</td><td>#id#</td></tr> 
            <tr><td>Фамилия:</td><td>#F#</td></tr>
            <tr><td>Имя:</td><td>#I#</td></tr>
            <tr><td>Отчество:</td><td>#O#</td></tr>
            <tr><td>Страна:</td><td>#country#</td></tr>
            <tr><td>Город:</td><td>#city#</td></tr>
            <tr><td>Профессия:</td><td>#profession#</td></tr>
            
            </tbody>
        </table>
            </center>
        </body>
    </html>

[end]

[get person]  ***** Шаблон SQL-запроса 
    select id, F, I, O, country, city, profession
    from test_persons
    where id=1
[end]
