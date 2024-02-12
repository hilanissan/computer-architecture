# Hila Nissan 212226575

.extern printf
.extern scanf


.section .rodata
formatD:    		.string     	" %uuh"
formatDefault:    	.string     	"invalid option!\n"
formatStrlen:		.string			"first pstring length: %d, second pstring length: %d\n"
formatPstrijcpy:	.string			"length: %d, string: %s\n"


    .align 8                                    
.CasesArray:
        .quad .Pstring                         # Case 31: pstrlen
        .quad .default                         # Case defult
        .quad .swapCase                        # Case 33: swap_case
        .quad .pstrijcpy                       # Case 34: pstrijcpy


.text                                          
.globl	run_func
.type	run_func, @function	                
# void run_func(int option, pstring* p1, pstring* p2)
# option in %edi, p1 in %rsi, p2 in %rdx
run_func:                                      
   pushq   %rbp	           			
    movq	%rsp, %rbp	       			
    	
    leaq    -31(%rdi), %rcx    			# %rdi had the conten of x, now we passed it to %rcx.
    cmpq    $4, %rcx    				# Check the choich with 4 (the number of options).    
    ja      .default				    # If an invalide choice was made, go to the default.
    jmp     *.CasesArray(,%rcx,8)	    # jump tp the valide option.


 # Case 31
   .Pstring:
    
    
    xorq	%r8, %r8					# Clear %r8.
	xorq	%r9, %r9					# Clear %r9.
	
    movq	%rsi, %rdi					# Move PS1 to %rdi as first argument.
	xorq    %rax, %rax					# Clear %rax.
	call	pstrlen						# Call pstrlen.
	movq	%rax, %r8					# Save the return value in %r8.
	
	movq	%rdx, %rdi					# Move PS2 to %rdi as first argument.
	xorq    %rax, %rax					# Clear %rax.
	call	pstrlen						# Call pstrlen.
	movq	%rax, %r9					# Save the return value in %r9.
	
	movq	%r8, %rsi					# Move %r8 (The result length of PS1) to %rsi as second argument to printf.
	movq	%r9, %rdx					# Move %r9 (The result length of PS2) to %rsi as third argument to printf.
    movq    $formatStrlen, %rdi			# Set the format of the result to %rdi as first argument to printf.
    xorq    %rax, %rax					# Clear %rax.
    callq    printf						# Call printf.
	
    jmp     .finish						# End of case, jump to return. 


    # Case 33
   .swapCase:
   
	pushq	%r12						# Save r12 as a callee function.
	pushq	%r13						# Save r13 as a callee function.
   
    xorq	%r12, %r12					# Clear %r12.
	xorq	%r13, %r13					# Clear %r13.
	movq	%rsi, %r12					# Move PS1 to %r12
	movq	%rdx, %r13					# Move PS2 to %r13.
	
	movq	%r12, %rdi					# Move PS1 to %rdi as first argument.
	xorq	%rax, %rax					# Clear %rax.
	call	swapCase
	movq	%rax, %r12					# Set the result in %r12.
	
	movq	%r13, %rdi					# Move PS1 to %rdi as first argument.
	xorq	%rax, %rax					# Clear %rax.
	call	swapCase
	movq	%rax, %r13					# Set the result in %r12.
	
	xorq	%rsi, %rsi					# Clear %rsi.
	movq	$formatPstrijcpy, %rdi		# Set the case's format to %rdi.
	movzbq	(%r12), %rsi				# Set the length of PS1 to %rsi.
	incq	%r12						# Skip the length.
	movq	%r12, %rdx					# Set the string of PS1 to %rdx.
	xorq	%rax, %rax					# Clear %rax.
	call	printf						# Call printf.
		
	xorq	%rsi, %rsi					# Clear %rsi.
	movq	$formatPstrijcpy, %rdi		# Set the case's format to %rdi.
	movzbq	(%r13), %rsi				# Set the length of PS2 to %rsi.
	incq	%r13						# Skip the length.
	movq	%r13, %rdx					# Set the string of PS2 to %rdx.
	xorq	%rax, %rax					# Clear %rax.
	call	printf						# Call printf.
	
	popq	%r13						# Restore the value of %r13 as a callee function.
	popq	%r12						# Restore the value of %r12 as a callee function.
	
    jmp     .finish						# End of case, jump to return.      


     # Case 34
   .pstrijcpy:
    
	pushq	%r12						# Save r12 as a callee function.
	pushq	%r13						# Save r13 as a callee function.
	
    movq	%rsi, %r12					# Save PS1 in %r12.
	movq	%rdx, %r13					# Save PS2 in %r13.
	subq	$16, %rsp					# Allocate space in the stack for two charecters (8 bytes each).
	
	# Scan i.
	leaq    -16(%rbp), %rsi				# Loading the first input (i) to %rsi as second argument to scanf.
	movq    $formatD, %rdi				# Loading the format (%d) as first argument to %rdi.
    xorq    %rax, %rax					# Clearing %rax.
    call    scanf						# Calling scanf.
	
	# Scan j.
	leaq    -8(%rbp), %rsi				# Loading the second input (j) to %rsi as second argument to scanf.
	movq    $formatD, %rdi				# Loading the format (%d) as first argument to %rdi.
    xorq    %rax, %rax					# Clearing %rax.
    call    scanf						# Calling scanf.
	
	# Clear all relevant registers.
	xorq	%rsi, %rcx
	xorq	%rdx, %rdx
	
	movq	%r12, %rdi					# Set PS1 to %rdi as first argument.
	movq	%r13, %rsi					# Set PS2 to %rsi as second argument.
	movzbq	-16(%rbp),%rdx				# Set i to %rdx as third argument.
	movzbq	-8(%rbp),%rcx				# Set j to %rcx as fourth argument.
	xorq	%rax, %rax					# Clear %rax.
	call    pstrijcpy					# Call pstrijcpy.
	
	movq	$formatPstrijcpy, %rdi		# Set the case's format to %rdi.
	movzbq	(%rax), %rsi				# Set the length of dest (PS1) to %rsi.
	incq	%rax						# Skip the length.
	movq	%rax, %rdx					# Set the string of dest (PS1) to %rdx.
	xorq	%rax, %rax					# Clear %rax.
	call	printf						# Call printf.
	
	movq	$formatPstrijcpy, %rdi		# Set the case's format to %rdi.
	movzbq	(%r13), %rsi				# Set the length of src (PS2) to %rsi.
	incq	%r13						# Skip the length.
	movq	%r13, %rdx					# Set the string of src (PS2) to %rdx.
	xorq	%rax, %rax					# Clear %rax.
	call	printf						# Call printf.
	
	addq	$16, %rsp					# Dealocate the stack space we used.
	popq	%r13						# Restore the value of %r13 as a callee function.
	popq	%r12						# Restore the value of %r12 as a callee function.
	
    jmp     .finish						# End of case, jump to return.


    # Default case.
   .default:
	movq    $formatDefault, %rdi		# Put the default format in %rdi.
	xorq    %rax, %rax					# Clear %rax.
	callq    printf						# Call printf.

    .finish:

    # return from printf:
    movq	   $0, %rax					# Return value is zero 
    movq	   %rbp, %rsp				
    popq	   %rbp						
    ret	
