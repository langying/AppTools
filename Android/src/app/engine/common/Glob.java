package app.engine.common;

import java.io.BufferedReader;
import java.io.FileReader;
import java.lang.reflect.Method;
import java.net.NetworkInterface;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import com.nostra13.universalimageloader.cache.disc.impl.UnlimitedDiskCache;
import com.nostra13.universalimageloader.cache.disc.naming.HashCodeFileNameGenerator;
import com.nostra13.universalimageloader.cache.memory.impl.LruMemoryCache;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.QueueProcessingType;
import com.nostra13.universalimageloader.core.decode.BaseImageDecoder;
import com.nostra13.universalimageloader.core.download.BaseImageDownloader;
import com.nostra13.universalimageloader.utils.StorageUtils;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Application;
import android.app.Application.ActivityLifecycleCallbacks;
import android.content.ComponentCallbacks;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.graphics.Point;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.provider.Settings.Secure;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.util.Log;
import android.webkit.WebView;

public class Glob {

    private static final String kTag = Glob.class.getSimpleName();
    private static final int MM_CACHE_SIZE = 8 * 1024 * 1024;
    private static final int SD_CACHE_SIZE = 50 * 1024 * 1024;

    private static int mCount = 0;
    private static Runnable mCheck = null;
    private static Handler mHandler = new Handler();

    public static Activity top = null;
    public static Application app = null;

    public static String deviceName = android.os.Build.MODEL;
    public static String deviceIMEI = null;
    public static String deviceIMSI = null;
    public static String deviceUUID = null;
    public static String deviceVersion = android.os.Build.VERSION.RELEASE;

    public static String macWIFI = null;
    public static String macWIRE = null;
    public static String simId = null;
    public static String androidId = null;
    public static String netOpName = null;
    public static String netOpUuid = null;
    public static Integer netOpType = null;

    public static int appVersionCode = 0;
    public static String bundleId = null;
    public static String appName = null;
    public static String appVersion = null;

    public static String mmId = "";
    public static String pathWeb = "";
    public static String pathCache = null;
    public static String pathExtCache = null;
    public static String pathDownload = null;
    public static String pathPluginsH5 = "";

    public static boolean isMIUI = false;
    public static boolean isDEBUG = false;
    public static boolean isYunOS = false;

    public static float density = 0;
    public static Point screen = new Point();

    public static Map<String, String> http = new HashMap<String, String>();

