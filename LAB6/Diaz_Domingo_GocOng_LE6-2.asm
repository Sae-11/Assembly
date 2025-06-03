;====================================================================
		  ; Group 4 CPE-3104
		  ; LE6-2
		  ; John Ivan Diaz
		  ; Niklas Domingo
		  ; Craig Joseph Goc-ong
;====================================================================


DATA SEGMENT

   PORTA EQU 0C0H
   PORTB EQU 0C2H
   PORTC EQU 0C4H
   PORT_CON EQU 0C6H
   
   MYSTR    DB    "HELLO$"
   

DATA ENDS
   
CODE    SEGMENT PUBLIC 'CODE'
        ASSUME CS:CODE

	
START:

	MOV DX, PORT_CON
	MOV AL, 89H
	OUT DX, AL
BEGIN:
       CALL INIT_LCD
	
CHECK_DAVBL:
   MOV DX, PORTC ; set port of DAVBL(PORTC)
   IN AL, DX ; read PORTC
   TEST AL, 10H ; check if DAVBL is high
   JZ CHECK_DAVBL ; if low then check again
   IN AL, DX ; read 4-bit keypad data
   AND AL, 0FH ; mask upper nibble

 
	 CMP AL, 00H ; check if key pressed is 1 (00H)
	 JE D1 ; display 1
	 CMP AL, 01H ; check if key pressed is 2 (01H)
	 JE D2 ; display 2
	 CMP AL, 02H ; check if key pressed is 3 (02H)
	 JE D3 ; display 3
	 CMP AL, 04H ; check if key pressed is 4 (04H)
	 JE D4 ; display 4
	 CMP AL, 05H ; check if key pressed is 5 (05H)
	 JE D5 ; display 5
	 CMP AL, 06H ; check if key pressed is 6 (06H)
	 JE D6 ; display 6
	 CMP AL, 08H ; check if key pressed is 7 (08H)
	 JE D7 ; display 7
	 CMP AL, 09H ; check if key pressed is 8 (09H)
	 JE D8 ; display 8
	 CMP AL, 0AH ; check if key pressed is 9 (0AH)
	 JE D9 ; display 9
	 CMP AL, 0CH ; check if key pressed is 9 (0AH)
	 JE D10 ; display *
	 CMP AL, 0EH
	 JE D11	 
	 CMP AL, 0DH ; check if key pressed is 0 (0DH)
	 JE D0 ; display 0

	 CALL DELAY_1MS
	 JMP CHECK_DAVBL
   
D0:
 
 PUSH AX
 MOV AL, 0CAH
 CALL INST_CTRL 
 MOV AL, '0' ; display ‘1‘
 CALL DATA_CTRL
 POP AX
 JMP CONT
 
D1:
 PUSH AX
 MOV AL, 0CAH
 CALL INST_CTRL 
 MOV AL, '1' ; display ‘1‘
 CALL DATA_CTRL
 POP AX
 JMP CONT
 
 
D2: 
 PUSH AX
 MOV AL, 0CAH
 CALL INST_CTRL 
 MOV AL, '2' ; display ‘1‘
 CALL DATA_CTRL
 POP AX
 JMP CONT
D3: 
 PUSH AX
 MOV AL, 0CAH
 CALL INST_CTRL 
 MOV AL, '3' ; display ‘1‘
 CALL DATA_CTRL
 POP AX
 JMP CONT
D4:
 PUSH AX
 MOV AL, 0CAH
 CALL INST_CTRL 
 MOV AL, '4' ; display ‘1‘
 CALL DATA_CTRL
 POP AX
 JMP CONT
D5:
 PUSH AX
 MOV AL, 0CAH
 CALL INST_CTRL 
 MOV AL, '5' ; display ‘1‘
 CALL DATA_CTRL
 POP AX
 JMP CONT
D6: 
 PUSH AX
 MOV AL, 0CAH
 CALL INST_CTRL 
 MOV AL, '6' ; display ‘1‘
 CALL DATA_CTRL
 POP AX
 JMP CONT
D7:
 PUSH AX
 MOV AL, 0CAH
 CALL INST_CTRL 
 MOV AL, '7' ; display ‘1‘
 CALL DATA_CTRL
 POP AX
 JMP CONT
D8:
 PUSH AX
 MOV AL, 0CAH
 CALL INST_CTRL 
 MOV AL, '8' ; display ‘1‘
 CALL DATA_CTRL
 POP AX
 JMP CONT
D9:
 PUSH AX
 MOV AL, 0CAH
 CALL INST_CTRL 
 MOV AL, '9' ; display ‘1‘
 CALL DATA_CTRL
 POP AX
 JMP CONT
 
D10:
 PUSH AX
 MOV AL, 0CAH
 CALL INST_CTRL 
 MOV AL, '*' 
 CALL DATA_CTRL
 POP AX
 JMP CONT
 
 D11:
 PUSH AX
 MOV AL, 0CAH
 CALL INST_CTRL 
 MOV AL, '#' 
 CALL DATA_CTRL
 POP AX
 JMP CONT
 
CONT:
   CALL DELAY_1MS
   JMP 	CHECK_DAVBL
   
DELAY_1MS:
   MOV BX, 02CAH
   L1:
   NOP
   DEC BX
   JNZ L1
   RET

   
INST_CTRL:
   PUSH AX
   MOV DX, PORTA
   OUT DX, AL
   MOV DX, PORTB
   MOV AL, 02H
   OUT DX, AL
   CALL DELAY_1MS
   MOV DX, PORTB
   MOV AL, 00H
   OUT DX, AL
   POP AX
   RET

INIT_LCD:
   MOV AL, 38H
   CALL INST_CTRL
   MOV AL, 08H
   CALL INST_CTRL
   MOV AL, 01H
   CALL INST_CTRL
   MOV AL, 06H
   CALL INST_CTRL
   MOV AL, 0CH
   CALL INST_CTRL 
   RET
   
DATA_CTRL:
   PUSH AX
   MOV DX, PORTA
   OUT DX, AL
   MOV DX, PORTB
   MOV AL, 03H
   OUT DX, AL
   CALL DELAY_1MS
   MOV DX, PORTB
   MOV AL, 01H
   OUT DX, AL
   POP AX
   RET

ENDLESS:
        JMP ENDLESS
CODE    ENDS
        END START