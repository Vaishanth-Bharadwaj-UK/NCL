*-----------------------------------------------------------
* Written by : Vaishanth Bharadwaj
* Description: EEE8087
*-----------------------------------------------------------

START   ORG $1000

INIT
    MOVE.L    #SEG_DAT,A0
    MOVE.B  (A0),D0
    MOVE.B    D0,SEG_LED
    MOVE.L    #FLAG,A1
    MOVE.L  #$0000,(A1)

    OR  #$0700,SR

SW_START
    MOVE.B  SW,D0
    AND.L #$1,D0
    BNE SW_START

    AND #$F8FF,SR

TIMER_RUN
    MOVE.B  SW,D0
    AND.L #$2,D0
    BEQ STOP_TIMER
    MOVE.L    (A1),D0
    BEQ TIMER_RUN
    MOVE.B  (A0),D0
    MOVE.B    D0,SEG_LED
    ADD.L   #$1,A0
    CMP.L #$67,D0
    BEQ STOP_TIMER
    MOVE.L    #$0000,(A1)
    BRA TIMER_RUN

STOP_TIMER
    MOVE.B  SW,D0
    AND.L #$4,D0
    BNE STOP_TIMER
    BRA INIT

ISR
    MOVE.L    #$1,(A1)
    RTE

    SIMHALT
    
SW  EQU $E00014
SEG_LED EQU $E0000E

    ORG $64
IVEC    DC.L    ISR

    ORG $2000
FLAG    DS.L    $01
SEG_DAT DC.B    $3F
    DC.B    $06
    DC.B    $5B
    DC.B    $4F
    DC.B    $66
    DC.B    $6D
    DC.B    $7D
    DC.B    $07
    DC.B    $7F
    DC.B    $67
    DC.B    $77
    DC.B    $7C
    DC.B    $39
    DC.B    $5E
    DC.B    $79
    DC.B    $71
    DC.B    $80

    ORG $64
IVEC    DC.L    ISR

	END	START



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
