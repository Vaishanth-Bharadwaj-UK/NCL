*-----------------------------------------------------------
* Written by : Vaishanth Bharadwaj
* Description: EEE8087
*-----------------------------------------------------------

START	ORG	$1000

    MOVE    #recary,A0
    MOVE    #$5,D0
    MOVE #array,A3
GENERATE
    MOVE    (A3),val(A0)
    MOVE    A0,D2
    ADD #reclen,D2
    MOVE    D2,adr(A0)
    ADD #$2,A3
    ADD #reclen,A0
    SUB #$1,D0
    BNE GENERATE
    MOVE    (A3),val(A0)
    MOVE    #$0000,adr(A0)

    MOVE    #recary,A2
    SUB #reclen,A2
    MOVE    #recary,adr(A2)

BUBBLE_SORT_INIT
    MOVE    #recary,A2
    SUB #reclen,A2
    MOVE    adr(A2),A0
    MOVE    adr(A0),A1
BUBBLE_SORT
    MOVE    val(A0),D1
    MOVE    val(A1),D2
    CMP D1,D2
    BGT NEXT_RUN
    MOVE    adr(A0),D3
    MOVE    adr(A1),D4
    MOVE    adr(A2),D5
    MOVE    D3,adr(A2)
    MOVE    D4,adr(A0)
    MOVE    D5,adr(A1)
    BRA BUBBLE_SORT_INIT
NEXT_RUN
    CMP #$0000,adr(A1)
    BEQ DONE
    MOVE    adr(A0),A0
    MOVE    adr(A1),A1
    MOVE    adr(A2),A2
    BRA BUBBLE_SORT
DONE
    MOVE    #recary,A0
    SUB #reclen,A0
    MOVE    adr(A0),D0
    MOVE    D0,A0
    MOVE    #recary_org,A1
LOOP_ORG
    MOVE    val(A0),D0
    MOVE    D0,(A1)
    ADD #$2,A1
    MOVE    adr(A0),D0
    MOVE    D0,A0
    BEQ FIN
    BRA LOOP_ORG
FIN
    MOVE    #recary,A0
    SUB #reclen,A0
    MOVE    adr(A0),D0
    MOVE    D0,A0
    MOVE    #recary_org,A1

	SIMHALT

    ORG $2000
recary  ds  12
val EQU 0
adr EQU 2
reclen  EQU 4
    ORG $2020
recary_org  ds  6
    ORG $2200
rec_offset  EQU recary_org-recary
    ORG $2500
array   DC  4,7,3,1,9,2

	END	START






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
