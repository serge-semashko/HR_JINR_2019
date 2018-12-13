test.mod

[report]
HERE is test.mod! doc_id=#doc_id#
    <script type="text/javascript" language="javascript">

        showDoc(true, "Просмотр документа"); 

        showPageTop(false); ??!mode=popup&!mode=print
        window.scrollTo(0, 0); $('##doc_container').show(100); $( "##doc_container" ).draggable({handle: '##doc_container_title'}); ??mode=popup

        window.setTimeout(function(){window.print();}, 700);  ??mode=print
        AjaxCall('doc_content', 'c=docs/edit_doc&doc_id=#doc_id#', true, '', true);    ??doEdit=Y
    </script>
[end]
