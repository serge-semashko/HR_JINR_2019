mob/tab_AllDocs.mod
                            

[report]
$INCLUDE mob/blocks.dat[head]
$LOG ++++ f_stat=#f_stat#; <br>
    <script>
        var submitForm=function(reset) {
           log(1,"mob/tab_AllDocs.mod.submitForm(); reset=" + reset);
            if(reset) {
                document.theForm.srn.value=1; 
            }
            document.theForm.submit();  ??
            var AjaxCall=function(target_div, query, force, containerId, showProgress) {  ??
            $("##ProgressModal").modal({ backdrop: 'static',	show: true }); ??
debugger; ??
            showBSProgressBar(true); ??
            AjaxCall("container","c=mob/all_docs_table", false, "theFormContainer", true);
        }

        var resetSort=function(){
            document.theForm.srt.value="dh.status"; ??
            document.theForm.desc.value="";  ??
            document.theForm.srt.value="ifnull(dh.doc_date, dh.created)"; 
            document.theForm.desc.value="desc";
            document.theForm.srn.value=1; 
        }

        var setBSProgress=function(bytes) {
            var value = (bytes / 7000) * 100;
            log(3,"setBSProgress:" + bytes); ??
            $("##BSprogress-label").html( bytes );
            $('.progress-bar').css('width',value+'%').text(value.toFixed(0)+'%');              
        }

var BSProgressBarON="";
	/**
        * Отображение pop-up окошка прогрессбара BootStrap (show=true)
        * или скрытие (!show)
        * API см. http://api.jqueryui.com/progressbar/
        */
       var showBSProgressBar=function(show)
       {
           log(1, "showBSProgressBar: " + show); 
            try{ ??
                if(show && !BSProgressBarON) {
                       log(3, "showBSProgressBar: SET ON"); 
                        setBSProgress(0);
                        $('##ProgressModal').modal({backdrop: false, keyboard: false, show: true});
                        $('##ProgressModal').data('bs.modal').options.backdrop = 'static';
                        BSProgressBarON="ON";
                }
                else {
                    if(BSProgressBarON) {
                       log(3, "showBSProgressBar: SET OFF"); 
                        $("##ProgressModal").modal('hide');
                        BSProgressBarON="";
                    }
                }
           } catch(e) {;} ??
       }
    </script>
    </head>
    <body>
    $INCLUDE mob/blocks.dat[top]

        <a href="https://sed.jinr.ru/sed/dubna"><img class="img-polnAll" src="#rootPath#images/comp.jpg"></a>
        <hr class="hr-allDoc">       
            <div id="theFormContainer">                      
                <form class="form-inline" name="theForm" id="theForm" method="POST" enctype="multipart/form-data">      
                    <input type=hidden name="c" value="#c#"> 
                    <input type=hidden name="srn" value="#srn#"> 
                    <input type=hidden name="srt" value="#srt#">
                    <input type=hidden name="desc" value="#desc#">
                    <input type=hidden name="adv" value="#adv#">

                    <table>
                        <tr>
                        $GET_DATA mob/tab_AllDocs.mod[getFilters]                                           
                            <td class="col1" style="width:15%">Подразделение:</td>                            
                            <td style="width:65%">
                                <input type=hidden value="#f_div_id#" size="5" name="f_div_id">
                                <input type=hidden value="#f_div#" name="f_div">
                                <div id="f_div" class="form-control info_input pt big bg_white" 
                                    style="display: inline-block; width:100%;" info_view="11" info_id="10">
                                    -- все -- ??!f_div
                                    #f_div#</div>
                            </td>
                            <td style="width:20%"></td>
                        </tr>
                        <tr>                            
                            <td class="col1">Тип документа:</td>
                            <td>
                            $INCLUDE mob/doc_types_dd.mod[filter]
                            </td>
                            <td></td>
                        </tr>
                        <tr>
                            <td class="col1">Искать текст:</td>
                            <td>
                                <input type="text" class="form-control" id="inputSearch" name="f_search" style="width:100%" value="#f_search#"> &nbsp;
                            </td>
                            <td>
                                <input type="button" onClick="submitForm(true);" class="button2" id="ok1" style="display: inline-block; margin: 0px; width:30pt;" value="OK">
                            </td>
                        </tr>                
                        <tr>
                            <td style="width:105px"></td>
                            <td>
                                <input type="button" id="search-r" class="button3" value="Расширенный поиск" style="display: inline-block; float:right">
                                <input type="button" id="search-p" class="button3" value="Простой поиск" style="display: none; float:right">
                            </td>
                            <td></td>
                        </tr>
                    </table>

                    <div id="search" style="display: none;">                    
                        <table>
                            <tr>
                            +++Фильтр по году+++ ??
                            $SET_PARAMETERS f_year=ALL; ??!f_year
                            $SET_PARAMETERS f_year=#CURR_YEAR#; ??!f_year
                                <td class="col1" style="width:15%">Год:</td>
                                <td style="width:65%">
                                    <select class="form-control" id="select02" name=f_year style="width:100px">
                                        <option value="ALL"
                                            selected ??f_year=ALL
                                                >-- все --</option>
                                        <option value="2018"
                                            selected ??f_year=2018
                                                >2018</option>
                                        <option value="2017"
                                            selected ??f_year=2017
                                                >2017</option>
                                        <option value="2016"
                                            selected ??f_year=2016
                                                >2016</option>
                                    </select>
                                </td>                                            
                                <td style="width:20%;"></td>
                            </tr>
                            <tr>
                                <td class="col1" style="padding:0 0 0 20px;">№ документа:</td>
                                <td>
                                    <input type="text" class="form-control" name="f_doc_number" value="#f_doc_number#" id="number" style="width:100px">
                                </td>
                                <td></td>
                            </tr>                            
                            <tr>
                                <td class="col1">Статус:</td>                                                             
                                <td>
                                    <input type="checkbox" name=f_stat value="1" 
                                        checked  
                                    > в процессе согласования
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <input type="checkbox" name=f_stat value="2" 
                                        checked 
                                    > на этапе завершения
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <input type="checkbox" name=f_stat value="3" 
                                        checked  
                                    > завершенные
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <input type=checkbox name=f_marked 
                                        checked ??f_marked
                                        >
                                    <i class="fa fa-flag 
                                        clr-red ??f_marked
                                        clr-gray ??!f_marked
                                        " aria-hidden="true">
                                    </i> только отмеченные
                                </td>                            
                                <td>                            
                                    <input type="button" class="button2" id="ok2" style="display:none; margin:0 0 10px 0; width:30pt;" value="ОК" 
                                        onClick="submitForm(true);">
                                </td>
                            </tr>
                        </table>     
                    </div>

                    <script>
                        $(document).ready(function () {
                            $("##search-r").click(function () {
                                $("##search").slideToggle("fast");
                                $("##search-r").hide();
                                $("##search-p").show();                            
                                $("##ok1").hide();
                                $("##ok2").show();
                                document.theForm.adv.value="Y";
                            });
                            $("##search-p").click(function () {
                                $("##search").slideToggle("fast");
                                $("##search-p").hide();
                                $("##search-r").show();                            
                                $("##ok2").hide();
                                $("##ok1").show();
                                document.theForm.adv.value="";
                            });
                            $('.info_input').click(showSprav);  // события на тестовых полях для справочников	

                            $("##search-r").click(); ??adv=Y_ZZZ
                            AjaxCall("container","c=mob/all_docs_table", false, '', true); 

                    });

                    $("##container").ajaxStart(function() {
                        $("##ProgressModal").modal({ 
                            backdrop: false,	
                            show: true
                        });
                        setBSProgress(0);
                    });
                    $("##container").ajaxStop(function(){ 
                        $('##ProgressModal').modal('hide');
                    });

                    </script>
                    <div id="container" style="width:100%" onload="demo();">        
                        $CALL_SERVICE c=mob/all_docs_table; ??
                    </div>
                
                    <hr class="hr-allDoc" style="margin-top:1px;"> 
                </form> 
            </div>
            $INCLUDE mob/tab_AllDocs.mod[Progress-bar Bootstrap]           
            $INCLUDE mob/blocks.dat[popup divs]  
            ----------------- DD-справочник ----------------- ??
            <div id="dd_info"></div>
            $INCLUDE mob/blocks.dat[footer]

    </body> ??
    </html> ??
[end]

[getFilters]
    select count(short_name) as num_divs from info_10 where id in(#f_div_id#) ??f_div_id
    ;
    select short_name as f_div from info_10 where id in(#f_div_id#) ??f_div_id&num_divs=1
[end]

[Progress-bar Bootstrap]
-----Модельное окно Progress-bar из Bootstrap-----??
<div class="modal fade" id="ProgressModal">
    <div class="modal-dialog" style="width:300px;" onClick="showBSProgressBar(false);">
        <div class="modal-content"  style="padding:0px 20px;">
            <h2 class="h4 text-center my-4">Загрузка...</h2>
            <div class="progress" >
                <div class="progress-bar progress-bar-striped progress-bar-success" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100000"
                    style="display:inline-block;" ??
                >0%</div>
            </div>
            <div id="BSprogress-label" style="text-align:right; font-size:8pt;">Loading...</div>
        </div>
    </div>
</div>
[end]




