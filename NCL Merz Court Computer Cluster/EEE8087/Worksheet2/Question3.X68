*-----------------------------------------------------------
* Written by : Vaishanth Bharadwaj
* Description: EEE8087
*-----------------------------------------------------------

START	ORG	$1000

INIT_START
    MOVE.L    #$0000,D2
    MOVE.L    #ORD,A0
    MOVE.B    D2,LED
SW_PRESSED
    MOVE.B  DONE,D3
    CMP.B   #$1,D3
    BEQ PLAYBACK
    MOVE.B  SW,D2
    CMP.B #$FF,D2
    BEQ SW_PRESSED

    EOR.B   #$FF,D2
    MOVE.B  D2,(A0)
    ADD.L   #$1,A0

SW_RELEASED
    MOVE.B  SW,D2
    CMP.B #$FF,D2
    BNE SW_RELEASED

    BRA SW_PRESSED

PLAYBACK
    MOVE.B    #$FF,(A0)
    MOVE.L    #ORD,A0
WAIT
    MOVE.L  #23,D0
    MOVE.B  #50,D1
    TRAP    #15
    MOVE.L    #$0000,D2
    MOVE.B    D2,LED
    MOVE.L  #23,D0
    MOVE    #50,D1
    TRAP    #15
NEXT_PLAY
    CMP.B #$FF,(A0)
    BEQ FIN_PLAY
    MOVE.B  (A0),LED
    MOVE.B  #$FF,(A0)
    ADD.L   #$1,A0
    BRA WAIT
FIN_PLAY
    MOVE.L    #$0000,D2
    MOVE.L    #ORD,A0
    MOVE.B    D2,LED
INIT
    MOVE.B  DONE,D3
    CMP.B   #$1,D3
    BEQ INIT
    BRA INIT_START

	SIMHALT

SW  EQU $E00014
LED EQU $E00010
DONE    EQU $E00012
ORD EQU $2500

	END	START
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
