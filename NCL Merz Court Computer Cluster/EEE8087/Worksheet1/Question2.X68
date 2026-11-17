*-----------------------------------------------------------
* Written by : Vaishanth Bharadwaj
* Description: EEE8087
*-----------------------------------------------------------

START	ORG	$1000

    MOVE    #5,$2000
    MOVE    #4,$2002
    MOVE    $2000,A0
    ADD $2002,A0
    MOVE    A0,$2004

    MOVE    #5,$2006
    MOVE    #-4,$2008
    MOVE    $2006,A0
    ADD $2008,A0
    MOVE    A0,$200A

	SIMHALT



	END	START

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
