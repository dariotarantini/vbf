module main

import os

struct Instruction {
mut:
    operator int
	operand int
}

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

fn vcbf(input string) []Instruction {
    mut pc := 0
    mut jmp_pc := 0
    mut jmp_stack := []int{}
    mut output := []Instruction
    for c in input {
        mch := c.str()
        if mch == '>' {
            output << Instruction{op_inc_dp, 0}
        }else if mch == '<' {
            output << Instruction{op_dec_dp, 0}
        }else if mch == '+' {
            output << Instruction{op_inc_val, 0}
        }else if mch == '-' {
            output << Instruction{op_dec_val, 0}
        }else if mch == '.' {
            output << Instruction{op_out, 0}
        }else if mch == ',' {
            output << Instruction{op_in, 0}
        }else if mch == '[' {
            output << Instruction{op_jmp_fwd, 0}
            jmp_stack << pc
        }else if mch == ']' {
            if jmp_stack.len == 0 {
                println('Compiler error')
                return []Instruction{}
            }
			jmp_pc = jmp_stack[jmp_stack.len-1]
            tmp_jmp_stack := jmp_stack
            jmp_stack = []int{}
            for i := 0; i < (tmp_jmp_stack.len-1); i++{
                jmp_stack << tmp_jmp_stack[i]
            }
            output << Instruction{op_jmp_bck, jmp_pc}
			output[jmp_pc].operand = pc
        }else{
            pc--
        }
        pc++
    }
    if jmp_stack.len != 0 {
	    println('Something went wrong...')
        return []Instruction{}
	}
    return output
}

fn vebf(input []Instruction){
	mut data := [0 ; data_size]
	mut data_ptr := 0
	for pc := 0; pc < (input.len); pc++ {
		if input[pc].operator == op_inc_dp {
			data_ptr++
        }else if input[pc].operator == op_dec_dp {
            data_ptr--
        }else if input[pc].operator == op_inc_val {
            data[data_ptr]++
        }else if input[pc].operator == op_dec_val {
            data[data_ptr]--
        }else if input[pc].operator == op_out {
            C.printf('%c', data[data_ptr])
        }else if input[pc].operator == op_in {
            cb := 0
            C.scanf('%c', &cb)    
            data[data_ptr] = cb
        }else if input[pc].operator == op_jmp_fwd {
			if data[data_ptr] == 0 {
				pc = input[pc].operand
			}
        }else if input[pc].operator == op_jmp_bck {
			if data[data_ptr] > 0 {
				pc = input[pc].operand
			}
        }else{
            println('Execution error')
        }
	}
}

fn main(){
    _args := parse(os.args, 1)
    if _args.command == 'help' {
        println('vbf 0.4 - simple brainfuck interpreter\nUsage: vbf [options] [file]\n\nOptions:\n - run\tRun a brainfuck script\n - help\tShow this message')
    }else if _args.command == 'run' {
        code := os.read_file(_args.unknown[0]) or {
		    println('File not found')
            return
        }
        c := vcbf(code)
        vebf(c)
    }else{
        println('Wrong command!')
    }
}
