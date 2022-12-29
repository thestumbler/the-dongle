            processor p12f629
            radix dec

            include p12f629.inc

; The recognition of labels and registers is not always good, therefore
; be treated cautiously the results.

            CONFIG      FOSC  = INTRCIO
            CONFIG      WDTE  = ON
            CONFIG      PWRTE = ON
            CONFIG      MCLRE = ON
            CONFIG      BOREN = ON
            CONFIG      CP    = OFF
            CONFIG      CPD   = OFF

            __idlocs 0x0103


;===============================================================================
; I/O pins
; pin 5    GP2     LED
; pin 2    GP5     UART IN
; pin 3    GP4     UART OUT

; Messages:
;
; msg_000   sends: ?30
; msg_001   sends: 259000059
; msg_002   sends: 256000056
; msg_003   sends: 1280129
; msg_004   sends: ~OK

;===============================================================================
; DATA address definitions

Common_RAM  equ         0x0020                                              ; size: 64 bytes

; RAM Memory and guesses of variables within
;
; Usage     Offset from 0x20
; 17        0x01        1     counter
;  1        0x04        4
;  1        0x05        5
;  9        0x0a        10
;  4        0x0b        11
;  7        0x0c        12
;  2        0x0e        14
;  7        0x0f        15
;  1        0x10        16
;  1        0x12        18
; 24        0x22        34
; 10        0x23        35    outgoing serial character
;  2        0x24        36
;  4        0x25        37
;  3        0x26        38    incoming serial character


;===============================================================================
; CODE area

            ; code
            org         __CODE_START                                                    ; address: 0x0000

vect_rst:   movlw       0x00
            movwf       PCLATH                                                          ; reg: 0x00a
            goto        vector_int
            nop

vect_int:   call        func_008
            bsf         STATUS, RP0                                         ; reg: 0x003, bit: 5
            movwf       OSCCAL                                              ; reg: 0x090
            movlw       0x00
            movwf       PCLATH                                              ; reg: 0x00a
            goto        main


msg_000:    bcf         PCLATH, 0x0                                         ; reg: 0x00a
            bcf         PCLATH, 0x1                                         ; reg: 0x00a
            bcf         PCLATH, 0x2                                         ; reg: 0x00a
            addwf       PCL, F                                              ; reg: 0x002
            retlw       0x3f
            retlw       0x33
            retlw       0x30
            retlw       0x0d
            retlw       0x0a
            retlw       0x00

msg_001:    bcf         PCLATH, 0x0                                         ; reg: 0x00a
            bcf         PCLATH, 0x1                                         ; reg: 0x00a
            bcf         PCLATH, 0x2                                         ; reg: 0x00a
            addwf       PCL, F                                              ; reg: 0x002
            retlw       0x32
            retlw       0x35
            retlw       0x39
            retlw       0x30
            retlw       0x30
            retlw       0x30
            retlw       0x30
            retlw       0x35
            retlw       0x39
            retlw       0x0d
            retlw       0x0a
            retlw       0x00

msg_002:    bcf         PCLATH, 0x0                                         ; reg: 0x00a
            bcf         PCLATH, 0x1                                         ; reg: 0x00a
            bcf         PCLATH, 0x2                                         ; reg: 0x00a
            addwf       PCL, F                                              ; reg: 0x002
            retlw       0x32
            retlw       0x35
            retlw       0x36
            retlw       0x30
            retlw       0x30
            retlw       0x30
            retlw       0x30
            retlw       0x35
            retlw       0x36
            retlw       0x0d
            retlw       0x0a
            retlw       0x00

msg_003:    bcf         PCLATH, 0x0                                         ; reg: 0x00a
            bcf         PCLATH, 0x1                                         ; reg: 0x00a
            bcf         PCLATH, 0x2                                         ; reg: 0x00a
            addwf       PCL, F                                              ; reg: 0x002
            retlw       0x31
            retlw       0x32
            retlw       0x38
            retlw       0x30
            retlw       0x31
            retlw       0x32
            retlw       0x39
            retlw       0x0d
            retlw       0x0a
            retlw       0x00

