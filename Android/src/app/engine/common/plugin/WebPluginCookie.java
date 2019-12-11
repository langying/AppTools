package app.engine.common.plugin;

import java.net.HttpCookie;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import android.annotation.SuppressLint;
import android.os.Build;
import android.text.TextUtils;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import app.engine.common.Glob;

@SuppressWarnings("deprecation")
public class WebPluginCookie {

    public Map<String, String> map(String cookie) {
        Map<String, String> map = new HashMap<String, String>();
        if (TextUtils.isEmpty(cookie)) {
            return map;
        }
        String[] list = cookie.split(";");// 多个Cookie是使用分号分隔的
        for (String item : list) {
            int idx = item.indexOf("=");// 在Cookie中键值使用等号分隔
            String key = item.substring(0, idx);// 获取键
            String val = item.substring(idx + 1);// 获取值
            map.put(key, encode(val));// 存至Map
        }
        return map;
    }

    /**
     * @param         domain: qwd.alimm.site
     * @param cookies
     */
    public void addCookie(final String domain, final HttpCookie... cookies) {
        sync(new Task() {
            @Override
            public void run(CookieManager mgr) {
                for (HttpCookie cookie : cookies) {
                    String value = cookie.getName() + "=" + cookie.getValue();
                    mgr.setCookie(domain, value);
                }
                mgr.setCookie(domain, "Path=/");
            }
        });
    }

    @SuppressLint("NewApi")
    private void sync(Task task) {
        CookieManager mgr = CookieManager.getInstance();
        mgr.setAcceptCookie(true);
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
            CookieSyncManager.createInstance(Glob.app);
        }
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
            mgr.removeSessionCookie();// 移除
        }
        else {
            mgr.removeSessionCookies(null);// 移除
        }

        task.run(mgr);

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
            CookieSyncManager.getInstance().sync();
        }
        else {
            mgr.flush();
        }
    }

    public static interface Task {
        public void run(CookieManager mgr);
    }

    private static String encode(String txt) {
        try {
            return URLEncoder.encode(txt, "UTF-8");
        }
        catch (Exception e) {
            return txt;
        }
    }
}
