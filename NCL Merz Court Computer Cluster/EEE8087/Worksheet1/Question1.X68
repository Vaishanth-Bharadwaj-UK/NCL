*-----------------------------------------------------------
* Written by : Vaishanth Bharadwaj
* Description: EEE8087
*-----------------------------------------------------------

START	ORG	$1000

    MOVE    $2000,D0
    MOVE    D0,$2002
    
    MOVE    #$0000,$2004
    MOVE    $2004,D0
    MOVE    D0,$2006

    MOVE    #$0001,$2008
    MOVE    $2008,D0
    MOVE    D0,$200A

	SIMHALT



	END	START


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
