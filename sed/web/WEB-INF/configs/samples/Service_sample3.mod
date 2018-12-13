samples/Service_sample3.mod

[comments]
testURL=?c=samples/Service_sample3
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
    <title>Service_sample3</title>
    <style>
        td {border:1px solid white}
        tr:nth-child(1n) {
            background: #FFFFFF;
           } 
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
    $INCLUDE [update] ??cop=update 
    $INCLUDE [show] 
[end]

[update]
    $GET_DATA [update person]
[end]

[show]
    $SET_PARAMETERS id=1;  ??!id
    $GET_DATA [get person]   
    <html> 
    $INCLUDE [head] 
    <body>
    <center>
    

+++++ Форма (фильтры) +++++ ??
    <form id="form_norm" name="theForm" method="post" enctype="multipart/form-data" >
        +++++ с - путь к текущему модулю +++++ ??
        <input type=hidden name="c" value="#c#">
         

        <input type=hidden name="cop" value="">
        <table border="1" cellpadding="7">
            <tbody>
            <tr><td>ID:</td><td>#id#</td><td><input size=17 name="id" value="#id#"></td></tr>
            <tr><td>Фамилия:</td><td>#F#</td><td><input size=17 name="F" value="#F#"></td></tr>
            <tr><td>Имя:</td><td>#I#</td><td><input size=17 name="I" value="#I#"></td></tr>
            <tr><td>Отчество:</td><td>#O#</td><td><input size=17 name="O" value="#O#"></td></tr>
            
 +++++++ Директива выполнения запроса в бд +++++++++ ??
                $GET_DATA [get dropdowns]
            <tr><td>Страна:</td><td>#country#</td><td>
                    <select class="test" id=country class=norm>
                        #COUNTRIES#
                    </select></td></tr>
            <tr><td>Город:</td><td>#city#</td><td>
                    <select class="test" id=city class=norm>                        
                        #CITIES#
                    </select></td></tr>
            <tr><td>Профессия:</td><td>#profession#</td><td>
                        <select class="test" id=profession class=norm>                        
                        #PROFESSIONS#
                    </select></td></tr></td></tr>                     
            <tr>  
                <td colspan=3 style="text-align:center;">
                    <input type="button" onClick="location.reload();" style="width:130;"  value="Закрыть">
                    <input type="button" onClick="
                        var idName = 'id';
                            newid = ($('input[name='+idName+']').val());                  
                        var vName = 'F';
                            newF = ($('input[name='+vName+']').val());  
                        var iName = 'I';
                            newI = ($('input[name='+iName+']').val());
                        var oName = 'O';
                            newO = ($('input[name='+oName+']').val());
                        var cName = 'country';
                            newcountry = ($('##'+cName).val());
                        var ciName = 'city';
                            newcity = ($('##'+ciName).val());
                        var pName = 'profession';
                            newprofession = ($('##'+pName).val());
                        $('#myModal1').load('/sed/dubna?c=samples/Service_sample3.mod&id='+newid+'&F='+newF+'&I='+newI+'&O='+newO+'&country='+newcountry+'&city='+newcity+'&profession='+newprofession+'&cop=update');
                        $('#myModal').show();
                    "
                    style="width:130;" value="Сохранить"></br> 
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
