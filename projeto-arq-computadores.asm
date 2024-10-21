; --- Mapeamento de Hardware (8051) ---
RS      equ     P1.3    ; Reg Select ligado em P1.3
EN      equ     P1.2    ; Enable ligado em P1.2

org 0000h
    LJMP START

org 0030h

; Escritas do LCD
BemVindo:
  DB "Bem vindo!"
  DB 00h
Escolha:
  DB "Escolha a bebida"
  DB 00h
Agua:
  DB "1 - Agua"
  DB 00h
CocaCola:
  DB "2 - Coca Cola"
  DB 00h
Cha:
  DB "3 - Chá Mate"
  DB 00h 
Suco:
  DB "4 - Suco"
  DB 00h 
Digite:
  DB "Faca seu pedido"
  DB 00h
Aguarde:
  DB "So mais uns"
  DB 00h 
Segundos:
  DB "segundos...""


; Mensagens de preparação
PreparandoAgua:
  DB "Preparando Agua"
  DB 00h
PreparandoCocaCola:
  DB "Preparando Coca"
  DB 00h
PreparandoCha:
  DB "Preparando Chá "
  DB 00h
PreparandoSuco:
  DB "Preparando Suco"
  DB 00h

; MAIN
org 0100h
START:
	;configurando teclado
	MOV 48H, #'4'
	MOV 49H, #'3'
	MOV 4AH, #'2'
	MOV 4BH, #'1'
    ; Inicializa o LCD e escreve mensagem inicial
    ACALL lcd_init
    MOV A, #00h
    ACALL posicionaCursor
    MOV DPTR, #BemVindo
    ACALL escreveStringROM
    MOV A, #40h
    ACALL posicionaCursor
    MOV DPTR, #Escolha
    ACALL escreveStringROM
    ACALL clearDisplay

    ; Exibe as opções de bebidas
    ACALL lcd_init
    MOV A, #00h
    ACALL posicionaCursor
    MOV DPTR, #Agua
    ACALL escreveStringROM
    MOV A, #40h
    ACALL posicionaCursor
    MOV DPTR, #CocaCola
    ACALL escreveStringROM
	ACALL clearDisplay	
    MOV A, #00h
    ACALL posicionaCursor
    MOV DPTR, #Cha
    ACALL escreveStringROM
    MOV A, #40h
    ACALL posicionaCursor
    MOV DPTR, #Suco
    ACALL escreveStringROM
    ACALL clearDisplay
    MOV A, #00h
    ACALL posicionaCursor
    MOV DPTR, #Digite
    ACALL escreveStringROM

    ; loop principal para escolha da bebida
ROTINA:
    ACALL leituraTeclado      ; Ler o teclado matricial
    JNB F0, ROTINA            ; Se nenhuma tecla foi pressionada, continua verificando

    ; Verifica qual número foi pressionado
    CJNE R0, #0Bh, check2     ; Se for '1', pula para Agua
    MOV DPTR, #PreparandoAgua
    ACALL exibePreparacao
    SJMP ROTINA

check2:
    CJNE R0, #0Ah, check3     ; Se for '2', pula para Coca-Cola
    MOV DPTR, #PreparandoCocaCola
    ACALL exibePreparacao
    SJMP ROTINA

check3:
    CJNE R0, #09h, check4     ; Se for '3', pula para Chá
    MOV DPTR, #PreparandoCha
    ACALL exibePreparacao
    SJMP ROTINA

check4:
    CJNE R0, #08h, ROTINA     ; Se for '4', prepara Suco
    MOV DPTR, #PreparandoSuco
    ACALL exibePreparacao
    SJMP ROTINA

    SJMP $                   ; Loop infinito

; Função para exibir mensagem de preparação
exibePreparacao:
    ACALL clearDisplay       ; Limpa o LCD
    MOV A, #00h              ; Define a posição do cursor
    ACALL posicionaCursor
    ACALL escreveStringROM   ; Escreve a string que está em DPTR no LCD
    ACALL clearDisplay
	MOV A, #00h
    ACALL posicionaCursor
    MOV DPTR, #Aguarde
    ACALL escreveStringROM
	MOV A, #40h
    ACALL posicionaCursor
    MOV DPTR, #Segundos
    ACALL escreveStringROM
	RET

; Funções do LCD
escreveStringROM:
  MOV R1, #00h
  ; Inicia a escrita da String no Display LCD
