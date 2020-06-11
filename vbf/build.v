module main


fn build(input []Instruction) string {
    mut output := '#include <stdio.h>\nint main(){char array[$data_size]={0};char *ptr=array;'
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