msg_004:    bcf         PCLATH, 0x0                                         ; reg: 0x00a
            bcf         PCLATH, 0x1                                         ; reg: 0x00a
            bcf         PCLATH, 0x2                                         ; reg: 0x00a
            addwf       PCL, F                                              ; reg: 0x002
            retlw       0x7e
            retlw       0x4f
            retlw       0x4b
            retlw       0x0d
            retlw       0x0a
            retlw       0x00




; ========================================================================
; LED INIT CODE
; ========================================================================
init_sys:   movlw       0x0d
            movwf       Common_RAM                                          ; reg: 0x020
            clrf        TMR0                                                ; reg: 0x001
            movlw       0x81
            movwf       FSR                                                 ; reg: 0x004
            bcf         STATUS, IRP                                         ; reg: 0x003, bit: 7
            movf        INDF, W                                             ; reg: 0x000
            andlw       0xf0
            iorlw       0x07
            movwf       INDF                                                ; reg: 0x000
            clrwdt
            movf        INDF, W                                             ; reg: 0x000
            andlw       0xf7
            btfsc       Common_RAM, 0x3                                     ; reg: 0x020
            andlw       0xf0
            iorwf       Common_RAM, W                                       ; reg: 0x020
            movwf       INDF                                                ; reg: 0x000
            clrwdt
            bsf         STATUS, RP0                                         ; reg: 0x003, bit: 5
            bcf         TRISIO, TRISIO2                                     ; reg: 0x085, bit: 2
            bcf         STATUS, RP0                                         ; reg: 0x003, bit: 5
            bsf         GPIO, GP2                                           ; reg: 0x005, bit: 2
            goto        lbl_024



sleep2x:    movlw       0x43   ; sleeps 2 ms * value in (Common_RAM+0x23)
            movwf       FSR                                                 ; reg: 0x004
            bcf         STATUS, IRP                                         ; reg: 0x003, bit: 7
            movf        INDF, W                                             ; reg: 0x000
            btfsc       STATUS, Z                                           ; reg: 0x003, bit: 2
            goto        lbl_007
lbl_003:    movlw       0x01
            movwf       (Common_RAM + 1)                                    ; reg: 0x021
lbl_004:    movlw       0xbf
            movwf       Common_RAM                                          ; reg: 0x020
lbl_005:    clrwdt
            decfsz      Common_RAM, F                                       ; reg: 0x020
            goto        lbl_005
            decfsz      (Common_RAM + 1), F                                 ; reg: 0x021
            goto        lbl_004
            movlw       0x4a
            movwf       Common_RAM                                          ; reg: 0x020
lbl_006:    decfsz      Common_RAM, F                                       ; reg: 0x020
            goto        lbl_006
            nop
            clrwdt
            decfsz      INDF, F                                             ; reg: 0x000
            goto        lbl_003
lbl_007:    return



; ========================================================================
; SERIAL OUT
; bit-banging at 9600 baud
; sends Common_RAM + 35
; uses Common_RAM + 1 as bit counter and flags for loop control
; ========================================================================
uart_out:   bsf         STATUS, RP0                                         ; reg: 0x003, bit: 5 (was func_006)
            bcf         TRISIO, TRISIO4                                     ; reg: 0x085, bit: 4
            bcf         STATUS, RP0                                         ; reg: 0x003, bit: 5
            bcf         GPIO, GP4                                           ; reg: 0x005, bit: 4
            movlw       0x08
            movwf       (Common_RAM + 1)                                    ; reg: 0x021
            goto        lbl_008
lbl_008:    nop
            bsf         (Common_RAM + 1), 0x7                               ; reg: 0x021
            goto        lbl_013
