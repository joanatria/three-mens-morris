.MODEL SMALL
.STACK 500h
.DATA 

; TITLE SCREEN
GREETING DB  'Welcome to Isagani Game!$' 
START DB '1. Start Game$'
RULE DB '2. Game Rules$'
ESCP DB '3. Exit$'
OPTN DB 'Choose an option: $'
KEY DB 'Press any key to continue...$'
BACK DB 'Press any key to go back...$'

; GAME RULES SECTION
R DB 'Game Rules:$' 
R1 DB '1. Players will take turns.$'
R2 DB '2. Player 1 will start the game.$'
R3 DB '3. Player 1 will set "O" and Player 2 will set "X".$'
R4 DB '4. The board is marked with cell numbers.$'
R5 DB '5. Enter cell number to place your mark.$'
R6 DB '6. Set 3 of your marks horizontally, vertically or diagonally to win.$'   

; BOARD LINES SECTION
L1 DB '[$'
L2 DB ']$'
L3 DB '-\-$'
L4 DB '-/-$'
L5 DB '---$'
N1 DB '    |     |     |$'
COL DB '    a     b     c$'
ROW1 DB '1 $' 
ROW2 DB '2 $'
ROW3 DB '3 $'

; CELL NUMBERS SECTION
B1 DB ' $' 
B2 DB ' $'
B3 DB ' $'
B4 DB ' $'
B5 DB ' $'
B6 DB ' $'
B7 DB ' $'
B8 DB ' $'
B9 DB ' $'

; BOARD CELLS SECTION
T1 DB 'a1$' 
T2 DB 'b1$'
T3 DB 'c1$'
T4 DB 'a2$'
T5 DB 'b2$'
T6 DB 'c2$'
T7 DB 'a3$'
T8 DB 'b3$'
T9 DB 'c3$'

; VARIABLES SECTION
PLAYER DB 50, '$' 
DONE DB 0
FROM_BOARD DB ?
TO_BOARD DB ?
FROM_BOARD_COL DB ?
FROM_BOARD_ROW DB ?
TO_BOARD_COL DB ?
TO_BOARD_ROW DB ?
AIMOVES DW ?
MOVES DW ?
QUOTIENT DB ? 
REMAINDER DB ?
VALID_MOVE DB 0
VALID_TO DB 0
VALID_FROM DB 0
TOKEN DB 88   
PLAYERINPUTT DB 3, ?, 26 DUP("$")
PLAYERINPUTT1 DB ?
PLAYERINPUTT2 DB ?
PLAYERINPUTF1 DB ?
PLAYERINPUTF2 DB ?
PLAYERINPUTF DB 3, ?, 26 DUP("$")
IS_EMPTY_BOOL DB ?
INVALID_BOOL DB ?
INVALID_BOOL_AI DB ?
VALID_BOOL_AI DB ?
PLAYER_TOKEN_BOOL DB 0
AI_TOKEN DB 0
AI_TOKEN01 DB 0
AI_TOKEN02 DB 0
AI_TOKEN03 DB 0
AI_TOKEN_FROM1 DB ?
AI_TOKEN_TO1 DB ?
AI_TOKEN_FROM2 DB ?
AI_TOKEN_TO2 DB ?
RANDOMNUM DB 0
EMPTY_SPOT1 DB 0
EMPTY_SPOT2 DB 0
EMPTY_SPOT3 DB 0 

; PROMTS SECTION
MOVE DB 32,'Your move! $'
FROM DB 32, 'From: $' 
TO DB 32, '                                           To: $'
TOTALAI DB  'Total AI moves: $'
TOTALPL DB  'Your total moves: $'
PROMPTAIMOVE db "AI moves from ", "$"
PROMPTAIMOVETO db " to ", "$"
TKN DB 'This cell is taken! Press any key...$' 
NUMBER_OF_MOVES DB ' Number of moves: $' 
PLYR_WON DB 'Yey, you $'
AI_WON DB 'Aww, AI $'
WON DB 'won the game!$'
DRW DB 'The game is draw!$'
TRA DB 'Do you want to play again? (y/n): $'
WI DB  32, 32, 32, 'Wrong input! Press any key...   $' 
INVALID_MESSAGE DB  32, 32, 32, 'Invalid move! Press any key...   $' 
EMP DB '                                                                               $' 
SPACE DB '                           $'  
PRINT_NEWLINE db 13, 10, "$"

.CODE
; ------------ RANDOM NUMBER GENERATOR ------- 
GENRANDOMNUM PROC NEAR
    CALL DELAY
    CALL DELAY
    CALL DELAY
    MOV AH, 0
    INT 1AH

    MOV AX, DX
    MOV DX, 0
    MOV BX, 3
    DIV BX
    MOV RANDOMNUM, DL
    RET
GENRANDOMNUM ENDP
; ------------ RANDOM NUMBER GENERATOR ENDS ------- 

; ------------ DELAY ------- 
DELAY PROC NEAR
        XOR CX, CX
        MOV CX, 1
    STARTDELAY:
        cmp CX, 30000
        JE ENDDELAY
        INC CX
        JMP STARTDELAY
    ENDDELAY:
        RET
DELAY ENDP
; ------------ DELAY ENDS ------- 

; ------------ AI MOVES FROM ------- 
AIMOVE_FROM PROC NEAR
    .IF BL == 01
        MOV AI_TOKEN_FROM1, 'a'
        MOV AI_TOKEN_FROM2, '1'
    .ELSEIF BL == 02
        MOV AI_TOKEN_FROM1, 'b'
        MOV AI_TOKEN_FROM2, '1'
    .ELSEIF BL == 03
        MOV AI_TOKEN_FROM1, 'c'
        MOV AI_TOKEN_FROM2, '1'
    .ELSEIF BL == 04
        MOV AI_TOKEN_FROM1, 'a'
        MOV AI_TOKEN_FROM2, '2'
    .ELSEIF BL == 05
        MOV AI_TOKEN_FROM1, 'b'
        MOV AI_TOKEN_FROM2, '2'
    .ELSEIF BL == 06
        MOV AI_TOKEN_FROM1, 'c'
        MOV AI_TOKEN_FROM2, '2'
    .ELSEIF BL == 07
        MOV AI_TOKEN_FROM1, 'a'
        MOV AI_TOKEN_FROM2, '3'
    .ELSEIF BL == 08
        MOV AI_TOKEN_FROM1, 'b'
        MOV AI_TOKEN_FROM2, '3'
    .ELSEIF BL == 09
        MOV AI_TOKEN_FROM1, 'c'
        MOV AI_TOKEN_FROM2, '3'
    .ELSE   
        MOV INVALID_BOOL, 01
    .ENDIF
    RET
AIMOVE_FROM ENDP
; ------------ AI MOVES FROM ENDS ------- 

; ------------ AI MOVES TO ------- 
AIMOVE_TO PROC NEAR
    .IF BH == 01
        MOV AI_TOKEN_TO1, 'a'
        MOV AI_TOKEN_TO2, '1'
    .ELSEIF BH == 02
        MOV AI_TOKEN_TO1, 'b'
        MOV AI_TOKEN_TO2, '1'
    .ELSEIF BH == 03
        MOV AI_TOKEN_TO1, 'c'
        MOV AI_TOKEN_TO2, '1'
    .ELSEIF BH == 04
        MOV AI_TOKEN_TO1, 'a'
        MOV AI_TOKEN_TO2, '2'
    .ELSEIF BH == 05
        MOV AI_TOKEN_TO1, 'b'
        MOV AI_TOKEN_TO2, '2'
    .ELSEIF BH == 06
        MOV AI_TOKEN_TO1, 'c'
        MOV AI_TOKEN_TO2, '2'
    .ELSEIF BH == 07
        MOV AI_TOKEN_TO1, 'a'
        MOV AI_TOKEN_TO2, '3'
    .ELSEIF BH == 08
        MOV AI_TOKEN_TO1, 'b'
        MOV AI_TOKEN_TO2, '3'
    .ELSEIF BH == 09
        MOV AI_TOKEN_TO1, 'c'
        MOV AI_TOKEN_TO2, '3'
    .ELSE   
        MOV INVALID_BOOL, 01
    .ENDIF
    RET
