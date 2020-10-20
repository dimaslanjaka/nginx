var ProxyFinder = require('public-proxy-finder');

ProxyFinder.ssl() //Retrieve an up-to-date list of SSL proxies
    .filter(function (proxy) { // Filter out any proxies that haven't been checked for over 30 minutes
        return proxy['Last Checked'] < 60 * 30 * 1000;
    })
    .then(function (proxies) {
        //Print the first one
        console.dir(proxies[0]);
    });