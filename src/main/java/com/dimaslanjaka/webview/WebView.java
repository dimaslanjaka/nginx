package com.dimaslanjaka.webview;

import android.content.Context;
import android.os.Build;
import android.util.AttributeSet;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;

public class WebView extends android.webkit.WebView {
	android.webkit.CookieManager cookieManager = new CookieManager();

	public WebView(@NonNull Context context) {
		super(context);
		initWebView();
	}

	public WebView(@NonNull Context context, @Nullable AttributeSet attrs) {
		super(context, attrs);
		initWebView();
	}

	public WebView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
		super(context, attrs, defStyleAttr);
		initWebView();
	}

	@RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
	public WebView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr, int defStyleRes) {
		super(context, attrs, defStyleAttr, defStyleRes);
		initWebView();
	}

	public WebView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr, boolean privateBrowsing) {
		super(context, attrs, defStyleAttr, privateBrowsing);
		initWebView();
	}

	public void initWebView() {
		cookieManager.setAcceptCookie(true);
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
			cookieManager.acceptThirdPartyCookies(this);
			cookieManager.setAcceptThirdPartyCookies(this, true);
		}
		setWebViewClient(new WebViewClient());
	}
}
