/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jinr.sed;

import dubna.walt.util.IOUtil;

/**
 *
 * @author serg
 */
public class ServiceIndexDoc extends ServiceEditDoc {
    
    /**
     * Основной метод сервиса - определяет порядок обработки запроса.
     *
     * @throws Exception
     */
    @Override
    public void start() throws Exception {
        try {
            initSuper(); // чтобы родительский класс инициализировал необходимые переменные
            getDocInfo();
            cfgTuner.outCustomSection("report", out); // вывод начала формы
//            cfgTuner.outCustomSection("report header", out); // вывод начала формы

            if (!cfgTuner.enabledExpression("ERROR")) {
                setDocIndex(); // Обновление индекса документа, если не было обнаружено ошибок
            }

        } catch (Exception e) {
            e.printStackTrace(System.out);
            IOUtil.writeLogLn("XXXXXXXX Exception: " + e.toString(), rm);
            cfgTuner.addParameter("ERROR", e.toString());
        } finally {

            cfgTuner.outCustomSection("report footer", out);
            out.flush();
        }
    }
    
}
