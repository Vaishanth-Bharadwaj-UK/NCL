*-----------------------------------------------------------
* Written by : Vaishanth Bharadwaj
* Description: EEE8087
*-----------------------------------------------------------

START	ORG	$1000

    MOVE    #recary,A0
    MOVE    #recary_org,A1
    MOVE    #$5,D0
    MOVE #array,A3
GENERATE
    MOVE    (A3),val(A0)
    MOVE    A0,D2
    ADD #reclen,D2
    MOVE    D2,adr(A0)
    MOVE    (A3),val(A1)
    MOVE    A1,D2
    ADD #reclen,D2
    MOVE    D2,adr(A1)
    ADD #$2,A3
    ADD #reclen,A0
    ADD #reclen,A1
    SUB #$1,D0
    BNE GENERATE
    MOVE    (A3),val(A0)
    MOVE    (A3),val(A1)
    MOVE    #$0000,adr(A0)
    MOVE    #$0000,adr(A1)

    MOVE    #recary,A0

    MOVE    #recary_org,A1
    MOVE    #$5,D0
BUBBLE_SORT_OUTER
    MOVE    D0,D1
    MOVE    #recary_org,A1
BUBBLE_SORT_INNER
    MOVE    val(A1),D2
    MOVE    adr(A1),A2
    MOVE    val(A2),D3
    CMP D2,D3
    BGT NO_SWAP
    MOVE    D3,val(A1)
    MOVE    D2,val(A2)
NO_SWAP   
    MOVE    adr(A1),A1
    SUB #$1,D1
    BNE BUBBLE_SORT_INNER
    SUB #$1,D0
    BNE BUBBLE_SORT_OUTER
    
	SIMHALT

    ORG $2000
recary  ds  12
val EQU 0
adr EQU 2
reclen  EQU 4
    ORG $2020
recary_org  ds  12
val_org EQU 0
adr_org EQU 2
reclen_org  EQU 4
    ORG $2200
rec_offset  EQU reclen_org-reclen
    ORG $2500
array   DC  4,7,3,1,9,2

	END	START



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
