/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dubna.walt.util;

//import java.sql.Connection;
//import java.sql.DriverManager;
//import java.sql.PreparedStatement;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 *
 * @author serg
 */
public class Logger {

    private ResourceManager rm_global;
    private ConnectionPool cp = null;
    private DBUtil dbUtil = null;
    private String now="NOW()";

    public Logger(ResourceManager rm_global) {
        this.rm_global = rm_global;
        if(!rm_global.getBoolean("NO_LOG_TO_DB")) {
            try{
                cp = (ConnectionPool) rm_global.getObject("ConnectionPool", false);
            }
            catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public void logRequest2DB(ResourceManager rm, String msg, Exception ex) {
        if(!rm_global.getBoolean("NO_LOG_TO_DB")) {

//            System.out.print("LOGGER.logRequest2DB() dbUtil=" + dbUtil);
            String sql="";
            String queryLabel=rm.getString("queryLabel", false, "?");
            Tuner cfgTuner = (Tuner) rm.getObject("cfgTuner");
            String cfgFile ="?";
            if(cfgTuner != null)
                cfgFile = cfgTuner.getParameter("cfgFile");
            int in = cfgFile.indexOf('.');
            if(in > 1)
                cfgFile = cfgFile.substring(0,in);
//            System.out.println("cfgFile=" + cfgFile);
//            System.out.println("EXCLUDE=" + rm.getString("excludeFromLog", false, "-"));
        if (!rm.getString("excludeFromLog", false, "-").contains("," + cfgFile + ",") )
            try {
                makeDBUtil(queryLabel);
    //            System.out.println(".......");
    //            System.out.println("  Logger.logRequest2DB(): cfgTuner=" + cfgTuner);
    
                if(msg.length() > 0)
                    System.out.println("Logger: " + queryLabel + ": logRequest2DB(msg=" + msg + ")");
    
                if(ex != null)
                    System.out.println("Logger: " + queryLabel + ": logRequest2DB(ex=" + ex.toString()); 

                String s = rm.getString("startTm");
                long l = 0;
                if (s.length() > 0) {
                    l = System.currentTimeMillis() - Long.parseLong(s);
                }
                String agent = cfgTuner.getParameter("h_user-agent");
                if(msg.contains("Выберите, кому нужно отправить документ")
                        || msg.contains("Введите результат")
                        || msg.contains("Неверный пароль")
    //                    || msg.contains("Неверный пароль")                 
                  ) {
                    agent = "ERROR: " + msg + "<br>" + agent;
                    msg="";
                }

                if(ex != null) {
                    StackTraceElement[] st = ex.getStackTrace();
                }

                if (dbUtil != null && dbUtil.isAlive()) {
                    if (cfgTuner != null) {
                        String e =  ((ex == null) ? msg : ex.toString() + " / " + msg);
                        if(e.length()> 2500)
                            e = e.substring(0, 2000);
                        e = e.replaceAll("'", "`");
    //                    System.out.println("\n\r msg=" + e);
                        sql = "insert into a_req_log (USER_ID, REAL_USER_ID, REQUEST_TYPE, queryLabel"
                                + ", C, REQUEST_NAME, QUERY, DOC_ID, COOKIES, ERR"
                                + ", DAT, IP, USER_AGENT, REF, SESS_ID, SESS, DID, TIM)"
                                + " values (" + cfgTuner.getIntParameter(null, "USER_ID", 0)
                                + ", " + cfgTuner.getIntParameter(null, "VU", 0)
                                + ", '" + rm.getString("requestType", false, "?")
                                + "', '" + queryLabel
                                + "', '" + cfgTuner.getParameter("cfgFile")
                                + "', '" + cfgTuner.getParameter("request_name")
                                + "', '" + trimString(cfgTuner.getParameter("queryString"), 2047)
                                + "', " + cfgTuner.getIntParameter(null, "doc_id", 0)
                                + ", '" + trimString(cfgTuner.getParameter("h_cookie"), 2047)
                                + "', '" + e
                                + "', " + now
    //                            + "', SYSDATE"
    //                            + "', NOW()"
                                + ", '" + cfgTuner.getParameter("ClientIP")
                                + "', '" + agent
                                + "', '" + cfgTuner.getParameter("h_referer")
                                + "', " + cfgTuner.getIntParameter(null, "SESS_ID", 0)
                                + ", '" + cfgTuner.getParameter("q_JSESSIONID")
                                + "', '" + cfgTuner.getParameter("q_cwldid")
                                + "', " + Long.toString(l)
                                + ")";
                    } else {
                        HttpServletRequest request = (HttpServletRequest) rm.getObject("request");
                        String user_id = "0";
                        String sess_id = "";
                        Object o;
                        HttpSession session = request.getSession();
                        System.out.print("***** ERROR: Logger- NO cfgTuner: session=" + session);
                        if (session != null) {
                            o = session.getAttribute("USER_ID");
                        System.out.print(" USER_ID=" + o);
                            if (o != null) {
                                user_id = o.toString();
                            }
                            o = session.getAttribute("JSESSIONID");
                        System.out.println(" JSESSIONID=" + o);
                            if (o != null) {
                                sess_id = o.toString();
                            }
                        }
                        user_id = (user_id.isEmpty()) ? "0" : user_id;
                        Cookie[] cookies = request.getCookies();
                        String n = "";
                        String v = "";
                        String q = "";
                        String vu = "null";
                        String dev_id = "";
                        if (cookies != null) {
                            for (int i = 0; i < cookies.length; i++) {
                                n = cookies[i].getName().trim();
                                v = StrUtil.unescape(cookies[i].getValue());
                                if (n.equals("VU")) {
                                    vu = v;
                                } else if (n.equals("cwldid")) {
                                    dev_id = v;
                                }
                                q += n + "=" + v + "; ";
                            }
                        }
                        String referer = "*";
                        if (request.getHeader("referer") != null) {
                            referer = StrUtil.replaceInString(
                                    StrUtil.replaceInString(
                                            StrUtil.replaceInString(
                                                    request.getHeader("referer"), "?", "%3F"), "&", "%26"), "=", "%3D");
                        }

                        sql = "insert into a_req_log (USER_ID, REAL_USER_ID, REQUEST_TYPE"
                                + ", C, QUERY, COOKIES, ERR"
                                + ", DAT, IP, USER_AGENT, REF, SESS, DID, TIM)"
                                //                            SESS_ID,
                                + " values (" + user_id
                                + ", " + vu
                                + ", '" + rm.getString("requestType")
                                //                            
                                + "', '" + rm.getString("cfgFileName")
                                + "', '" + trimString(request.toString(), 2047)
                                + "', '" + trimString(q, 2047)
                                + "', '" + ((ex == null) ? msg : ex.toString() + " / " + msg)
                                + "', " + now
    //                            + "', SYSDATE"
    //                            + "', NOW()"
                                + ", '" + rm.getString("clientIP")
                                + "', '*"
                                + "', '" + referer
                                //                            + "', " + cfgTuner.getIntParameter(null, "SESS_ID", 0) 
                                + "', '" + sess_id
                                + "', '" + dev_id
                                + "', " + Long.toString(l)
                                + ")";
                    }
//                    System.out.println("***** Logger.logRequest2DB() SQL:");

                    try {
                        dbUtil.update(sql);
                    }
                    catch(Exception ee){
                        System.out.println("XXXXX LOGGER ECEPTION: " + ee.toString());
                        if(dbUtil != null) {
                            dbUtil.getConnection().close();
                            dbUtil.close();
                            dbUtil = null;
                        }
                        makeDBUtil(queryLabel);
                        dbUtil.update(sql);
                    }
                } else {
                    System.out.println("***** ERROR: Logger.logRequest2DB() - NOT CONNECTED! ");
                }
            } catch (Exception e) {
                System.out.println("++++++++++++++++++++++++++++++++++++++");
                System.out.println("++++++++++++++++++++++++++++++++++++++");
                System.out.println("***** ERROR: Logger.logRequest2DB()");
                System.out.println("***** Logger SQL:" + sql);
    //            System.out.println(e.toString());
                e.printStackTrace();                
                System.out.println("++++++++++++++++++++++++++++++++++++++");                
            }
            finally {
                finish(queryLabel);
            }
        }
    }
//insert into a_req_log (USER_ID, C, REQUEST_NAME, QUERY, DOC_ID, COOKIES, ERR, DAT, IP, USER_AGENT, REF, SESS_ID, SESS, DID, TIM, REAL_USER_ID) 
//    values (2309, JINR/reports/zajavka4dogovor.cfg, U:Список заявок, c=JINR/reports/zajavka4dogovor&ajax=Y, 0, JSESSIONID=11FAEC1F6495D9479576FA99B832F47F; doc_year=2016; smallScreen=; helperWindow=true; nomsg=; yrc=; curr_budget_table=; cwl4=; cwl=efdaee66e7f58f17f23ca5c970ff41b3%3A94968%3A2309%3Aserg%3A127.0.0.1%3A1499380124322; cwldid=1501240590.465; ; yr=17; VU=; cwlp=c53376befdeb225c45902415f1d6ea47%3A115149%3A2309%3Aserg%3A159.93.40.211%3A1503310157668; cwl8=5b8f0a6d97725b7ac3d60520080643a6%3A94987%3A2309%3Aserg%3A127.0.0.1%3A1503349080070; vu_id=, LOGGER, NOW(), 127.0.0.1, Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36, http://ak0211.jinr.ru:8084/sed/dubna?tm=1503400203445, 94987, 11FAEC1F6495D9479576FA99B832F47F, 1501240590.465, 146, 2309

    /**
     * Коннект к БД
     *
     * @return объект DBUtil, который далее будет использоваться для обращения к
     * БД.
     * @throws Exception
     * 
     * 
    */
/**
     *
     * @return @throws Exception
     */
    private void makeDBUtil(String queryLabel) throws Exception {
        
        if(dbUtil != null && dbUtil.isAlive())
            return;
        
        long startTm = System.currentTimeMillis();
        try {
            if(cp == null) {
                IOUtil.writeLog(3, "<br><small><i>Logger.makeDBUtil() "
                    + rm_global.getString("DB", true, "")
                    + " / " + rm_global.getString("connString", true)
                    + " / " + rm_global.getString("database", false)
                    + " / " + rm_global.getString("connParam", false)
                    + " / " + rm_global.getString("usr", true)
                    + "</i></small>...", rm_global);

                System.out.print("Logger: connect: " + rm_global.getString("DB", true, "")
                    + " / " + rm_global.getString("connString", true)
                    + " / " + rm_global.getString("database", false)
                    + " / " + rm_global.getString("connParam", false)
                    + " / " + rm_global.getString("usr", true) + "/*** "
                //	+ cfgTuner.getParameter("pw")
                );
                dbUtil = new DBUtil(
                    rm_global.getString("DB", true, "")
                    , rm_global.getString("connString", true)
                    + rm_global.getString("database", false)
                    + rm_global.getString("connParam", false)
                    , rm_global.getString("usr", true)
                    , rm_global.getString("pw", true)
                    , queryLabel + "_logger" 
                );
                String connectTime=Long.toString(System.currentTimeMillis() - startTm);
                System.out.println(" - OK " + connectTime + "ms.");
                IOUtil.writeLog(3, " - OK! " + connectTime + "ms. ", rm_global);
            }
            else {
//                System.out.print("Logger: connect: cp=" + cp);
                dbUtil = new DBUtil(cp, queryLabel + "_logger");
            }

//    rm_global.setObject("DBUtil", dbUtil, true);
        } catch (Exception e) {
            System.out.println("[" + Fmt.shortDateStr(new java.util.Date()) + "] Connection to " + rm_global.getString("connString") + " FAILED!..." + e.toString());
            e.printStackTrace(System.out);
            dbUtil=null;
        }
    }
    
    public void finish(String queryLabel){
//        System.out.println("Logger: " + queryLabel + " finish()");
        try {
            if (dbUtil != null) {
                dbUtil.close();
                dbUtil = null;
            }
        } catch (Throwable tr) {
            tr.printStackTrace(System.out);
        }
        
    }
    
    /**
     * Finalizer. Закрытие коннектов к базе, запись в консоль Томката в режиме
     * "debug=on"
     */
    @Override
    protected void finalize() {
        System.out.println("  ..... Logger.finalize()");
        finish(" FINALIZE ");
        System.runFinalization();
        System.gc();
        try {
            super.finalize();
        } catch (Throwable tr) {
            tr.printStackTrace(System.out);
        }
    }

    private String trimString(String s, int maxLen) {
        return s.substring(0, Math.min(s.length(), maxLen));
    }
}
