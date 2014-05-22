(function() {
    var self = this;
    var spawn, escapeArgument, windowsSpawn;
    spawn = require("child_process").spawn;
    escapeArgument = function(arg) {
        var res, i, quote_hit;
        if (arg === "") {
            return '""';
        } else if (!/[ \t"]/.test(arg)) {
            return arg;
        } else if (!/[\\"]/.test(arg)) {
            return '"' + arg + '"';
        } else {
            res = '"';
            for (i = arg.length - 1; i >= 0; i = i - 1) {
                res = arg.charAt(i) + res;
                if (quote_hit && arg.charAt(i) === "\\") {
                    res = "\\" + res;
                } else if (arg.charAt(i) === '"') {
                    quote_hit = true;
                    res = "\\" + res;
                } else {
                    quote_hit = 0;
                }
            }
            return res = '"' + res;
        }
    };
    windowsSpawn = function(executable, args, options) {
        args = args.map(escapeArgument);
        args = [ '"' + executable + '"' ].concat(args);
        args = args.join(" ");
        options = options || {};
        options.windowsVerbatimArguments = true;
        return spawn(process.env.comspec || "cmd.exe", [ "/s", "/c", '"' + args + '"' ], options);
    };
    if (process.platform === "win32") {
        exports.spawn = windowsSpawn;
    } else {
        exports.spawn = spawn;
    }
}).call(this);