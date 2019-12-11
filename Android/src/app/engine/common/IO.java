package app.engine.common;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.Closeable;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.Locale;
import java.util.Set;

import android.content.Context;
import android.content.SharedPreferences.Editor;
import android.os.Environment;
import android.util.Base64;
import android.util.Log;

public class IO {

    private static final String kTAG = IO.class.getSimpleName();

    public static void close(Closeable... handles) {
        for (Closeable handle : handles) {
            try {
                handle.close();
            }
            catch (Exception e) {
            }
        }
    }

    public static void deleteFile(File... files) {
        if (files == null) {
            return;
        }
        for (File file : files) {
            if (file != null && file.exists()) {
                file.delete();
            }
        }
    }

    public static void deleteDirs(File... paths) {
        for (File path : paths) {
            deleteDir(path);
        }
    }

    public static void deleteDir(File path) {
        if (path == null || !path.exists()) {
            return;
        }
        for (File file : path.listFiles()) {
            if (file.isDirectory()) {
                deleteDir(file);
            }
            else {
                file.delete();
            }
        }
        path.delete();
    }

    public static void saveFile(String txt, String file) {
        FileOutputStream otStream = null;
        try {
            otStream = new FileOutputStream(file);
            otStream.write(txt.getBytes());
        }
        catch (Exception e) {
            Log.e(kTAG, "saveToFile to file:" + file, e);
        }
        finally {
            close(otStream);
        }
    }

    public static boolean copyFile(File src, File dst) {
        File tmp = null;
        FileInputStream inStream = null;
        FileOutputStream otStream = null;
        try {
            tmp = new File(dst.getPath() + ".tmp");
            inStream = new FileInputStream(src);
            otStream = new FileOutputStream(tmp);
            inStream.getChannel().transferTo(0, src.length(), otStream.getChannel());
            if (tmp.renameTo(dst)) {
                return true;
            }
            else {
                throw new Exception("Failed to rename " + tmp + " to " + dst);
            }
        }
        catch (Exception e) {
            Log.e(kTAG, String.format("Exception copyTo(%s, %s)", src, dst), e);
            return false;
        }
        finally {
            deleteFile(tmp);
            close(inStream, otStream);
        }
    }

    public static void copyDir(File src, File dst) {
        if (!src.isDirectory() || !dst.isDirectory()) {
            return;
        }
        if (!dst.exists()) {
            dst.mkdirs();
        }
        for (File file : src.listFiles()) {
            if (file.isDirectory()) {
                copyDir(file, new File(dst, file.getName()));
            }
            else {
                copyFile(file, new File(dst, file.getName()));
            }
        }
    }

    public static boolean download(String url, String file) {
        boolean success = false;
        InputStream inStream = null;
        FileOutputStream otStream = null;
        try {
            inStream = new URL(url).openStream();
            otStream = new FileOutputStream(file);
            byte[] buf = new byte[1024];
            for (int len = -1; (len = inStream.read(buf)) != -1;) {
                otStream.write(buf, 0, len);
            }
            success = true;
        }
        catch (Exception e) {
            Log.e(kTAG, String.format("download [%s] to [%s] error", url, file), e);
        }
        finally {
            close(inStream, otStream);
        }
        return success;
    }

    public static String textWithSP(String file, String name) {
        return Glob.app.getSharedPreferences(file, Context.MODE_PRIVATE).getString(name, null);
    }

    @SuppressWarnings("unchecked")
    public static void commitSP(String file, String key, Object val) {
        Editor edit = Glob.app.getSharedPreferences(file, Context.MODE_PRIVATE).edit();
        if (val == null) {
            edit.remove(key);
        }
        else if (val instanceof Long) {
            edit.putLong(key, (Long) val);
        }
        else if (val instanceof Float) {
            edit.putFloat(key, (Float) val);
        }
        else if (val instanceof Integer) {
            edit.putInt(key, (Integer) val);
        }
        else if (val instanceof Boolean) {
            edit.putBoolean(key, (Boolean) val);
        }
        else if (val instanceof String) {
            edit.putString(key, (String) val);
        }
        else if (val instanceof Set<?>) {
            edit.putStringSet(key, (Set<String>) val);
        }
        else {
            edit.putString(key, val.toString());
        }
        edit.commit();
    }

