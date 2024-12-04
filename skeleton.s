    AREA    TermProject2024, CODE, READONLY
    
; Constants
IMG_WIDTH    EQU     20
IMG_HEIGHT   EQU     20
NEW_WIDTH    EQU     80
NEW_HEIGHT   EQU     80

    ENTRY
    
main        
    ; Load base addresses
    LDR     R4, =source_data     ; Source image
    LDR     R5, =ResultBuffer    ; Destination buffer
    
    ; Initialize loop counters
    MOV     R6, #0              ; i counter
    MOV     R7, #0              ; j counter

    ; YOUR CODE HERE

; Floating point multiplication
multiply_floats
    PUSH    {R4-R11, LR}
    
    ; Load constants from memory
    LDR     R12, =mantissa_mask     ; Load address of mantissa mask
    LDR     R12, [R12]             ; Load actual value
    
    ; YOUR CODE HERE

multiply_done
    POP     {R4-R11, PC}

; IEEE 754 Addition
add_floats
    PUSH    {R4-R11, LR}
    
    ; Extract mantissas and add implied 1
    LDR     R8, =mantissa_mask
    LDR     R8, [R8]            ; Load mantissa mask

    ; YOUR CODE HERE
    
add_done
    POP     {R4-R11, PC}

; IEEE 754 Subtraction
subtract_floats
    PUSH    {R4-R11, LR}
    
    ; Use addition routine
    BL      add_floats
    
    POP     {R4-R11, PC}

; #########################
; DO NOT MODIFY end_program
; #########################
end_program
    MOV     R0, #0             ; Return 0
    MOV     R7, #0x11          ; SWI exit
    SWI     0                   ; Exit program and return 0
; #########################
; DO NOT MODIFY end_program
; #########################

; YOUR CODE HERE
    AREA    ROData, DATA, READONLY
mantissa_mask	DCD     0x007FFFFF          ; Store the large constant here
infinity_const 	DCD		0x7F800000
implied_one     DCD     0x800000

source_data
    INCLUDE data\downsampled\0.txt   ; Include the image data

    AREA    RWData, DATA, READWRITE
ResultBuffer
    SPACE   NEW_WIDTH * NEW_HEIGHT * 4   ; Space for 80x80 result
    
    END
