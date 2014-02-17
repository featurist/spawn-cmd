spawn = require '../spawn.js'.spawn
os = require 'os'

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

    if (process.platform == 'win32')
        it 'spawns a batch file' @(done)
            spawn and wait for ('test\test-batch', ['2', '3', '9'], r/2\r\n5\r\n8\r\n/, done)

        it 'passes arguments with spaces to batch file' @(done)
            spawn and wait for ('test\test-args', ['a b', 'cd', 'e f'], r/ok/, done)
