; --- Mapeamento de Hardware (8051) ---
RS      equ     P1.3    ; Reg Select ligado em P1.3
EN      equ     P1.2    ; Enable ligado em P1.2

org 0000h
    LJMP START

org 0030h

; Escritas do LCD
BemVindo:
  DB "Bem vindo!"
  DB 00h ; Marca null no fim da String
Escolha:
  DB "Escolha a bebida"
  DB 00h ; Marca null no fim da String
Agua:
  DB "1 - Agua"
  DB 00h ; Marca null no fim da String
CocaCola:
  DB "2 - Coca Cola"
  DB 00h ; Marca null no fim da String
Cha:
  DB "3 - Chá Mate"
  DB 00h ; Marca null no fim da String
Suco:
  DB "4 - Suco"
  DB 00h ; Marca null no fim da String
Digite:
  DB "Digite o numero"
  DB 00h ; Marca null no fim da String

; Mensagens de preparação
PreparandoAgua:
  DB "Preparando Agua..."
  DB 00h
PreparandoCocaCola:
  DB "Preparando Coca Cola..."
  DB 00h
PreparandoCha:
  DB "Preparando Chá Mate..."
  DB 00h
PreparandoSuco:
  DB "Preparando Suco..."
  DB 00h

; MAIN
org 0100h
START:
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
    ACALL lcd_init
    MOV A, #00h
    ACALL posicionaCursor
    MOV DPTR, #Cha
    ACALL escreveStringROM
    MOV A, #40h
    ACALL posicionaCursor
    MOV DPTR, #Suco
    ACALL escreveStringROM
    ACALL clearDisplay
    ACALL lcd_init
    MOV A, #00h
    ACALL posicionaCursor
    MOV DPTR, #Digite
    ACALL escreveStringROM

    ; Loop principal para escolha da bebida
ROTINA:
    ACALL leituraTeclado      ; Ler o teclado matricial
    JNB F0, ROTINA            ; Se nenhuma tecla foi pressionada, continua verificando

    ; Verifica qual número foi pressionado
    CJNE R0, #0Bh, check2     ; Se for '1', pula para Coca-Cola
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
    MOV P0, #0F0h        ; Configura as linhas como saída (P0.4 a P0.7)
    NOP                  ; Pequeno atraso
    MOV A, P0            ; Lê as colunas (P0.0 a P0.3)
    ANL A, #0F0h         ; Verifica se alguma tecla foi pressionada
    JZ semTecla          ; Se não houver tecla pressionada, pula para semTecla
    
    MOV P0, #0FEh        ; Ativa a linha 1
    MOV A, P0
    ANL A, #0F0h
    CJNE A, #0F0h, tecla1
    
    MOV P0, #0FDh        ; Ativa a linha 2
    MOV A, P0
    ANL A, #0F0h
    CJNE A, #0F0h, tecla2
    
    MOV P0, #0FBh        ; Ativa a linha 3
    MOV A, P0
    ANL A, #0F0h
    CJNE A, #0F0h, tecla3
    
    MOV P0, #0F7h        ; Ativa a linha 4
    MOV A, P0
    ANL A, #0F0h
    CJNE A, #0F0h, tecla4

    SJMP semTecla        ; Sem tecla pressionada

tecla1:
    MOV R0, #0Bh         ; Tecla '1'
    SETB F0              ; Indica que uma tecla foi pressionada
    RET

tecla2:
    MOV R0, #0Ah         ; Tecla '2'
    SETB F0
    RET

tecla3:
    MOV R0, #09h         ; Tecla '3'
    SETB F0
    RET

tecla4:
    MOV R0, #08h         ; Tecla '4'
    SETB F0
    RET

semTecla:
    CLR F0               ; Nenhuma tecla pressionada
    RET

end
