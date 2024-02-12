# Hila Nissan 212226575

.section .rodata
invalid:        .string	"invalid input!\n"
.text	                                        
.globl	pstrlen 
	.type	pstrlen, @function	                # the label "pstrlen" representing the beginning of a function
# char pstrlen(Pstring* pstr)
# p1 in %rdi
pstrlen:                            	       
		pushq	%rbp						
	    movq	%rsp,%rbp 
	    movb   (%rdi), %al                      # return the first size char of a pstring p1
		movq	%rbp,%rsp	
	    popq	%rbp
	    ret                                     # return to caller function 


.global swapCase
.type swapCase, @function
# Pstring* swapCase(Pstring* pstr)
# p1 in %rdi
swapCase:
	pushq	%rbp						
	movq	%rsp,%rbp	

	movq	%rdi,%rax	# rax is pointer to pstring - return value
	addq	$1,	%rdi	# pstring has the length at the first byte - need to add 1 to the pointer
.while_loop_swp:
	cmpb	$0,	(%rdi)	# check if pstring at index i = \0 
	je		.break_swp					# if true - ends the loop

	cmpb	$90,(%rdi)	# check if pstring[i] <= 'Z'
	jbe		.may_be_capital
	cmpb	$122,				(%rdi)	# check if pstring[i] <= 'z'
	jbe		.may_be_small
	jmp		.continue
.may_be_capital:
	cmpb	$65,(%rdi)	# check if pstring[i] < 'A'
	jb		.continue
	addb	$32,(%rdi)	# make current char small case
	jmp		.continue
.may_be_small:
	cmpb	$97,(%rdi)	# check if pstring[i] < 'a'
	jb		.continue
	subb	$32,(%rdi)	# make current char capital
	jmp		.continue
.continue:
	addq	$1,	%rdi	# add 1 to rdi - next char
	jmp		.while_loop_swp
.break_swp:
	movq	%rbp,%rsp	
	popq	%rbp						
	ret


.globl	pstrijcpy
.type	pstrijcpy, @function	            
# Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j)
# p1 in %rdi, p2 in %rsi, i in %dl, j in %cl
pstrijcpy:	                            
	pushq	%rbp						
	movq	%rsp, %rbp	                	

	pushq	%r12						# save r12
	pushq	%rdi						# save pointer to pstring1 to the stack

	cmpb	%dl, %cl		            # compare i and j (rdx and rcx)
	jb		.invalid_cpy				# if j is less than i, goto invalid
	cmpb	$0, %dl		                # compare 0 and i (rdx)
	jb		.invalid_cpy				# if i is less than 0, goto invalid
	addb	$1, %cl		                # add 1 to j - to check length (start in 0)
	cmpb	%cl, (%rdi)	            # compare pstring1 length (rdi) and j+1 (rcx)
	jb		.invalid_cpy				# if pstring1 length is less than j+1, goto invalid
	cmpb	%cl, (%rsi)	            # compare pstring2 length (rsi) and j+1 (rcx)
	jb		.invalid_cpy				# if pstring2 length is less than j+1, goto invalid
	subb	$1,	%cl		                # subtract 1 from j - to check length (start in 0)

	addq	$1,	%rdi	                # pstring has the length at the first byte - need to add 1 to the pointer
	addq	$1,	%rsi	                # pstring has the length at the first byte - need to add 1 to the pointer
	addq	%rdx, %rdi	                # add i to pstring1 pointer - rdi is pointer to pstring1[i]
	addq	%rdx, %rsi	                # add i to pstring2 pointer - rsi is pointer to pstring2[i]
.while_loop_cpy:
	cmpb	%dl, %cl		            # compare i and j (rdx and rcx)
	jl		.break_cpy					# if j is less than i, break

	movb	0(%rsi), %r12b	            # copy pstring2[i] to r12
	movb	%r12b, 0(%rdi)	            # copt r12 to pstring2[i]
	addb	$1,	%dl		                # add 1 to i (i++)
	addq	$1,	%rdi	                # add 1 to rdi
	addq	$1,	%rsi 	                # add 1 to rsi
	jmp		.while_loop_cpy
.invalid_cpy:
	movq	$invalid,%rdi	        # move format to first argument for printf
	movq	$0, %rax	                # set rax to 0
	call	printf
	movq	$0,	%rax	                # set rax to 0
.break_cpy:
	popq	%rax						# return value - pointer to pstring1
	popq	%r12						# save r12
	movq	%rbp, %rsp	                
	popq	%rbp						
	ret
	
