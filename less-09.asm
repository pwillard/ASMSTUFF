    nam less-09.asm 

; include "common.inc"  

; run in Char32 screen

    org $1100
start
    clr SW  ; Clear Loop Variable
loop
    bsr     IN_key      ; read a keypress
    tst     SW          ; test SW
    beq     loop        ; loop if SW=0
    rts                 ; endless loop

SW  fcb     0 ; Loop Variable if SW = 1, then exit
     
;----------------------------------------------------------------------------
; Keyboard reading is done by storing a masked value in the Memory location
; based on the columns in the top row below of the keyboard matrix and
; tesed against the bits in the rows on the left side of the keyboard matrix
; 
; For example, to test if the letter "T" is pressed, the following is used:
; Store %11101111 in $FF02
; Load byte from $FF00 and test it against %00000100 (bit 2 of the row matrix)
; if result is true, then "T" is pressed.
; 
; Methods: you can test with COMx or BITx instructions.
;
;Keyboard Matrix
;                  COLUMNS BITS
; ROW 		          $FF02 		                
; BITS      7   6   5   4   3   2   1   0
;----------------------------------------------------------------------------
; 7     Joysick results
; 6       Shift F2  f1  CNT ALT BRK CLR ENT
; 5        ?/   >/. =/- </, +/; */: )/9 (/8
; 4        '/7  &/6 %/5 $/4 #/3 "/2 !/1  0 
; 3        SPC  RGT LFT DN  UP   Z   Y   Z
; 2         W    V   U   T   S   R   Q   P
; 1         O    N   M   L   K   J   I   H
; 0         G    F   E   D   C   B   A   @
; $FF00

IN_key
    ldx     #$FF00  ; get the Row Value
IN_Loop
; Look for Space Bar 
    lda     #%01111111  ; get the Column Value Bit 7 '7F'
    sta     2,X         ; store the Column Value
    lda     ,X          ; get the Row Value
    bita    #%00001000  ; test bit 3 for space bar
    beq     IN_Found_SP ; loop if space bar not pressed

; Look for 'C'
    lda     #%11110111  ; get the Column Value Bit 3 'F7'
    sta     2,X         ; store the Column Value
    lda     ,X          ; get the Row Value
    coma                ; invert the Column Value
    anda    #%00000001  ; test bit 0 for 'C'
    bne     IN_Found_C  ; loop if 'C' not pressed

; Look For 'Q'
    lda     #%11111101  ; get the Column Value Bit 1 'FD'
    sta     2,X         ; store the Column Value
    lda     ,X          ; get the Row Value
    coma                ; invert the Column Value
    anda    #%00000100  ; test bit 6 for 'Q'
    bne     IN_Found_Q  ; loop if 'Q' not pressed

;------------------------------------------------------------------------------
    bra     IN_Loop     ; loop if not found

; Georges Code Examples
IN_Found_SP
    lda     #'S 
    sta     $0408
    bra     Found_Exit

IN_Found_C
    lda     #'C
    sta     $0407
    bra     Found_Exit

IN_Found_Q
    lda     #'Q
    sta     $0406
    inc     SW          ; set SW to exit loop
    bra     Found_Exit


Found_Exit
    rts                 ; return back to calling routine

;------------------------------------------------------------------------------
; End of File
   end  start
