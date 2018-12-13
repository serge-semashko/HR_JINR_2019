/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jinr.sed;

import dubna.walt.util.ResourceManager;
import dubna.walt.util.Tuner;

/**
 *
 * @author Pavel
 */
public class QueueUserValidator extends dubna.walt.util.UserValidator {

    @Override
    public synchronized boolean validate(ResourceManager rm) throws Exception {
        Tuner cfgTuner = (Tuner) rm.getObject("cfgTuner");
        String userValidatorQueue = rm.getString("UserValidatorQueue", true);
        String[] classQueue = userValidatorQueue.split(",");
        String uid = "";
        dubna.walt.util.UserValidator uv = null;

        if (cfgTuner.getParameter("UV_CLASS").isEmpty()) {
            for (int i = 0; i < classQueue.length && uid.isEmpty(); i++) {
                String className = classQueue[i];

                uv = getUV(className, rm);

                uv.validate(rm);
                System.out.println("QueueUserValidator. ClassName: " + className + ", USER_ID:" + cfgTuner.getParameter("USER_ID"));
                uid = cfgTuner.getParameter("USER_ID");
                if (!uid.isEmpty()) {
                    cfgTuner.setParameterSession("UV_CLASS", className);
                    //getVUser(uid, cfgTuner, rm);
                } else {
                    cfgTuner.setParameterSession("UV_CLASS", "");
                }
            }
        } else {
            uv = getUV(cfgTuner.getParameter("UV_CLASS"), rm);
            System.out.println("QueueUserValidator. ClassName: " + cfgTuner.getParameter("UV_CLASS") + ", USER_ID:" + cfgTuner.getParameter("USER_ID"));
            uv.validate(rm);
            uid = cfgTuner.getParameter("USER_ID");
            if (uid.isEmpty()) {
                cfgTuner.setParameterSession("UV_CLASS", "");
            }

        }

        return true;
    }

    private dubna.walt.util.UserValidator getUV(String className, ResourceManager rm) throws Exception {
        dubna.walt.util.UserValidator uv = null;
        Object o = rm.getObject(className, false);
        if (o != null) {
            try {
                uv = (dubna.walt.util.UserValidator) o;
            } catch (Exception e) {
                uv = null;
            }
        }
        if (uv == null) {
            Class cl = Class.forName(className);
            uv = (dubna.walt.util.UserValidator) (cl.newInstance());
            rm.setObject(className, uv);
        }
        return uv;
    }

}
