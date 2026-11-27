*-----------------------------------------------------------
* Written by : Vaishanth Bharadwaj
* Description: EEE8087
*-----------------------------------------------------------

START   ORG $1000

    MOVE.L    #$0000,D0
    MOVE.L    D0,LED_STAT
    MOVE.B    D0,LED

FG_LOOP
    MOVE.L  LED_STAT,D0
    MOVE.B  D0,LED
    BRA FG_LOOP

ISR
    SUB.L   #$4,SP
    MOVE.L    D0,(SP)
    MOVE.L    LED_STAT,D0
    EOR.L #$1,D0
    MOVE.L    D0,LED_STAT
    MOVE.L    (SP),D0
    ADD.L   #$4,SP
    RTE

    SIMHALT
    
LED EQU $E00010

    ORG $2000
LED_STAT    DS.L  1

    ORG $64
IVEC    DC.L    ISR

	END	START




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
