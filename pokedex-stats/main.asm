// change these constants as needed
infile equ "firered.gba"
outfile equ "test.gba"

.definelabel free_space, 0x08800000

// -----------------------------------------------------------------------------

.definelabel fcode_buffer2, 0x02021CD0
.definelabel displayed_string, 0x02021D18

.definelabel base_stats, 0x080001BC
.definelabel abilities, 0x080001C0

.definelabel return_loc, 0x08106380
.definelabel write_method, 0x081047C8
.definelabel int_to_str, 0x08008E78
.definelabel fdecoder, 0x08008FCC

// -----------------------------------------------------------------------------

.gba
.thumb

.create outfile, 0x08000000
.import infile

// -----------------------------------------------------------------------------

// credits to Sperical Ice, DoesntKnowHowToPlay and Squeetz

.org 0x0810611E
    b 0x081061A8

.org 0x08106370
    ldr r0, =pokedex_stats |1
    bx r0
    .pool

.org 0x08106530
    b 0x081066D0

.org 0x08452200
    lsl r2, r1, #0

// -----------------------------------------------------------------------------

.org free_space
.align 2

pokedex_stats:
@@main:
    mov r5, #4
    str r5, [sp]
    str r6, [sp, #4]
    mov r0, r10
    cmp r0, #0
    beq @@unknown_base_stats

@@hp:
    mov r0, #0
    bl @@print_stat
    mov r3, #4 // y co-ord
    str r3, [sp]
    mov r3, #0 // x co-ord
    ldr r5, =write_method |1
    bl @@call_via_r5
    
@@atk:
    mov r0, #1
    bl @@print_stat
    mov r3, #4 // y co-ord
    str r3, [sp]
    mov r3, #0x2C // x co-ord
    ldr r5, =write_method |1
    bl @@call_via_r5
     
@@def:
    mov r0, #2
    bl @@print_stat
    mov r3, #18 // y co-ord
    str r3, [sp]
    mov r3, #0 // x co-ord
    ldr r5, =write_method |1
    bl @@call_via_r5
     
@@spa:
    mov r0, #4
    bl @@print_stat
    mov r3, #18 // y co-ord
    str r3, [sp]
    mov r3, #0x2C // x co-ord
    ldr r5, =write_method |1
    bl @@call_via_r5
     
@@spd:
    mov r0, #5
    bl @@print_stat
    mov r3, #32 // y co-ord
    str r3, [sp]
    mov r3, #0 // x co-ord
    ldr r5, =write_method |1
    bl @@call_via_r5
     
@@spe:
    mov r0, #3
    bl @@print_stat
    mov r3, #32 // y co-ord
    str r3, [sp]
    mov r3, #0x2C // x co-ord
    ldr r5, =write_method |1
    bl @@call_via_r5
    
@@print_ability_one:
    ldr r0, [sp, #0x1C]
    mov r3, #0x1C
    mul r0, r3
    ldr r1, =base_stats
	ldr r1, [r1]
    mov r3, #0x16
    add r1, r1, r3
    add r1, r0, r1
    ldr r3, =abilities
	ldr r3, [r3]
    ldrb r2, [r1]
    mov r1, #0xD
    mul r1, r2
    add r2, r1, r3    
    ldr r1, [r7]
    add r1, #0x53
    ldrb r1, [r1]
    mov r0, r1
    mov r1, #0
    mov r3, #46
    str r3, [sp]
    mov r3, #0
    ldr r5, =write_method |1
    bl @@call_via_r5
    
@@print_ability_two:
    ldr r0, [sp, #0x1C]
    mov r3, #0x1C
    mul r0, r3
    ldr r1, =base_stats
	ldr r1, [r1]
    mov r3, #0x16
    add r1, r1, r3
    add r1, r0, r1
    ldrb r2, [r1, #1]
    ldrb r5, [r1, #0]
    ldr r3, =abilities
	ldr r3, [r3]
    cmp r2, r5
    beq @@return
    cmp r2, #0
    beq @@return
    mov r1, #0xD
    mul r1, r2
    add r2, r1, r3
    
    ldr r1, [r7]
    add r1, #0x53
    ldrb r1, [r1]
    mov r0, r1
    mov r1, #0
    mov r3, #60
    str r3, [sp]
    mov r3, #0
    ldr r5, =write_method |1
    bl @@call_via_r5
    b @@return
    
@@unknown_base_stats:
    mov r0, r1
    mov r1, #0
    ldr r2, =@@capture
    mov r3, #4 // y co-ord
    str r3, [sp]
    mov r3, #0 // x co-ord
    ldr r5, =write_method |1
    bl @@call_via_r5
    
@@return:
    mov r5, #0
    ldr r0, =return_loc |1
    bx r0
    
@@print_stat:
    push {lr}
    ldr r3, [sp, #0x20]
    mov r1, #0x1C
    mul r3, r1
    ldr r2, =base_stats
	ldr r2, [r2]
    add r2, r3
    add r2, r0
    ldrb r1, [r2]
    mov r4, r0
    ldr r0, =fcode_buffer2
    mov r3, #0
    cmp r1, #99
    bhi @@no_leading_zeroes
    cmp r1, #9
    bhi @@one_leading_zero

@@two_leading_zeroes:
    str r3, [r0]
    add r0, #1

@@one_leading_zero:
    str r3, [r0]
    add r0, #1

@@no_leading_zeroes:
    mov r3, #3
    ldr r5, =int_to_str |1
    bl @@call_via_r5
    
    mov r2, r4
    ldr r0, =displayed_string
    ldr r1, =@@table
    lsl r2, r2, #2
    add r1, r2
    ldr r1, [r1]
    ldr r5, =fdecoder |1
    bl @@call_via_r5
    ldr r1, [r7]
    add r1, #0x53
    ldrb r1, [r1]
    mov r0, r1
    mov r1, #0
    ldr r2, =displayed_string
    pop {r5}
    
@@call_via_r5:
    bx r5

.pool

.align 4 

@@table:
	.word @@stat_hp
	.word @@stat_atk
	.word @@stat_def
	.word @@stat_spe
	.word @@stat_spa
	.word @@stat_spd
	
@@stat_hp:
	.byte 0xC2, 0xCA, 0x0, 0x0, 0xFD, 0x2, 0xFF
	
@@stat_atk:
	.byte 0xBB, 0xE8, 0xDF, 0x0, 0xFD, 0x2, 0xFF 
	
@@stat_def:
	.byte 0xBE, 0xD9, 0xDA, 0x0, 0xFD, 0x2, 0xFF
	
@@stat_spe:
	.byte 0xCD, 0xE4, 0xD9, 0x0, 0xFD, 0x2, 0xFF
	
@@stat_spa:
	.byte 0xCD, 0xE4, 0xBB, 0x0, 0xFD, 0x2, 0xFF
	
@@stat_spd:
	.byte 0xCD, 0xE4, 0xBE, 0x0, 0xFD, 0x2, 0xFF
	
@@capture:
	.byte 0xBD, 0xD5, 0xE4, 0xE8, 0xE9, 0xE6, 0xD9, 0x0, 0xDA, 0xE3, 0xE6, 0xFE, 0xE1, 0xE3, 0xE6, 0xD9, 0x0, 0xDD, 0xE2, 0xDA, 0xE3, 0xE6, 0xE1, 0xD5, 0xE8, 0xDD, 0xE3, 0xE2, 0xAB, 0xFF

.close