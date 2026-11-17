*-----------------------------------------------------------
* Written by : Vaishanth Bharadwaj
* Description: EEE8087
*-----------------------------------------------------------

START	ORG	$1000

    MOVE    #recary,A0
    MOVE    #array,A1
    MOVE    #5,D1
LOOP1
    MOVE    (A1),val(A0)
    ADD #2,A1
    MOVE    A0,D0
    ADD #reclen,D0
    MOVE    D0,adr(A0)
    ADD #reclen,A0
    SUB #1,D1
    BNE LOOP1
    MOVE    (A1),val(A0)
    MOVE    #0000,adr(A0)
    
	SIMHALT

    ORG $2000
recary  ds  12
val EQU 0
adr EQU 2
reclen  EQU 4
    ORG $2500
array   DC  3,4,1,2,6,5

	END	START
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
