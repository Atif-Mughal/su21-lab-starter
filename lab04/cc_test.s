.data
failure_message: .asciiz "Test failed for some reason.\n"
success_message: .asciiz "Sanity checks passed! Make sure there are no CC violations.\n"
array:
    .word 1 2 3 4 5
exp_inc_array_result:
    .word 2 3 4 5 6

.text
main:
    # We test our program by loading a bunch of random values
    # into a few saved registers - if any of these are modified
    # after these functions return, then we know calling
    # convention was broken by one of these functions
    li s0, 2623
    li s1, 2910
    # ... skipping middle registers so the file isn't too long
    # If we wanted to be rigorous, we would add checks for
    # s2-s20 as well
    li s11, 134
    # Now, we call some functions
    # simple_fn: should return 1
    jal simple_fn # Shorthand for "jal ra, simple_fn"
    li t0, 1
    bne a0, t0, failure
    # naive_pow: should return 2 ** 7 = 128
    li a0, 2
    li a1, 7
    jal naive_pow
    li t0, 128
    bne a0, t0, failure
    # inc_arr: increments "array" in place
    la a0, array
    li a1, 5
    jal inc_arr
    jal check_arr # Verifies inc_arr and jumps to "failure" on failure
    # Check the values in the saved registers for sanity
    li t0, 268435547
    li t1, 5
    li t2, 134
    bne s0, t0, failure
    bne s1, t1, failure
    bne s11, t2, failure
    # If none of those branches were hit, print a message and exit normally
    li a0, 4
    la a1, success_message
    ecall
    li a0, 10
    ecall

# Just a simple function. Returns 1.
simple_fn:
    li a0, 1
    ret

# Computes a0 to the power of a1.
naive_pow:
    li s0, 1
naive_pow_loop:
    beq a1, zero, naive_pow_end
    mul s0, s0, a0
    addi a1, a1, -1
    j naive_pow_loop
naive_pow_end:
    mv a0, s0
    ret

# Increments the elements of an array in-place.
inc_arr:
    addi sp, sp, -4
    sw ra, 0(sp)
    mv s0, a0 # Save start of array
    mv s1, a1 # Save length of array
    li t0, 0  # Initialize counter
inc_arr_loop:
    beq t0, s1, inc_arr_end
    slli t1, t0, 2 # Convert array index to byte offset
    add a0, s0, t1 # Calculate address of current array element
    jal helper_fn  # Call helper function to increment the value at the address
    addi t0, t0, 1 # Increment counter
    j inc_arr_loop
inc_arr_end:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# Helper function to increment the value at the memory address in a0.
helper_fn:
    lw t1, 0(a0)   # Load value from memory address
    addi t1, t1, 1 # Increment value
    sw t1, 0(a0)   # Store updated value back to memory address
    ret

# Check the result of inc_arr.
check_arr:
    la t0, exp_inc_array_result
    la t1, array
    addi t2, t1, 20 # Last element is 5*4 bytes off
check_arr_loop:
    beq t1, t2, check_arr_end
    lw t3, 0(t0)
    lw t4, 0(t1)
    bne t3, t4, failure
    addi t0, t0, 4
    addi t1, t1, 4
    j check_arr_loop
check_arr_end:
    ret

failure:
    li a0, 4 # String print ecall
    la a1, failure_message
    ecall
    li a0, 10 # Exit ecall
    ecall

