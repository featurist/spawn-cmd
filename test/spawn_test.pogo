spawn = require '../spawn.js'.spawn

describe 'spawn'

    it 'spawns a process' @(done)
        self.stdout = ''
        self.stderr = ''

        spawned = spawn('echo', ['zomg'])

        spawned.stdout.on "data" @(data)
            self.stdout = self.stdout + data.toString()

        spawned.stderr.on "data" @(data)
            self.stderr = self.stderr + data.toString()

        spawned.on 'exit' @(code)
            self.stderr.should.equal ""
            self.stdout.should.equal "zomg\n"
            code.should.equal 0
            done()
