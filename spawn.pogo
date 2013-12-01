spawn = require 'child_process'.spawn

windows spawn (executable, args, options) =
    spawn (process.env.comspec, ['/c', executable].concat(args), options)

if (process.env.comspec)
    exports.spawn = windows spawn
else
    exports.spawn = spawn
