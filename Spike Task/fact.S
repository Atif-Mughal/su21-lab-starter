.text
.globl _start
_start:
      la a0, num            # load address of num to a0
      lw a0, 0(a0)          # load value of num into a0

      jal ra, factorial     # call factorial function
      la t0, result         # load address of result into t0
      sw a0, 0(t0)          # save the result in memory

write_tohost:
      li x1, 1
      sw x1, tohost, t5
      j write_tohost

.data
.align 4
num: .word 6                # num 6 factorial 
result: .word 0

.align 12
.section ".tohost","aw",@progbits;                            
.align 4; .global tohost; tohost: .dword 0;                     
.align 4; .global fromhost; fromhost: .dword 0;

.text
factorial:
      addi sp, sp, -12            # prepare stack
      sw ra, 8(sp)                # save the return address
      sw a0, 4(sp)                # save the argument
      li a1, 1
      
      ble a0, a1, exit            # if num is 0 or 1, return 1
      addi a0, a0, -1             # num = num - 1
      jal ra, factorial           # call factorial function recursively
      lw a1, 4(sp)                # load the original num
      mul a0, a0, a1              # multiply by the original num

exit:
      lw ra, 8(sp)                # load the return address
      addi sp, sp, 12             # restore stack
      jr ra                       # return