AIMOVE_TO ENDP
; ------------ AI MOVES TO ENDS -------

; ------------ PLAYER INPUT -------
PLAYER_INPUT PROC
    LEA DX, MOVE
    MOV AH, 9
    INT 21H

    LEA DX, FROM
    MOV AH, 9
    INT 21H

    MOV AH, 0AH
    MOV DX, OFFSET PLAYERINPUTF
    INT 21H

    MOV BL, [PLAYERINPUTF+2]
    MOV BH, [PLAYERINPUTF+3]

    MOV FROM_BOARD_COL, BL
    MOV FROM_BOARD_ROW, BH

    LEA DX, PRINT_NEWLINE
    MOV AH, 09H
    INT 21H

    ; SET CURSOR
    MOV AH, 2
    MOV DH, 17
    MOV DL, 48
    INT 10H
 
    LEA DX, TO
    MOV AH, 09H
    INT 21H

    MOV AH, 0AH
    MOV DX, OFFSET PLAYERINPUTT
    INT 21H

    ; SET CURSOR
    MOV AH, 2
    MOV DH, 16
    MOV DL, 29 
    INT 10H

    MOV BL, [PLAYERINPUTT+2]
    MOV BH, [PLAYERINPUTT+3]
    MOV TO_BOARD_COL, BL
    MOV TO_BOARD_ROW, BH 

    MOV AH, 2
    MOV DH, 16
    MOV DL, 29 
    INT 10H

    RET
PLAYER_INPUT ENDP
; ------------ PLAYER INPUT ENDS -------


