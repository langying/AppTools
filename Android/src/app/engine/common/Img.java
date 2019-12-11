package app.engine.common;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.BitmapFactory;
import android.graphics.BitmapFactory.Options;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.LinearGradient;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Point;
import android.graphics.PorterDuff.Mode;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Shader.TileMode;
import android.media.ThumbnailUtils;
import android.util.Log;
import android.view.View;

public class Img {

	private static final String kTag = Img.class.getSimpleName();

	/**
	 * 根据URL获取bitmap
	 *
	 * @param url
	 * @return
	 */
	public Bitmap bitmapWithURL(String url) {
		InputStream inStream = null;
		try {
			Options options = new Options();
			options.inPurgeable = true;
			options.inInputShareable = true;
			options.inPreferredConfig = Bitmap.Config.RGB_565;

			inStream = IO.inStreamWithURL(url);
			return BitmapFactory.decodeStream(inStream, null, options);
		}
		catch (Exception e) {
			Log.e(kTag, "bitmapWithURL:" + url, e);
			return null;
		}
		finally {
			IO.close(inStream);
		}
	}

	/**
	 * 根据url、size获取bitmap
	 *
	 * @param url
	 * @param nw
	 * @param nh
	 * @return
	 */
	public static Bitmap bitmapWithSize(String url, int nw, int nh) {
		InputStream inStream = null;
		try {
			inStream = IO.inStreamWithURL(url);
			Options options = sizeWithBitmap(url);
			return BitmapFactory.decodeStream(inStream, null, optionsWithSize(options, nw, nh));
		}
		catch (Exception e) {
			Log.e(kTag, "bitmapWithURL:" + url, e);
			return null;
		}
		finally {
			IO.close(inStream);
		}
	}

	/**
	 * 根据已有的bitmap和size，获取新的bitmap
	 *
	 * @param bp
	 * @param nw
	 * @param nh
	 * @return
	 */
	public static Bitmap bitmapWithSize(Bitmap bp, int nw, int nh) {
		int bw = bp.getWidth();
		int bh = bp.getHeight();
		float sx = nw / (float) bw;
		float sy = nh / (float) bh;
		Matrix matrix = new Matrix();
		matrix.postScale(sx, sy);
		return Bitmap.createBitmap(bp, 0, 0, bw, bh, matrix, true);
	}

	/**
	 * 等比缩放，至少一个边适应w/h
	 *
	 * @param bp
	 * @param nw
	 * @param nh
	 * @return
	 */
	public static Bitmap bitmapWithAdjust(Bitmap bp, int nw, int nh) {
		int bw = bp.getWidth();
		int bh = bp.getHeight();
		if (bw <= nw && bh <= nh) {
			return bp;
		}
		float sx = nw / (float) bw;
		float sy = nh / (float) bh;
		Matrix matrix = new Matrix();
		if (sx < sy) {
			matrix.postScale(sx, sx);
		}
		else {
			matrix.postScale(sy, sy);
		}
		return Bitmap.createBitmap(bp, 0, 0, bw, bh, matrix, true);
	}

	/**
	 * 等比缩放，至少一个边适应w/h
	 *
	 * @param bp
	 * @param nw
	 * @param nh
	 * @param centerX
	 * @param centerY
	 * @return
	 */
	public static Bitmap bitmapWithAdjust(Bitmap bp, int nw, int nh, float centerX, float centerY) {
		int bw = bp.getWidth();
		int bh = bp.getHeight();
		if (bw <= nw && bh <= nh) {
			return bp;
		}

		float sw = nw / (float) bw;
		float sh = nh / (float) bh;
		Matrix matrix = new Matrix();
		if (sw < sh) {
			matrix.postScale(sw, sw, centerX, centerY);
		}
		else {
			matrix.postScale(sw, sw, centerX, centerY);
		}
		return Bitmap.createBitmap(bp, 0, 0, bw, bh, matrix, true);
	}

