package app.engine.common;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.accounts.AccountManager;
import android.app.Activity;
import android.app.ActivityManager;
import android.app.ActivityManager.RunningAppProcessInfo;
import android.app.ActivityManager.RunningTaskInfo;
import android.app.AlarmManager;
import android.app.AlertDialog;
import android.app.DownloadManager;
import android.app.KeyguardManager;
import android.app.NotificationManager;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.hardware.SensorManager;
import android.location.LocationManager;
import android.media.AudioManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.os.PowerManager;
import android.os.Vibrator;
import android.os.storage.StorageManager;
import android.provider.Settings;
import android.service.wallpaper.WallpaperService;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.WindowManager;
import android.view.accessibility.AccessibilityManager;
import android.widget.Toast;

public class App {

    private static final String TAG = App.class.getSimpleName();
    private static final Map<Class<?>, String> MAP = new HashMap<Class<?>, String>();

    static {
        MAP.put(Vibrator.class, Context.VIBRATOR_SERVICE);
        MAP.put(WifiManager.class, Context.WIFI_SERVICE);
        MAP.put(AlarmManager.class, Context.ALARM_SERVICE);
        MAP.put(AudioManager.class, Context.AUDIO_SERVICE);
        MAP.put(PowerManager.class, Context.POWER_SERVICE);
        MAP.put(SensorManager.class, Context.SENSOR_SERVICE);
        MAP.put(WindowManager.class, Context.WINDOW_SERVICE);
        MAP.put(AccountManager.class, Context.ACCOUNT_SERVICE);
        MAP.put(LayoutInflater.class, Context.LAYOUT_INFLATER_SERVICE);
        MAP.put(StorageManager.class, Context.STORAGE_SERVICE);
        MAP.put(ActivityManager.class, Context.ACTIVITY_SERVICE);
        MAP.put(DownloadManager.class, Context.DOWNLOAD_SERVICE);
        MAP.put(LocationManager.class, Context.LOCATION_SERVICE);
        MAP.put(KeyguardManager.class, Context.KEYGUARD_SERVICE);
        MAP.put(ClipboardManager.class, Context.CLIPBOARD_SERVICE);
        MAP.put(TelephonyManager.class, Context.TELEPHONY_SERVICE);
        MAP.put(WallpaperService.class, Context.WALLPAPER_SERVICE);
        MAP.put(ConnectivityManager.class, Context.CONNECTIVITY_SERVICE);
        MAP.put(NotificationManager.class, Context.NOTIFICATION_SERVICE);
        MAP.put(AccessibilityManager.class, Context.ACCESSIBILITY_SERVICE);
    }

    public static void install(Uri apk) {
        if (apk == null) {
            return;
        }
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.setDataAndType(apk, "application/vnd.android.package-archive");
        if ((Build.VERSION.SDK_INT >= 24)) {
            // 添加这一句表示对目标应用临时授权该Uri所代表的文件
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        }
        if (intent.resolveActivity(Glob.app.getPackageManager()) == null) {
            toast("下载完成，请点击下拉列表的通知手动安装");
        }
        else {
            Glob.app.startActivity(intent);
        }
    }

    public static boolean isAppInstalled(String pkg) {
        List<PackageInfo> infos = Glob.app.getPackageManager().getInstalledPackages(0);
        for (PackageInfo info : infos) {
            if (info.packageName.equalsIgnoreCase(pkg)) {
                return true;
            }
        }
        return false;
    }

    public static boolean isPermission(String permission) {
        return PackageManager.PERMISSION_GRANTED == Glob.app.checkCallingOrSelfPermission(permission);
    }

    @SuppressWarnings("deprecation")
    public static boolean isAppOnBackground() {
        ActivityManager manager = getService(ActivityManager.class);
        List<RunningTaskInfo> tasks = manager.getRunningTasks(1);
        if (tasks.size() > 0 && Glob.app.getPackageName().equals(tasks.get(0).topActivity.getPackageName())) {
            return false;
        }
        return true;
    }

    public static boolean isAppOnForeground() {
        String pkg = Glob.app.getPackageName();
        List<RunningAppProcessInfo> processes = getService(ActivityManager.class).getRunningAppProcesses();
        if (processes == null || processes.size() <= 0) {
            return false;
        }
        for (RunningAppProcessInfo process : processes) {
            if (pkg.equals(process.processName) && process.importance == RunningAppProcessInfo.IMPORTANCE_FOREGROUND) {
                return true;
            }
        }
        return false;
    }

    @SuppressWarnings("deprecation")
    public static boolean isNetworkAvailable() {
        NetworkInfo info = getService(ConnectivityManager.class).getActiveNetworkInfo();
        if (info != null && info.isConnected() && info.isAvailable()) {
            return true;
        }
        else {
            return false;
        }
    }

    public static String getIPAddress() {
        String ip = null;
        try {
            for (Enumeration<NetworkInterface> en = NetworkInterface.getNetworkInterfaces(); en.hasMoreElements();) {
                NetworkInterface intf = en.nextElement();
                for (Enumeration<InetAddress> addr = intf.getInetAddresses(); addr.hasMoreElements();) {
                    InetAddress inetAddress = addr.nextElement();
                    if (!inetAddress.isLoopbackAddress()) {
                        ip = inetAddress.getHostAddress().toString();
                    }
                }
            }
        }
        catch (Exception e) {
            Log.e(TAG, "getIPAddress failure.", e);
        }
        return ip;
    }

