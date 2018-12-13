
samples/if.cfg

[comments]
descr=Описание директивы $IF
input=
output=
parents=tab_samples.cfg
childs=
testURL=?c=samples/if&ajax=Y
author=Куняев
[end]

[description]
Описание директивы $IF
[end]


[parameters]
title=$IF
[end]

[report]
$INCLUDE samples/common.dat[start]

<h3>Директива $IF</h3>
<fieldset class="code bg_white"><legend>Описание:</legend>
Оператор $IF управляет условным ветвлением. Тело оператора $IF выполняется, если значение выражения ИСТИНА.<br>
Существует две формы синтаксиса оператора $IF.<br>

Синтаксис<br>
<ul>
<li>
&##36;IF выражение  <br>
 &nbsp;&nbsp;    строка1<br>
 &nbsp;&nbsp; строка2<br>
&nbsp;&nbsp;...<br>
&##36;EIF<br>
</li>
<li>
&##36;IF выражение  <br>
&nbsp;&nbsp;    строка1<br>
&nbsp;&nbsp;    строка2<br>
&nbsp;&nbsp;    ...<br>
&##36;ELSE<br>
&nbsp;&nbsp;    строка1<br>
&nbsp;&nbsp;    строка2<br>
&nbsp;&nbsp;    ...<br>
&##36;EIF<br>
</li>
</ul>

В обоих формах оператора $IF производится вычисление  выражения<br>
В первой форме синтаксиса если выражение верно , выполняется группа строк до директивы $EIF ($ENDIF). 
Если выражение ложно, группа строк пропускается.<br> 
Во второй форме синтаксиса, в который используется директива $ELSE, группа строк после $ELSE 
выполняется, только если выражение ложно.<br>
Затем в обеих формах управление передается из оператора $IF в следующую строку программы после $EIF,<br> кроме случаев, когда один из операторов содержит директиву $BREAK.</div>
<hr>

</fieldset>

$INCLUDE samples/common.dat[bottom]

[end]