lbl_009:    bcf         (Common_RAM + 1), 0x7                               ; reg: 0x021
lbl_010:    rrf         (Common_RAM + 35), F                                ; reg: 0x043
            btfsc       STATUS, C                                           ; reg: 0x003, bit: 0
            bsf         GPIO, GP4                                           ; reg: 0x005, bit: 4
            btfss       STATUS, C                                           ; reg: 0x003, bit: 0
            bcf         GPIO, GP4                                           ; reg: 0x005, bit: 4
            bsf         (Common_RAM + 1), 0x6                               ; reg: 0x021
            goto        lbl_013
lbl_011:    bcf         (Common_RAM + 1), 0x6                               ; reg: 0x021
            decfsz      (Common_RAM + 1), F                                 ; reg: 0x021
            goto        lbl_010
            goto        lbl_012
lbl_012:    nop
            bsf         GPIO, GP4                                           ; reg: 0x005, bit: 4
lbl_013:    movlw       0x1c ; loops 0x1c, FSR just used for looping, not FSR access
            movwf       FSR                                                             ; reg: 0x004
lbl_014:    decfsz      FSR, F                                                          ; reg: 0x004
            goto        lbl_014 ; 0x1c = 28 * 3 cycles = 86 us
            nop
            clrwdt
            btfsc       (Common_RAM + 1), 0x7                               ; reg: 0x021
            goto        lbl_009
            btfsc       (Common_RAM + 1), 0x6                               ; reg: 0x021
            goto        lbl_011
            return

; ========================================================================
; SERIAL IN?
; bit-banging at 9600 baud
; builds in  Common_RAM + 38
; returns Common_RAM + 1
; uses Common_RAM + 0 as bit counter and flags for loop control
; ========================================================================
uart_in:    bsf         STATUS, RP0                                         ; reg: 0x003, bit: 5 (was func_007)
            bsf         TRISIO, TRISIO5                                     ; reg: 0x085, bit: 5
lbl_015:    clrwdt
            bcf         STATUS, RP0                                         ; reg: 0x003, bit: 5
            btfss       GPIO, GP5                                           ; reg: 0x005, bit: 5
            goto        lbl_016
            bsf         STATUS, RP0                                         ; reg: 0x003, bit: 5
            goto        lbl_015
lbl_016:    movlw       0x08
            movwf       Common_RAM                                          ; reg: 0x020
            clrf        (Common_RAM + 38)                                   ; reg: 0x046
            bsf         Common_RAM, 0x7                                     ; reg: 0x020
            goto        lbl_020
lbl_017:    bcf         Common_RAM, 0x7                                     ; reg: 0x020
            goto        lbl_020
lbl_018:    bcf         STATUS, C                                           ; reg: 0x003, bit: 0
            btfsc       GPIO, GP5                                           ; reg: 0x005, bit: 5
            bsf         STATUS, C                                           ; reg: 0x003, bit: 0
            rrf         (Common_RAM + 38), F                                ; reg: 0x046
            bsf         Common_RAM, 0x6                                     ; reg: 0x020
            goto        lbl_020
lbl_019:    bcf         Common_RAM, 0x6                                     ; reg: 0x020
            decfsz      Common_RAM, F                                       ; reg: 0x020
            goto        lbl_018
            movf        (Common_RAM + 38), W                                ; reg: 0x046
            movwf       (Common_RAM + 1)                                    ; reg: 0x021
            goto        lbl_022
lbl_020:    movlw       0x1c
            btfsc       Common_RAM, 0x7                                     ; reg: 0x020
            movlw       0x07
            movwf       (Common_RAM + 1)                                    ; reg: 0x021
lbl_021:    decfsz      (Common_RAM + 1), F                                 ; reg: 0x021
            goto        lbl_021
            nop
            btfsc       Common_RAM, 0x7                                     ; reg: 0x020
            goto        lbl_017
            btfsc       Common_RAM, 0x6                                     ; reg: 0x020
            goto        lbl_019
            goto        lbl_018
