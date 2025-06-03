;====================================================================
		  ; Group 4 CPE-3104
		  ; LE6-1
		  ; John Ivan Diaz
		  ; Niklas Domingo
		  ; Craig Joseph Goc-ong
;====================================================================

DATA SEGMENT
   PORTA EQU 0F0H
   PORTB EQU 0F2H
   PORTC EQU 0F4H
   PORT_CON EQU 0F6H
DATA ENDS

CODE    SEGMENT PUBLIC 'CODE'
        ASSUME CS:CODE

START:
       MOV DX, PORT_CON
       MOV AL, 89H
       OUT DX, AL
       
       CALL INIT_LCD
       
       MOV AL, 0C7H
       CALL INST_CTRL
       
       MOV AL, 'H'
       CALL DATA_CTRL
       MOV AL, 'E'
       CALL DATA_CTRL
       MOV AL, 'L'
       CALL DATA_CTRL
       MOV AL, 'L'
       CALL DATA_CTRL
       MOV AL, 'O'
       CALL DATA_CTRL
       MOV AL, '!'
       CALL DATA_CTRL
       
       
       
ENDLESS:
        JMP ENDLESS
	
DELAY_1MS:
   MOV BX, 02CAH
L1:
   DEC BX
   NOP
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
   
CODE    ENDS
        END START