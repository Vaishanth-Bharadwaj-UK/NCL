*-----------------------------------------------------------
* Written by : Vaishanth Bharadwaj
* Description: EEE8087
*-----------------------------------------------------------

START	ORG	$1000

    MOVE.L    #SEG_DAT,A0
    MOVE.B  (A0),D0
    MOVE.B    D0,SEG_LED
SW_PRESSED
    MOVE.B  SW,D0
    AND.L #$1,D0
    BNE SW_PRESSED

    MOVE.B    (A0),D0
    ADD.L #$1,A0
    MOVE.B  D0,SEG_LED
    CMP.B #$80,(A0)
    BNE SW_RELEASED
    MOVE.L    #SEG_DAT,A0

SW_RELEASED
    MOVE.B  SW,D0
    AND.L #$1,D0
    BEQ SW_RELEASED

    BRA SW_PRESSED

	SIMHALT

SW  EQU $E00014
SEG_LED EQU $E0000E
SEG_DAT DC.B    $3F
    DC.B    $06
    DC.B    $5B
    DC.B    $4F
    DC.B    $66
    DC.B    $6D
    DC.B    $7D
    DC.B    $07
    DC.B    $7F
    DC.B    $67
    DC.B    $77
    DC.B    $7C
    DC.B    $39
    DC.B    $5E
    DC.B    $79
    DC.B    $71
    DC.B    $80

	END	START
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
