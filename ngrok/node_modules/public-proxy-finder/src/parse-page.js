var cheerio = require('cheerio'),
    YES = 'yes',
    NO = 'no',
    regex = {
        second: /([0-9]+)\ssecond/,
        minute: /([0-9]+)\sminute/,
        hour: /([0-9]+)\shour/,
        day: /([0-9]+)\sday/
    };

module.exports = function (html) {
    var $ = cheerio.load(html),
        $table = $("#proxylisttable"),
        $columns = $('thead th', $table),
        columns = [],
        out = [];

    if (!$columns.length) {
        console.warn('Could not parse the page');
        return [];
    } else {
        $columns.each(function () {
            columns.push($(this).text().trim());
        });

        $('tbody tr', $table).each(function () {
            var row = {};

            $('td', $(this)).each(function (i) {
                var txt = $(this).text().trim(),
                    match;

                if (txt === YES) {
                    txt = true;
                } else if (txt === NO) {
                    txt = false;
                } else if (match = txt.match(regex.second)) {
                    txt = parseInt(match[1]) * 1000;
                } else if (match = txt.match(regex.minute)) {
                    txt = parseInt(match[1]) * 60000;
                } else if (match = txt.match(regex.hour)) {
                    txt = parseInt(match[1]) * 3600000;
                } else if (match = txt.match(regex.day)) {
                    txt = parseInt(match[1]) * 86400000;
                } else if (!isNaN(txt)) {
                    txt = parseInt(txt);
                }

                row[columns[i]] = txt;
            });

            out.push(row);
        });

        return out;
    }
};