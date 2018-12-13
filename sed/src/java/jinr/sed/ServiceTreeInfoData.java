package jinr.sed;

import java.sql.ResultSet;
import dubna.walt.util.DBUtil;
import dubna.walt.util.IOUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Vector;

/**
 * author: Устенко
 */
public class ServiceTreeInfoData extends dubna.walt.service.Service {

    protected PreparedStatement checkStmt = null;

    protected int nr;
    protected int numFields = 0;
    protected int numCols = 0;
    protected String[] fields_types = null;
    protected String[] fields = null;
    protected String  dataSeparator = "~|~";
    protected String[] fields_names = null;

    protected String[] searchSubstrings = null;
    private String orderByField = null;

    /**
     * Основной метод сервиса - определяет порядок обработки запроса.
     *
     * @throws Exception
     */
    public void start() throws Exception {
        try {
			//  получаем список полей справочника, их названия и типы из описания справочника
            // (результат выполнения запросов в секции [preSQLs] .cfg - файла)
            dataSeparator = !cfgTuner.getParameter("DATA_SEPARATOR").isEmpty()?cfgTuner.getParameter("DATA_SEPARATOR"):dataSeparator;
            fields = cfgTuner.getParameter("FIELDS").split(",");
            fields_names = cfgTuner.getParameter("FIELDS_NAMES").split(",");
            fields_types = cfgTuner.getParameter("FIELDS_TYPES").split(",");
            orderByField = cfgTuner.getParameter("orderByField");
            if (orderByField == null || orderByField.isEmpty()) {
                orderByField = fields_names[0];
            }

            numFields = cfgTuner.getIntParameter("NUM_FIELDS");
            cfgTuner.outCustomSection("report header", out); // Выводим начало таблицы включая заголовки столбцов
            showInfoRecords(); // показываем записи справочника
        } catch (Exception e) {
            e.printStackTrace(System.out);
            IOUtil.writeLogLn("XXXXXXXX Exception: " + e.toString(), rm);
            cfgTuner.addParameter("ERROR", e.toString());
        } finally {
            cfgTuner.outCustomSection("footer script", out);
            cfgTuner.outCustomSection("report footer", out);
            out.flush();
        }
    }

    /**
     * Вывод таблицы записей справочника
     *
     * @throws Exception
     */
    protected void showInfoRecords() throws Exception {
        // конструируем SQL-запрос в базу
        String requesterId = cfgTuner.getParameter("requesterId");

        //  получаем общее кол-во записей, соотв. критерию поиска.  
        String s = "select count(*) as NUM_RECORDS from "
                + cfgTuner.getParameter("TABLE_NAME")
                + " " + cfgTuner.getParameter("CRITERIA");
        ResultSet r = dbUtil.getResults(s); // выполняем запрос
        if (r.next()) {
            int tot_num_recs = r.getInt(1);
            r.close();
            cfgTuner.addParameter("TOT_NUM_RECS", Integer.toString(tot_num_recs));
            if (tot_num_recs > 0) {
                s = "select " + cfgTuner.getParameter("FIELDS")
                        + cfgTuner.getParameter("SYS_FIELDS")
                        + " from " + cfgTuner.getParameter("TABLE_NAME")
                        + " " + cfgTuner.getParameter("CRITERIA") + " order by " + orderByField;
                IOUtil.writeLogLn("+++ GET RECORDS SQL: '" + s + "'", rm);
                r = dbUtil.getResults(s); // выполняем запрос
                ResultSetMetaData metaData = r.getMetaData();
                numCols = metaData.getColumnCount(); // кол-во полученных столбцов
                int id, pid;
                while (r.next()) // цикл по полученным записям, собираем из них JSON массив
                {
                    id = r.getInt(1); // первое поле - всегда ID записи 
                    pid = r.getInt(2); // второе поле - всегда PID записи
                    String sPid = pid >= 0 ? requesterId + pid : "#";
                    String sId = requesterId + id;
                    String record = "{\"id\" : \"" + sId + "\", \"parent\" : \"" + sPid + "\", \"text\" : \"";
                    String val = "";
                    for (int i = 3; i <= numFields; i++) // цикл по полям записи
                    {
                        //остальные поля пойдут в JSON поле text через сепаратор
                        val += (i > 3 ? dataSeparator : "") + r.getString(i).replaceAll("\"", "\\\\\"");
                    }
                    record += val;
                    record += "\"";
                    
                    String sJsTreeType = "";
                    
                    String sInfoTreeMode = "";
                    String sInfoID = cfgTuner.getParameter("info_id");
                    if (cfgTuner.getParameter("INFO_TREE_MODE").length() > 0)
                        sInfoTreeMode = cfgTuner.getParameter("INFO_TREE_MODE");
                    
                    if (cfgTuner.getParameter("info_id").equals("1017") & (sInfoTreeMode.equals("select")) | sInfoTreeMode.equals("edit")){
                        String sIsFolder = r.getString(numFields+1);
                        String sSelectable = r.getString(numFields+2);
                        
                        if ((sIsFolder.length() > 0) & (sSelectable.length() > 0) ) {
                            sJsTreeType += sIsFolder + sSelectable;
                            }

/*
                        
                        if (sInfoTreeMode.equals("edit")){
                            String sBeginDate = r.getString(numFields+3);
                            String sEndDate = r.getString(numFields+4);
                            
                            if(sBeginDate == null) {
                                sJsTreeType += "bd0";
                                }
                            else {
                                sJsTreeType += "bd1";
                                }
                            
                            
                            }
*/                        

                        }
                    if (sJsTreeType.length() >0 ) {
                        record += ", \"type\" : \"" + sJsTreeType + "\"";
                        }
                    
                    record += "}, ";
                    cfgTuner.addParameter("record", record); // заносим в Tuner полученную строку

                    cfgTuner.outCustomSection("item", out); // выводим строку
                }
                r.close();
            }
        }

    }

}
