package java.net;

import java.io.IOException;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

/**
 * In global scope, before running any threads, call
 * ```java
 * CookieHandler.setDefault(SessionCookieManager.getInstance());
 * ```
 * When your thread is finished, call inside of it
 * ```java
 * SessionCookieManager.getInstance().clear();
 * ```
 * @see "https://stackoverflow.com/questions/16305486/cookiemanager-for-multiple-threads"
 */
public class SessionCookieManager extends CookieHandler {
    private CookiePolicy policyCallback;


    public SessionCookieManager() {
        this(null, null);
    }

    private final static SessionCookieManager ms_instance = new SessionCookieManager();

    public static SessionCookieManager getInstance() {
        return ms_instance;
    }

    private final static ThreadLocal<CookieStore> ms_cookieJars = new ThreadLocal<CookieStore>() {
        @Override
        protected synchronized CookieStore initialValue() {
            return (new CookieManager()).getCookieStore(); /*InMemoryCookieStore*/
        }
    };

    public void clear() {
        getCookieStore().removeAll();
    }

    public SessionCookieManager(CookieStore store,
                                CookiePolicy cookiePolicy) {
        // use default cookie policy if not specify one
        policyCallback = (cookiePolicy == null) ? CookiePolicy.ACCEPT_ALL //note that I changed it to ACCEPT_ALL
                : cookiePolicy;

        // if not specify CookieStore to use, use default one

    }

    public void setCookiePolicy(CookiePolicy cookiePolicy) {
        if (cookiePolicy != null) policyCallback = cookiePolicy;
    }

    public CookieStore getCookieStore() {
        return ms_cookieJars.get();
    }

    public Map<String, List<String>>
    get(URI uri, Map<String, List<String>> requestHeaders)
            throws IOException {
        // pre-condition check
        if (uri == null || requestHeaders == null) {
            throw new IllegalArgumentException("Argument is null");
        }

        Map<String, List<String>> cookieMap =
                new java.util.HashMap<String, List<String>>();
        // if there's no default CookieStore, no way for us to get any cookie
        if (getCookieStore() == null)
            return Collections.unmodifiableMap(cookieMap);

        List<HttpCookie> cookies = new java.util.ArrayList<HttpCookie>();
        for (HttpCookie cookie : getCookieStore().get(uri)) {
            // apply path-matches rule (RFC 2965 sec. 3.3.4)
            if (pathMatches(uri.getPath(), cookie.getPath())) {
                cookies.add(cookie);
            }
        }

        // apply sort rule (RFC 2965 sec. 3.3.4)
        List<String> cookieHeader = sortByPath(cookies);

        cookieMap.put("Cookie", cookieHeader);
        return Collections.unmodifiableMap(cookieMap);
    }


    public void
    put(URI uri, Map<String, List<String>> responseHeaders)
            throws IOException {
        // pre-condition check
        if (uri == null || responseHeaders == null) {
            throw new IllegalArgumentException("Argument is null");
        }


        // if there's no default CookieStore, no need to remember any cookie
        if (getCookieStore() == null)
            return;

        for (String headerKey : responseHeaders.keySet()) {
            // RFC 2965 3.2.2, key must be 'Set-Cookie2'
            // we also accept 'Set-Cookie' here for backward compatibility
            if (headerKey == null
                    || !(headerKey.equalsIgnoreCase("Set-Cookie2")
                    || headerKey.equalsIgnoreCase("Set-Cookie")
            )
            ) {
                continue;
            }

            for (String headerValue : responseHeaders.get(headerKey)) {
                try {
                    List<HttpCookie> cookies = HttpCookie.parse(headerValue);
                    for (HttpCookie cookie : cookies) {
                        if (shouldAcceptInternal(uri, cookie)) {
                            getCookieStore().add(uri, cookie);
                        }
                    }
                } catch (IllegalArgumentException e) {
                    // invalid set-cookie header string
                    // no-op
                }
            }
        }
    }


    /* ---------------- Private operations -------------- */

    // to determine whether or not accept this cookie
    private boolean shouldAcceptInternal(URI uri, HttpCookie cookie) {
        try {
            return policyCallback.shouldAccept(uri, cookie);
        } catch (Exception ignored) { // pretect against malicious callback
            return false;
        }
    }


    /*
     * path-matches algorithm, as defined by RFC 2965
     */
    private boolean pathMatches(String path, String pathToMatchWith) {
        if (path == pathToMatchWith)
            return true;
        if (path == null || pathToMatchWith == null)
            return false;
        if (path.startsWith(pathToMatchWith))
            return true;

        return false;
    }


    /*
     * sort cookies with respect to their path: those with more specific Path attributes
     * precede those with less specific, as defined in RFC 2965 sec. 3.3.4
     */
    private List<String> sortByPath(List<HttpCookie> cookies) {
        Collections.sort(cookies, new CookiePathComparator());

        List<String> cookieHeader = new java.util.ArrayList<String>();
        for (HttpCookie cookie : cookies) {
            // Netscape cookie spec and RFC 2965 have different format of Cookie
            // header; RFC 2965 requires a leading $Version="1" string while Netscape
            // does not.
            // The workaround here is to add a $Version="1" string in advance
            if (cookies.indexOf(cookie) == 0 && cookie.getVersion() > 0) {
                cookieHeader.add("$Version=\"1\"");
            }

            cookieHeader.add(cookie.toString());
        }
        return cookieHeader;
    }


    static class CookiePathComparator implements Comparator<HttpCookie> {
        public int compare(HttpCookie c1, HttpCookie c2) {
            if (c1 == c2) return 0;
            if (c1 == null) return -1;
            if (c2 == null) return 1;

            // path rule only applies to the cookies with same name
            if (!c1.getName().equals(c2.getName())) return 0;

            // those with more specific Path attributes precede those with less specific
            if (c1.getPath().startsWith(c2.getPath()))
                return -1;
            else if (c2.getPath().startsWith(c1.getPath()))
                return 1;
            else
                return 0;
        }
    }
}