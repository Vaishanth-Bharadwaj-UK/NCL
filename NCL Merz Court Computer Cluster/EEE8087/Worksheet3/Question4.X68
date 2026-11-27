*-----------------------------------------------------------
* Written by : Vaishanth Bharadwaj
* Description: EEE8087
*-----------------------------------------------------------

START	ORG	$1000

    OR  #$0700,SR
    
    MOVE    #LIST,A0
    MOVE    #15,D0
    MOVE #ARRAY,A3
GENERATE
    MOVE    (A3),val(A0)
    MOVE    A0,D2
    ADD.L #reclen,D2
    MOVE    D2,adr(A0)
    ADD #$2,A3
    ADD #reclen,A0
    SUB #$1,D0
    BNE GENERATE
    MOVE    (A3),val(A0)
    MOVE    #LIST,adr(A0)

    MOVE.L  #X,A0
    MOVE.L  #X,A1
    MOVE.L  #LIST,A2
    MOVE.L  #SEG_DAT,D1

    AND #$F8FF,SR
    
SW_PRESSED
    MOVE.B  SW,D0
    AND.L #$1,D0
    BNE SW_PRESSED
    
WAIT
    MOVE  COUNT,D0
    BEQ WAIT

    MOVE  (A0),A3
    ADD   D1,A3
    MOVE.B  (A3),SEG_LED
    ADD   #$2,A0
    
    OR  #$0700,SR
    MOVE  COUNT,D0
    SUB   #$1,D0
    MOVE  D0,COUNT
    AND #$F8FF,SR
    
SW_RELEASED
    MOVE.B  SW,D0
    AND.L #$1,D0
    BEQ SW_RELEASED
    
    BRA SW_PRESSED
    
ISR
    SUB.L   #$4,SP
    MOVE.L  D0,(SP)
    
    MOVE  val(A2),D0
    MOVE  adr(A2),A2
    MOVE  D0,(A1)
    ADD   #$2,A1
    MOVE  COUNT,D0
    ADD   #$1,D0
    MOVE  D0,COUNT
    
    MOVE.L  (SP),D0
    ADD.L   #$4,SP
    RTE

	SIMHALT

SW  EQU $E00014
SEG_LED EQU $E0000E

    ORG $64
IVEC    DC.L    ISR

    ORG $2000
LIST    DS    12
val EQU 0
adr EQU 2
reclen  EQU 4

    ORG $2100
ARRAY   DC  $0,$1,$2,$3,$4,$5,$6,$7,$8,$9,$A,$B,$C,$D,$E,$F

    ORG $2500
COUNT   DC    0
X   DS    100

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
    
	END	START
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