    public static String textWithURL(String url) {
        byte[] data = bytesWithURL(url);
        if (data == null || data.length <= 0) {
            return null;
        }
        return new String(data);
    }

    public static byte[] bytesWithURL(String url) {
        byte[] data = new byte[] { 0 };
        InputStream inStream = null;
        ByteArrayOutputStream otStream = null;
        try {
            inStream = new URL(url).openStream();
            otStream = new ByteArrayOutputStream();
            byte[] buffer = new byte[1024];
            for (int len = -1; (len = inStream.read(buffer)) != -1;) {
                otStream.write(buffer, 0, len);
            }
            data = otStream.toByteArray();
        }
        catch (Exception e) {
            Log.e(kTAG, "bytesWithAsset:", e);
        }
        finally {
            close(inStream, otStream);
        }
        return data;
    }

    public static String textWithAsset(String name) {
        byte[] data = bytesWithAsset(name);
        if (data == null || data.length <= 0) {
            return null;
        }
        return new String(data);
    }

    public static byte[] bytesWithAsset(String name) {
        byte[] data = new byte[] { 0 };
        InputStream inStream = null;
        ByteArrayOutputStream otStream = null;
        try {
            inStream = Glob.app.getAssets().open(name);
            otStream = new ByteArrayOutputStream();
            byte[] buffer = new byte[1024];
            for (int len = -1; (len = inStream.read(buffer)) != -1;) {
                otStream.write(buffer, 0, len);
            }
            data = otStream.toByteArray();
        }
        catch (Exception e) {
            Log.e(kTAG, "bytesWithAsset:", e);
        }
        finally {
            close(inStream, otStream);
        }
        return data;
    }