loop:
  MOV A, R1
  MOVC A,@A+DPTR 	 ; lê da memória de programa
  JZ finish2		 ; if A is 0, then end of data has been reached - jump out of loop
  ACALL sendCharacter	 ; send data in A to LCD module
  INC R1		 ; point to next piece of data
  MOV A, R1
  JMP loop		 ; repeat
finish2:
  RET

lcd_init:
  ; Inicializa o LCD
  CLR RS
  ; Função set
  CLR P1.7
  CLR P1.6
  SETB P1.5
  CLR P1.4
  SETB EN
  CLR EN
  CALL delay
  SETB EN
  CLR EN
  SETB P1.7
  SETB EN
  CLR EN
  CALL delay
  ; Entry mode set
  CLR P1.7
  CLR P1.6
  CLR P1.5
  CLR P1.4
  SETB EN
  CLR EN
  SETB P1.6
  SETB P1.5
  SETB EN
  CLR EN
  CALL delay
  ; Display on/off control
  CLR P1.7
  CLR P1.6
  CLR P1.5
  CLR P1.4
  SETB EN
  CLR EN
  SETB P1.7
  SETB P1.6
  SETB P1.5
  SETB P1.4
  SETB EN
  CLR EN
  CALL delay
  RET

sendCharacter:
  SETB RS  		; Envia um caractere para o LCD
  MOV C, ACC.7
  MOV P1.7, C
  MOV C, ACC.6
  MOV P1.6, C
  MOV C, ACC.5
  MOV P1.5, C
  MOV C, ACC.4
  MOV P1.4, C
  SETB EN
  CLR EN
  MOV C, ACC.3
  MOV P1.7, C
  MOV C, ACC.2
  MOV P1.6, C
  MOV C, ACC.1
  MOV P1.5, C
  MOV C, ACC.0
  MOV P1.4, C
  SETB EN
  CLR EN
  CALL delay
  CALL delay
  RET

posicionaCursor:
  CLR RS	
  SETB P1.7
  MOV C, ACC.6
  MOV P1.6, C
  MOV C, ACC.5
  MOV P1.5, C
  MOV C, ACC.4
  MOV P1.4, C
  SETB EN
  CLR EN
  MOV C, ACC.3
  MOV P1.7, C
  MOV C, ACC.2
  MOV P1.6, C
  MOV C, ACC.1
  MOV P1.5, C
  MOV C, ACC.0
  MOV P1.4, C
  SETB EN
  CLR EN
  CALL delay
  CALL delay
  RET

clearDisplay:
  CLR RS	
  CLR P1.7
  CLR P1.6
  CLR P1.5
  CLR P1.4
  SETB EN
  CLR EN
  CLR P1.7
  CLR P1.6
  CLR P1.5
  SETB P1.4
  SETB EN
  CLR EN
  MOV R6, #40
rotC:
  CALL delay
  DJNZ R6, rotC
  RET

delay:
  MOV R0, #50
  DJNZ R0, $
  RET

; Funções do teclado matricial
leituraTeclado:
	MOV R0, #0			; clear R0 - the first key is key0

	; scan row0
	MOV P0, #0FFh	
	CLR P0.0			; clear row0
	CALL colScan		; call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 
						; | (because the pressed key was found and its number is in  R0)
	; scan row1
	SETB P0.0			; set row0
	CLR P0.1			; clear row1
	CALL colScan		; call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 
						; | (because the pressed key was found and its number is in  R0)
	; scan row2
	SETB P0.1			; set row1
	CLR P0.2			; clear row2
	CALL colScan		; call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 
						; | (because the pressed key was found and its number is in  R0)
	; scan row3
	SETB P0.2			; set row2
	CLR P0.3			; clear row3
	CALL colScan		; call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 
						; | (because the pressed key was found and its number is in  R0)
finish:
	RET

; column-scan subroutine
colScan:
	JNB P0.4, gotKey	; if col0 is cleared - key found
	INC R0				; otherwise move to next key
	JNB P0.5, gotKey	; if col1 is cleared - key found
	INC R0				; otherwise move to next key
	JNB P0.6, gotKey	; if col2 is cleared - key found
	INC R0				; otherwise move to next key
	RET					; return from subroutine - key not found
gotKey:
	SETB F0				; key found - set F0
	RET

end
