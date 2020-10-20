A simple library to probe the following sites for proxies (visit them to receive an explanation of field names and values):

 - http://www.sslproxies.org/
 - http://www.us-proxy.org/
 - http://free-proxy-list.net/uk-proxy.html
 - http://www.socks-proxy.net/
 - http://free-proxy-list.net/anonymous-proxy.html
 
 
[![NPM](https://nodei.co/npm/public-proxy-finder.png?downloads=true&downloadRank=true&stars=true)](https://www.npmjs.com/package/public-proxy-finder/)
 
See [Runkit page](https://runkit.com/npm/public-proxy-finder) for examples.
All functions return Promises containing an array of proxy specs.

# API

```js
var ProxyFinder = require('public-proxy-finder');

// Refer to list above for proxy sources
ProxyFinder.ssl();
ProxyFinder.US();
ProxyFinder.UK();
ProxyFinder.socks();
ProxyFinder.anonymous();

// Convenience method to combine the above into one resultset
ProxyFinder.all();
```

