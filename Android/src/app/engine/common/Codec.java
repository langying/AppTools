package app.engine.common;

import java.io.File;
import java.io.FileInputStream;
import java.math.BigInteger;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.security.MessageDigest;

import android.annotation.SuppressLint;
import android.text.TextUtils;
import android.util.Log;

@SuppressLint("DefaultLocale")
public class Codec {

	private static final String	kUTF	= "UTF-8";
	private static final String	kTag	= Codec.class.getSimpleName();
	private static final char[]	kHex	= { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

	public static String md5(File file) {
		String ret = MD5(file);
		if (TextUtils.isEmpty(ret)) {
			return null;
		}
		else {
			return ret.toLowerCase();
		}
	}

	public static String MD5(File file) {
		FileInputStream inStream = null;
		try {
			inStream = new FileInputStream(file);
			MessageDigest digest = MessageDigest.getInstance("MD5");

			byte buf[] = new byte[1024];
			for (int len = -1; (len = inStream.read(buf)) != -1;) {
				digest.update(buf, 0, len);
			}
			BigInteger bigInt = new BigInteger(1, digest.digest());
			return bigInt.toString(16).toUpperCase();
		}
		catch (Exception e) {
			Log.e(kTag, "md5:" + file, e);
			return null;
		}
		finally {
			IO.close(inStream);
		}
	}

	public static String hexStringWithBytes(byte bytes[]) {
		StringBuilder ret = new StringBuilder(bytes.length * 2);
		for (int i = 0, l = bytes.length; i < l; ++i) {
			ret.append(kHex[(bytes[i] & 0xf0) >> 4]);
			ret.append(kHex[(bytes[i] & 0x0f)]);
		}
		return ret.toString();
	}

	public static String encodeURL(String url) {
		try {
			return URLEncoder.encode(url, kUTF);
		}
		catch (Exception e) {
			Log.i(kTag, String.format("encodeURL(%s) exception:%s", url, e.getMessage()));
			return url;
		}
	}

	public static String decodeURL(String url) {
		try {
			return URLDecoder.decode(url, kUTF);
		}
		catch (Exception e) {
			Log.i(kTag, String.format("decodeURL(%s) exception:%s", url, e.getMessage()));
			return url;
		}
	}
}