lbl_022:    return


;========================================================================
; MAIN?
;========================================================================
main:       bsf         STATUS, RP0                                         ; reg: 0x003, bit: 5
            bcf         TRISIO, TRISIO4                                     ; reg: 0x085, bit: 4
            bcf         STATUS, RP0                                         ; reg: 0x003, bit: 5
            bsf         GPIO, GP4                                           ; reg: 0x005, bit: 4
            clrf        (Common_RAM + 10)                                   ; reg: 0x02a
            movlw       0x07
            movwf       CMCON                                                           ; reg: 0x019
            clrf        (Common_RAM + 4)                            ; reg: 0x024
            clrf        (Common_RAM + 5)                            ; reg: 0x025
            goto        init_sys

; Delay for 1274 x 2 ms = 2.55 seconds
lbl_024:    clrwdt
            movlw       0x04
            movwf       (Common_RAM + 34)                                   ; reg: 0x042
lbl_025:    movlw       0xfa
            movwf       (Common_RAM + 35)                                   ; reg: 0x043
            call        sleep2x
            decfsz      (Common_RAM + 34), F                                ; reg: 0x042
            goto        lbl_025

            bsf         STATUS, RP0                                         ; reg: 0x003, bit: 5
            clrf        EEADR                                                           ; reg: 0x09b
            bcf         EECON1, 0x7                                         ; reg: 0x09c
            bsf         EECON1, RD                                          ; reg: 0x09c, bit: 0
            movf        EEDAT, W                                    ; reg: 0x09a
            bcf         STATUS, RP0                                         ; reg: 0x003, bit: 5
            movwf       (Common_RAM + 14)                                   ; reg: 0x02e


lbl_026:    movf        (Common_RAM + 10), W                                ; reg: 0x02a
            addlw       0xfc
            btfsc       STATUS, C                                           ; reg: 0x003, bit: 0
            goto        lbl_057

            addlw       0x04
            goto        lbl_058

lbl_027:    clrf        (Common_RAM + 34)                                   ; reg: 0x042
lbl_028:    movf        (Common_RAM + 34), W                                ; reg: 0x042
            call        msg_000
            incf        (Common_RAM + 34), F                                ; reg: 0x042
            movwf       Common_RAM                                          ; reg: 0x020
            movwf       (Common_RAM + 35)                                   ; reg: 0x043
            call        uart_out
            movlw       0x05
            subwf       (Common_RAM + 34), W                                ; reg: 0x042
            btfss       STATUS, Z                                           ; reg: 0x003, bit: 2
            goto        lbl_028
            call        uart_in
            movf        (Common_RAM + 1), W                                 ; reg: 0x021
            movwf       (Common_RAM + 15)                                   ; reg: 0x02f
            movf        (Common_RAM + 15), W                                ; reg: 0x02f

            sublw       0x33
            btfss       STATUS, Z                                           ; reg: 0x003, bit: 2
            goto        lbl_029
            movlw       0x0c
            movwf       (Common_RAM + 12)                                   ; reg: 0x02c
            movf        (Common_RAM + 14), W                                ; reg: 0x02e
            sublw       0xab
            btfss       STATUS, Z                                           ; reg: 0x003, bit: 2
            clrf        (Common_RAM + 12)                                   ; reg: 0x02c
            goto        lbl_031

lbl_029:    movf        (Common_RAM + 15), W                                ; reg: 0x02f
            sublw       0x7e
            btfss       STATUS, Z                                           ; reg: 0x003, bit: 2
            goto        lbl_030
            movlw       0x02
            movwf       (Common_RAM + 12)                                   ; reg: 0x02c
            goto        lbl_031

lbl_030:    clrf        (Common_RAM + 12)                                   ; reg: 0x02c

lbl_031:    movlw       0x01
            movwf       (Common_RAM + 11)                                   ; reg: 0x02b

