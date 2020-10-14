package com.dimaslanjaka.components.okhttp;

import okhttp3.OkHttpClient;

public class Client {
    public static WebkitCookieManagerProxy proxy = new WebkitCookieManagerProxy();
    public static OkHttpClient client = new OkHttpClient.Builder().cookieJar(proxy).build();
}
