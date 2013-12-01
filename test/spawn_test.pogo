spawn = require '../spawn.js'.spawn

describe 'spawn'

    it 'spawns a process' @(done)
        self.stdout = ''

        spawned = spawn('echo', ['zomg'])

        spawned.stdout.on "data" @(data)
            self.stdout = self.stdout + data.toString()

        spawned.on 'exit' @(code)
            code.should.equal 0
            self.stdout.should.equal "zomg\n"
            done()
