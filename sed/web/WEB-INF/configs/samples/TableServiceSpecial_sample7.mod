samples/TableServiceSpecial_sample7.mod

[comments]
testURL=?c=samples/TableServiceSpecial_sample7
author:Белякова О.В.
[end]

[description]
    Пример применения сервиса TableServiceSpecial.
    <ol>
        <li>Создает форму с фильтрами, получает данные из базы для формирования выпадающих списков</li>
        <li>Выводит заголовок таблицы </li>
        <li>Выполняет запрос в БД</li>
        <li>Выводит тело таблицы</li>
        <li>По клику на строку таблицы выводит модальное окно с данными одной строки</li>
    </ol>
Отличие от samples/TableServiceSpecial_sample6.mod в способе AJAX-загрузки контента.
Здесь - с использованием общей функции СЭДа AjaxCall
[end]

[parameters]
    service=dubna.walt.service.TableServiceSpecial
    tableCfg=table_no
[end]

[head]
    <head>
    <meta charset="utf-8">
    <title>TableServiceSpecial_sample6</title>
    
    <script type="text/javascript" src="#jsPath#jquery-1.11.0.min.js"></script>

    <link rel="stylesheet" href="mob/BS/css/bootstrap.min.css">
    <script src="mob/BS/js/bootstrap.min.js"></script>
    <!-- Подключения скрипта control-modal.min.js к странице -->
    <script src="mob/BS/js/control-modal.min.js"></script>
    <script type="text/javascript">
        $INCLUDE free/js_CallModule.dat[report]
        $INCLUDE free/js_service.dat[log function_]
        var setStandardEvents = function() {;}
    </script>

    <style>
        table {
           border: solid 1px ##e0e0e0; 
           font-size:11pt; 
           font-family: Arial;
           }
            td {
                border: none 1px white; 
                padding: 5px;       
           }
            .stripe {
                background: #E0FFFF;
               } 

            .doc_item:hover {
                background: #FFFF80; /* Цвет фона при наведении */    
                cursor:pointer;
           }
    </style>

    <script type="text/javascript">
        /**
         * Раскраска таблицы и установка обработчика события 
         */ 
        $(document).ready(function(){                             
             $("table tr:even").addClass('stripe');

    про события модального окна см. https://getbootstrap.com/docs/4.0/components/modal/#events  ??

            $('##myModal').on('show.bs.modal', function (event) {
                var tr = $(event.relatedTarget)     // <tr...> that triggered the modal
                var id = tr.data('person_id')       // Extract info from data-* attributes
                $("##modal-body").html("<br><center>loading...<br></center><br><br>");
                AjaxCall=function(target_div, query, force, containerId, showProgress) ??
                AjaxCall("modal-body", "c=samples/Service_sample7.mod&id=" + id, false, false, false);
            })
        });
    </script>
    </head>
[end]

[report header]
    <html>
    $INCLUDE [head] 
    <body>
    +++++ Форма (фильтры, сортировка, и др.) +++++ ??
    <form name="theForm" method="post">
    +++++++ Начальная строка и кол-во строк на странице по умолчанию ++++ ??
    $SET_PARAMETERS srn=1; rpp=9990;  

    <center>
    +++++++ с - путь к текущему модулю +++++ ??
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
            <td style="text-align: center;">
                <input type="submit" style="width:130; text-align: center;" value="Выполнить"> </br>
            </td>
        </tr>
        </tbody>
    </table>

    $SET_PARAMETERS srt=dh.STATUS; desc=; ??!srt
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


[item] ***** Cоздание строки таблицы - 1 записи
    <tr class="doc_item clickable modal-show" 
            data-toggle="modal" 
            data-target="##myModal" 
            data-person_id="#id#">
        <td>#id#</td> 
        <td>#F# #I# #O#</td> 
        <td>#country#</td>
        <td>#city#</td>
        <td>#profession#</td>
    </tr>
[end]


[report footer]
    </table>
    </center>
    </form>
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog">
         <div class="modal-dialog">
           <div class="modal-content">
              <div class="modal-header"><button class="close" type="button" data-dismiss="modal">x</button>
                 <h4 class="modal-title" id="myModalLabel">Название модального окна</h4>
              </div>
            <div id="modal-body" class="modal-body">
            </div>
        </div>
      </div>
    </div>

    </body>
    </html>
[end]

[SQL]  ****** Шаблон SQL запроса 
    select id, F, I, O, country, city, profession
    from test_persons
    where 1=1
        and F like '#f#%' ??f
        and I like '#i#%' ??i
        and O like '#o#%' ??o
        and city like '#city#%' ??city
        and country like '#country#%' ??country
    order by F, I, O
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
