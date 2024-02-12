# Hila Nissan 212226575

.extern printf
.extern scanf
.extern rand
.extern srand


.section .data
seed_value:
    .space 4
guess_value:
    .space 4
random_value:
    .space 4
attempt_counter:
    .int 0               
max_attempts:
    .int 5   

.section .rodata
prompt_seed:
    .string "Enter configuration seed: "
prompt_guess:
    .string "What is your guess? "
incorrect_msg:
    .string "Incorrect.\n"
won_msg:
    .string "Congratz! You won!\n"
lost_msg:
    .string "Game over, you lost :(. The correct answer was %d\n"
 scanf_fmt:
    .string "%d"




.section .text
.globl main
.type	main, @function 
main:
    pushq %rbp
    movq %rsp, %rbp    

    # Print the prompt
    movq $prompt_seed, %rdi
    xorq %rax, %rax
    call printf

    # Read the seed 
    movq $scanf_fmt, %rdi
    movq $seed_value, %rsi
    xorq %rax, %rax
    call scanf

    # Load the seed value into a register
    movl seed_value, %edi

    # Send the seed to srand
    call srand

    # Generate random number based on the seed
    call rand               # Call rand to generate a random number
    movl %eax, random_value # Store the random number in random_value

    # Calculate random number modulo 10
    movl random_value, %eax  # Load the random number into %eax
    movl $10, %ecx           # Load 10 into %ecx
    idivl %ecx               # Calculate the remainder of random number divided by 10
    movl %edx, random_value  # Store the result in random_value



.loop_attempts:
    movl max_attempts, %eax
    cmp %eax, attempt_counter  # Compare the attempt counter with the maximum attempts allowed
    jge .end_attempts        # If the maximum attempts reached, end the loop

    # Print the prompt for the user's guess
    movq $prompt_guess, %rdi
    xorq %rax, %rax
    call printf

    # Read the user's guess
    movq $scanf_fmt, %rdi
    movq $guess_value, %rsi
    xorq %rax, %rax
    call scanf

    # Compare the guess with the random number
    movl random_value, %eax  # Load the random number into %eax
    cmpl %eax, guess_value   # Compare the user's guess with the random number
    je .won_attempt          # Jump to the "won_attempt" section if the guess is correct

    # Print incorrect message
    movq $incorrect_msg, %rdi
    xorq %rax, %rax
    call printf

    incq attempt_counter     # Increment attempt counter
    jmp .loop_attempts       # Repeat the loop

.won_attempt:
    # Print "Congratulations! You won!"
    movq $won_msg, %rdi
    xorq %rax, %rax
    call printf
    jmp .done

.end_attempts:
    # Print "Game over, you lost :("
    movq $lost_msg, %rdi
    movl random_value, %esi  # Load the random number from memory
    xorq %rax, %rax
    call printf

.done:
    # Exit
    xorq %rax, %rax
    movq %rbp, %rsp
    popq %rbp
    ret
    