function getColNames(resultSet) {
    var metaData = resultSet.getMetaData();
    var numCols = metaData.getColumnCount();
    var sqlColNames = [];
    for (var i = 0; i < numCols; i++) {
        sqlColNames.push(metaData.getColumnLabel(i + 1));
    }
    return sqlColNames;
}
;
function loopSQL(sqlSection, execSection) {
    var sql = BT.getCustomSectionAsString(sqlSection);
    if (sql.length ===0 ) {
       BT.WriteLog(2 , "<font color=red> loopSQL:" + sqlSection + ": SECTION NOT FOUND OR EMPTY</font>");
       return;
    } 
    var r = dbUtil.getResults(sql);
    if (typeof r == "undefined") {
        return;
    }
    if (r == null) {
        return;
    }


    var headers = getColNames(r);
    var sumstr = "";
    while (r.next()) {
        for (i = 0; i < headers.length; i++) {
            var val = r.getString(i + 1);
            BT.addParameter(headers[i], val);
            sumstr += headers[i] + " " + val + " ";
        }
        BT._$LOG("$LOG2 loop select= " + sumstr + "\n", sectionLines, out);
        BT.getCustomSection("",execSection,out);
    }
    dbUtil.closeResultSet(r);
}
;
function prm(name){
    return BT.getParameter(null,null,name);
}
function $INCLUDE(sectionName) {
    BT._$INCLUDE(sectionName,sectionLines,out);
}

