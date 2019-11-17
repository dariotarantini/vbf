module main

import os


const (
	op_inc_dp = 0
	op_dec_dp = 1
	op_inc_val = 2
	op_dec_val = 3
	op_out = 4
	op_in = 5
	op_jmp_fwd = 6
	op_jmp_bck = 7
    data_size = 65535
)

fn main(){
    if os.args[1] == 'help' {
        println('vbf 0.7 - simple brainfuck interpreter/compiler\nUsage: vbf [options] [file]\n\nOptions:\n - run\t\tRun a brainfuck script\n - build\tGenerate a C program from brainfuck that can be compiled\n - help\t\tShow this message')
    }else if os.args[1] == 'run' {
        code := os.read_file(os.args[2]) or {
		    println('File not found')
            return
        }
        c := compile(code)
        excute(c)
    }else if os.args[1] == 'build' {
        code := os.read_file(os.args[2]) or {
		    println('File not found')
            return
        }
        c := compile(code)
        resp := build(c)
        file := os.create('./'+os.args[2]+'.c') or {
		    println('Problem while creating the file')
            return
        }
        file.write(resp)
        file.close()
        println('Program generated correctly')
    }else{
        println('Wrong command!')
    }
}