	/**
	 * 根据已有的bitmap，获取圆角矩形的bitmap
	 *
	 * @param bitmap
	 * @param radius
	 * @return
	 */
	public static Bitmap bitmapWithRoundRect(Bitmap bitmap, int radius) {
		Rect rect = new Rect(0, 0, bitmap.getWidth(), bitmap.getHeight());
		Bitmap ret = Bitmap.createBitmap(bitmap.getWidth(), bitmap.getHeight(), Config.ARGB_8888);

		Paint paint = new Paint();
		paint.setAntiAlias(true);

		Canvas canvas = new Canvas(ret);
		canvas.drawRoundRect(new RectF(rect), radius, radius, paint);

		paint.setXfermode(new PorterDuffXfermode(Mode.SRC_IN));
		canvas.drawBitmap(bitmap, rect, rect, paint);
		return ret;
	}

	/**
	 * ThumbnailUtils获取缩略图
	 *
	 * @param path
	 * @param width
	 * @param height
	 * @return
	 */
	public static Bitmap bitmapWithThumbnail(String url, int width, int height) {
		Bitmap src = bitmapWithSize(url, width, height);
		Bitmap dst = ThumbnailUtils.extractThumbnail(src, width, height, ThumbnailUtils.OPTIONS_RECYCLE_INPUT);
		src.recycle();
		src = null;
		return dst;
	}

	/**
	 * 获取屏幕快照
	 *
	 * @param page
	 * @return
	 */
	public static Bitmap bitmapWithScreenShot(Activity page) {
		page = page != null ? page : App.topActivity();
		if (page == null) {
			return null;
		}

		Rect frame = new Rect();
		Point size = new Point();
		page.getWindowManager().getDefaultDisplay().getSize(size);
		page.getWindow().getDecorView().getWindowVisibleDisplayFrame(frame);

		View view = page.getWindow().getDecorView();
		view.setDrawingCacheEnabled(true);
		view.buildDrawingCache();
		Bitmap bitmap = Bitmap.createBitmap(view.getDrawingCache(), 0, frame.top, size.x, size.y - frame.top);
		view.destroyDrawingCache();
		return bitmap;
	}

	/**
	 * 创建倒影图片，不连原图
	 *
	 * @param bp:原图
	 * @param ratio:高度是原图高度几分之几
	 * @return
	 */
	public static Bitmap bitmapWithReflection(Bitmap bp, float ratio) {
		int bw = bp.getWidth();
		int bh = bp.getHeight();
		int dy = Math.round(bh * ratio);

		Matrix matrix = new Matrix();
		matrix.preScale(1, -1);
		Bitmap src = Bitmap.createBitmap(bp, 0, bh - dy, bw, dy, matrix, false);
		Bitmap dst = Bitmap.createBitmap(bw, dy, Config.ARGB_8888);
		Canvas canvas = new Canvas(dst);
		canvas.drawBitmap(src, 0, 0, null);

		Paint paint = new Paint();
		LinearGradient shader = new LinearGradient(0, 0, 0, dst.getHeight(), 0xffffffff, 0x00ffffff, TileMode.CLAMP);
		paint.setShader(shader);
		paint.setXfermode(new PorterDuffXfermode(Mode.DST_IN));
		canvas.drawRect(0, 0, dst.getWidth(), dst.getHeight(), paint);

		src.recycle();
		src = null;
		return dst;
	}

