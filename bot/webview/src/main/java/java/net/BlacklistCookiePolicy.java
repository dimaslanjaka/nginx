package java.net;

/**
 * The following is an example of a cookie policy that rejects cookies from domains that are on a blacklist,
 * before applying the CookiePolicy.ACCEPT_ORIGINAL_SERVER policy:
 * ```java
 * String[] list = new String[]{ ".example.com" };
 * CookieManager cm = new CookieManager(null, new BlacklistCookiePolicy(list));
 * CookieHandler.setDefault(cm);
 * //The sample code will not accept cookies from hosts such as the following:
 * ///host.example.com
 * ///domain.example.com
 * //However, this sample code will accept cookies from hosts such as the following:
 * ///example.com
 * ///example.org
 * ///myhost.example.org
 * ```
 */
public class BlacklistCookiePolicy implements CookiePolicy {
    String[] blacklist = new String[]{"medium.com"};

    public BlacklistCookiePolicy(String[] list) {
        blacklist = list;
    }

    public boolean shouldAccept(URI uri, HttpCookie cookie) {
        String host;
        try {
            host = InetAddress.getByName(uri.getHost()).getCanonicalHostName();
        } catch (UnknownHostException e) {
            host = uri.getHost();
        }

        for (int i = 0; i < blacklist.length; i++) {
            if (HttpCookie.domainMatches(blacklist[i], host)) {
                return false;
            }
        }

        return CookiePolicy.ACCEPT_ORIGINAL_SERVER.shouldAccept(uri, cookie);
    }
}
