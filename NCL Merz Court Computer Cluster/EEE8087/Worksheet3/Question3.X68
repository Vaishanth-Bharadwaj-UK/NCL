*-----------------------------------------------------------
* Written by : Vaishanth Bharadwaj
* Description: EEE8087
*-----------------------------------------------------------

START	ORG	$1000

LOOP

    MOVE.L    X,D0
    ADD.L   #$1,D0
    MOVE.L  D0,X
    
    OR  #$0700,SR
    MOVE.L    Z,D0
    ADD.L   #$1,D0
    MOVE.L  D0,Z
    AND  #$F8FF,SR
    
    BRA LOOP

ISR
    SUB.L   #$4,SP
    MOVE.L  D0,(SP)
    
    MOVE.L    Y,D0
    ADD.L   #$1,D0
    MOVE.L  D0,Y
    MOVE.L    Z,D0
    ADD.L   #$1,D0
    MOVE.L  D0,Z
    
    MOVE.L  (SP),D0
    ADD.L   #$4,SP
    RTE

	SIMHALT

    ORG $64
IVEC    DC.L    ISR

    ORG $2000
X   DC.L    0
Y   DC.L    0
Z   DC.L    0

	END	START

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