	/**
	 * 创建一个倒影图片，连带原图
	 *
	 * @param bp:原图
	 * @param ratio:倒影部分bitmap的高度是原图高度几分之几
	 * @param gap:图片与倒影间隔距离
	 * @return
	 */
	public static Bitmap bitmapWithReflection(Bitmap bp, float ratio, int gap) {
		int bw = bp.getWidth();
		int bh = bp.getHeight();
		int dy = Math.round(bh * ratio);

		Matrix matrix = new Matrix();
		matrix.preScale(1, -1);// 图片缩放，x轴变为原来的1倍，y轴为-1倍,实现图片的反转

		// 创建反转后的图片Bitmap对象，图片高是原图的ratio
		Bitmap src = Bitmap.createBitmap(bp, 0, bh - dy, bw, dy, matrix, false);
		// 创建标准的Bitmap对象，宽和原图一致,图片高是原图的ratio
		Bitmap dst = Bitmap.createBitmap(bw, (bh + dy + gap), Config.ARGB_8888);

		Paint paint1 = new Paint();
		paint1.setColor(Color.WHITE);// 画间隔矩形

		// 实现倒影效果
		/**
		 * @param 参数一:为渐变起初点坐标x位置
		 * @param 参数二:为y轴位置
		 * @param 参数三和四:分辨对应渐变终点
		 * @param 最后参数为平铺方式.
		 * @param TileMode.MIRROR这里设置为镜像Gradient是基于Shader类，所以我们通过Paint的setShader方法来设置这个渐变
		 */
		LinearGradient shader = new LinearGradient(0, bh, 0, dst.getHeight() + gap, 0x70ffffff, 0x00ffffff, TileMode.CLAMP);
		Paint paint2 = new Paint();
		paint2.setShader(shader);
		paint2.setXfermode(new PorterDuffXfermode(Mode.DST_IN));

		Canvas canvas = new Canvas(dst);
		canvas.drawBitmap(bp, 0, 0, null);// 画原始图片
		canvas.drawRect(0, bh, bw, bh + gap, paint1);
		canvas.drawBitmap(src, 0, bh + gap, null);// 画倒影图片
		canvas.drawRect(0, bh, bw, dst.getHeight() + gap, paint2);// 覆盖效果
		src.recycle();
		src = null;
		return dst;
	}

	/**
	 * 只获取url对应的bitmap的像素尺寸
	 *
	 * @param url
	 * @return
	 */
	public static Options sizeWithBitmap(String url) {
		InputStream inStream = null;
		try {
			Options options = new Options();
			options.inJustDecodeBounds = true;
			inStream = IO.inStreamWithURL(url);
			BitmapFactory.decodeStream(inStream, null, options);
			return options;
		}
		catch (Exception e) {
			Log.e(kTag, "sizeWithBitmap:" + url, e);
			return null;
		}
		finally {
			IO.close(inStream);
		}
	}

	/**
	 * 根据options和指定的size，更新options
	 *
	 * @param options
	 * @param nw
	 * @param nh
	 */
	public static Options optionsWithSize(Options options, int nw, int nh) {
		int scale = 1;
		int bw = options.outWidth;
		int bh = options.outHeight;
		if (bw > nw && bh > nh) {
			while (true) {
				if (bw / 2 <= nw || bh / 2 <= nh) {
					break;
				}
				bw /= 2;
				bh /= 2;
				scale *= 2;
			}
		}

		try {
			options.inDither = false;
			options.inPurgeable = true;
			options.inInputShareable = true;
			options.inJustDecodeBounds = false;

			options.inSampleSize = scale;
			options.inPreferredConfig = Config.RGB_565;
			BitmapFactory.Options.class.getField("inNativeAlloc").setBoolean(options, true);
		}
		catch (Exception e) {
			Log.e(kTag, "setScaleOptions error:" + e.getMessage());
		}
		return options;
	}

	/**
	 * 将bitmap保存到磁盘路径
	 *
	 * @param bitmap
	 * @param path
	 * @return
	 */
	public static boolean saveBitmap(Bitmap bitmap, String path) {
		FileOutputStream otStream = null;
		try {
			File file = new File(path);
			if (!file.exists()) {
				file.createNewFile();
			}
			otStream = new FileOutputStream(file);
			return bitmap.compress(Bitmap.CompressFormat.PNG, 80, otStream);
		}
		catch (Exception e) {
			Log.e(kTag, "failure when saveBitmapToPath:" + path, e);
			return false;
		}
		finally {
			IO.close(otStream);
		}
	}
}
