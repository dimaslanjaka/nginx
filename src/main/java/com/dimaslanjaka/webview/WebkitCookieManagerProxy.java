package com.dimaslanjaka.webview;

import android.os.Build;
import com.dimaslanjaka.gradle.javafx.webview.cookie.JavaFxCookieManager;
import com.dimaslanjaka.gradle.javafx.webview.cookie.JavaFxCookiePolicy;
import com.dimaslanjaka.gradle.javafx.webview.cookie.JavaFxCookieStore;

import java.io.IOException;
import java.net.CookieStore;
import java.net.URI;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * CookieManager Proxy
 * ```java
 * android.webkit.CookieSyncManager.createInstance(appContext);
 * // unrelated, just make sure cookies are generally allowed
 * android.webkit.CookieManager.getInstance().setAcceptCookie(true);
 * <p>
 * // magic starts here
 * WebkitCookieManagerProxy coreCookieManager = new WebkitCookieManagerProxy(null, java.net.CookiePolicy.ACCEPT_ALL);
 * java.net.CookieHandler.setDefault(coreCookieManager);
 * ```
 *
 * @see "https://stackoverflow.com/questions/12731211/pass-cookies-from-httpurlconnection-java-net-cookiemanager-to-webview-android"
 */
public class WebkitCookieManagerProxy extends JavaFxCookieManager {
	public static android.webkit.CookieManager webkitCookieManager;
	public static JavaFxCookieStore cookieStore;
	public static JavaFxCookiePolicy cookiePolicy;

	public WebkitCookieManagerProxy() {
		this(null, null);
	}

	public WebkitCookieManagerProxy(JavaFxCookieStore store, JavaFxCookiePolicy policy) {
		super(null, cookiePolicy);
		cookieStore = store;
		cookiePolicy = policy;
		webkitCookieManager = android.webkit.CookieManager.getInstance();
	}

	public void setWebkitCookieManager(android.webkit.CookieManager manager) {
		webkitCookieManager = manager;
	}

	@Override
	@SuppressWarnings("ConstantConditions") // todo: suppress warnings android studio
	public void put(URI uri, Map<String, List<String>> responseHeaders) throws IOException {
		// make sure our args are valid
		if ((uri == null) || (responseHeaders == null)) return;

		// save our url once
		String url = uri.toString();

		// go over the headers
		for (String headerKey : responseHeaders.keySet()) {
			// ignore headers which aren't cookie related
			if ((headerKey == null) || !(headerKey.equalsIgnoreCase("Set-Cookie2") || headerKey.equalsIgnoreCase("Set-Cookie")))
				continue;

			// process each of the headers
			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
				for (String headerValue : Objects.requireNonNull(responseHeaders.get(headerKey))) {
					webkitCookieManager.setCookie(url, headerValue);
				}
			} else {
				if (responseHeaders.get(headerKey) != null) {
					for (int i = 0; i < responseHeaders.get(headerKey).size(); i++) {
						webkitCookieManager.setCookie(url, responseHeaders.get(headerKey).get(i));
					}
				}
			}
		}
	}

	@Override
	public Map<String, List<String>> get(URI uri, Map<String, List<String>> requestHeaders) throws IOException {
		// make sure our args are valid
		if ((uri == null) || (requestHeaders == null)) throw new IllegalArgumentException("Argument is null");

		// save our url once
		String url = uri.toString();

		// prepare our response
		Map<String, List<String>> res = new java.util.HashMap<String, List<String>>();

		// get the cookie
		String cookie = webkitCookieManager.getCookie(url);

		// return it
		if (cookie != null) res.put("Cookie", Collections.singletonList(cookie));
		return res;
	}

	@Override
	public CookieStore getCookieStore() {
		// we don't want anyone to work with this cookie store directly
		throw new UnsupportedOperationException();
	}
}