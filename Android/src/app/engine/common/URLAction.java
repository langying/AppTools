package app.engine.common;

import java.io.File;
import java.io.Serializable;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import android.net.Uri;

public class URLAction implements Serializable {

    private static final long serialVersionUID = -2162803314383080403L;

    public static final int ATURLActionTypeUnknown = 0;
    public static final int ATURLActionTypePop = 1;
    public static final int ATURLActionTypeNative = 2;
    public static final int ATURLActionTypeSystem = 3;
    public static final int ATURLActionTypeH5Online = 4;
    public static final int ATURLActionTypeH5Offline = 5;

    private int type;
    private String url;
    private String host;
    private String path;
    private String scheme;
    private Map<String, String> parameters = new HashMap<String, String>();

    public static URLAction actionWithURLString(String txt) {
        if (txt == null) {
            return null;
        }
        txt = txt.replace("$://", "gold://");
        txt = txt.replace("/asset/", "/android_asset/");
        Uri url = Uri.parse(txt);
        URLAction action = new URLAction();
        action.url = txt;
        action.host = url.getHost();
        action.path = url.getPath();
        action.scheme = url.getScheme();
        action.makeParams(txt);

        if ("gold".equalsIgnoreCase(action.scheme)) {
            if (action.host.length() <= 0) {
                action.type = ATURLActionTypeUnknown;
            }
            else if (action.isDownload()) {
                action.type = ATURLActionTypeH5Offline;
            }
            else if (action.nativeClass() != null) {
                action.type = ATURLActionTypeNative;
            }
            else if ("pop".equalsIgnoreCase(action.host)) {
                action.type = ATURLActionTypePop;
            }
            else {
                action.type = ATURLActionTypeH5Online;
            }
        }
        else if (action.scheme.startsWith("http")) {
            // 直接打开在线URL
            action.type = ATURLActionTypeH5Online;
        }
        else if (App.canOpenURL(txt)) {
            // 交给系统处理
            action.type = ATURLActionTypeSystem;
        }
        else {
            // 未知的URL，就跳转到错误页面吧
            action.type = ATURLActionTypeUnknown;
        }
        return action;
    }

    public boolean isInnerURL() {
        if ("http".equalsIgnoreCase(scheme) || "https".equalsIgnoreCase(scheme)) {
            return getBoolean("_inner");
        }
        return false;
    }

    public boolean isDownload() {
        return false;
    }

    public Class<?> clazz() {
        Class<?> clazz = null;
        switch (type) {
        case ATURLActionTypeH5Online:
        case ATURLActionTypeH5Offline:
            try {
                clazz = Class.forName(IO.log("{}.WebActivity", Glob.bundleId));
            }
            catch (Exception e) {
            }
            break;
        case ATURLActionTypeNative:
            clazz = nativeClass();
            break;
        case ATURLActionTypeSystem:
        case ATURLActionTypeUnknown:
            break;
        default:
            break;
        }
        return clazz;
    }

    public Class<?> nativeClass() {
        Class<?> clazz = null;
        try {
            clazz = Class.forName(IO.log("{}.{}Activity", Glob.bundleId, host));
        }
        catch (Exception e) {
        }
        if (clazz != null) {
            return clazz;
        }
        try {
            clazz = Class.forName(IO.log("{}.{}.{}Activity", Glob.bundleId, host.toLowerCase(Locale.CHINA), host));
        }
        catch (Exception e) {
        }
        return clazz;
    }

    public String URLString() {
        switch (type) {
        case ATURLActionTypePop:
        case ATURLActionTypeNative:
        case ATURLActionTypeSystem:
        case ATURLActionTypeUnknown:
        case ATURLActionTypeH5Online: {
            int idx = url.indexOf('?');
            StringBuffer path = new StringBuffer(idx < 0 ? url : url.substring(0, idx)).append('?');
            for (Map.Entry<String, String> entry : parameters.entrySet()) {
                path.append(entry.getKey()).append('=').append(encode(entry.getValue())).append('&');
            }
            path.deleteCharAt(path.length() - 1);
            String http = path.toString();
            if (type == ATURLActionTypeH5Online) {
                http = http.replace("$://", "gold://");
                http = http.replace("gold://", "http://");
            }
            return http;
        }
        case ATURLActionTypeH5Offline: {
            String path = IO.log("{}/{}/index.html", Glob.pathPluginsH5, host);
            if (!new File(path).exists()) {
                path = IO.log("{}/{}/index.html", Glob.pathWeb, host);
            }
            StringBuffer query = new StringBuffer();
            for (Map.Entry<String, String> e : parameters.entrySet()) {
                query.append(IO.log("{}={}&", e.getKey(), e.getValue()));
            }
            query.deleteCharAt(path.length() - 1);
            return IO.log("file://{}?{}", path, query);
        }
        }
        return url;
    }

    private void makeParams(String url) {
        int idx = url.indexOf('?');
        if (idx < 0) {
            return;
        }
        String[] list = url.substring(idx + 1).split("&");
        for (String item : list) {
            String[] kv = cut(item, "=");
            parameters.put(kv[0], decode(kv[1]));
        }

        parameters.put("_bdid", Glob.bundleId);
        parameters.put("_name", Glob.deviceName);
        parameters.put("_sysv", Glob.deviceVersion);
        parameters.put("_ttid", "");
        parameters.put("_uuid", Glob.deviceUUID);
        parameters.put("_appv", Glob.appVersion);
        parameters.put("_mmid", Glob.mmId);
    }

    private String[] cut(String str, String tag) {
        int idx = str.indexOf(tag);
        if (idx == -1) {
            return new String[] { str, "" };
        }
        else {
            return new String[] { str.substring(0, idx), str.substring(idx + tag.length()) };
        }
    }

    public String getString(String name) {
        return parameters.get(name);
    }

    public boolean getBoolean(String name) {
        return Boolean.valueOf(parameters.get(name));
    }

    public static String decode(String txt) {
        try {
            return URLDecoder.decode(txt, "UTF-8");
        }
        catch (Exception e) {
            return txt;
        }
    }

    public static String encode(String txt) {
        try {
            return URLEncoder.encode(txt, "UTF-8");
        }
        catch (Exception e) {
            return txt;
        }
    }

    // -----------------------------------------------------------------
    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getHost() {
        return host;
    }

    public void setHost(String host) {
        this.host = host;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getScheme() {
        return scheme;
    }

    public void setScheme(String scheme) {
        this.scheme = scheme;
    }

    public Map<String, String> getParameters() {
        return parameters;
    }

    public void setParameters(Map<String, String> parameters) {
        this.parameters = parameters;
    }

}
