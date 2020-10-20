var request = require('request-promise').defaults({
    headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36',
        'Accept-Language': 'en-GB,en;q=1.0'
    },
    gzip: true,
    followAllRedirects: true,
    followRedirect: true
});

module.exports = request;