    public static String getSystemProperty(String key, String defaultValue) {
        String value = defaultValue;
        try {
            Class<?> clazz = Class.forName("android.os.SystemProperties");
            Method method = clazz.getMethod("get", String.class, String.class);
            value = (String) method.invoke(null, key, defaultValue);
        }
        catch (Exception e0) {
            Log.e(TAG, "getSystemProperty(android.os.SystemProperties):" + key, e0);

            InputStream inStream = null;
            Reader inReader = null;
            BufferedReader inBuffer = null;
            try {
                Process p = Runtime.getRuntime().exec("getprop " + key);
                inStream = p.getInputStream();
                inReader = new InputStreamReader(inStream);
                inBuffer = new BufferedReader(inReader);
                value = inBuffer.readLine();
            }
            catch (Exception e1) {
                Log.e(TAG, "getSystemProperty(exec:getprop):" + key, e1);
            }
            finally {
                IO.close(inBuffer, inReader, inStream);
            }
        }
        return value;
    }

    public static String getSystemSetting(String key, String defaulValue) {
        String val = Settings.System.getString(Glob.app.getContentResolver(), key);
        if (TextUtils.isEmpty(val)) {
            return defaulValue;
        }
        return val;
    }

    public static void setSystemSetting(String key, String val) {
        Settings.System.putString(Glob.app.getContentResolver(), key, val);
    }

    public static PackageInfo getPackageInfo(String pkg) {
        try {
            if (TextUtils.isEmpty(pkg)) {
                pkg = Glob.app.getPackageName();
            }
            PackageManager mgr = Glob.app.getPackageManager();
            return mgr.getPackageInfo(pkg, PackageManager.GET_CONFIGURATIONS);
        }
        catch (Exception e) {
            Log.e(TAG, "getPackageInfo error:" + pkg, e);
        }
        return null;
    }

    public static void toast(String text) {
        Toast.makeText(Glob.app, text, Toast.LENGTH_LONG).show();
    }

    public static boolean canOpenURL(String url) {
        return false;
    }

    public static void killSelf() {
        String pkg = Glob.app.getPackageName() + ":";
        List<RunningAppProcessInfo> processes = getService(ActivityManager.class).getRunningAppProcesses();
        for (RunningAppProcessInfo process : processes) {
            if (process.processName.contains(pkg)) {
                android.os.Process.killProcess(process.pid);
            }
        }
        android.os.Process.killProcess(android.os.Process.myPid());
    }

    @SuppressWarnings("unchecked")
    public static <T> T getService(Class<T> clazz) {
        return (T) Glob.app.getSystemService(MAP.get(clazz));
    }

    public static Activity topActivity() {
        try {
            Class<?> clazz = Class.forName("android.app.ActivityThread");
            Object instance = clazz.getMethod("currentActivityThread").invoke(null);

            Field field = clazz.getDeclaredField("mActivities");
            field.setAccessible(true);
            Map<?, ?> activities = (Map<?, ?>) field.get(instance);
            for (Object record : activities.values()) {
                Class<?> recordClass = record.getClass();
                Field recordPause = recordClass.getDeclaredField("paused");
                recordPause.setAccessible(true);
                if (!recordPause.getBoolean(record)) {
                    Field recordActivity = recordClass.getDeclaredField("activity");
                    recordActivity.setAccessible(true);
                    Activity activity = (Activity) recordActivity.get(record);
                    return activity;
                }
            }
        }
        catch (Exception e) {
            Log.e(TAG, "topActivity failure.", e);
        }
        return null;
    }

    public static Object invoke(String clsName, String funName, Object... params) {
        Object ret = null;
        try {
            Class<?> cls = Class.forName(clsName);
            Method mtd = cls.getMethod(funName);
            ret = mtd.invoke(null, params);
        }
        catch (Exception e) {
            Log.e(TAG, String.format("invoke(%s, %s)", clsName, funName), e);
        }
        return ret;
    }

    public static void pop() {
        Glob.top.finish();
    }

    public static void openURL(String url) {
    }

    public static void pushURL(String url) {
        pushAction(URLAction.actionWithURLString(url));
    }

    @SuppressWarnings("deprecation")
    public static void pushAction(URLAction action) {
        switch (action.getType()) {
        case URLAction.ATURLActionTypePop: {
            App.pop();
            break;
        }
        case URLAction.ATURLActionTypeNative:
        case URLAction.ATURLActionTypeH5Online:
        case URLAction.ATURLActionTypeH5Offline: {
            Intent intent = new Intent(Glob.top, action.clazz());
            intent.putExtra("action", action);
            Glob.top.startActivity(intent);
            break;
        }
        case URLAction.ATURLActionTypeSystem: {
            App.openURL(action.URLString());
            break;
        }
        case URLAction.ATURLActionTypeUnknown: {
            AlertDialog.Builder builder = new AlertDialog.Builder(Glob.top);
            builder.setTitle("无效的URL");
            builder.setPositiveButton("确定", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                }
            });
            AlertDialog dialog = builder.create();
            dialog.setCanceledOnTouchOutside(false);
            if (!Glob.isMIUI) {
                dialog.getWindow().setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT);
            }
            dialog.show();
            break;
        }
        }
        if (action.getType() != URLAction.ATURLActionTypeUnknown && action.getBoolean("_finish")) {
            Glob.top.finish();
        }
        Glob.top.overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
}
