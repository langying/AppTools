package app.engine.common;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Point;
import android.graphics.Typeface;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.AbsoluteLayout;
import android.widget.Button;
import android.widget.TextView;

@SuppressWarnings("deprecation")
public class UI {

    private static final String TAG = UI.class.getSimpleName();

    public static enum Layout {
        LT,			// 左上角
        LB,			// 左下角
        RT,			// 右上角
        RB,			// 右下角
        THC,		// 向上水平居中
        BHC,		// 向下水平居中
        LVC,		// 向左垂直居中
        RVC,		// 向右垂直居中
        Center,		// 居中对齐
        OutsideBHC,	// 外部向下水平居中
        OutsideTHC,	// 外部向上水平居中
        OutsideLVC,	// 外部向左垂直居中
        OutsideRVC,	// 外部向右垂直居中
    }

    public static int toPixelSize(float dpSize) {
        return (int) (dpSize * Glob.density + 0.5);
    }

    public static Point toPixelSize(Point pt) {
        pt.set(toPixelSize(pt.x), toPixelSize(pt.y));
        return pt;
    }

    public static void setSize(View view, float width, float height) {
        ViewGroup.LayoutParams params = view.getLayoutParams();
        params.width = toPixelSize(width);
        params.height = toPixelSize(height);
        view.setLayoutParams(params);
    }

    public static void text(int resid, String text) {
        View view = Glob.top.findViewById(resid);
        if (view == null) {
            return;
        }
        if (view instanceof Button) {
            ((Button) view).setText(text);
        }
        else if (view instanceof TextView) {
            ((TextView) view).setText(text);
        }
    }

    @SuppressWarnings("unchecked")
    public static <T> T view(int resid) {
        return (T) Glob.top.findViewById(resid);
    }

    @SuppressLint("SetJavaScriptEnabled")
    public static WebView style(WebView webview) {
        webview.setVerticalScrollBarEnabled(false);
        webview.setHorizontalScrollBarEnabled(false);

        WebSettings settings = webview.getSettings();
        settings.setSupportZoom(false);
        settings.setSaveFormData(false);
        settings.setAllowFileAccess(true);
        settings.setAppCacheEnabled(true);
        settings.setDomStorageEnabled(true);
        settings.setJavaScriptEnabled(true);
        settings.setBuiltInZoomControls(false);
        settings.setDisplayZoomControls(false);
        settings.setSupportMultipleWindows(false);
        settings.setMediaPlaybackRequiresUserGesture(false);
        settings.setAppCacheMaxSize(1024 * 1024 * 8);
        settings.setCacheMode(WebSettings.LOAD_DEFAULT);
        settings.setAppCachePath(webview.getContext().getDir("cache", Context.MODE_PRIVATE).getPath());
        return webview;
    }

    public static void visible(int resid, int visibility) {
        View view = Glob.top.findViewById(resid);
        if (view == null) {
            return;
        }
        view.setVisibility(visibility);
    }

    public static void goBack(int resid) {
        View view = Glob.top.findViewById(resid);
        if (view == null) {
            return;
        }
        ((WebView) view).goBack();
    }

    public static void reload(int resid) {
        View view = Glob.top.findViewById(resid);
        if (view == null) {
            return;
        }
        ((WebView) view).reload();
    }

    public static void loadURL(int resid, String url) {
        View view = Glob.top.findViewById(resid);
        if (view == null) {
            return;
        }
        ((WebView) view).loadUrl(url, Glob.http);
    }

    public static void click(int resid, View.OnClickListener handler) {
        View view = Glob.top.findViewById(resid);
        if (view != null) {
            view.setClickable(true);
            view.setOnClickListener(handler);
        }
    }

    /** Android 字体必须保存在assets/fonts目录 */
    public static void setFontForAllTextView(View view, String fontName) {
        try {
            Typeface font = Typeface.createFromAsset(view.getContext().getAssets(), fontName);
            if (view instanceof ViewGroup) {
                ViewGroup group = (ViewGroup) view;
                for (int idx = 0, len = group.getChildCount(); idx < len; idx++) {
                    setFontForAllTextView(group.getChildAt(idx), fontName);
                }
            }
            else if (view instanceof TextView) {
                ((TextView) view).setTypeface(font);
            }
        }
        catch (Exception e) {
            Log.e(TAG, "error when setFont:" + fontName, e);
        }
    }

    public static void addSubview(AbsoluteLayout group, View child, Layout layout, Point offset) {
        toPixelSize(offset);
        Point node = new Point(group.getWidth(), group.getHeight());
        Point size = new Point(child.getWidth(), child.getHeight());
        switch (layout) {
        case LT: {
            child.setX(offset.x);
            child.setY(offset.y);
            break;
        }
        case LB: {
            child.setX(offset.x);
            child.setY(node.y - size.y - offset.y);
            break;
        }
        case RT: {
            child.setX(node.x - size.x - offset.x);
            child.setY(offset.y);
            break;
        }
        case RB: {
            child.setX(node.x - size.x - offset.x);
            child.setY(node.y - size.y - offset.y);
            break;
        }
        case THC: {
            child.setX((node.x - size.x) / 2 + offset.x);
            child.setY(offset.y);
            break;
        }
        case BHC: {
            child.setX((node.x - size.x) / 2 + offset.x);
            child.setY(node.y - size.y - offset.y);
            break;
        }
        case LVC: {
            child.setX(offset.x);
            child.setY((node.y - size.y) / 2 + offset.y);
            break;
        }
        case RVC: {
            child.setX(node.x - size.x - offset.x);
            child.setY((node.y - size.y) / 2 + offset.y);
            break;
        }
        case Center: {
            child.setX((node.x - size.x) / 2 + offset.x);
            child.setY((node.y - size.y) / 2 + offset.y);
            break;
        }
        case OutsideBHC: {
            child.setX((node.x - size.x) / 2 + offset.x);
            child.setY(node.y + offset.y);
            break;
        }
        case OutsideTHC: {
            child.setX((node.x - size.x) / 2 + offset.x);
            child.setY(0 - size.y - offset.y);
            break;
        }
        case OutsideLVC: {
            child.setX(0 - size.x - offset.x);
            child.setY((node.y - size.y) / 2 + offset.y);
            break;
        }
        case OutsideRVC: {
            child.setX(node.x + offset.x);
            child.setY((node.y - size.y) / 2 + offset.y);
            break;
        }
        }
    }
}
