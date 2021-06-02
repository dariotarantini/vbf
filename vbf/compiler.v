module main

fn compile(input string) []Instruction {
    mut pc := 0
    mut jmp_pc := 0
    mut jmp_stack := []int{}
    mut output := []Instruction{}
    for c in input {
        mch := c.ascii_str()
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
                return [Instruction{}]
            }
			jmp_pc = jmp_stack[jmp_stack.len-1]
            tmp_jmp_stack := jmp_stack.clone()
            jmp_stack = [0]
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
    if jmp_stack.len > 1 && jmp_stack[0] != 0 {
	    println('Something went wrong...')
        return []Instruction{}
	}
    return output
}