MAIN PROC
    MOV AX, @DATA
    MOV DS, AX 
    
    ; ------------ TITLE SCREEN -------
    TITLESCREEN:   
        MOV AX,0600H 
        MOV BH,07H 
        MOV CX,0000H 
        MOV DX,184FH 
        INT 10H 

        MOV AH, 2
        MOV BH, 0
        MOV DH, 6
        MOV DL, 14
        INT 10H 
            
        MOV AH, 2
        MOV DH, 7
        MOV DL, 14
        INT 10H 
        
        MOV AH, 2
        MOV DH, 8
        MOV DL, 14
        INT 10H 
    
        MOV AH, 2
        MOV DH, 9
        MOV DL, 14
        INT 10H  
            
        MOV AH, 2
        MOV DH, 10
        MOV DL, 29
        INT 10H 
        
        LEA DX, GREETING 
        MOV AH, 9
        INT 21H
 
        MOV AH, 2
        MOV DH, 13
        MOV DL, 30
        INT 10H  

        LEA DX, START 
        MOV AH, 9
        INT 21H

        MOV AH, 2
        MOV DH, 14
        MOV DL, 30
        INT 10H  

        LEA DX, RULE 
        MOV AH, 9
        INT 21H

        MOV AH, 2
        MOV DH, 15
        MOV DL, 30
        INT 10H  

        LEA DX, ESCP 
        MOV AH, 9
        INT 21H

        MOV AH, 2
        MOV DH, 16
        MOV DL, 30
        INT 10H  

        LEA DX, OPTN 
        MOV AH, 9
        INT 21H

        MOV AH, 1
        INT 21H 
        SUB AL, 48
        
        .IF al == 1
            JMP INITIALIZE
        .ELSEIF al == 2
            JMP RULES
        .ELSEIF al == 3
            JMP EXIT
        .ELSE
            JMP TITLESCREEN
        .ENDIF
        
        MOV AH, 7   
        INT 21H
    
        MOV AX,0600H 
        MOV BH,07H 
        MOV CX,0000H 
        MOV DX,184FH 
        INT 10H 

    
    
    ; ------------ TITLE SCREEN -------
    
    ; ------------ GAME RULES -------
    RULES:
        MOV AX,0600H 
        MOV BH,07H 
        MOV CX,0000H 
        MOV DX,184FH 
        INT 10H 

        MOV AH, 2
        MOV BH, 0
        MOV DH, 6
        MOV DL, 7
        INT 10H
    
        LEA DX, R
        MOV AH, 9
        INT 21H

        MOV AH, 2
        MOV DH, 7
        MOV DL, 7
        INT 10H 
    
        LEA DX, R1   
        MOV AH, 9
        INT 21H 

        MOV AH, 2
        MOV DH, 8
        MOV DL, 7
        INT 10H 
    
        LEA DX, R2   
        MOV AH, 9
        INT 21H

        MOV AH, 2
        MOV DH, 9
        MOV DL, 7
        INT 10H 
    
        LEA DX, R3   
        MOV AH, 9
        INT 21H
    
        MOV AH, 2
        MOV DH, 10
        MOV DL, 7
        INT 10H
    
        LEA DX, R4  
        MOV AH, 9
        INT 21H

        MOV AH, 2
        MOV DH, 11
        MOV DL, 7
        INT 10H      
            
        LEA DX, R5 
        MOV AH, 9
        INT 21H
            
        MOV AH, 2
        MOV DH, 12
        MOV DL, 7
        INT 10H
        
        LEA DX, R6
        MOV AH, 9
        INT 21H
        
        MOV AH, 2
        MOV DH, 15
        MOV DL, 7
        INT 10H 
    
        LEA DX, BACK 
        MOV AH, 9
        INT 21H
        
        MOV AH, 7   
        INT 21H 

        JMP TITLESCREEN
        
    
    ; ------------ GAME RULES -------
    
    ; ------------ INITIALIZE -------
    INITIALIZE: 
        MOV PLAYER, 50    
        MOV DONE, 0 

        MOV MOVES, 0
        MOV AIMOVES, 0
        
        MOV B1, 88
        MOV B2, 88
        MOV B3, 88
        MOV B4, 32
        MOV B5, 32
        MOV B6, 32
        MOV B7, 79
        MOV B8, 79
        MOV B9, 79
                                                
        JMP PLRCHANGE

    ; ------------ INITIALIZE -------
    
    ; ------------ VICTORY -------
    VICTORY:
        MOV AH, 2
        MOV DH, 17
        MOV DL, 28 
        INT 10H 

        .IF PLAYER == 49
            LEA DX, PLYR_WON
            MOV AH, 9
            INT 21H

            LEA DX, WON
            MOV AH, 9
            INT 21H
            
            MOV AH, 2
            MOV DH, 18
            MOV DL, 28 
            INT 10H 

            LEA DX, NUMBER_OF_MOVES
            MOV AH, 9
            INT 21H
            
            MOV AX, MOVES
            MOV BL, 10
            DIV BL

            MOV QUOTIENT, AL
            MOV REMAINDER, AH

            MOV DL, QUOTIENT
            ADD DL, '0'
            MOV AH, 2
            INT 21H

            MOV DL, REMAINDER
            ADD DL, '0'
            MOV AH, 2
            INT 21H

        .ELSEIF PLAYER == 50
            LEA DX, AI_WON
            MOV AH, 9
            INT 21H

            LEA DX, WON
            MOV AH, 9
            INT 21H

            MOV AH, 2
            MOV DH, 18
            MOV DL, 28 
            INT 10H 

            LEA DX, NUMBER_OF_MOVES
            MOV AH, 9
            INT 21H

            MOV AX, AIMOVES
            MOV BL, 10
            DIV BL

            MOV QUOTIENT, AL
            MOV REMAINDER, AH

            MOV DL, QUOTIENT
            ADD DL, '0'
            MOV AH, 2
            INT 21H

            MOV DL, REMAINDER
            ADD DL, '0'
            MOV AH, 2
            INT 21H
        .ENDIF

        
        MOV AH, 2
        MOV DH, 19
        MOV DL, 28 
        INT 10H  
            
        LEA DX, KEY  
        MOV AH, 9
        INT 21H
        
        MOV AH, 7    
        INT 21H    
        
        JMP PLAY_AGAIN                     

    ; ------------ VICTORY -------

    ; ------------ WIN CHECK -------
    CHECK:   
        CHECK1:
            .IF B1 == 79
                MOV AL, B1
                MOV BL, B2 
                MOV CL, B3

                CMP AL, BL
                JNZ CHECK2

                CMP BL, CL
                JNZ CHECK2

                MOV DONE, 1
                JMP BOARD
            .ELSE
                JMP CHECK2
            .ENDIF

        CHECK2:
            .IF B4 == 79
                MOV AL, B4
                MOV BL, B5 
                MOV CL, B6

                CMP AL, BL
                JNZ CHECK3

                CMP BL, CL
                JNZ CHECK3

                MOV DONE, 1
                JMP BOARD
            .ELSEIF B4 == 88
                MOV AL, B4
                MOV BL, B5 
                MOV CL, B6

                CMP AL, BL
                JNZ CHECK3

                CMP BL, CL
                JNZ CHECK3

                MOV DONE, 1
                JMP BOARD
            .ELSE
                JMP CHECK3
            .ENDIF

        CHECK3:
            .IF B7 == 88
                MOV AL, B7
                MOV BL, B8
                MOV CL, B9

                CMP AL, BL
                JNZ CHECK4

                CMP BL, CL
                JNZ CHECK4 

                MOV DONE, 1
                JMP BOARD
            .ELSE
                JMP CHECK4
            .ENDIF

        CHECK4:
            .IF B1 == 88
                MOV AL, B1
                MOV BL, B4 
                MOV CL, B7

                CMP AL, BL
                JNZ CHECK5

                CMP BL, CL
                JNZ CHECK5

                MOV DONE, 1
                JMP BOARD
            .ELSEIF B1 == 79
                MOV AL, B1
                MOV BL, B4 
                MOV CL, B7

                CMP AL, BL
                JNZ CHECK5

                CMP BL, CL
                JNZ CHECK5

                MOV DONE, 1
                JMP BOARD
            .ELSE
                JMP CHECK5
            .ENDIF

        CHECK5:
            .IF B2 == 88
                MOV AL, B2
                MOV BL, B5 
                MOV CL, B8

                CMP AL, BL
                JNZ CHECK6

                CMP BL, CL
                JNZ CHECK6

                MOV DONE, 1
                JMP BOARD
            .ELSEIF B2 == 79
                MOV AL, B2
                MOV BL, B5 
                MOV CL, B8

                CMP AL, BL
                JNZ CHECK6

                CMP BL, CL
                JNZ CHECK6

                MOV DONE, 1
                JMP BOARD
            .ELSE
                JMP CHECK6
            .ENDIF

        CHECK6:
            .IF B3 == 88
                MOV AL, B3
                MOV BL, B6 
                MOV CL, B9

                CMP AL, BL
                JNZ CHECK7

                CMP BL, CL
                JNZ CHECK7

                MOV DONE, 1
                JMP BOARD
            .ELSEIF B3 == 79
                MOV AL, B3
                MOV BL, B6 
                MOV CL, B9

                CMP AL, BL
                JNZ CHECK7

                CMP BL, CL
                JNZ CHECK7

                MOV DONE, 1
                JMP BOARD
            .ELSE
                JMP CHECK7
            .ENDIF

        CHECK7:
            .IF B1 == 79
                MOV AL, B1
                MOV BL, B5 
                MOV CL, B9

                CMP AL, BL
                JNZ CHECK8

                CMP BL, CL
                JNZ CHECK8

                MOV DONE, 1
                JMP BOARD
            .ELSEIF B1 == 88
                MOV AL, B1
                MOV BL, B5 
                MOV CL, B9

                CMP AL, BL
                JNZ CHECK8

                CMP BL, CL
                JNZ CHECK8

                MOV DONE, 1
                JMP BOARD
            .ELSE
                JMP CHECK8
            .ENDIF

        CHECK8:
            .IF B3 == 88
                MOV AL, B3
                MOV BL, B5 
                MOV CL, B7

                CMP AL, BL
                JNZ PLRCHANGE

                CMP BL, CL
                JNZ PLRCHANGE

                MOV DONE, 1
                JMP BOARD
            .ELSEIF B3 == 79
                MOV AL, B3
                MOV BL, B5 
                MOV CL, B7

                CMP AL, BL
                JNZ PLRCHANGE

                CMP BL, CL
                JNZ PLRCHANGE

                MOV DONE, 1
                JMP BOARD
            .ELSE
                JMP PLRCHANGE
            .ENDIF
   
    
    ; ------------ WIN CHECK -------
    
    ; ------------ PLAYER CHANGE -------
    PLRCHANGE:                     
        CMP PLAYER, 49
        JZ P2
        CMP PLAYER, 50
        JZ P1
        
        P1:
            MOV PLAYER, 49
            MOV TOKEN, 79 ; O
            JMP BOARD
             
        P2:
            MOV PLAYER, 50
            MOV TOKEN, 88 ; X
            JMP BOARD

    
    ; ------------ PLAYER CHANGE -------
    
    ; ------------ PRINT BOARD -------
    BOARD:    
        MOV AX,0600H 
        MOV BH,07H 
        MOV CX,0000H 
        MOV DX,184FH 
        INT 10H
    
        MOV AH, 2
        MOV BH, 0
        MOV DH, 6
        MOV DL, 30
        INT 10H

        LEA DX, COL
        MOV AH, 9
        INT 21H 

        MOV AH, 2
        MOV DH, 7
        MOV DL, 30 
        INT 10H
    
        MOV AH, 2
        MOV DL, 32
        INT 21H

        LEA DX, ROW1
        MOV AH, 9
        INT 21H 

        LEA DX, L1
        MOV AH, 9
        INT 21H 
        
        LEA DX, B1
        MOV AH, 9
        INT 21H 

        LEA DX, L2
        MOV AH, 9
        INT 21H 
        
        LEA DX, L3
        MOV AH, 9
        INT 21H
    
        LEA DX, L1
        MOV AH, 9
        INT 21H 
        
        LEA DX, B2
        MOV AH, 9
        INT 21H 

        LEA DX, L2
        MOV AH, 9
        INT 21H
        
        LEA DX, L4
        MOV AH, 9
        INT 21H
        
        LEA DX, L1
        MOV AH, 9
        INT 21H 
        
        LEA DX, B3
        MOV AH, 9
        INT 21H 

        LEA DX, L2
        MOV AH, 9
        INT 21H
    
        MOV AH, 2
        MOV DH, 8
        MOV DL, 30 
        INT 10H 
    
        LEA DX, N1
        MOV AH, 9
        INT 21H 
    
        MOV AH, 2
        MOV DH, 9
        MOV DL, 30 
        INT 10H
    
        MOV AH, 2
        MOV DL, 32
        INT 21H
        
        LEA DX, ROW2
        MOV AH, 9
        INT 21H 

        LEA DX, L1
        MOV AH, 9
        INT 21H 
        
        LEA DX, B4
        MOV AH, 9
        INT 21H 

        LEA DX, L2
        MOV AH, 9
        INT 21H 
    
        LEA DX, L5
        MOV AH, 9
        INT 21H

        LEA DX, L1
        MOV AH, 9
        INT 21H 
        
        LEA DX, B5
        MOV AH, 9
        INT 21H 

        LEA DX, L2
        MOV AH, 9
        INT 21H
        
        LEA DX, L5
        MOV AH, 9
        INT 21H

        LEA DX, L1
        MOV AH, 9
        INT 21H 
        
        LEA DX, B6
        MOV AH, 9
        INT 21H 

        LEA DX, L2
        MOV AH, 9
        INT 21H
    
        MOV AH, 2
        MOV DH, 10
        MOV DL, 30 
        INT 10H   

        LEA DX, N1
        MOV AH, 9
        INT 21H  

        MOV AH, 2
        MOV DH, 11
        MOV DL, 30 
        INT 10H
        
        MOV AH, 2
        MOV DL, 32
        INT 21H   
    
        LEA DX, ROW3
        MOV AH, 9
        INT 21H 

        LEA DX, L1
        MOV AH, 9
        INT 21H 
        
        LEA DX, B7
        MOV AH, 9
        INT 21H 

        LEA DX, L2
        MOV AH, 9
        INT 21H 
        
        LEA DX, L4
        MOV AH, 9
        INT 21H

        LEA DX, L1
        MOV AH, 9
        INT 21H 
        
        LEA DX, B8
        MOV AH, 9
        INT 21H 

        LEA DX, L2
        MOV AH, 9
        INT 21H
        
        LEA DX, L3
        MOV AH, 9
        INT 21H
    
        LEA DX, L1
        MOV AH, 9
        INT 21H 
        
        LEA DX, B9
        MOV AH, 9
        INT 21H 

        LEA DX, L2
        MOV AH, 9
        INT 21H

        MOV AH, 2
        MOV DH, 12
        MOV DL, 30 
        INT 10H 
    
        MOV AH, 2
        MOV DH, 13
        MOV DL, 30 
        INT 10H
    
        LEA DX, TOTALPL
        MOV AH, 9
        INT 21H

        MOV AX, MOVES
        MOV BL, 10
        DIV BL

        MOV QUOTIENT, AL
        MOV REMAINDER, AH

        MOV DL, QUOTIENT
        ADD DL, '0'
        MOV AH, 2
        INT 21H

        MOV DL, REMAINDER
        ADD DL, '0'
        MOV AH, 2
        INT 21H


        MOV AH, 2
        MOV DH, 14
        MOV DL, 30 
        INT 10H

        LEA DX, TOTALAI
        MOV AH, 9
        INT 21H

        MOV AX, AIMOVES
        MOV BL, 10
        DIV BL

        MOV QUOTIENT, AL
        MOV REMAINDER, AH

        MOV DL, QUOTIENT
        ADD DL, '0'
        MOV AH, 2
        INT 21H

        MOV DL, REMAINDER
        ADD DL, '0'
        MOV AH, 2
        INT 21H

        MOV AH, 2
        MOV DH, 16
        MOV DL, 29
        INT 10H 
    
        CMP DONE, 1
        JZ VICTORY

    ; ------------ PRINT BOARD -------
    
    ; ------------ PLAYER MOVES -------
    INPUT:
        .IF PLAYER == 49 ; Player
            INC MOVES
            JMP TAKEINPUT
        .ELSEIF PLAYER == 50 ; AI
            INC AIMOVES

            MOV AH, 2
            MOV DH, 16
            MOV DL, 29
            INT 10H 
        
            JMP COMPUTER
        .ENDIF

    TAKEINPUT:
        CALL PLAYER_INPUT

        .IF FROM_BOARD_COL == 'a'
            .IF FROM_BOARD_ROW == '1' 
                MOV FROM_BOARD, 1
            .ELSEIF FROM_BOARD_ROW == '2' 
                MOV FROM_BOARD, 4
            .ELSEIF FROM_BOARD_ROW == '3' 
                MOV FROM_BOARD, 7
            .ELSE
                JMP INVALID
            .ENDIF
        .ELSEIF FROM_BOARD_COL == 'b' 
            .IF FROM_BOARD_ROW == '1' 
                MOV FROM_BOARD, 2
            .ELSEIF FROM_BOARD_ROW == '2' 
                MOV FROM_BOARD, 5
            .ELSEIF FROM_BOARD_ROW == '3' 
                MOV FROM_BOARD, 8
            .ELSE
                JMP INVALID
            .ENDIF
        .ELSEIF FROM_BOARD_COL == 'c' 
            .IF FROM_BOARD_ROW == '1' 
                MOV FROM_BOARD, 3
            .ELSEIF FROM_BOARD_ROW == '2' 
                MOV FROM_BOARD, 6
            .ELSEIF FROM_BOARD_ROW == '3' 
                MOV FROM_BOARD, 9
            .ELSE
                JMP INVALID
            .ENDIF
        .ELSE
            JMP INVALID
        .ENDIF

        .IF TO_BOARD_COL == 'a' 
            .IF TO_BOARD_ROW == '1' 
                MOV TO_BOARD, 1
            .ELSEIF TO_BOARD_ROW == '2' 
                MOV TO_BOARD, 4
            .ELSEIF TO_BOARD_ROW == '3' 
                MOV TO_BOARD, 7
            .ELSE
                JMP INVALID
            .ENDIF
        .ELSEIF TO_BOARD_COL == 'b' 
            .IF TO_BOARD_ROW == '1' 
                MOV TO_BOARD, 2
            .ELSEIF TO_BOARD_ROW == '2' 
                MOV TO_BOARD, 5
            .ELSEIF TO_BOARD_ROW == '3' 
                MOV TO_BOARD, 8
            .ELSE
                JMP INVALID
            .ENDIF
        .ELSEIF TO_BOARD_COL == 'c'
            .IF TO_BOARD_ROW == '1' 
                MOV TO_BOARD, 3
            .ELSEIF TO_BOARD_ROW == '2'
                MOV TO_BOARD, 6
            .ELSEIF TO_BOARD_ROW == '3' 
                MOV TO_BOARD, 9
            .ELSE
                JMP INVALID
            .ENDIF
        .ELSE
            JMP INVALID
        .ENDIF

    MOVE_TO:
        MOV CL, TOKEN
        .IF TO_BOARD == 1
            .IF FROM_BOARD == 2
                .IF B2 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B1_TO
            .ELSEIF FROM_BOARD == 4
                .IF B4 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B1_TO

            .ELSEIF FROM_BOARD == 5
                .IF B5 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B1_TO
            .ELSE
                JMP INVALID
            .ENDIF
        .ELSEIF TO_BOARD == 2
            .IF FROM_BOARD == 1
                .IF B1 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B2_TO
            .ELSEIF FROM_BOARD == 3
                .IF B3 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B2_TO
            .ELSEIF FROM_BOARD == 5
                .IF B5 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B2_TO
            .ELSE
                JMP INVALID
            .ENDIF 
        .ELSEIF TO_BOARD == 3
            .IF FROM_BOARD == 2
                .IF B2 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B3_TO
            .ELSEIF FROM_BOARD == 5
                .IF B5 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B3_TO
            .ELSEIF FROM_BOARD == 6
                .IF B6 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B3_TO
            .ELSE
                JMP INVALID
            .ENDIF 
        .ELSEIF TO_BOARD == 4
            .IF FROM_BOARD == 1
                .IF B1 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B4_TO
            .ELSEIF FROM_BOARD == 5
                .IF B5 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B4_TO
            .ELSEIF FROM_BOARD == 7
                .IF B7 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B4_TO
            .ELSE
                JMP INVALID
            .ENDIF
        .ELSEIF TO_BOARD == 5
            .IF FROM_BOARD == 1
                .IF B1 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B5_TO
            .ELSEIF FROM_BOARD == 2
                .IF B2 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B5_TO
            .ELSEIF FROM_BOARD == 3
                .IF B3 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B5_TO
            .ELSEIF FROM_BOARD == 4
                .IF B4 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B5_TO
            .ELSEIF FROM_BOARD == 6
                .IF B6 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B5_TO
            .ELSEIF FROM_BOARD == 7
                .IF B7 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B5_TO
            .ELSEIF FROM_BOARD == 8
                .IF B8 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B5_TO
            .ELSEIF FROM_BOARD == 9
                .IF B9 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B5_TO
            .ELSE
                JMP INVALID
            .ENDIF
        .ELSEIF TO_BOARD == 6
            .IF FROM_BOARD == 3
                .IF B3 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B6_TO
            .ELSEIF FROM_BOARD == 5
                .IF B5 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B6_TO
            .ELSEIF FROM_BOARD == 9
                .IF B9 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B6_TO
            .ELSE
                JMP INVALID
            .ENDIF
        .ELSEIF TO_BOARD == 7
            .IF FROM_BOARD == 4
                .IF B4 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B7_TO
            .ELSEIF FROM_BOARD == 5
                .IF B5 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B7_TO
            .ELSEIF FROM_BOARD == 8
                .IF B8 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B7_TO
            .ELSE
                JMP INVALID
            .ENDIF   
        .ELSEIF TO_BOARD == 8
            .IF FROM_BOARD == 5
                .IF B5 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B8_TO
            .ELSEIF FROM_BOARD == 7
                .IF B7 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B8_TO
            .ELSEIF FROM_BOARD == 9
                .IF B9 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B8_TO
            .ELSE
                JMP INVALID
            .ENDIF
        .ELSEIF TO_BOARD == 9
            .IF FROM_BOARD == 8
                .IF B8 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B9_TO
            .ELSEIF FROM_BOARD == 5
                .IF B5 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B9_TO
            .ELSEIF FROM_BOARD == 6
                .IF B6 == 88
                    JMP INVALID
                .ELSE 
                    MOV VALID_FROM, 1
                .ENDIF
                MOV VALID_MOVE, 1
                JMP CHECK_B9_TO
            .ELSE
                JMP INVALID
            .ENDIF
        .ENDIF

    PUT_TOKEN:
        .IF TO_BOARD == 1
            .IF FROM_BOARD == 2
                JMP B1U
            .ELSEIF FROM_BOARD == 4
                JMP B1U
            .ELSEIF FROM_BOARD == 5
                JMP B1U
            .ELSE
                JMP INVALID
            .ENDIF
        .ELSEIF TO_BOARD == 2
            .IF FROM_BOARD == 1
                JMP B2U
            .ELSEIF FROM_BOARD == 3
                JMP B2U
            .ELSEIF FROM_BOARD == 5
                JMP B2U
            .ELSE
                JMP INVALID
            .ENDIF
        .ELSEIF TO_BOARD == 3
            .IF FROM_BOARD == 2
                JMP B3U
            .ELSEIF FROM_BOARD == 5
                JMP B3U
            .ELSEIF FROM_BOARD == 6
                JMP B3U
            .ELSE
                JMP INVALID
            .ENDIF
        .ELSEIF TO_BOARD == 4
            .IF FROM_BOARD == 1
                JMP B4U
            .ELSEIF FROM_BOARD == 5
                JMP B4U
            .ELSEIF FROM_BOARD == 7
                JMP B4U
            .ELSE
                JMP INVALID
            .ENDIF
        .ELSEIF TO_BOARD == 5
            .IF FROM_BOARD <= 9
                JMP B5U
            .ELSE
                JMP INVALID
            .ENDIF
        .ELSEIF TO_BOARD == 6
            .IF FROM_BOARD == 3
                JMP B6U
            .ELSEIF FROM_BOARD == 5
                JMP B6U
            .ELSEIF FROM_BOARD == 9
                JMP B6U
            .ELSE
                JMP INVALID
            .ENDIF
        .ELSEIF TO_BOARD == 7
            .IF FROM_BOARD == 4
                JMP B7U
            .ELSEIF FROM_BOARD == 5
                JMP B7U
            .ELSEIF FROM_BOARD == 8
                JMP B7U
            .ELSE
                JMP INVALID
            .ENDIF
        .ELSEIF TO_BOARD == 8
            .IF FROM_BOARD == 5
                JMP B8U
            .ELSEIF FROM_BOARD == 7
                JMP B8U
            .ELSEIF FROM_BOARD == 9
                JMP B8U
            .ELSE
                JMP INVALID
            .ENDIF
        .ELSEIF TO_BOARD == 9
            .IF FROM_BOARD == 8
                JMP B9U
            .ELSEIF FROM_BOARD == 5
                JMP B9U
            .ELSEIF FROM_BOARD == 6
                JMP B9U
            .ELSE
                JMP INVALID
            .ENDIF
        .ELSE 
            JMP INVALID
        .ENDIF

    INVALID:
        DEC MOVES
        
        MOV AH, 2
        MOV DH, 16
        MOV DL, 29
        INT 10H

        LEA DX, PRINT_NEWLINE  
        MOV AH, 9
        INT 21H

        LEA DX, SPACE  
        MOV AH, 9
        INT 21H
            
        LEA DX, INVALID_MESSAGE  
        MOV AH, 9
        INT 21H
        
        MOV AH, 7     
        INT 21H 
        
        MOV AH, 2
        MOV DH, 16
        MOV DL, 20 
        INT 10H
            
        LEA DX, EMP  
        MOV AH, 9
        INT 21H 
        
        MOV AH, 2
        MOV DH, 16
        MOV DL, 29
        INT 10H
        
        JMP BOARD       

    TAKEN:
        DEC MOVES

        MOV AH, 2
        MOV DH, 16
        MOV DL, 29
        INT 10H

        LEA DX, PRINT_NEWLINE  
        MOV AH, 9
        INT 21H

        LEA DX, SPACE  
        MOV AH, 9
        INT 21H  
            
        LEA DX, TKN   
        MOV AH, 9
        INT 21H  
        
        MOV AH, 7     
        INT 21H 
        
        MOV AH, 2
        MOV DH, 16
        MOV DL, 20 
        INT 10H
            
        LEA DX, EMP  
        MOV AH, 9
        INT 21H 
        
        MOV AH, 2
        MOV DH, 16
        MOV DL, 29
        INT 10H
        
        JMP BOARD

        CHECK_B1_TO:
            .IF B1 == 88 ;X
                JMP TAKEN
            .ELSEIF B1 == 79 ;O
                JMP TAKEN
            .ELSE 
                MOV VALID_TO, 1
                JMP PLAYER_MOVE
            .ENDIF

        CHECK_B2_TO:
            .IF B2 == 88 ;X
                JMP TAKEN
            .ELSEIF B2 == 79 ;O
                JMP TAKEN
            .ELSE 
                MOV VALID_TO, 1
                JMP PLAYER_MOVE
            .ENDIF
        
        CHECK_B3_TO:
            .IF B3 == 88 ;X
                JMP TAKEN
            .ELSEIF B3 == 79 ;O
                JMP TAKEN
            .ELSE 
                MOV VALID_TO, 1
                JMP PLAYER_MOVE
            .ENDIF

        CHECK_B4_TO:
            .IF B4 == 88 ;X
                JMP TAKEN
            .ELSEIF B4 == 79 ;O
                JMP TAKEN
            .ELSE 
                MOV VALID_TO, 1
                JMP PLAYER_MOVE
            .ENDIF

        CHECK_B5_TO:
            .IF B5 == 88 ;X
                JMP TAKEN
            .ELSEIF B5 == 79 ;O
                JMP TAKEN
            .ELSE 
                MOV VALID_TO, 1
                JMP PLAYER_MOVE
            .ENDIF

        CHECK_B6_TO:
            .IF B6 == 88 ;X
                JMP TAKEN
            .ELSEIF B6 == 79 ;O
                JMP TAKEN
            .ELSE 
                MOV VALID_TO, 1
                JMP PLAYER_MOVE
            .ENDIF

        CHECK_B7_TO:
            .IF B7 == 88 ;X
                JMP TAKEN
            .ELSEIF B7 == 79 ;O
                JMP TAKEN
            .ELSE 
                MOV VALID_TO, 1
                JMP PLAYER_MOVE
            .ENDIF

        CHECK_B8_TO:
            .IF B8 == 88 ;X
                JMP TAKEN
            .ELSEIF B8 == 79 ;O
                JMP TAKEN
            .ELSE 
                MOV VALID_TO, 1
                JMP PLAYER_MOVE
            .ENDIF

        CHECK_B9_TO:
            .IF B9 == 88 ;X
                JMP TAKEN
            .ELSEIF B9 == 79 ;O
                JMP TAKEN
            .ELSE 
                MOV VALID_TO, 1
                JMP PLAYER_MOVE
            .ENDIF

        PLAYER_MOVE:
            .IF TO_BOARD == 1
                .IF FROM_BOARD == 2
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B2
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 4
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B4
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 5
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B5
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSE
                    JMP INVALID
                .ENDIF
            .ELSEIF TO_BOARD == 2
                .IF FROM_BOARD == 1
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B1
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 3
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B3
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 5
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B5
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSE
                    JMP INVALID
                .ENDIF 
            .ELSEIF TO_BOARD == 3
                .IF FROM_BOARD == 2
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B2
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 5
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B5
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 6
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B6
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSE
                    JMP INVALID
                .ENDIF 
            .ELSEIF TO_BOARD == 4
                .IF FROM_BOARD == 1
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B1
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 5
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B5
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 7
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B7
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSE
                    JMP INVALID
                .ENDIF
            .ELSEIF TO_BOARD == 5
                .IF FROM_BOARD == 1
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B1
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 2
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B2
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 3
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B3
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 4
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B4
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 6
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B6
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 7
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B7
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 8
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B8
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 9
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B9
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSE
                    JMP INVALID
                .ENDIF
            .ELSEIF TO_BOARD == 6
                .IF FROM_BOARD == 3
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B3
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 5
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B5
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 9
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                    JMP CLEAR_B9
                    .ELSE 
                    JMP INVALID
                    .ENDIF
                .ELSE
                    JMP INVALID
                .ENDIF
            .ELSEIF TO_BOARD == 7
                .IF FROM_BOARD == 4
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B4
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 5
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B5
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 8
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B8
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSE
                    JMP INVALID
                .ENDIF   
            .ELSEIF TO_BOARD == 8
                .IF FROM_BOARD == 5
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B5
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 7
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B7
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 9
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B9
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSE
                    JMP INVALID
                .ENDIF
            .ELSEIF TO_BOARD == 9
                .IF FROM_BOARD == 8
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B8
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 5
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B5
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSEIF FROM_BOARD == 6
                    .IF VALID_MOVE == 1 && VALID_TO == 1 && VALID_FROM == 1
                        JMP CLEAR_B6
                    .ELSE 
                        JMP INVALID
                    .ENDIF
                .ELSE
                    JMP INVALID
                .ENDIF
            .ENDIF

        CLEAR_B1:

            MOV B1, 32
            JMP PUT_TOKEN

        CLEAR_B2:

            MOV B2, 32
            JMP PUT_TOKEN

        CLEAR_B3:

            MOV B3, 32
            JMP PUT_TOKEN

        CLEAR_B4:

            MOV B4, 32
            JMP PUT_TOKEN

        CLEAR_B5:

            MOV B5, 32
            JMP PUT_TOKEN

        CLEAR_B6:

            MOV B6, 32
            JMP PUT_TOKEN

        CLEAR_B7:

            MOV B7, 32
            JMP PUT_TOKEN

        CLEAR_B8:

            MOV B8, 32
            JMP PUT_TOKEN

        CLEAR_B9:

            MOV B9, 32
            JMP PUT_TOKEN

        B1U:
            MOV B1, CL
            JMP CHECK

        B2U:
            MOV B2, CL
            JMP CHECK

        B3U:
            MOV B3, CL
            JMP CHECK

        B4U: 
            MOV B4, CL
            JMP CHECK

        B5U: 
            MOV B5, CL
            JMP CHECK

        B6U:
            MOV B6, CL
            JMP CHECK

        B7U: 
            MOV B7, CL
            JMP CHECK

        B8U: 
            MOV B8, CL
            JMP CHECK

        B9U:
            MOV B9, CL
            JMP CHECK


    ; ------------ PLAYER MOVES -------

    ; ------------- COMPUTER ----------   
    COMPUTER:
        XOR BL, BL
        XOR BH, BH
        MOV INVALID_BOOL_AI, 00

        MOV AI_TOKEN01, 0
        MOV AI_TOKEN02, 0
        MOV AI_TOKEN03, 0

        .IF B1 == 88
            MOV AI_TOKEN, 01
        .ELSE
            MOV AI_TOKEN, 00
        .ENDIF

        .IF AI_TOKEN == 01
            MOV AI_TOKEN01, 01
        .ENDIF
        
        
        .IF B2 == 88
            MOV AI_TOKEN, 01
        .ELSE
            MOV AI_TOKEN, 00
        .ENDIF

        .IF AI_TOKEN == 01
            .IF AI_TOKEN01 == 0
                MOV AI_TOKEN01, 02
            .ELSEIF AI_TOKEN01 > 0
                .IF AI_TOKEN02 == 0
                    MOV AI_TOKEN02, 02
                .ELSEIF AI_TOKEN02 > 0
                    MOV AI_TOKEN03, 02
                .ENDIF
            .ENDIF 
        .ENDIF

        .IF B3 == 88
            MOV AI_TOKEN, 01
        .ELSE
            MOV AI_TOKEN, 00
        .ENDIF

        .IF AI_TOKEN == 01
            .IF AI_TOKEN01 == 0
                MOV AI_TOKEN01, 03
            .ELSEIF AI_TOKEN01 > 0
                .IF AI_TOKEN02 == 0
                    MOV AI_TOKEN02, 03
                .ELSEIF AI_TOKEN02 > 0
                    MOV AI_TOKEN03, 03
                .ENDIF
            .ENDIF 
        .ENDIF
        
        
        .IF B4 == 88
            MOV AI_TOKEN, 01
        .ELSE
            MOV AI_TOKEN, 00
        .ENDIF

        .IF AI_TOKEN == 01
            .IF AI_TOKEN01 == 0
                MOV AI_TOKEN01, 04
            .ELSEIF AI_TOKEN01 > 0
                .IF AI_TOKEN02 == 0
                    MOV AI_TOKEN02, 04
                .ELSEIF AI_TOKEN02 > 0
                    MOV AI_TOKEN03, 04
                .ENDIF
            .ENDIF 
        .ENDIF
        
        
        .IF B5 == 88
            MOV AI_TOKEN, 01
        .ELSE
            MOV AI_TOKEN, 00
        .ENDIF

        .IF AI_TOKEN == 01
            .IF AI_TOKEN01 == 0
                MOV AI_TOKEN01, 05
            .ELSEIF AI_TOKEN01 > 0
                .IF AI_TOKEN02 == 0
                    MOV AI_TOKEN02, 05
                .ELSEIF AI_TOKEN02 > 0
                    MOV AI_TOKEN03, 05
                .ENDIF
            .ENDIF 
        .ENDIF
        
        
        .IF B6 == 88
            MOV AI_TOKEN, 01
        .ELSE
            MOV AI_TOKEN, 00
        .ENDIF

        .IF AI_TOKEN == 01
            .IF AI_TOKEN01 == 0
                MOV AI_TOKEN01, 06
            .ELSEIF AI_TOKEN01 > 0
                .IF AI_TOKEN02 == 0
                    MOV AI_TOKEN02, 06
                .ELSEIF AI_TOKEN02 > 0
                    MOV AI_TOKEN03, 06
                .ENDIF
            .ENDIF 
        .ENDIF

        .IF B7 == 88
            MOV AI_TOKEN, 01
        .ELSE
            MOV AI_TOKEN, 00
        .ENDIF

        .IF AI_TOKEN == 01
            .IF AI_TOKEN01 == 0
                MOV AI_TOKEN01, 07
            .ELSEIF AI_TOKEN01 > 0
                .IF AI_TOKEN02 == 0
                    MOV AI_TOKEN02, 07
                .ELSEIF AI_TOKEN02 > 0
                    MOV AI_TOKEN03, 07
                .ENDIF
            .ENDIF 
        .ENDIF
        
        .IF B8 == 88
            MOV AI_TOKEN, 01
        .ELSE
            MOV AI_TOKEN, 00
        .ENDIF

        .IF AI_TOKEN == 01
            .IF AI_TOKEN01 == 0
                MOV AI_TOKEN01, 08
            .ELSEIF AI_TOKEN01 > 0
                .IF AI_TOKEN02 == 0
                    MOV AI_TOKEN02, 08
                .ELSEIF AI_TOKEN02 > 0
                    MOV AI_TOKEN03, 08
                .ENDIF
            .ENDIF 
        .ENDIF
        
        .IF B9 == 88
            MOV AI_TOKEN, 01
        .ELSE
            MOV AI_TOKEN, 00
        .ENDIF

        .IF AI_TOKEN == 01
            .IF AI_TOKEN01 == 0
                MOV AI_TOKEN01, 09
            .ELSEIF AI_TOKEN01 > 0
                .IF AI_TOKEN02 == 0
                    MOV AI_TOKEN02, 09
                .ELSEIF AI_TOKEN02 > 0
                    MOV AI_TOKEN03, 09
                .ENDIF
            .ENDIF 
        .ENDIF

        CALL GENRANDOMNUM

        MOV EMPTY_SPOT1, 0
        MOV EMPTY_SPOT2, 0
        MOV EMPTY_SPOT3, 0
        
        .IF B1 == 32
            MOV IS_EMPTY_BOOL, 01
        .ELSE
            MOV IS_EMPTY_BOOL, 00
        .ENDIF

        .IF IS_EMPTY_BOOL == 01
            .IF EMPTY_SPOT1 == 0
                MOV EMPTY_SPOT1, 01
            .ELSEIF EMPTY_SPOT1 > 0
                .IF EMPTY_SPOT2 == 0
                    MOV EMPTY_SPOT2, 01
                .ELSEIF EMPTY_SPOT2 > 0
                    MOV EMPTY_SPOT3, 01
                .ENDIF
            .ENDIF 
        .ENDIF
        
        .IF B2 == 32
            MOV IS_EMPTY_BOOL, 01
        .ELSE
            MOV IS_EMPTY_BOOL, 00
        .ENDIF

        .IF IS_EMPTY_BOOL == 01
            .IF EMPTY_SPOT1 == 0
                MOV EMPTY_SPOT1, 02
            .ELSEIF EMPTY_SPOT1 > 0
                .IF EMPTY_SPOT2 == 0
                    MOV EMPTY_SPOT2, 02
                .ELSEIF EMPTY_SPOT2 > 0
                    MOV EMPTY_SPOT3, 02
                .ENDIF
            .ENDIF 
        .ENDIF

        .IF B3 == 32
            MOV IS_EMPTY_BOOL, 01
        .ELSE
            MOV IS_EMPTY_BOOL, 00
        .ENDIF

        .IF IS_EMPTY_BOOL == 01
            .IF EMPTY_SPOT1 == 0
                MOV EMPTY_SPOT1, 03
            .ELSEIF EMPTY_SPOT1 > 0
                .IF EMPTY_SPOT2 == 0
                    MOV EMPTY_SPOT2, 03
                .ELSEIF EMPTY_SPOT2 > 0
                    MOV EMPTY_SPOT3, 03
                .ENDIF
            .ENDIF 
        .ENDIF
        
        .IF B4 == 32
            MOV IS_EMPTY_BOOL, 01
        .ELSE
            MOV IS_EMPTY_BOOL, 00
        .ENDIF

        .IF IS_EMPTY_BOOL == 01
            .IF EMPTY_SPOT1 == 0
                MOV EMPTY_SPOT1, 04
            .ELSEIF EMPTY_SPOT1 > 0
                .IF EMPTY_SPOT2 == 0
                    MOV EMPTY_SPOT2, 04
                .ELSEIF EMPTY_SPOT2 > 0
                    MOV EMPTY_SPOT3, 04
                .ENDIF
            .ENDIF 
        .ENDIF
        
        .IF B5 == 32
            MOV IS_EMPTY_BOOL, 01
        .ELSE
            MOV IS_EMPTY_BOOL, 00
        .ENDIF

        .IF IS_EMPTY_BOOL == 01
            .IF EMPTY_SPOT1 == 0
                MOV EMPTY_SPOT1, 05
            .ELSEIF EMPTY_SPOT1 > 0
                .IF EMPTY_SPOT2 == 0
                    MOV EMPTY_SPOT2, 05
                .ELSEIF EMPTY_SPOT2 > 0
                    MOV EMPTY_SPOT3, 05
                .ENDIF
            .ENDIF 
        .ENDIF
        
        .IF B6 == 32
            MOV IS_EMPTY_BOOL, 01
        .ELSE
            MOV IS_EMPTY_BOOL, 00
        .ENDIF

        .IF IS_EMPTY_BOOL == 01
            .IF EMPTY_SPOT1 == 0
                MOV EMPTY_SPOT1, 06
            .ELSEIF EMPTY_SPOT1 > 0
                .IF EMPTY_SPOT2 == 0
                    MOV EMPTY_SPOT2, 06
                .ELSEIF EMPTY_SPOT2 > 0
                    MOV EMPTY_SPOT3, 06
                .ENDIF
            .ENDIF 
        .ENDIF

        .IF B7 == 32
            MOV IS_EMPTY_BOOL, 01
        .ELSE
            MOV IS_EMPTY_BOOL, 00
        .ENDIF

        .IF B7 == 88
            MOV AI_TOKEN, 01
        .ELSE
            MOV AI_TOKEN, 00
        .ENDIF

        .IF IS_EMPTY_BOOL == 01
            .IF EMPTY_SPOT1 == 0
                MOV EMPTY_SPOT1, 07
            .ELSEIF EMPTY_SPOT1 > 0
                .IF EMPTY_SPOT2 == 0
                    MOV EMPTY_SPOT2, 07
                .ELSEIF EMPTY_SPOT2 > 0
                    MOV EMPTY_SPOT3, 07
                .ENDIF
            .ENDIF 
        .ENDIF
        
        .IF B8 == 32
            MOV IS_EMPTY_BOOL, 01
        .ELSE
            MOV IS_EMPTY_BOOL, 00
        .ENDIF

        .IF IS_EMPTY_BOOL == 01
            .IF EMPTY_SPOT1 == 0
                MOV EMPTY_SPOT1, 08
            .ELSEIF EMPTY_SPOT1 > 0
                .IF EMPTY_SPOT2 == 0
                    MOV EMPTY_SPOT2, 08
                .ELSEIF EMPTY_SPOT2 > 0
                    MOV EMPTY_SPOT3, 08
                .ENDIF
            .ENDIF 
        .ENDIF
        
        .IF B9 == 32
            MOV IS_EMPTY_BOOL, 01
        .ELSE
            MOV IS_EMPTY_BOOL, 00
        .ENDIF

        .IF IS_EMPTY_BOOL == 01
            .IF EMPTY_SPOT1 == 0
                MOV EMPTY_SPOT1, 09
            .ELSEIF EMPTY_SPOT1 > 0
                .IF EMPTY_SPOT2 == 0
                    MOV EMPTY_SPOT2, 09
                .ELSEIF EMPTY_SPOT2 > 0
                    MOV EMPTY_SPOT3, 09
                .ENDIF
            .ENDIF 
        .ENDIF

        .IF RANDOMNUM == 0
            MOV BL, AI_TOKEN01
            CALL AIMOVE_FROM
            CALL GENRANDOMNUM
            .IF RANDOMNUM == 0
                MOV BH, EMPTY_SPOT1
                CALL AIMOVE_TO
            .ELSEIF RANDOMNUM == 1
                MOV BH, EMPTY_SPOT2
                CALL AIMOVE_TO
            .ELSEIF RANDOMNUM == 2
                MOV BH, EMPTY_SPOT3
                CALL AIMOVE_TO
            .ENDIF
        .ELSEIF RANDOMNUM == 1
            MOV BL, AI_TOKEN02
            CALL AIMOVE_FROM
            CALL GENRANDOMNUM
            .IF RANDOMNUM == 0
                MOV BH, EMPTY_SPOT1
                CALL AIMOVE_TO
            .ELSEIF RANDOMNUM == 1
                MOV BH, EMPTY_SPOT2
                CALL AIMOVE_TO
            .ELSEIF RANDOMNUM == 2
                MOV BH, EMPTY_SPOT3
                CALL AIMOVE_TO
            .ENDIF
        .ELSEIF RANDOMNUM == 2
            MOV BL, AI_TOKEN03
            CALL AIMOVE_FROM
            CALL GENRANDOMNUM
            .IF RANDOMNUM == 0
                MOV BH, EMPTY_SPOT1
                CALL AIMOVE_TO
            .ELSEIF RANDOMNUM == 1
                MOV BH, EMPTY_SPOT2
                CALL AIMOVE_TO
            .ELSEIF RANDOMNUM == 2
                MOV BH, EMPTY_SPOT3
                CALL AIMOVE_TO
            .ENDIF
        .ENDIF
        
        MOV BL, AI_TOKEN_FROM1
        MOV BH, AI_TOKEN_FROM2
        MOV PLAYERINPUTF1, BL
        MOV PLAYERINPUTF2, BH 

        MOV BL, AI_TOKEN_TO1
        MOV BH, AI_TOKEN_TO2
        MOV PLAYERINPUTT1, BL
        MOV PLAYERINPUTT2, BH 

        .IF PLAYERINPUTF1 == 'a' && PLAYERINPUTF2 == '1'
            .IF PLAYERINPUTT1 == 'a' && PLAYERINPUTT2 == '2'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'b' && PLAYERINPUTT2 == '1'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'b' && PLAYERINPUTT2 == '2'
                MOV VALID_BOOL_AI, 01
            .ELSE
                MOV VALID_BOOL_AI, 00
            .ENDIF
        .ELSEIF PLAYERINPUTF1 == 'a' && PLAYERINPUTF2 == '2'
            .IF PLAYERINPUTT1 == 'a' && PLAYERINPUTT2 == '1'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'a' && PLAYERINPUTT2 == '3'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'b' && PLAYERINPUTT2 == '2'
                MOV VALID_BOOL_AI, 01
            .ELSE
                MOV VALID_BOOL_AI, 00
            .ENDIF
        .ELSEIF PLAYERINPUTF1 == 'a' && PLAYERINPUTF2 == '3'
            .IF PLAYERINPUTT1 == 'a' && PLAYERINPUTT2 == '2'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'b' && PLAYERINPUTT2 == '2'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'b' && PLAYERINPUTT2 == '3'
                MOV VALID_BOOL_AI, 01
            .ELSE
                MOV VALID_BOOL_AI, 00
            .ENDIF
        .ELSEIF PLAYERINPUTF1 == 'b' && PLAYERINPUTF2 == '1'
            .IF PLAYERINPUTT1 == 'a' && PLAYERINPUTT2 == '1'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'b' && PLAYERINPUTT2 == '2'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'c' && PLAYERINPUTT2 == '1'
                MOV VALID_BOOL_AI, 01
            .ELSE
                MOV VALID_BOOL_AI, 00
            .ENDIF
        .ELSEIF PLAYERINPUTF1 == 'b' && PLAYERINPUTF2 == '2'
            .IF PLAYERINPUTT1 == 'a' && PLAYERINPUTT2 == '1'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'a' && PLAYERINPUTT2 == '2'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'a' && PLAYERINPUTT2 == '3'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'b' && PLAYERINPUTT2 == '1'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'b' && PLAYERINPUTT2 == '3'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'c' && PLAYERINPUTT2 == '1'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'c' && PLAYERINPUTT2 == '2'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'c' && PLAYERINPUTT2 == '3'
                MOV VALID_BOOL_AI, 01
            .ELSE
                MOV VALID_BOOL_AI, 00
            .ENDIF
        .ELSEIF PLAYERINPUTF1 == 'b' && PLAYERINPUTF2 == '3'
            .IF PLAYERINPUTT1 == 'a' && PLAYERINPUTT2 == '3'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'b' && PLAYERINPUTT2 == '2'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'c' && PLAYERINPUTT2 == '3'
                MOV VALID_BOOL_AI, 01
            .ELSE
                MOV VALID_BOOL_AI, 00
            .ENDIF
        .ELSEIF PLAYERINPUTF1 == 'c' && PLAYERINPUTF2 == '1'
            .IF PLAYERINPUTT1 == 'b' && PLAYERINPUTT2 == '1'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'b' && PLAYERINPUTT2 == '2'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'c' && PLAYERINPUTT2 == '2'
                MOV VALID_BOOL_AI, 01
            .ELSE
                MOV VALID_BOOL_AI, 00
            .ENDIF
        .ELSEIF PLAYERINPUTF1 == 'c' && PLAYERINPUTF2 == '2'
            .IF PLAYERINPUTT1 == 'b' && PLAYERINPUTT2 == '2'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'c' && PLAYERINPUTT2 == '1'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'c' && PLAYERINPUTT2 == '3'
                MOV VALID_BOOL_AI, 01
            .ELSE
                MOV VALID_BOOL_AI, 00
            .ENDIF
        .ELSEIF PLAYERINPUTF1 == 'c' && PLAYERINPUTF2 == '3'
            .IF PLAYERINPUTT1 == 'b' && PLAYERINPUTT2 == '2'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'b' && PLAYERINPUTT2 == '3'
                MOV VALID_BOOL_AI, 01
            .ELSEIF PLAYERINPUTT1 == 'c' && PLAYERINPUTT2 == '2'
                MOV VALID_BOOL_AI, 01
            .ELSE
                MOV VALID_BOOL_AI, 00
            .ENDIF
        .ELSE   
            MOV INVALID_BOOL_AI, 01
        .ENDIF

        .IF VALID_BOOL_AI == 01
            MOV BL, AI_TOKEN_FROM1
            MOV BH, AI_TOKEN_FROM2

            .IF BL == 'a' && BH == '1'
                MOV B1, 32
            .ELSEIF BL == 'a' && BH == '2'
                MOV B4, 32
            .ELSEIF BL == 'a' && BH == '3'
                MOV B7, 32
            .ELSEIF BL == 'b' && BH == '1'
                MOV B2, 32
            .ELSEIF BL == 'b' && BH == '2'
                MOV B5, 32
            .ELSEIF BL == 'b' && BH == '3'
                MOV B8, 32
            .ELSEIF BL == 'c' && BH == '1'
                MOV B3, 32
            .ELSEIF BL == 'c' && BH == '2'
                MOV B6, 32
            .ELSEIF BL == 'c' && BH == '3'
                MOV B9, 32
            .ELSE   
                MOV INVALID_BOOL_AI, 01
            .ENDIF
            
            MOV BL, AI_TOKEN_TO1
            MOV BH, AI_TOKEN_TO2

            .IF BL == 'a' && BH == '1'
                MOV B1, 88
            .ELSEIF BL == 'a' && BH == '2'
                MOV B4, 88
            .ELSEIF BL == 'a' && BH == '3'
                MOV B7, 88
            .ELSEIF BL == 'b' && BH == '1'
                MOV B2, 88
            .ELSEIF BL == 'b' && BH == '2'
                MOV B5, 88
            .ELSEIF BL == 'b' && BH == '3'
                MOV B8, 88
            .ELSEIF BL == 'c' && BH == '1'
                MOV B3, 88
            .ELSEIF BL == 'c' && BH == '2'
                MOV B6, 88
            .ELSEIF BL == 'c' && BH == '3'
                MOV B9, 88
            .ELSE   
                MOV INVALID_BOOL_AI, 01
            .ENDIF

        .ELSEIF VALID_BOOL_AI == 00
            MOV INVALID_BOOL_AI, 01
        .ENDIF

        .IF INVALID_BOOL_AI == 01
            JMP COMPUTER
        .ENDIF


        PRINT_AI_MOVE:
            LEA DX, PROMPTAIMOVE
            MOV AH, 09H
            INT 21H

            MOV DL, AI_TOKEN_FROM1
            MOV AH, 02H
            INT 21H

            MOV DL, AI_TOKEN_FROM2
            MOV AH, 02H
            INT 21H

            LEA DX, PROMPTAIMOVETO
            MOV AH, 09H
            INT 21H

            MOV DL, AI_TOKEN_TO1
            MOV AH, 02H
            INT 21H

            MOV DL, AI_TOKEN_TO2
            MOV AH, 02H
            INT 21H

            MOV DL, '.'
            MOV AH, 02H
            INT 21H

            MOV DL, 13
            MOV AH, 02H
            INT 21H

            MOV DL, 10
            MOV AH, 02H
            INT 21H

            LEA DX, SPACE
            MOV AH, 09H
            INT 21H  

            LEA DX, KEY  
            MOV AH, 9
            INT 21H
                
            MOV AH, 7   
            INT 21H
            
            JMP CHECK
 
    ; ------------ COMPUTER ENDS ------- 

    ; ------------ PLAY AGAIN------- 
    PLAY_AGAIN:             
        MOV AX,0600H 
        MOV BH,07H 
        MOV CX,0000H 
        MOV DX,184FH 
        INT 10H  
        
        MOV AH, 2
        MOV BH, 0
        MOV DH, 10
        MOV DL, 24
        INT 10H

        LEA DX, TRA   
        MOV AH, 9 
        INT 21H
        
        MOV AH, 1     
        INT 21H
        
        .IF AL == 121 || AL == 89 
            JMP INITIALIZE
        .ELSEIF AL == 110 || AL == 78
            JMP EXIT
        .ELSE
            MOV AH, 2
            MOV BH, 0
            MOV DH, 10
            MOV DL, 24
            INT 10H
        
            LEA DX, WI  
            MOV AH, 9
            INT 21H 
            
            MOV AH, 7 
            INT 21H
            
            MOV AH, 2
            MOV BH, 0
            MOV DH, 10
            MOV DL, 24
            INT 10H
        
            LEA DX, EMP  
            MOV AH, 9
            INT 21H
        
            JMP PLAY_AGAIN 
        .ENDIF
    ; ------------ PLAY AGAIN-------     
    EXIT:
        MOV AH, 4CH
        INT 21H 
    MAIN ENDP
END MAIN