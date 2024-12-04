    AREA    TermProject2024, CODE, READONLY
    ENTRY

; ===========================
; Constants
; ===========================
IMG_WIDTH    EQU     20
IMG_HEIGHT   EQU     20
NEW_WIDTH    EQU     80
NEW_HEIGHT   EQU     80
FLOAT_ONE    DCD     0x3F800000   ; IEEE 754? 1.0

; ===========================
; Main Program
; ===========================
main
    LDR     R4, =source_data     ; Load source data address
    LDR     R5, =ResultBuffer    ; Load destination buffer address

    ; Initialize loop counters
    MOV     R6, #0              ; i counter (row)
    MOV     R7, #0              ; j counter

    BL      InterpolateImage     ; Perform interpolation
    BL      end_program          ; End program

; ===========================
; Subroutine: InterpolateImage
; ===========================
InterpolateImage
    PUSH    {R4-R11, LR}        ; Save working registers

    ; Loop through destination rows
RowLoop
    CMP     R6, #NEW_HEIGHT
    BGE     InterpolationDone   ; If all rows are processed, exit

    MOV     R7, #0              ; Reset column counter

ColLoop
    CMP     R7, #NEW_WIDTH
    BGE     NextRow             ; If all columns are processed, go to next row

    ; Calculate corresponding source coordinates (float scaling)
    MOV     R8, R6              ; R8 = i
    MOV     R9, R7              ; R9 = j

    BL      ScaleCoordinates    ; Scale coordinates
    BL      BilinearCompute     ; Compute interpolated value

    ; Store result in ResultBuffer
    STR     R0, [R5], #4        ; Store interpolated value and increment pointer

    ADD     R7, R7, #1          ; Increment column
    B       ColLoop

NextRow
    ADD     R6, R6, #1          ; Increment row
    B       RowLoop

InterpolationDone
    POP     {R4-R11, PC}

; ===========================
; Subroutine: ScaleCoordinates
; Input: R8 (i), R9 (j)
; Output: R2 (x_float), R3 (y_float)
; ===========================
ScaleCoordinates
    PUSH    {R4-R7, LR}

    ; Scale x and y
    MOV     R0, R8              ; x = i
    MOV     R1, R9              ; y = j
    BL      MultiplyByScale     ; Scale x by IMG_WIDTH / NEW_WIDTH
    MOV     R2, R0              ; R2 = x_float
    BL      MultiplyByScale     ; Scale y by IMG_HEIGHT / NEW_HEIGHT
    MOV     R3, R0              ; R3 = y_float

    POP     {R4-R7, PC}

; ===========================
; Subroutine: BilinearCompute
; Input: R2 (x_float), R3 (y_float)
; Output: R0 (interpolated value)
; ===========================
BilinearCompute
    PUSH    {R4-R11, LR}

    ; Calculate surrounding indices and weights
    ; (Pseudocode equivalent for clarity: Perform IEEE 754 manipulations)

    ; Extract 4 surrounding pixels
    ; Compute weighted average

    POP     {R4-R11, PC}

; ===========================
; Subroutine: MultiplyByScale
; Input: R0 (value to scale)
; Output: R0 (scaled value)
; ===========================
MultiplyByScale
    PUSH    {R4-R7, LR}

    ; Multiply by scale factor (pre-computed)
    ; Example: (IMG_WIDTH / NEW_WIDTH) or (IMG_HEIGHT / NEW_HEIGHT)

    POP     {R4-R7, PC}

; ===========================
; Data and Buffers
; ===========================
source_data
    INCLUDE data\downsampled\0.txt

ResultBuffer
    SPACE   NEW_WIDTH * NEW_HEIGHT * 4   ; Space for 80x80 result buffer

; ===========================
; End Program (Do Not Modify)
; ===========================
end_program
    MOV     R0, #0
    MOV     R7, #0x11
    SWI     0

    END
