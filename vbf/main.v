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
        println('vbf 1.0 - simple brainfuck interpreter/compiler\nUsage: vbf [options] [file]\n\nOptions:\n - run\t\tRun a brainfuck script\n - build\tGenerate a C program from brainfuck that can be compiled\n - help\t\tShow this message')
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
        filename := os.args[2].replace(".vbf", "")
        mut file := os.create('./' + filename + '.c') or {
		    println('Problem while creating the file')
            return
        }
        file.write_string(resp) ?
        file.close()
        
        $if windows {
            println('Program generated correctly\nNow you can build it.')
        }
        $if macos {
            println('Program generated correctly\nNow you can build it.')
        }
        $if linux {
            os.system("cc " + filename + ".c -o " + filename)
            os.rm(filename + ".c") ?
            println('Program generated correctly\nExcute with: ./' + filename)
        }
    }else{
        println('Wrong command!')
    }
}
