samples/Service_sample6.mod

[comments]
testURL=?c=samples/Service_sample6
author:Белякова О.В.
[end]

[description]
    Пример применения сервиса Service.
    <ol>
        <li>Выводит информацию одной строки из базы данных по ID в отдельное окно.</li>
        <li>Позволяет менять информацию в БД с помощью формы</li>       
    </ol>
[end]

[parameters]
    service=dubna.walt.service.Service
    tableCfg=table_no
[end]


[report]
    $INCLUDE [update] ??cop=update&id
    $INCLUDE [show]  ??!cop=update|ERROR
[end]

[update]
    $GET_DATA [update person]
    <script type="text/javascript">
        $('##myModal').modal('hide'); ??!ERROR
        document.theForm.submit(); ??!ERROR
    </script>
[end]

[show]
    $SET_PARAMETERS id=1;  ??!id
    $GET_DATA [get person]   

    <center> 
+++++ Форма +++++ ??
        <table border="1" cellpadding="7">
            <tbody>
            <tr><td>ID:</td><td colspan=2><input readonly size=5 name="id" value="#id#"></td></tr>
            <tr><td>Фамилия:</td><td>#F#</td><td><input size=17 name="F" value="#F#"></td></tr>
            <tr><td>Имя:</td><td>#I#</td><td><input size=17 name="I" value="#I#"></td></tr>
            <tr><td>Отчество:</td><td>#O#</td><td><input size=17 name="O" value="#O#"></td></tr>
            
 +++++++ Директива выполнения запроса в бд +++++++++ ??
            $GET_DATA [get dropdowns]
            <tr><td>Страна:</td><td>#country#</td><td>
                    <select class="test" id="country" class=norm>
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
            </tbody>
        </table>
    </center>

    <div class="modal-footer" style="text-align:center; margin-top:10px;">
        <button class="btn btn-primary" type="button" onClick="
                $('##modal-body').load('/sed/dubna?c=#c#'
                    +'&id=' + $('input[name=id]').val()
                    +'&F=' + $('input[name=F]').val()
                    +'&I=' + $('input[name=I]').val()
                    +'&O=' + $('input[name=O]').val()
                    +'&country=' + $( '##country option:selected' ).text() 
                    +'&city=' +  $( '##city option:selected' ).text() 
                    +'&profession=' + $( '##profession option:selected' ).text() 
                    +'&cop=update');
            "> Сохранить </button>  
        <button class="btn btn-default" type="button" data-dismiss="modal"> Отмена </button>  
     </div>
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

