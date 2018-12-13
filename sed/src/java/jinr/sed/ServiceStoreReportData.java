/*
 */
package jinr.sed;

import dubna.walt.service.Service;
import dubna.walt.util.BasicTuner;
import dubna.walt.util.IOUtil;
import java.io.File;
import java.io.FileInputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletOutputStream;

/**
 *
 * @author serg
 */
public class ServiceStoreReportData extends Service {

    @Override
    public void start()
            throws Exception {
        String tmpFileName = cfgTuner.getParameter("logPath") + "ADB" + cfgTuner.getParameter("tm");
        PrintWriter out_orig = out;
        out = new PrintWriter(tmpFileName, "utf-8");
//		out = new PrintWriter(tmpFileName, "Cp1251");
        System.out.println("++++++++++++++++ ServiceStoreReportData ++++++++ ");
        cfgTuner.outCustomSection("report", out);
        out.flush();
        out.close();

        try {
//      String tmpFilePath = (String)this.rm.getObject("tmpFilePath");
            File tmpFile = new File(tmpFileName);
            long l = tmpFile.length();
            System.out.println("+++ ServiceStoreReportData tmpFile:" + tmpFileName + "; LENGTH=" + l);
//			response.setContentType(cfgTuner.getParameter("contentType")); - is in Service.beforeStart()
            if (cfgTuner.enabledOption("SendToClient")) {
                FileInputStream is = new FileInputStream(tmpFile);
                ServletOutputStream outStream = (ServletOutputStream) this.rm.getObject("outStream");
                IOUtil.copyStream(is, outStream);
                is.close();
                outStream.flush();
            }

            String ps_sql = cfgTuner.getParameter("PS_SQL");
            if (!ps_sql.isEmpty()) {
                Connection conn = dbUtil.getConnection();
//                conn.setAutoCommit(true);
                PreparedStatement stmt = conn.prepareStatement(ps_sql);
                System.out.println(ps_sql);
                String[] sa = BasicTuner.readFileFromDisk(tmpFileName, rm.getString("serverEncoding", false, "utf-8"), cfgTuner.getIntParameter(null, "maxLength", 64000) );
//      cfgTuner.readFile( startPath + fileName);
                String cont = "";
                for (String sa1 : sa) {
                    cont = cont + sa1;
                }
                stmt.setString(1, cont);
                stmt.executeUpdate();
// readDataFile(String fileName, int maxLength);
            }
            tmpFile.delete();
//      System.out.println("+++ DELETE tmpFile " + tmpFileName);
        } catch (Exception e) {
            e.printStackTrace(System.out);
        }
    }
}
