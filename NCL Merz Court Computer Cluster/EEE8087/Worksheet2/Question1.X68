*-----------------------------------------------------------
* Written by : Vaishanth Bharadwaj
* Description: EEE8087
*-----------------------------------------------------------

START	ORG	$1000

    MOVE    #$0000,D0
    MOVE    D0,D1
    MOVE.B    D0,LED
SW_PRESSED
    MOVE.B  SW,D0
    AND #$1,D0
    BNE SW_PRESSED

    MOVE    D1,D0
    EOR #$1,D0
    MOVE    D0,D1
    MOVE.B  D0,LED

SW_RELEASED
    MOVE.B  SW,D0
    AND #$1,D0
    BEQ SW_RELEASED

    BRA SW_PRESSED

	SIMHALT

SW  EQU $E00014
LED EQU $E00010

	END	START
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
