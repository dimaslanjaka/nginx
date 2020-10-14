package java.net;

import java.util.List;

/**
 * ```java
 * CookieHandler.setDefault(new CookieManager(new ThreadLocalCookieStore(), null));
 * ```
 * @see "https://stackoverflow.com/questions/16305486/cookiemanager-for-multiple-threads"
 */
public class ThreadLocalCookieStore implements CookieStore {

    private final static ThreadLocal<CookieStore> ms_cookieJars = new ThreadLocal<CookieStore>() {
        @Override
        protected synchronized CookieStore initialValue() {
            return (new CookieManager()).getCookieStore(); /*InMemoryCookieStore*/
        }
    };

    @Override
    public void add(URI uri, HttpCookie cookie) {
        ms_cookieJars.get().add(uri, cookie);
    }

    @Override
    public List<HttpCookie> get(URI uri) {
        return ms_cookieJars.get().get(uri);
    }

    @Override
    public List<HttpCookie> getCookies() {
        return ms_cookieJars.get().getCookies();
    }

    @Override
    public List<URI> getURIs() {
        return ms_cookieJars.get().getURIs();
    }

    @Override
    public boolean remove(URI uri, HttpCookie cookie) {
        return ms_cookieJars.get().remove(uri, cookie);
    }

    @Override
    public boolean removeAll() {
        return ms_cookieJars.get().removeAll();
    }
}
