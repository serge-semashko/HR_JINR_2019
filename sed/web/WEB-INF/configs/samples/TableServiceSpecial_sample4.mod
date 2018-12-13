samples/TableServiceSpecial_sample4.cfg

[comments]
testURL=?c=samples/TableServiceSpecial_sample4
author:Белякова О.В.
[end]

[description]
    Пример применения сервиса TableServiceSpecial.
    <ol>
        <li>Создает форму с фильтрами, получает данные из базы для формирования выпадающих списков</li>
        <li>Выводит заголовок таблицы </li>
        <li>Выполняет запрос в БД</li>
        <li>Выводит тело таблицы</li>
        <li>Сортировка таблицы</li>
        <li>Создает навигацию по страницам</li>
        <li>По клику на строку таблицы выводит модальное окно с информацией</li>
    </ol>
[end]

[parameters]
    service=dubna.walt.service.TableServiceSpecial
    tableCfg=table_no
[end]

[head]
    <head>
    <meta charset="utf-8">
    <title>TableServiceSpecial_sample4</title>    
    <script type="text/javascript" src="#jsPath#jquery-1.11.0.min.js"></script>
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
            .oddRow {
                background: #FFFFFF;
            }
            .stripe {
                background: #E0FFFF;
            } 
            .doc_item:hover {
                background: #FFFF80; /* Цвет фона при наведении */    
                cursor:pointer;
            }
    </style>
    <script>
        $(document).ready(function(){
            $("table tr:even").addClass('stripe');    
            myModalHide();
        });
        function myModalShow(id){
            $("#myModal1").load("/sed/dubna?c=samples/Service_sample3.mod&id="+id);
            $("#myModal").show();
        }
        function myModalHide(){
            $("#myModal").hide();
        }
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
            <td>
                <input type="submit" style="width:130;" value="Выполнить"> </br>
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
    </center>
[end]

[item] ***** Cоздание строки таблицы - 1 записи
    <tr id='formx' class="pt
                    oddRow ??oddRow=1
                    doc_item clickable" onClick="myModalShow(#id#);">
        <td>#id#</td> 
        <td>#F# #I# #O#</td> 
        <td>#country#</td>
        <td>#city#</td>
        <td>#profession#</td>
    </tr>
[end]

[report footer]
    </table>
    </form>
    <div class="modal" id="myModal" >
        <div class="overlay"></div>
        <div class="visible">
            <div class="dialog_title right">
                <div id="doc_window_title" style="float:left;">Просмотр документа</div>
                <div class="btn" onclick="myModalHide();" style="width:20px; height:15px; float:right;">
                    <img src="/sed/images/close.png" width="16" height="14" border="0">
                </div>
                <div style="clear:both;"></div>
            </div>
            <h2>Информационная карточка</h2>
            <div class="content" id="myModal1"></div>
        </div>
    </div>
    <style>
    *{
        font-size:11pt; 
        font-family: Arial;
    }
    .overlay {
	background: #000;
	position: fixed;
	left: 0;
	right: 0;
	top: 0;
	bottom: 0;
	z-index: 1000;
	opacity: .5;
    }
    .visible {
	background: #fff;
	position: fixed;
	left: 50%;
	top: 30%;
	margin-top: -200px;
	overflow: hidden;
	z-index: 2000;
	width: 500px;
	padding: 0px;
	margin-left: -250px;
    }
    .content {
	padding: 0 1em;
	border-top: 1px solid #ccc;
	border-bottom: 1px solid #ccc;
	background: WhiteSmoke;
    }
    .dialog_title {
        border-bottom: solid 2px #336699;
        background: #336699 url(/sed/images/head_bg.png) repeat-y right top;
        padding: 0 0 0 8px;
        color: white;
        font-weight: bold;
        cursor: default;
    }
    </style>
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