lbl_032:    movf        (Common_RAM + 12), W                                ; reg: 0x02c
            subwf       (Common_RAM + 11), W                                ; reg: 0x02b
            btfsc       STATUS, C                                           ; reg: 0x003, bit: 0
            goto        lbl_033
            movlw       0x2f
            addwf       (Common_RAM + 11), W                                ; reg: 0x02b
            movwf       FSR                                                             ; reg: 0x004
            bcf         STATUS, IRP                                         ; reg: 0x003, bit: 7
            clrf        (Common_RAM + 37)                                   ; reg: 0x045
            movf        FSR, W                                                          ; reg: 0x004
            movwf       (Common_RAM + 36)                                   ; reg: 0x044
            bcf         (Common_RAM + 37), 0x0                              ; reg: 0x045
            btfsc       STATUS, IRP                                         ; reg: 0x003, bit: 7
            bsf         (Common_RAM + 37), 0x0                              ; reg: 0x045

            call        uart_in
            movf        (Common_RAM + 36), W                                ; reg: 0x044
            movwf       FSR                                                             ; reg: 0x004
            bcf         STATUS, IRP                                         ; reg: 0x003, bit: 7
            btfsc       (Common_RAM + 37), 0x0                              ; reg: 0x045
            bsf         STATUS, IRP                                         ; reg: 0x003, bit: 7
            movf        (Common_RAM + 1), W                                 ; reg: 0x021
            movwf       INDF                                                            ; reg: 0x000
            incf        (Common_RAM + 11), F                                ; reg: 0x02b
            goto        lbl_032

lbl_033:    movf        (Common_RAM + 12), W                                ; reg: 0x02c
            sublw       0x0c
            btfss       STATUS, Z                                           ; reg: 0x003, bit: 2
            goto        lbl_034
            movlw       0x01
            movwf       (Common_RAM + 10)                                   ; reg: 0x02a
            goto        lbl_036


lbl_034:    movf        (Common_RAM + 12), W                                ; reg: 0x02c
            sublw       0x02
            btfss       STATUS, Z                                           ; reg: 0x003, bit: 2
            goto        lbl_035
            movlw       0x02
            movwf       (Common_RAM + 10)                                   ; reg: 0x02a
            goto        lbl_036

lbl_035:    movlw       0x03
            movwf       (Common_RAM + 10)                                   ; reg: 0x02a


lbl_036:    goto        lbl_057 ; back to msg000 prompt


lbl_037:    movf        (Common_RAM + 18), W                                ; reg: 0x032
            sublw       0x44
            btfss       STATUS, Z                                           ; reg: 0x003, bit: 2
            goto        lbl_039
            clrf        (Common_RAM + 34)                                   ; reg: 0x042
lbl_038:    movf        (Common_RAM + 34), W                                ; reg: 0x042
            call        msg_001
            incf        (Common_RAM + 34), F                                ; reg: 0x042
            movwf       Common_RAM                                          ; reg: 0x020
            movwf       (Common_RAM + 35)                                   ; reg: 0x043
            call        uart_out
            movlw       0x0b
            subwf       (Common_RAM + 34), W                                ; reg: 0x042
            btfss       STATUS, Z                                           ; reg: 0x003, bit: 2
            goto        lbl_038
            goto        lbl_041
lbl_039:    clrf        (Common_RAM + 34)                                   ; reg: 0x042
lbl_040:    movf        (Common_RAM + 34), W                                ; reg: 0x042
            call        msg_002
            incf        (Common_RAM + 34), F                                ; reg: 0x042
            movwf       Common_RAM                                          ; reg: 0x020
            movwf       (Common_RAM + 35)                                   ; reg: 0x043
            call        uart_out
            movlw       0x0b
            subwf       (Common_RAM + 34), W                                ; reg: 0x042
            btfss       STATUS, Z                                           ; reg: 0x003, bit: 2
            goto        lbl_040
