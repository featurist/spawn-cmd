spawn = require '../spawn.js'.spawn
os = require 'os'
path = require 'path'

describe 'spawn'
    spawn and wait for (command, args, match, done) =
        stdout = ''
        stderr = ''

        spawned = spawn(command, args)

        spawned.stdout.on "data" @(data)
            stdout := stdout + data.toString()

        spawned.stderr.on "data" @(data)
            stderr := stderr + data.toString()

        spawned.on 'exit' @(code)
            set timeout
              stderr.should.equal ""
              stdout.should.match(match)
              code.should.equal 0
              done()
            1

    it 'spawns a process' @(done)
        spawn and wait for ('echo', ['zomg'], r/zomg/, done)

    it 'escapes quotes and slashes properly' @(done)
        spawn and wait for (path.normalize('test/argv'), ['a', 'b"c', 'd\g', 'h"" i'], @new RegExp(['argc=5', '1 a', '2 b"c', '3 d\\g', '4 h"" i'].join(os.EOL)), done)

    it 'escapes empty arguments properly' @(done)
        spawn and wait for (path.normalize('test/argv'), ['a', '', 'c'], @new RegExp(['argc=4', '1 a', '2 ', '3 c'].join(os.EOL)), done)

    if (process.platform == 'win32')
        it 'spawns a batch file' @(done)
            spawn and wait for ('test\test-batch', ['2', '3', '9'], r/2\r\n5\r\n8\r\n/, done)

        it 'passes arguments with spaces to batch file' @(done)
            spawn and wait for ('test\test-args', ['a b', 'cd', 'e f'], r/ok/, done)

        it 'spawns a batch file with spaces and some simple arguments' @(done)
            spawn and wait for ('test\test spaces', ['a'], r/ok/, done)

        it 'spawns a batch file with spaces with no arguments' @(done)
            spawn and wait for ('test\test spaces', [], r/ok/, done)

        it 'passes arguments with spaces to a batch file with spaces' @(done)
            spawn and wait for ('test\test spaces args.cmd', ['a', 'b c', 'd e', 'fg', 'h i'], r/ok/, done)