    @TargetApi(Build.VERSION_CODES.KITKAT)
    public static void init(Application appliaction) {
        app = appliaction;
        if (app == null) {
            app = (Application) invoke("android.app.AppGlobals", "getInitialApplication", (Object[]) null);
        }
        if (app == null) {
            app = (Application) invoke("android.app.ActivityThread", "currentApplication", (Object[]) null);
        }
        if (app == null) {
            throw new RuntimeException("init failure, bacame app is null.");
        }
        {
            TelephonyManager tm = (TelephonyManager) app.getSystemService(Context.TELEPHONY_SERVICE);
            deviceIMEI = tm.getDeviceId();
            deviceIMSI = tm.getSubscriberId();

            simId = tm.getSimSerialNumber();
            androidId = Secure.getString(app.getContentResolver(), Secure.ANDROID_ID);

            macWIFI = getMacWIFI();
            macWIRE = getMacWIRE();

            long imei = TextUtils.isEmpty(deviceIMEI) ? System.nanoTime() : deviceIMEI.hashCode();
            long imsi = TextUtils.isEmpty(deviceIMSI) ? System.nanoTime() : deviceIMSI.hashCode();
            long sim = TextUtils.isEmpty(simId) ? System.nanoTime() : simId.hashCode();
            long adr = TextUtils.isEmpty(androidId) ? System.nanoTime() : androidId.hashCode();
            deviceUUID = new UUID(imei << 32 | imsi, sim << 32 | adr).toString();

            netOpName = tm.getNetworkOperatorName();
            netOpUuid = tm.getNetworkOperator();
            netOpType = tm.getNetworkType();
        }
        try {
            PackageManager mgr = app.getPackageManager();
            PackageInfo pkg = mgr.getPackageInfo(app.getPackageName(), PackageManager.GET_CONFIGURATIONS);
            appVersionCode = pkg.versionCode;
            bundleId = pkg.packageName;
            appName = app.getResources().getString(pkg.applicationInfo.labelRes);
            appVersion = pkg.versionName;
        }
        catch (Exception e) {
        }
        {
            pathCache = app.getCacheDir() + "/";
            pathExtCache = app.getExternalCacheDir() + "/";
            pathDownload = Environment.getDownloadCacheDirectory() + "/";
        }
        {
            isMIUI = !TextUtils.isEmpty(App.getSystemProperty("ro.miui.ui.version.name", null));
            isDEBUG = (0 != (Glob.app.getApplicationInfo().flags & ApplicationInfo.FLAG_DEBUGGABLE));
            isYunOS = isYunOS();
        }
        {
            DisplayMetrics display = app.getResources().getDisplayMetrics();
            density = display.density;
            screen.set((int) (display.widthPixels / density + 0.5), (int) (display.heightPixels / density + 0.5));
        }
        {
            ImageLoaderConfiguration cfg = new ImageLoaderConfiguration.Builder(app)       //
                    .diskCacheSize(SD_CACHE_SIZE)							                // SDCard
                    .diskCacheFileCount(100)												//
                    .diskCacheExtraOptions(Glob.screen.x, Glob.screen.y, null)				//
                    .diskCache(new UnlimitedDiskCache(StorageUtils.getCacheDirectory(app)))//
                    .diskCacheFileNameGenerator(new HashCodeFileNameGenerator())			//
                    .memoryCacheSize(MM_CACHE_SIZE)											//
                    .memoryCacheExtraOptions(Glob.screen.x, Glob.screen.y)					// Memory
                    .memoryCacheSizePercentage(13)											//
                    .memoryCache(new LruMemoryCache(MM_CACHE_SIZE))							//
                    .threadPoolSize(2)														// Runtime.getRuntime().availableProcessors()
                    .threadPriority(Thread.NORM_PRIORITY - 2)								//
                    .tasksProcessingOrder(QueueProcessingType.FIFO)							//
                    .imageDecoder(new BaseImageDecoder(false))								//
                    .imageDownloader(new BaseImageDownloader(app))							//
                    .denyCacheImageMultipleSizesInMemory()									//
                    .defaultDisplayImageOptions(DisplayImageOptions.createSimple())			//
                    .build();
            ImageLoader.getInstance().init(cfg);
        }
        app.registerComponentCallbacks(new ComponentCallbacks() {
            @Override
            public void onLowMemory() {
                ImageLoader.getInstance().clearMemoryCache();
            }

            @Override
            public void onConfigurationChanged(Configuration newConfig) {
            }
        });
        app.registerActivityLifecycleCallbacks(new ActivityLifecycleCallbacks() {

            @Override
            public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
                Log.i(kTag, activity.getClass().getSimpleName() + ":onActivityCreated");
            }

            @Override
            public void onActivityStarted(Activity activity) {
                Log.i(kTag, activity.getClass().getSimpleName() + ":onActivityStarted");
                top = activity;
            }

            @Override
            public void onActivityResumed(Activity activity) {
                mCount++;
                Log.i(kTag, activity.getClass().getSimpleName() + ":onActivityResumed:" + mCount);
                if (mCheck != null) {
                    mHandler.removeCallbacks(mCheck);
                }
            }

            @Override
            public void onActivityPaused(Activity activity) {
                mCount--;
                if (mCheck != null) {
                    mHandler.removeCallbacks(mCheck);
                }
                Log.i(kTag, activity.getClass().getSimpleName() + ":onActivityPaused:" + mCount);
            }

            @Override
            public void onActivityStopped(Activity activity) {
                Log.i(kTag, activity.getClass().getSimpleName() + ":onActivityStopped:" + mCount);
                if (mCheck != null) {
                    mHandler.removeCallbacks(mCheck);
                }
                mHandler.postDelayed(mCheck = new Runnable() {
                    @Override
                    public void run() {
                        if (mCount > 0) {
                            Log.i(kTag, "App still alived:" + mCount);
                        }
                        else {
                            Log.i(kTag, "App enter stoped:" + mCount);
                            App.killSelf();
                        }
                    }
                }, 3000);
            }

            @Override
            public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
                Log.i(kTag, activity.getClass().getSimpleName() + ":onActivitySaveInstanceState");
            }

            @Override
            public void onActivityDestroyed(Activity activity) {
                Log.i(kTag, activity.getClass().getSimpleName() + ":onActivityDestroyed");
            }
        });

        if (Build.VERSION.SDK_INT >= 19) {
            WebView.setWebContentsDebuggingEnabled(isDEBUG);
        }
    }

    public static String getMmId() {
        return mmId;
    }

    public static void setMmId(String id) {
        if (id != null) {
            mmId = id;
        }
    }

    private static Object invoke(String clsName, String funName, Object... params) {
        Object ret = null;
        try {
            Class<?> cls = Class.forName(clsName);
            Method mtd = cls.getMethod(funName);
            ret = mtd.invoke(null, params);
        }
        catch (Exception e) {
            Log.e(kTag, String.format("invoke(%s, %s)", clsName, funName), e);
        }
        return ret;
    }

    private static boolean isYunOS() {
        String ret;
        ret = App.getSystemProperty("persist.sys.yunosflag", null);
        if ("1".equals(ret)) {
            return true;
        }
        ret = App.getSystemProperty("ro.yunos.product.model", null);
        if (!TextUtils.isEmpty(ret)) {
            return true;
        }
        ret = App.getSystemProperty("ro.yunos.product.chip", null);
        if (!TextUtils.isEmpty(ret)) {
            return true;
        }
        ret = App.getSystemProperty("ro.yunos.version.release", null);
        if (!TextUtils.isEmpty(ret)) {
            return true;
        }
        return false;
    }

    private static String getMacWIRE() {
        String mac = addressWithName("eth0");
        if (!TextUtils.isEmpty(mac)) {
            return mac;
        }

        FileReader reader = null;
        BufferedReader buffer = null;
        try {
            reader = new FileReader("/sys/class/net/eth0/address");
            buffer = new BufferedReader(reader, 256);
            return buffer.readLine();
        }
        catch (Exception e) {
            return null;
        }
        finally {
            IO.close(buffer, reader);
        }
    }

    private static String getMacWIFI() {
        String mac = addressWithName("wlan0");
        if (!TextUtils.isEmpty(mac)) {
            return mac;
        }

        WifiManager wifiMgr = (WifiManager) app.getSystemService(Context.WIFI_SERVICE);
        WifiInfo wifiInfo = (null == wifiMgr) ? null : wifiMgr.getConnectionInfo();
        mac = (null == wifiInfo) ? null : wifiInfo.getMacAddress();
        if (TextUtils.isEmpty(mac) || mac.equalsIgnoreCase("02:00:00:00:00:00")) {
            mac = null;
        }
        return mac;
    }

    private static String addressWithName(String name) {
        try {
            NetworkInterface net = NetworkInterface.getByName(name);
            if (net == null) {
                return null;
            }
            byte[] bytes = net.getHardwareAddress();
            if (bytes == null || bytes.length <= 0) {
                return null;
            }
            StringBuilder ret = new StringBuilder();
            for (byte b : bytes) {
                ret.append(String.format("%02X:", b));
            }
            ret.deleteCharAt(ret.length() - 1);
            return ret.toString();
        }
        catch (Exception e) {
            Log.w(kTag, "addressWithName(" + name + "):" + e.getMessage());
            return null;
        }
    }
}
