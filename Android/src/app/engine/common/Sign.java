package app.engine.common;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.InputStream;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.security.MessageDigest;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.util.HashMap;
import java.util.Map;

import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.pm.Signature;
import android.os.Build;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.util.Log;

public class Sign {

    private static final String kTag = Sign.class.getSimpleName();

    private static final String kPackageParser = "android.content.pm.PackageParser";

    public Map<String, String> parseSignature(Signature signature) {
        InputStream inStream = null;
        try {
            inStream = new ByteArrayInputStream(signature.toByteArray());
            CertificateFactory factory = CertificateFactory.getInstance("X.509");
            X509Certificate cert = (X509Certificate) factory.generateCertificate(inStream);

            Map<String, String> info = new HashMap<String, String>();
            info.put("pubKey", cert.getPublicKey().toString());
            info.put("signName", cert.getSigAlgName());
            info.put("subjectDN", cert.getSubjectDN().toString());
            info.put("signNumber", cert.getSerialNumber().toString());
            return info;
        }
        catch (Exception e) {
            Log.e(kTag, "Sign::md5WithSignture", e);
            return null;
        }
        finally {
            IO.close(inStream);
        }
    }

    public static String md5WithSignture(Signature signature) {
        InputStream inStream = null;
        try {
            inStream = new ByteArrayInputStream(signature.toByteArray());
            CertificateFactory factory = CertificateFactory.getInstance("X.509");
            X509Certificate cert = (X509Certificate) factory.generateCertificate(inStream);
            MessageDigest digest = MessageDigest.getInstance("SHA-1");
            digest.update(cert.getEncoded()); // 获得公钥
            byte[] data = digest.digest();
            return Codec.hexStringWithBytes(data);
        }
        catch (Exception e) {
            Log.e(kTag, "Sign::md5WithSignture", e);
            return null;
        }
        finally {
            IO.close(inStream);
        }
    }

    public static Signature signatureWithPkg(String pkg) throws NameNotFoundException {
        try {
            if (TextUtils.isEmpty(pkg)) {
                pkg = Glob.app.getPackageName();
            }
            PackageInfo pkgInfo = Glob.app.getPackageManager().getPackageInfo(pkg, PackageManager.GET_SIGNATURES);
            return pkgInfo.signatures[0];
        }
        catch (Exception e) {
            Log.e(kTag, "Sign::signtureWithPackage for pkg:" + pkg, e);
            return null;
        }
    }

    public static Signature signatureWithApk(String apk) {
        try {
            Object mParser, pkgInfo;
            DisplayMetrics metrics = new DisplayMetrics();
            metrics.setToDefaults();

            if (Build.VERSION.SDK_INT > 20) {
                mParser = newInstance("android.content.pm.PackageParser");
                pkgInfo = invokeMethod(mParser, "parsePackage", new File(apk), PackageManager.GET_SIGNATURES);
            }
            else {
                mParser = newInstance("android.content.pm.PackageParser", apk);
                pkgInfo = invokeMethod(mParser, "parsePackage", new File(apk), apk, metrics, PackageManager.GET_SIGNATURES);
            }

            invokeMethod(mParser, "collectCertificates", pkgInfo, PackageManager.GET_SIGNATURES);

            Field mSignatures = pkgInfo.getClass().getDeclaredField("mSignatures");
            mSignatures.setAccessible(true);
            Signature[] signatures = (Signature[]) mSignatures.get(pkgInfo);
            return signatures[0];
        }
        catch (Exception e) {
            Log.e(kTag, "Sign::signatureWithApk for apk:" + apk, e);
        }
        return null;
    }

    private static Object newInstance(String name, Object... args) throws Exception {
        if (args == null || args.length <= 0) {
            Class<?> clazz = Class.forName(kPackageParser);
            return clazz.newInstance();
        }
        else {
            Class<?> clazz = Class.forName(name);
            Class<?>[] type = new Class<?>[args.length];
            for (int i = 0, l = args.length; i < l; i++) {
                type[i] = args.getClass();
            }
            Constructor<?> constructor = clazz.getConstructor(type);
            return constructor.newInstance(args);
        }
    }

    private static Object invokeMethod(Object thiz, String func, Object... args) throws Exception {
        Class<?>[] type = new Class<?>[args.length];
        for (int i = 0, l = args.length; i < l; i++) {
            type[i] = args.getClass();
        }
        Method method = thiz.getClass().getMethod(func, type);
        method.setAccessible(true);
        return method.invoke(thiz, args);
    }
}
