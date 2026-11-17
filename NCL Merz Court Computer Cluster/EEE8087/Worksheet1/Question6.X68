*-----------------------------------------------------------
* Written by : Vaishanth Bharadwaj
* Description: EEE8087
*-----------------------------------------------------------

START	ORG	$1000

    MOVE    #$FF0F,$2000
    MOVE    $2000,D0
    MOVE    #$0,D1
    MOVE    #$10,D2
LOOP1
    LSL #1,D0
    BCC none
    ADD #$1,D1
none
    SUB #$1,D2
    BNE LOOP1
    MOVE D1,$2004

    MOVE    #$FF0F,$2000
    MOVE    $2000,D0
    MOVE    #$0,D1
    MOVE    #$10,D2
LOOP2
    LSL #1,D0
    BCS one
    SUB #$1,D2
    BNE LOOP2
    BRA next
one
    ADD #$1,D1
    SUB #$1,D2
    BNE LOOP2
next
    MOVE D1,$2006

	SIMHALT



	END	START
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
