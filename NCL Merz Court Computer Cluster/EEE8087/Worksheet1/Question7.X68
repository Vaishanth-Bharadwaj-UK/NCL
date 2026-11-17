*-----------------------------------------------------------
* Written by : Vaishanth Bharadwaj
* Description: EEE8087
*-----------------------------------------------------------

START	ORG	$1000

    MOVE    #$8,$2000
    MOVE    $2000,D0
    LSR #$1,D0
    MOVE    D0,$2002
    LSR #$1,D0
    MOVE    D0,$2004

    MOVE    #-$8,$2006
    MOVE    $2006,D0
    ASR #$1,D0
    MOVE    D0,$2008
    ASR #$1,D0
    MOVE    D0,$200A


	SIMHALT



	END	START
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