lbl_041:    movf        (Common_RAM + 10), W                                ; reg: 0x02a
            sublw       0x03
            btfsc       STATUS, Z                                           ; reg: 0x003, bit: 2
            goto        lbl_048
            call        uart_in
            movf        (Common_RAM + 1), W                                 ; reg: 0x021
            movwf       (Common_RAM + 15)                                   ; reg: 0x02f
            movf        (Common_RAM + 15), W                                ; reg: 0x02f
            sublw       0x4f
            btfss       STATUS, Z                                           ; reg: 0x003, bit: 2
            goto        lbl_047
            movlw       0x64
            movwf       (Common_RAM + 35)                                   ; reg: 0x043
            call        sleep2x
            clrf        (Common_RAM + 34)                                   ; reg: 0x042
lbl_042:    movf        (Common_RAM + 34), W                                ; reg: 0x042
            call        msg_003
            incf        (Common_RAM + 34), F                                ; reg: 0x042
            movwf       Common_RAM                                          ; reg: 0x020
            movwf       (Common_RAM + 35)                                   ; reg: 0x043
            call        uart_out
            movlw       0x09
            subwf       (Common_RAM + 34), W                                ; reg: 0x042
            btfss       STATUS, Z                                           ; reg: 0x003, bit: 2
            goto        lbl_042
            call        uart_in
            movf        (Common_RAM + 1), W                                 ; reg: 0x021
            movwf       (Common_RAM + 15)                                   ; reg: 0x02f
            movf        (Common_RAM + 15), W                                ; reg: 0x02f
            sublw       0x4f
            btfss       STATUS, Z                                           ; reg: 0x003, bit: 2
            goto        lbl_045
            movf        INTCON, W                                           ; reg: 0x00b
            movwf       Common_RAM                                          ; reg: 0x020
            bcf         INTCON, GIE                                         ; reg: 0x00b, bit: 7
            bsf         STATUS, RP0                                         ; reg: 0x003, bit: 5
            clrf        EEADR                                                           ; reg: 0x09b
            movlw       0xde
            movwf       EEDAT                                                           ; reg: 0x09a
            bcf         EECON1, 0x7                                         ; reg: 0x09c
            bsf         EECON1, WREN                                                    ; reg: 0x09c, bit: 2
            movlw       0x55
            movwf       EECON2                                                          ; reg: 0x09d
            movlw       0xaa
            movwf       EECON2                                                          ; reg: 0x09d
            bsf         EECON1, WR                                          ; reg: 0x09c, bit: 1
lbl_043:    btfsc       0x1c, 0x1                                           ; reg: 0x01c
            goto        lbl_043
            bcf         0x1c, 0x2                                           ; reg: 0x01c
            bcf         STATUS, RP0                                         ; reg: 0x003, bit: 5
            movf        Common_RAM, W                                                   ; reg: 0x020
            iorwf       INTCON, F                                           ; reg: 0x00b
lbl_044:    bsf         STATUS, RP0                                         ; reg: 0x003, bit: 5
            bcf         TRISIO, TRISIO2                                                 ; reg: 0x085, bit: 2
            bcf         STATUS, RP0                                         ; reg: 0x003, bit: 5
            bcf         GPIO, GP2                                           ; reg: 0x005, bit: 2
            clrwdt
            goto        lbl_044
            goto        lbl_046
lbl_045:    movlw       0x03
            movwf       (Common_RAM + 10)                                   ; reg: 0x02a
lbl_046:    goto        lbl_048
lbl_047:    movlw       0x03
            movwf       (Common_RAM + 10)                                   ; reg: 0x02a
lbl_048:    goto        lbl_057
lbl_049:    movf        (Common_RAM + 16), W                                ; reg: 0x030
            sublw       0x54
            btfss       STATUS, Z                                           ; reg: 0x003, bit: 2
            goto        lbl_054
            clrf        (Common_RAM + 34)                                   ; reg: 0x042
