;====================================================================
		  ; Group 4 CPE-3104
		  ; LE6-3
		  ; John Ivan Diaz
		  ; Niklas Domingo
		  ; Craig Joseph Goc-ong
;====================================================================


DATA	SEGMENT
      PORTA 	EQU 0C0h
      PORTB 	EQU 0C2h
      PORTC 	EQU 0C4h
      COM_REG1 	EQU 0C6h
      
      PORTA2	EQU 0F0h
      COM_REG2	EQU 0F6h
      
      CLEAN	DB " Initializing.","$"
      OPTION1 	DB "[1] Coke Large","$"
      OPTION2	DB "[2] Coke Medium","$"
      OPTION3	DB "[3] Sprite Large","$"
      OPTION4	DB "[4] Sprite Medium","$"
      MESSAGE1	DB "Dispensing...", "$"
      OUTPUT1	DB "Drink is Ready!!!","$"
    
DATA	ENDS


CODE    SEGMENT PUBLIC 'CODE'
        ASSUME CS:CODE
	MOV AX, DATA
	MOV DS, AX
	org 0000h

START:

   ; Initialize 8255 command registers
      MOV DX, COM_REG1
      MOV AL, 10001001b
      OUT DX, AL
      
      MOV DX, COM_REG2
      MOV AL, 10001001b
      OUT DX, AL
      
    ; Initialize LCD
      CALL INIT_LCD
      
    ; ===== START =====
    
   MAIN_MENU:
      CALL CLEAR_SCREEN
      
      LEA SI, CLEAN
      MOV AL, 081h	; LCD position
      CALL INST_CTRL
      CALL PRINT_STRING
      
      LEA SI, OPTION1
      MOV AL, 081h	; LCD position
      CALL INST_CTRL
      CALL PRINT_STRING
      
      LEA SI, OPTION2
      MOV AL, 0C1h	; LCD position
      CALL INST_CTRL
      CALL PRINT_STRING
      
      LEA SI, OPTION3
      MOV AL, 095h	; LCD position
      CALL INST_CTRL
      CALL PRINT_STRING
      
      LEA SI, OPTION4
      MOV AL, 0D5h	; LCD position
      CALL INST_CTRL
      CALL PRINT_STRING
      
        
      CHECK_DAVBL:
      
	 MOV DX, PORTC
	 IN AL, DX
	 TEST AL, 10h
	 JZ CHECK_DAVBL
	 IN AL, DX
	 AND AL, 0Fh
	 PUSH AX
	    CHECK_INPUT:
	       CMP AL, 00h
	       JE INPUT_OPTION1
	       CMP AL, 01h
	       JE INPUT_OPTION2
	       CMP AL, 02h
	       JE INPUT_OPTION3
	       CMP AL, 04h
	       JE INPUT_OPTION4
	   JMP CHECK_DAVBL
	
	
	INPUT_OPTION1:
	    CALL CLEAR_SCREEN
	    LEA SI, MESSAGE1
	    MOV AL, 0C4h
	    CALL INST_CTRL
	    CALL PRINT_STRING
	    MOV CL, 07h
	    
	    MOV DX, PORTA2
	    MOV AL, 00000001b
	    OUT DX, AL
	    CALL DISPLAY_COUNT
	    CALL FINISH
	    POP AX
	    JMP CHECK_DAVBL
	
	INPUT_OPTION2:
	    CALL CLEAR_SCREEN
	    LEA SI, MESSAGE1
	    MOV AL, 0C4h
	    CALL INST_CTRL
	    CALL PRINT_STRING
	    MOV CL, 04h
	    
	    MOV DX, PORTA2
	    MOV AL, 00000010b
	    OUT DX, AL
	    CALL DISPLAY_COUNT
	    CALL FINISH
	    POP AX
	    JMP CHECK_DAVBL
	
	INPUT_OPTION3:
	    CALL CLEAR_SCREEN
	    LEA SI, MESSAGE1
	    MOV AL, 0C4h
	    CALL INST_CTRL
	    CALL PRINT_STRING
	    MOV CL, 07h
	    
	    MOV DX, PORTA2
	    MOV AL, 00000100b
	    OUT DX, AL
	    CALL DISPLAY_COUNT
	    CALL FINISH
	    POP AX
	    JMP CHECK_DAVBL
	
	INPUT_OPTION4:
	    CALL CLEAR_SCREEN
	    LEA SI, MESSAGE1
	    MOV AL, 0C4h
	    CALL INST_CTRL
	    CALL PRINT_STRING
	    MOV CL, 04h
	    
	    MOV DX, PORTA2
	    MOV AL, 00001000b
	    OUT DX, AL
	    CALL DISPLAY_COUNT
	    CALL FINISH
	    POP AX
	    JMP CHECK_DAVBL

	
	
	FINISH:
	    CALL CLEAR_SCREEN
	    LEA SI, OUTPUT1
	    MOV AL, 0C2h
	    CALL INST_CTRL
	    CALL PRINT_STRING
	    MOV DX, PORTA2
	    MOV AL, 00h
	    OUT DX, AL
	    CALL DELAY
	    JMP MAIN_MENU
	
	
	
	
	CLEAR_SCREEN:
	    MOV AL, 01h
	    CALL INST_CTRL
	    
	PRINT_STRING:
	    
	    MOV AX, [SI]
	    CMP AL, '$'
	    JE DELAY2
	    CALL DATA_CTRL
	    INC SI
	    JMP PRINT_STRING
	
	DISPLAY_COUNT:
	
	    MOV AL, 09Dh
	    CALL INST_CTRL
	    MOV AL, 030h
	    ADD AL, CL
	    CALL DATA_CTRL
	    MOV AL, 's'
	    CALL DATA_CTRL
	    CALL DELAY
	    DEC CL
	    CMP CL, 00h
	    JNE DISPLAY_COUNT
	
	
	
	INST_CTRL:
	 PUSH AX ; preserve value of AL
	 MOV DX, PORTA ; set port of LCD data bus (PORTA)
	 OUT DX, AL ; write data in AL to PORTA
	 MOV DX, PORTB ; set port of LCD control lines (PORTB)
	 MOV AL, 02H ; E=1, RS=0 (access instruction reg)
	 OUT DX, AL ; write data in AL to PORTB
	 CALL DELAY2 ; delay for 1 ms
	 MOV DX, PORTB ; set port of LCD control lines (PORTB)
	 MOV AL, 00H ; E=0, RS=0
	 OUT DX, AL ; write data in AL to PORTB
	 POP AX ; restore value of AL
	 
	 RET
	 
      
      DATA_CTRL:
	 PUSH AX ; preserve value of AL
	 MOV DX, PORTA ; set port of LCD data bus (PORTA)
	 OUT DX, AL ; write data in AL to PORTA
	 MOV DX, PORTB ; set port of LCD control lines (PORTB)
	 MOV AL, 03H ; E=1, RS=1 (access data register)
	 OUT DX, AL ; write data in AL to PORTB
	 CALL DELAY2 ; delay for 1 ms
	 MOV DX, PORTB ; set port of LCD control lines (PORTB)
	 MOV AL, 01H ; E=0, RS=1
	 OUT DX, AL ; write data in AL to PORTB
	 POP AX ; restore value of AL
	 
	 RET
	
	
	
      INIT_LCD:

	 MOV AL, 38H ; 8-bit interface, dual-line display
	 CALL INST_CTRL ; write instruction to LCD
	 MOV AL, 08H ; display off, cursor off, blink off
	 CALL INST_CTRL ; write instruction to LCD
	 MOV AL, 01H ; clear display
	 CALL INST_CTRL ; write instruction to LCD
	 MOV AL, 06H ; increment cursor, display shift off
	 CALL INST_CTRL ; write instruction to LCD
	 MOV AL, 0CH ; display on, cursor off, blink off
	 CALL INST_CTRL ; write instruction to LCD

	 RET
	
      DELAY:
	 MOV BX, 07FFFh
	 
	 LOOP1:
	    DEC BX
	    NOP
	    JNZ LOOP1
	  
	    RET
	    
      DELAY2:
	 MOV BX, 02CAh
	 
	 LOOP2:
	    DEC BX
	    NOP
	    JNZ LOOP2
	  
	    RET
	
	
ENDLESS:
        JMP ENDLESS
CODE    ENDS
        END START