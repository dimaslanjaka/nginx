package com.dimaslanjaka.components.webview

import okhttp3.Cookie
import java.net.HttpCookie
import java.net.URI

class CookieParser(cookies: String, url: String) {
    private val secureCookies = mutableListOf<Cookie>()
    private val nonSecureCookies = mutableListOf<Cookie>()
    private val allCookies = mutableListOf<Cookie>()

    init {
        val split = cookies.split(";")
        val uri = URI(url)
        val cookieManager = java.net.CookieManager()
        split.forEach { splitted ->
            HttpCookie.parse(splitted).forEach {
                cookieManager.cookieStore.add(uri, it)
                val a = Cookie.Builder()
                        .domain(uri.host).name(it.name)
                        .value(it.value).secure().build()
                val b = Cookie.Builder()
                        .domain(uri.host).name(it.name)
                        .value(it.value).httpOnly().build()
                secureCookies.add(a)
                nonSecureCookies.add(b)
                allCookies.add(a)
                allCookies.add(b)
            }
        }
    }

    fun getSecuredCookies(): MutableList<Cookie> {
        return secureCookies
    }

    fun getNonSecuredCookies(): MutableList<Cookie> {
        return nonSecureCookies
    }

    fun getAllCookies(): MutableList<Cookie> {
        return allCookies
    }
}