lbl_050:    movf        (Common_RAM + 34), W                                ; reg: 0x042
            call        msg_004
            incf        (Common_RAM + 34), F                                ; reg: 0x042
            movwf       Common_RAM                                          ; reg: 0x020
            movwf       (Common_RAM + 35)                                   ; reg: 0x043
            call        uart_out
            movlw       0x05
            subwf       (Common_RAM + 34), W                                ; reg: 0x042
            btfss       STATUS, Z                                           ; reg: 0x003, bit: 2
            goto        lbl_050
            movf        INTCON, W                                           ; reg: 0x00b
            movwf       Common_RAM                                          ; reg: 0x020
            bcf         INTCON, GIE                                         ; reg: 0x00b, bit: 7
            bsf         STATUS, RP0                                         ; reg: 0x003, bit: 5
            clrf        EEADR                                                           ; reg: 0x09b
            movlw       0xab
            movwf       EEDAT                                                           ; reg: 0x09a
            bcf         EECON1, 0x7                                         ; reg: 0x09c
            bsf         EECON1, WREN                                                    ; reg: 0x09c, bit: 2
            movlw       0x55
            movwf       EECON2                                                          ; reg: 0x09d
            movlw       0xaa
            movwf       EECON2                                                          ; reg: 0x09d
            bsf         EECON1, WR                                          ; reg: 0x09c, bit: 1
lbl_051:    btfsc       0x1c, 0x1                                           ; reg: 0x01c
            goto        lbl_051
            bcf         0x1c, 0x2                                           ; reg: 0x01c
            bcf         STATUS, RP0                                         ; reg: 0x003, bit: 5
            movf        Common_RAM, W                                                   ; reg: 0x020
            iorwf       INTCON, F                                           ; reg: 0x00b
lbl_052:    bsf         STATUS, RP0                                         ; reg: 0x003, bit: 5
            bcf         TRISIO, TRISIO2                                                 ; reg: 0x085, bit: 2
            movlw       0x04
            bcf         STATUS, RP0                                         ; reg: 0x003, bit: 5
            xorwf       GPIO, F                                                         ; reg: 0x005
            movlw       0x02
            movwf       (Common_RAM + 34)                                   ; reg: 0x042
lbl_053:    movlw       0xfa movwf  (Common_RAM + 35)                                   ; reg: 0x043
            call        sleep2x
            decfsz      (Common_RAM + 34), F                                ; reg: 0x042
            goto        lbl_053
            goto        lbl_052
            goto        lbl_055
lbl_054:    movlw       0x03
            movwf       (Common_RAM + 10)                                   ; reg: 0x02a
lbl_055:    goto        lbl_057
lbl_056:    bsf         STATUS, RP0                                         ; reg: 0x003, bit: 5
            bcf         TRISIO, TRISIO2                                                 ; reg: 0x085, bit: 2
            movlw       0x04
            bcf         STATUS, RP0                                         ; reg: 0x003, bit: 5
            xorwf       GPIO, F                                                         ; reg: 0x005
            movlw       0x64
            movwf       (Common_RAM + 35)                                   ; reg: 0x043
            call        sleep2x
            goto        lbl_056
lbl_057:    goto        lbl_026
            sleep

lbl_058:    bsf         PCLATH, 0x0                                         ; reg: 0x00a
            bcf         PCLATH, 0x1                                         ; reg: 0x00a
            bcf         PCLATH, 0x2                                         ; reg: 0x00a
            addwf       PCL, F                                                          ; reg: 0x002
            goto        lbl_027
            goto        lbl_037
            goto        lbl_049
            goto        lbl_056

func_008:                                                                   ; address: 0x03ff

            retlw       0x44

;===============================================================================
; EEDATA area

            ; eeprom

            org         __EEPROM_START                                                  ; address: 0x2100

            db          0xde
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00
            db          0xff
            db          0x00

            end
