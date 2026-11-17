*-----------------------------------------------------------
* Written by : Vaishanth Bharadwaj
* Description: EEE8087
*-----------------------------------------------------------

START	ORG	$1000

    MOVE    #5,$2000
    MOVE    #6,$2002
    MOVE    $2000,D0
    SUB $2002,D0
    BMI small1
    MOVE    $2000,D0
    MOVE    D0,$2004
    BRA next1
small1
    MOVE    $2002,D0
    MOVE    D0,$2004
next1

    MOVE    #5,$2006
    MOVE    #6,$2008
    MOVE    $2006,D0
    SUB $2008,D0
    BPL big1
    MOVE    $2008,D0
    MOVE    D0,$200A
    BRA next2
big1
    MOVE    $2006,D0
    MOVE    D0,$200A
next2

    MOVE    #5,$200C
    MOVE    #4,$200E
    MOVE    $200C,D0
    SUB $200E,D0
    BMI small2
    MOVE    $200C,D0
    MOVE    D0,$2010
    BRA next3
small2
    MOVE    $200E,D0
    MOVE    D0,$2010
next3

    MOVE    #5,$2012
    MOVE    #4,$2014
    MOVE    $2012,D0
    SUB $2014,D0
    BPL big2
    MOVE    $2014,D0
    MOVE    D0,$2016
    BRA next4
big2
    MOVE    $2012,D0
    MOVE    D0,$2016
next4

	SIMHALT



	END	START
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
