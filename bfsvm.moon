-- partial brainf*** compiler for simple virtual machine

-- opcodes
IADD = 1
ISUB = 2
IMUL = 3
ILT  = 4
IEQ  = 5
BR   = 6 --jmp
BRT  = 7
BRF  = 8
ICONST = 9
LOAD   = 10
GLOAD  = 11
STORE  = 12
GSTORE = 13
PRINT  = 14
POP  = 15
HALT = 16
CALL = 17
RET  = 18
INPUT= 19

stack = {}
output = {}
gp = 0 -- global pool
emit = (...) ->
    for i in *{...}
        output[#output + 1] = i

ops =
    -- doesn't yet work within loops.
    -- would need indirect memory access or code modification?
    '>': () ->
        gp = gp + 1
    '<': () ->
        gp = gp - 1
    '+': () ->
        emit GLOAD, gp
        emit ICONST, 1
        emit IADD
        emit GSTORE, gp
    '-': () ->
        emit GLOAD, gp
        emit ICONST, -1
        emit IADD
        emit GSTORE, gp
    '.': () ->
        emit GLOAD, gp
        emit PRINT
    ',': (v) ->
        emit 19 -- default svm has no input mechanism; 19 = INPUT opcode
        emit GSTORE, gp
    '[': (pc) ->
        stack[#stack + 1] = #output + 1
        --print("jump start at:", #output + 1)
        emit GLOAD, gp
        emit ICONST, 0
        emit IEQ
        emit BRT, 0
    ']': (pc) ->
        res = stack[#stack]
        stack[#stack] = nil
        output[res + 6] = #output + 3
        --print("jump back at: ", #output + 3)
        emit BR, res

brainfart_svm = (program) ->
    output = {}
    gp = 0
    stack = {}
    i = 1
    while i <= #program
        ops[program\sub(i,i)]()
        i = i + 1
    --print(#output, 'words')
    return output

return brainfart_svm
