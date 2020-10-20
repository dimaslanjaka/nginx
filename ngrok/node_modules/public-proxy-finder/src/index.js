var request = require('./request'),
    parse = require('./parse-page'),
    Promise = require('bluebird'),
    mergeForAll = function (ssl, us, uk, socks, anon) {
        return ssl.concat(us, uk, socks, anon);
    };

module.exports = {
    /**
     * Fetch the proxy list from {@link http://www.sslproxies.org/}
     * @return {Promise.<Object[]>}
     */
    ssl: function () {
        return request.get('http://www.sslproxies.org/').then(parse);
    },
    /**
     * Fetch the proxy list from {@link http://www.us-proxy.org/}
     * @return {Promise.<Object[]>}
     */
    US: function () {
        return request.get('http://www.us-proxy.org/').then(parse)
    },
    /**
     * Fetch the proxy list from {@link http://free-proxy-list.net/uk-proxy.html}
     * @return {Promise.<Object[]>}
     */
    UK: function () {
        return request.get('http://free-proxy-list.net/uk-proxy.html').then(parse);
    },
    /**
     * Fetch the proxy list from {@link http://www.socks-proxy.net/}
     * @return {Promise.<Object[]>}
     */
    socks: function () {
        return request.get('http://www.socks-proxy.net/').then(parse);
    },
    /**
     * Fetch the proxy list from {@link http://free-proxy-list.net/anonymous-proxy.html}
     * @return {Promise.<Object[]>}
     */
    anonymous: function () {
        return request.get('http://free-proxy-list.net/anonymous-proxy.html').then(parse);
    }
};

/**
 * Combines all the available requests into one resultset
 * @return {Promise.<Object[]>}
 */
module.exports.all = function () {
    return Promise.all([
        module.exports.ssl(),
        module.exports.US(),
        module.exports.UK(),
        module.exports.socks(),
        module.exports.anonymous()
    ]).spread(mergeForAll);
};