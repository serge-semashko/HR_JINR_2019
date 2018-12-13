samples/Service_sample2.mod

[comments]
testURL=?c=samples/Service_sample2
author:Белякова О.В.
[end]

[description]
    Пример применения сервиса Service.
    <ol>
        <li>Выводит информацию одной строки из базы данных по ID в отдельное окно.</li>
        <li>Позволяет менять информацию в БД с помощью форм</li>       
    </ol>
[end]

[parameters]
    service=dubna.walt.service.Service
    tableCfg=table_no
[end]

[head]
    <head>
    <meta charset="utf-8">
    <title>Service_sample2</title>
    <style>
        td {border:1px solid white}
        tr:nth-child(2n) {
            background: #E0FFFF;
           } 
        tr:nth-child(1) {
           background: #B0E0E6; 
           }
        select.test {
           width: 97pt;
           }
    </style>
    </head>
[end]


[report]
    $SET_PARAMETERS id=1;  ??!id
    $GET_DATA [update person]  ??cop=update 
    $GET_DATA [get person]   
    <html>
    $INCLUDE [head] 
    <body>
    <center>
    

+++++ Форма (фильтры) +++++ ??
    <form id="form_norm" name="theForm" method="post" enctype="multipart/form-data">
        +++++ с - путь к текущему модулю +++++ ??
        <input type=hidden name="c" value="#c#">
         <table border="1" cellpadding="7">
            <tbody>
             <tr><td>ID:</td><td><input size=5 name="id" value="#id#"></td>
              <td><input type="submit" style="width:130;" value="Искать по ID"></br></td>
             </tr> 
            </tbody>
         </table>

        <input type=hidden name="cop" value="">
        <table border="1" cellpadding="7">
            <tbody>
            <tr><td>Фамилия:</td><td>#F#</td><td><input size=17 name="F" value="#F#"></td></tr>
            <tr><td>Имя:</td><td>#I#</td><td><input size=17 name="I" value="#I#"></td></tr>
            <tr><td>Отчество:</td><td>#O#</td><td><input size=17 name="O" value="#O#"></td></tr>
            
 +++++++ Директива выполнения запроса в бд +++++++++ ??
                $GET_DATA [get dropdowns]
            <tr><td>Страна:</td><td>#country#</td><td>
                    <select class="test" name=country class=norm>
                        #COUNTRIES#
                    </select></td></tr>
            <tr><td>Город:</td><td>#city#</td><td>
                    <select class="test" name=city class=norm>                        
                        #CITIES#
                    </select></td></tr>
            <tr><td>Профессия:</td><td>#profession#</td><td>
                        <select class="test" name=profession class=norm>                        
                        #PROFESSIONS#
                    </select></td></tr></td></tr>                     
            <tr>
                <td colspan=3 style="text-align:center;">
                    <input type="button" onClick="document.theForm.cop.value='update'; document.theForm.submit();" style="width:130;" value="Сохранить"> </br> 
                </td>
            </tr>
            </tbody>
        </table>
    </form>
                
            </center>
      
</body>
    </html>

[end]

[get person]  ***** Шаблон SQL-запроса 
    select id, F, I, O, country, city, profession
    from test_persons
    where id='#id#'
[end]

[update person]  ***** Шаблон SQL-запроса 
    update test_persons
    set  F='#F#', I='#I#', O='#O#', country='#country#', city='#city#', profession='#profession#'
     where id='#id#'
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
    ;
    select distinct concat('<option value="', profession, '" '
        , case when profession='#profession#' then 'selected' else '' end
        , '>' , profession, '</option>')as PROFESSIONS
    from test_persons
[end]
