*-----------------------------------------------------------
* Written by : Vaishanth Bharadwaj
* Description: EEE8087
*-----------------------------------------------------------

START	ORG	$1000

    MOVE    x,$2000
    MOVE    y,$2002
    MOVE    z,$2006
    MOVE    $2002,D0
    CMP $2000,D0
    BEQ  equal1
    MOVE    #$0,$2004
    BRA next1
equal1   MOVE    #$1,$2004
next1

    MOVE    $2006,D0
    CMP $2000,D0
    BEQ  equal2
    MOVE    #$0,$2004
    BRA next2
equal2   MOVE    #$1,$2008
next2

	SIMHALT

x   DC  1
y   DC  2
z   DC  1

	END	START


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
