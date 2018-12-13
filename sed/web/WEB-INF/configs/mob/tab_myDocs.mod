mob/tab_myDocs.mod


[report]
    $INCLUDE mob/blocks.dat[head] 
    </head>
    <body>
    $INCLUDE mob/blocks.dat[top] 
    <hr class="hr-myDoc">
    <a href="https://sed.jinr.ru/sed/dubna"><img class="img-poln" src="#rootPath#images/comp.jpg"></a>     
    

        <fieldset class="fieldset-myDoc">
            $GET_DATA mob/docs_to_sign_table.cfg[count docs]
            <legend class="legend-myDoc">Ожидают (#NUM_DOCS_TO_SIGN#):</legend>
                <div>                                    
                        $CALL_SERVICE c=mob/docs_to_sign_table;                                    
                </div>
        </fieldset>
    
    $INCLUDE mob/blocks.dat[popup divs]
    <hr class="hr-myDoc">
    $INCLUDE mob/blocks.dat[footer]

[end]

