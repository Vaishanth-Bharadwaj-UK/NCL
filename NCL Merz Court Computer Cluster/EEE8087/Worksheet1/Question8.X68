*-----------------------------------------------------------
* Written by : Vaishanth Bharadwaj
* Description: EEE8087
*-----------------------------------------------------------

START	ORG	$1000

    MOVE    #$2000,A0
    MOVE    #$8,D1
LOOP1
    MOVE D1,(A0)
    ADDA #$2,A0
    SUB #$1,D1
    BNE LOOP1
    MOVE    #$2000,A0
    MOVE    #$2010,A1
    MOVE    #$8,D1
LOOP2
    MOVE    (A0)+,(A1)+
    SUB #$1,D1
    BNE LOOP2

	SIMHALT



	END	START
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
