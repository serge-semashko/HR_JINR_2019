package jinr.sed;

import dubna.walt.service.Service;
import dubna.walt.util.DBUtil;
import dubna.walt.util.IOUtil;
import dubna.walt.util.ResourceManager;
import dubna.walt.util.Tuner;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class JinrUserValidator extends dubna.walt.util.UserValidator {

    protected Tuner accRightsTuner = null;
    protected int queryNum = 0;

    /**
     *
     * @throws java.lang.Exception
     */
    public static String OAUTH_APPLICATION_ID = "";
    public static String OAUTH_APPLICATION_PASSWORD = "";
    public static final String OAUTH_TOKEN_URL = "http://login.jinr.ru/cgi-bin/token";
    public static final String OAUTH_INFO_URL = "http://login.jinr.ru/cgi-bin/infojson";
    public static final String OAUTH_TOKEN_SESSION_KEY = "OAUTH_TOKEN";
    public static final String OAUTH_TOKEN_EXPIRE_SESSION_KEY = "OAUTH_TOKEN_EXPIRE";
    public static final String OAUTH_LAST_TOKEN_CHECK_TIME_SESSION_KEY = "OAUTH_LAST_CHECK_TIME";

    public static int OAUTH_TOKEN_CHECK_INTERVAL = -1;
    private static boolean OAUTH_INITED = false;
    private static String OAUTH_CFG_NAME = "";
    private static String GUEST_USER_ID = "";
    private static String OAUTH_LOGOUT_PARAM = "";
    private static String LOCAL_USER_PARAM_NAME="";
    private static final String USER_AGENT = "Mozilla/5.0";

    private static void nocache(HttpServletResponse response){
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
        response.setDateHeader("Expires", 0);
    }

        public static void getVUser(String user_id, Tuner cfgTuner, ResourceManager rm) {
        if (cfgTuner.enabledOption("q_vu_id")) {
            cfgTuner.deleteParameter("VU");
            IOUtil.writeLog(3, "======= getVUser() ======= user_id=" + user_id + "=>" + cfgTuner.getParameter("q_vu_id"), rm);
            String a = ",2309,413,2584,8329,4790,4241,3311,97,4206,3663,";
//	2309-Куняев 413-Белякова 2584-Печникова 8329-Чихалина 4790-Яковлев 4241-Устенко 3311-Приходько 97-Александров 4206-Тяпкина, 3663 - Семашко

            if (a.contains("," + user_id + ",")||a.contains("," + cfgTuner.getParameter("VU") + ",")) {
                if(cfgTuner.getParameter("VU").isEmpty()){
                    cfgTuner.setParameterSession("VU", cfgTuner.getParameter("USER_ID"));
                }
                cfgTuner.setParameterSession("USER_ID", cfgTuner.getParameter("q_vu_id"));
                IOUtil.writeLogLn(" - OK", rm);
            }
        }else{
           if(!cfgTuner.getParameter("VU").isEmpty()){
               cfgTuner.setParameterSession("USER_ID", cfgTuner.getParameter("VU"));
               cfgTuner.setParameterSession("VU", null);
               cfgTuner.deleteParameter("q_vu_id");
           }
        
        }
    }
    


    public static String sendGet(String url) throws Exception {
        URL obj = new URL(url);
        HttpURLConnection con = (HttpURLConnection) obj.openConnection();
        con.setRequestMethod("GET");
        con.setRequestProperty("User-Agent", USER_AGENT);
        int responseCode = con.getResponseCode();
        System.out.println("\nSending 'GET' request to URL : " + url);
        System.out.println("Response Code : " + responseCode);
        BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
        String inputLine;
        StringBuilder response = new StringBuilder();
        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }
        in.close();
                System.out.println("Answer is: "+response.toString());
        return response.toString();

    }

    public static String sendPost(String url, String urlParameters) throws IOException {
        URL obj = new URL(url);
        HttpURLConnection con = (HttpURLConnection) obj.openConnection();
        con.setRequestMethod("POST");
        con.setRequestProperty("User-Agent", USER_AGENT);
        con.setRequestProperty("Accept-Language", "en-US,en;q=0.5");
        con.setDoOutput(true);
        DataOutputStream wr = new DataOutputStream(con.getOutputStream());
        wr.writeBytes(urlParameters);
        wr.flush();
        wr.close();
        int responseCode = con.getResponseCode();
        System.out.println("\nSending 'POST' request to URL : " + url);
        System.out.println("Post parameters : " + urlParameters);
        System.out.println("Response Code : " + responseCode);
        BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
        String inputLine;
        StringBuilder response = new StringBuilder();
        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }
        in.close();
                System.out.println("Answer is: "+response.toString());
		return(response.toString());
    }

    
    private static JSONObject getOauthUserInfo(String token) throws IOException {
        String infoparams = "oauth_token=" + token;
        String infoJson = "";
        try {
            infoJson = sendPost(OAUTH_INFO_URL, infoparams);
        } catch (IOException ex) {
            throw new IOException("Нет соединения с " + OAUTH_INFO_URL + " : " + ex.getMessage());
        }
        JSONParser jp = new JSONParser();
        try {
            return (JSONObject) jp.parse(infoJson);
        } catch (ParseException ex) {
            return error(infoJson);
        }
    }
    private static void doOauthLogout(HttpSession hs, ResourceManager rm){
        hs.removeAttribute(OAUTH_TOKEN_SESSION_KEY);
        hs.removeAttribute(OAUTH_TOKEN_EXPIRE_SESSION_KEY);
        hs.removeAttribute(OAUTH_LAST_TOKEN_CHECK_TIME_SESSION_KEY);
        List<String> queryParams = new ArrayList();
        queryParams.add("_OAUTH_ACTION=LOGOUT");
        try {
            runCfg(OAUTH_CFG_NAME, queryParams, rm);
            //hs.invalidate();
        } catch (Exception ex) {
            Logger.getLogger(JinrUserValidator.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private static void doOauthLogin(JSONObject jo, ResourceManager rm) {
        HttpServletRequest request = (HttpServletRequest) rm.getObject("request");
        HttpSession hs = request.getSession();
        String date = (String) jo.get("date");
        String jinrid = (String) jo.get("jinrid");
        String mail = (String) jo.get("mail");
        String tel = (String) jo.get("tel");
        String id = (String) jo.get("id");
        String login = (String) jo.get("login");
        String lab = (String) jo.get("lab");
        String fio = (String) jo.get("fio");
        List<String> queryParams = new ArrayList();
        queryParams.add("_OAUTH_LOGIN=" + login);
        queryParams.add("_OAUTH_JINRID=" + jinrid);
        queryParams.add("_OAUTH_MAIL=" + mail);
        queryParams.add("_OAUTH_LAB=" + lab);
        queryParams.add("_OAUTH_FIO=" + fio);
        queryParams.add("_OAUTH_ID=" + id);
        queryParams.add("_OAUTH_DATE=" + date);
        queryParams.add("_OAUTH_TEL=" + tel);
        queryParams.add("_OAUTH_ACTION=LOGIN");

        try {
            runCfg(OAUTH_CFG_NAME, queryParams, rm);
        } catch (Exception ex) {
            Logger.getLogger(JinrUserValidator.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    private static void runCfg(String cfgFileName, List<String> queryParam, ResourceManager rm) throws Exception {
        ResourceManager rms = rm.cloneRM();
        Tuner cfgTuner1 = new Tuner(queryParam.toArray(new String[0]), cfgFileName, rms.getString("CfgRootPath", false), rms);
        DBUtil db = makeDBUtil(rms);
        rms.setObject("DBUtil", db, false);
        rms.setObject("cfgTuner", cfgTuner1);
        String className = cfgTuner1.getParameter("parameters", "service");
        if (className == null || className.length() == 0) {
            className = "dubna.walt.service.Service";
        }
        Class cl = Class.forName(className);
        Service srv = (Service) (cl.newInstance());
        srv.doIt(rms);
        if (db != null) {
            try {
                db.commit();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            db.close();
            db = null;
        }
    }

    public static synchronized DBUtil makeDBUtil(ResourceManager rm) throws Exception {
        DBUtil dbUtil = null;
        Connection conn = DriverManager.getConnection(rm.getString("connString")
                + rm.getString("database")
                + rm.getString("connParam"), rm.getString("usr"), rm.getString("pw"));
        conn.setAutoCommit(false);
        dbUtil = new DBUtil(conn, "MONITOR");
        dbUtil.db = DBUtil.DB_MySQL;
        dbUtil.allocate();
        return dbUtil;
    }

  
    public static void oauthInit(ResourceManager r) {
        OAUTH_CFG_NAME = r.getString("OAUTH_CFG_NAME");
        OAUTH_APPLICATION_ID = r.getString("OAUTH_APPLICATION_ID");
        OAUTH_APPLICATION_PASSWORD = r.getString("OAUTH_APPLICATION_PASSWORD");
        OAUTH_TOKEN_CHECK_INTERVAL = r.getInt("OAUTH_TOKEN_CHECK_INTERVAL");
        GUEST_USER_ID=r.getString("GUEST_USER_ID");
        LOCAL_USER_PARAM_NAME=r.getString("LOCAL_USER_PARAM_NAME");
        OAUTH_LOGOUT_PARAM=r.getString("OAUTH_LOGOUT_PARAM");

        if (!OAUTH_CFG_NAME.isEmpty() && !OAUTH_APPLICATION_ID.isEmpty() && !OAUTH_APPLICATION_PASSWORD.isEmpty()) {
            OAUTH_INITED = true;
        }
    }

    @Override
    public synchronized boolean validate(ResourceManager rm) throws IOException {
        HttpServletRequest request = (HttpServletRequest) rm.getObject("request");
        HttpServletResponse response = (HttpServletResponse) rm.getObject("response");
        nocache(response);
        HttpSession hs = request.getSession();
        Tuner cfgTuner = (Tuner) rm.getObject("cfgTuner");
        
        cfgTuner.deleteParameter(LOCAL_USER_PARAM_NAME); //USER_ID
        System.out.println("USER_Id============="+cfgTuner.getParameter(LOCAL_USER_PARAM_NAME));
        //cfgTuner.setParameterSession(LOCAL_USER_PARAM_NAME, null);
        if (!OAUTH_INITED) {
            oauthInit(rm);
        }
        if (OAUTH_INITED) {
            String code = null;
            
            boolean userLogged = checkOauthUserLoggedIn(hs, rm); // проверяет, залогинен ли oauth пользователь ещё, или уже нет
            if(!userLogged) code = request.getParameter("code");
            if(request.getParameter(OAUTH_LOGOUT_PARAM)!=null){
                doOauthLogout(hs,rm);
                code=null;
            }

            if (code != null) { // Процедура логина пользователя
                String tokenparams = "code=" + code + "&client_id=" + OAUTH_APPLICATION_ID + "&pass=" + OAUTH_APPLICATION_PASSWORD;
                String tokenJson = sendPost(OAUTH_TOKEN_URL, tokenparams);
                System.out.println(tokenJson);
                JSONParser jp = new JSONParser();
                JSONObject jo;
                try {
                    jo = (JSONObject) jp.parse(tokenJson);
                    String token = (String) jo.get("access_token");
                    hs.setAttribute(OAUTH_TOKEN_SESSION_KEY, token);
                    String tokenexpire = (String) jo.get("expires_in");
                    hs.setAttribute(OAUTH_TOKEN_EXPIRE_SESSION_KEY, tokenexpire);
                    jo = getOauthUserInfo(token);
                    if (!jo.containsKey("error")) {
                        doOauthLogin(jo, rm);
                    } else {
                        doOauthError(jo, rm);
                    }
                    System.out.println(jo);
                } catch (ParseException ex) { // сервер прислал какую-то хрень или ошибку
                    System.err.println("JSONParser не смог разобрать вот это: \"" + tokenJson + "\"");
                    doOauthError(error(tokenJson), rm);
                } catch (IOException ex) {
                    doOauthError(error(ex.getMessage()), rm);
                }
            }
        }
        //Гостевой userId, если есть
        String userId =(String) hs.getAttribute(LOCAL_USER_PARAM_NAME);
        getVUser(userId, cfgTuner, rm);
        if(userId==null||userId.isEmpty()){
            hs.setAttribute(LOCAL_USER_PARAM_NAME, GUEST_USER_ID);
        }
        System.out.println("UserId="+cfgTuner.getParameter("USER_ID"));
        return true;
    }

    public static void print(String[] ss) {
        if (ss == null) {
            return;
        }
        for (int i = 0; i < ss.length; i++) {
            System.out.println(ss[i] + "\r\n");
        }
    }

    private static JSONObject error(String in) {
        JSONObject jo = new JSONObject();
        jo.put("error", in);
        return jo;
    }


    private static Long getLongParam(Object in, long def) {
        if (in == null) {
            return def;
        }
        if (in instanceof Long) {
            return (Long) in;
        }
        if (in instanceof String) {
            if (((String) in).trim().isEmpty()) {
                return def;
            } else {
                return Long.parseLong((String) in);
            }
        }
        return def;
    }

    private boolean checkOauthUserLoggedIn(HttpSession hs, ResourceManager rm) {
        String sesstoken = (String) hs.getAttribute(OAUTH_TOKEN_SESSION_KEY);
        Long lastOauthCheck = getLongParam(hs.getAttribute(OAUTH_LAST_TOKEN_CHECK_TIME_SESSION_KEY), 0l);
        try {
            if (sesstoken == null || sesstoken.trim().isEmpty() ) return false;
            
            if( System.currentTimeMillis() - lastOauthCheck > OAUTH_TOKEN_CHECK_INTERVAL * 1000) {
                JSONObject jo = getOauthUserInfo(sesstoken);
                if (jo.containsKey("error")) { // вышел или token протух
                    doOauthLogout(hs, rm);
                    return false;
                } else { //не вышел, продлеваем время для следующей проверки
                    hs.setAttribute(OAUTH_LAST_TOKEN_CHECK_TIME_SESSION_KEY, (Long) System.currentTimeMillis());
                    return true;
                }
            }else{
                return true;
            }
        } catch (IOException e) {
            // вот тут возможно надо логаутить, а может и не надо.
        }
        return false;
    }

    private void doOauthError(JSONObject jo, ResourceManager rm) {
        String error = (String) jo.get("error");
        List<String> queryParams = new ArrayList();
        queryParams.add("_OAUTH_ERROR=" + error);
        queryParams.add("_OAUTH_ACTION=ERROR");
        try {
            runCfg(OAUTH_CFG_NAME, queryParams, rm);
        } catch (Exception ex) {
            Logger.getLogger(JinrUserValidator.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    
    

	



}