    public static boolean hasSDCard() {
        return Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED);
    }

    public static String getSDcardPath() {
        if (hasSDCard()) {
            return Environment.getExternalStorageDirectory().getPath();
        }
        else {
            return null;
        }
    }

    public static long getSDCardIdleSpace() {
        return new File(getSDcardPath()).getFreeSpace();
    }

    public static long getDataIdleSapce() {
        return new File("/data").getFreeSpace();
    }

    public static InputStream inStreamWithURL(String url) throws IOException {
        if (url.startsWith("/")) {
            return new FileInputStream(url);
        }
        else if (url.startsWith("http:") || url.startsWith("https:")) {
            return new URL(url).openStream();
        }
        else if (url.startsWith("data:")) {
            String[] comps = url.split(":");
            String[] datas = comps[comps.length - 1].split(";");
            String[] codes = datas[datas.length - 1].split(",");
            byte[] bytes = Base64.decode(codes[codes.length - 1], Base64.DEFAULT);
            return new ByteArrayInputStream(bytes);
        }
        else if (url.startsWith("file:")) {
            int idx = url.indexOf('?');
            if (idx > 0) {
                // 本地URL要去除?以及后面的参数，保证PathFile的正确读取
                url = url.substring(0, idx);
            }
            if (url.startsWith("file:///asset/")) {
                url = url.replace("file:///asset/", "");
                return Glob.app.getAssets().open(url);
            }
            else if (url.startsWith("file:///cache/")) {
                url = url.replace("file:///cache/", "");
                return new FileInputStream(Glob.pathCache + url);
            }
            else {
                url = url.replace("file://", "");
                return new FileInputStream(url);
            }
        }
        else {
            return new URL(url).openStream();
        }
    }

    public static String log(String txt, Object... args) {
        return fmt(txt, "{}", args);
    }

    public static String fmt(String txt, String tag, Object... args) {
        int size = txt == null ? 0 : txt.length();
        if (size <= 0) {
            return txt;
        }

        StringBuilder ret = new StringBuilder(size * 2);
        for (int i = 0, idx = 0, pos = 0, len = (args == null ? 0 : args.length); i <= len; i++) {
            pos = txt.indexOf(tag, idx);
            if (i == len || pos == -1) {
                ret.append(txt.substring(idx));
                break;
            }
            else {
                String str = txt.substring(idx, pos);
                ret.append(str).append(args[i]);
                idx = pos + tag.length();
            }
        }
        return ret.toString();
    }

    public static String getMimeType(File file) {
        String val = "*/*";
        String name = file.getName();
        int idx = name.lastIndexOf(".");
        if (idx < 0) {
            return val;
        }
        String key = name.substring(idx, name.length()).toLowerCase(Locale.CHINA);
        if (key == "") {
            return val;
        }
        for (int i = 0; i < MIME_TYPE_MAP.length; i++) {
            if (key.equals(MIME_TYPE_MAP[i][0])) {
                val = MIME_TYPE_MAP[i][1];
                break;
            }
        }
        return val;
    }

    public static final String[][] MIME_TYPE_MAP = { //
            { ".3gp", "video/3gpp" }, { ".apk", "application/vnd.android.package-archive" }, { ".asf", "video/x-ms-asf" }, { ".avi", "video/x-msvideo" },
            { ".bin", "application/octet-stream" }, { ".bmp", "image/bmp" }, { ".c", "text/plain" }, { ".class", "application/octet-stream" },
            { ".conf", "text/plain" }, { ".cpp", "text/plain" }, { ".doc", "application/msword" },
            { ".docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document" }, { ".xls", "application/vnd.ms-excel" },
            { ".xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" }, { ".exe", "application/octet-stream" }, { ".gif", "image/gif" },
            { ".gtar", "application/x-gtar" }, { ".gz", "application/x-gzip" }, { ".h", "text/plain" }, { ".htm", "text/html" }, { ".html", "text/html" },
            { ".jar", "application/java-archive" }, { ".java", "text/plain" }, { ".jpeg", "image/jpeg" }, { ".jpg", "image/jpeg" },
            { ".js", "application/x-javascript" }, { ".log", "text/plain" }, { ".m3u", "audio/x-mpegurl" }, { ".m4a", "audio/mp4a-latm" },
            { ".m4b", "audio/mp4a-latm" }, { ".m4p", "audio/mp4a-latm" }, { ".m4u", "video/vnd.mpegurl" }, { ".m4v", "video/x-m4v" },
            { ".mov", "video/quicktime" }, { ".mp2", "audio/x-mpeg" }, { ".mp3", "audio/x-mpeg" }, { ".mp4", "video/mp4" },
            { ".mpc", "application/vnd.mpohun.certificate" }, { ".mpe", "video/mpeg" }, { ".mpeg", "video/mpeg" }, { ".mpg", "video/mpeg" },
            { ".mpg4", "video/mp4" }, { ".mpga", "audio/mpeg" }, { ".msg", "application/vnd.ms-outlook" }, { ".ogg", "audio/ogg" },
            { ".pdf", "application/pdf" }, { ".png", "image/png" }, { ".pps", "application/vnd.ms-powerpoint" }, { ".ppt", "application/vnd.ms-powerpoint" },
            { ".pptx", "application/vnd.openxmlformats-officedocument.presentationml.presentation" }, { ".prop", "text/plain" }, { ".rc", "text/plain" },
            { ".rmvb", "audio/x-pn-realaudio" }, { ".rtf", "application/rtf" }, { ".sh", "text/plain" }, { ".tar", "application/x-tar" },
            { ".tgz", "application/x-compressed" }, { ".txt", "text/plain" }, { ".wav", "audio/x-wav" }, { ".wma", "audio/x-ms-wma" },
            { ".wmv", "audio/x-ms-wmv" }, { ".wps", "application/vnd.ms-works" }, { ".xml", "text/plain" }, { ".z", "application/x-compress" },
            { ".zip", "application/x-zip-compressed" }, { "", "*/*" } };
}
