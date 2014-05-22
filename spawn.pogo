spawn = require 'child_process'.spawn

// See quote_cmd_arg() from https://github.com/joyent/node/blob/master/deps/uv/src/win/process.c#L427
// This function is a direct copy
escape argument (arg) =
    if (arg == "")
        '""'
    else if (!r/[ \t"]/.test(arg))
        arg
    else if (!r/[\\"]/.test(arg))
        '"' + arg + '"'
    else
        res = '"'
        for (i = arg.length - 1, i >= 0, i := i - 1)
            res := arg.charAt(i) + res
            if (quote_hit && arg.charAt(i) == '\')
                res := '\' + res
            else if (arg.charAt(i) == '"')
                quote_hit = true
                res := '\' + res
            else
                quote_hit := 0

        res := '"' + res

windows spawn (executable, args, options) =
    // We have to manually escape because of featurist/spawn-cmd#3

    args := args.map(escape argument)
    args := ['"' + executable + '"'].concat(args)
    args := args.join(" ")
    options := options || {}
    options.windowsVerbatimArguments := true

    // See https://github.com/joyent/node/issues/2318#issuecomment-32706753 for details on the '/s' key
    spawn (process.env.comspec || 'cmd.exe', ['/s', '/c', '"' + args + '"'], options)

if (process.platform == 'win32')
    exports.spawn = windows spawn
else
    exports.spawn = spawn
