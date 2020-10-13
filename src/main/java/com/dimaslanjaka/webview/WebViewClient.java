package com.dimaslanjaka.webview;

import android.webkit.WebView;

public class WebViewClient extends android.webkit.WebViewClient {
	android.webkit.CookieManager cookieManager = new CookieManager();

	public WebViewClient() {
		super();
	}

	public WebViewClient(android.webkit.CookieManager cookieManager1) {
		super();
		cookieManager = cookieManager1;
	}

	@Override
	public void onPageFinished(WebView view, String url) {
		super.onPageFinished(view, url);
	}
}
