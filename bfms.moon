-- terrible brainf*** in moonscript
ptr = nil
mem = nil
stack  = nil
dstack = nil

ops =
    '>': () -> ptr += 1
    '<': () -> ptr -= 1
    '+': () -> mem[ptr] += 1
    '-': () -> mem[ptr] -= 1
    '.': () ->
        io.write(string.char(mem[ptr]))
        return nil --avoid implicit return
    ',': (v) ->
        mem[ptr] = string.byte(io.read(1))
    '[': (pc) ->
        if mem[ptr] == 0
            return dstack + 1
        else
            stack[#stack + 1] = pc
    ']': (pc) ->
        dstack = pc
        result = stack[#stack]
        stack[#stack] = nil
        return result

setmetatable(ops, __index:(t,k) -> return () -> ) -- undefined operator is ignored

brainfart = (program, timeLimit=5, debug) ->
    n   = 1 -- program counter
    ptr = 1 -- data counter
    stack  = {} -- stack of loops
    mem    = {} -- clear memory
    dstack = -1 -- end point of current loop
    setmetatable(mem, __index:(t,k) -> return 0) -- undefined memory address is 0

    worker = coroutine.create () ->
        while n <= #program
            n = ops[program\sub(n,n)](n) or n + 1
            coroutine.yield(true)
            if debug
                print(n, ptr, program\sub(n,n), mem[ptr])
        coroutine.yield(false)

    start = os.clock()
    worktoDo = true
    while os.clock() - start < timeLimit and worktoDo
        worktoDo = coroutine.resume(worker)
    print "Program halted: took to long" if worktoDo

return brainfart
