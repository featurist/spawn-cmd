(function() {
    var self = this;
    var spawn, windowsSpawn;
    spawn = require("child_process").spawn;
    windowsSpawn = function(executable, args, options) {
        return spawn(process.env.comspec, [ "/c", executable ].concat(args), options);
    };
    if (process.env.comspec) {
        exports.spawn = windowsSpawn;
    } else {
        exports.spawn = spawn;
    }
}).call(this);