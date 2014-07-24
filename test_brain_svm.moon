--test brainfart simple virtual machine compiler
VM = require 'vm'
bfsvm = require 'bfsvm'

writechar = (s) ->
    os.exit(0) unless s
    if type(s) == "number"
        s = string.char(s)
    io.write(s)

output = bfsvm("++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+<<<<<<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.")
vm = VM(output, 1, 64, nil, writechar)
vm.execute()

output = bfsvm(",[.,]")
vm = VM(output, 1, 64, nil, writechar)
vm.execute()
