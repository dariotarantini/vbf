module main

import os


struct Args {
pub mut:
    command string
    options map[string]string
    unknown []string
}

fn parse_hypen_args(v string) []string {
    mut delimitter := '-'

    if v.starts_with('--') {
        delimitter = '--'
    }

    val := v.replace(delimitter, '')

    return val.split('=')
}

fn detect_hypen_args(v string) bool {
    return v.starts_with('-')
}

pub fn parse(a []string, slice_num int) Args {
    args := a.slice(slice_num, a.len)

    mut parsed := Args{'', map[string]string{}, []string}

    for i := 0; i < args.len; i++ {
        current := args[i]
        next := if i+1 > args.len-1 { '' } else { args[i+1] }
        prev := if i-1 <= 0 { '' } else { args[i-1] }
        no_hyphens := !detect_hypen_args(prev) && !detect_hypen_args(current)
        
        if i == 0 && !detect_hypen_args(current) {
            parsed.command = current
        }

        if detect_hypen_args(prev) {
            prev_arg := parse_hypen_args(prev)
            parsed.options[prev_arg[0]] = current
        }

        if i != 0 && no_hyphens {
            parsed.unknown << current
        }

        if detect_hypen_args(current) {
            arg := parse_hypen_args(current)

            if arg.len == 2 {
                parsed.options[arg[0]] = arg[1]
            }

            if arg.len == 1 && next.len == 0 {
                parsed.options[arg[0]] = ''
            }
        }
    }

    return parsed
}

pub fn (v Args) str() string {
    opts_str := v.options.str().split('\n').join(' ')

    return '\{ command: ${v.command}, options: ${opts_str}, unknown: ${v.unknown.str()} \}'
}


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
fn vbbf(input []Instruction) string {
    mut output := ''
    output += '#include <stdio.h>\nint main(){char array[$data_size]={0};char *ptr=array;'
	for pc := 0; pc < (input.len); pc++ {
		if input[pc].operator == op_inc_dp {
            output += '++ptr;'
        }else if input[pc].operator == op_dec_dp {
            output += '--ptr;'
        }else if input[pc].operator == op_inc_val {
            output += '++(*ptr);'
        }else if input[pc].operator == op_dec_val {
            output += '--(*ptr);'
        }else if input[pc].operator == op_out {
            output += 'printf("%c", *ptr);'
        }else if input[pc].operator == op_in {
            output += 'scanf("%c", &ptr);'
        }else if input[pc].operator == op_jmp_fwd {
            output += 'while(*ptr){'
        }else if input[pc].operator == op_jmp_bck {
            output += '}'
        }else{
            println('Build error')
        }
	}
    output += ' return 0;}'
    return output
}
fn main(){
    _args := parse(os.args, 1)
    if _args.command == 'help' {
        println('vbf 0.5 - simple brainfuck interpreter/compiler\nUsage: vbf [options] [file]\n\nOptions:\n - run\t\tRun a brainfuck script\n - build\tGenerate a C program from brainfuck that can be compiled\n - help\t\tShow this message')
    }else if _args.command == 'run' {
        code := os.read_file(_args.unknown[0]) or {
		    println('File not found')
            return
        }
        c := vcbf(code)
        vebf(c)
    }else if _args.command == 'build' {
        code := os.read_file(_args.unknown[0]) or {
		    println('File not found')
            return
        }
        resp := vbbf(vcbf(code))
        file := os.create('./'+_args.unknown[0]+'.c') or {
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
