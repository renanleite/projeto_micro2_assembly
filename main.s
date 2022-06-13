/*	while(true){
		imprime msg("Digite...")
		c <- ler comando
		
		switch(c){
			case 0:
			case 1:
			case 2:			
		}
	}
*/

PRINT:
	subi sp, sp, 4 					/* reserve space on the stack */
	stw  ra, 0(sp)

LACO_PRINT:
	ldb r5, 0(r4)
	beq r5, zero, FIM_PRINT 		/* string is null-terminated */
	call PUT_JTAG
	addi r4, r4, 1
	br LACO_PRINT
	
FIM_PRINT:
	ldw ra, 0(sp)
	addi sp, sp, 4
	ret


.global _start

_start:
									/* set up stack pointer */
	movia sp, 0x007FFFFC 			/* stack starts from highest memory address in SDRAM */
	movia r6, 0x10001000 			/* JTAG UART base address */
									/* print a text string */						
	movia r10, BUFFER
	movia r8, TEXT_STRING
	
LOOP:
	mov r4, r8
	call PRINT

									/* read and echo characters */
GET_JTAG:
	ldwio r4, 0(r6) 				/* read the JTAG UART Data register */
	andi r8, r4, 0x8000 			/* check if there is new data */
	beq r8, r0, GET_JTAG 			/* if no data, wait */
	andi r5, r4, 0x00ff 			/* the data is in the least significant byte */
	stb r5, (r10)					#store no buffer
	addi r10, r10, 1				#incrementa r10

	call PUT_JTAG 					/* echo character */

	movi r7, '\n'
	bne r5,r7, GET_JTAG 
	
	movia r10, BUFFER				#reinicializar o buffer

	ldb r9, (r10)					#passa o conteudo do buffer para r9

	movi r11, '0'
	beq r9, r11, LED


	movi r11, '1'
	beq r9, r11, ANIMACAO


	movi r11, '2'
	beq r9, r11, CRONOMETRO

	movia r4, TEXT_ERROR
	call PRINT
	br FIM_COMANDO
	
LED:
	addi r10, r10, 1
	ldb r9, (r10)
	
	movi r11, '0'
	beq r9, r11, APAGA
	
	movi r11, '1'
	beq r9, r11, ACENDE

ANIMACAO:
	addi r10, r10, 1
	ldb r9, (r10)
	
	movi r11, '0'
	beq r9, r11, COMECA
	
	movi r11, '1'
	beq r9, r11, TERMINA
	
CRONOMETRO:
	addi r10, r10, 1
	ldb r9, (r10)
	
	movi r11, '0'
	beq r9, r11, LIGA
	
	movi r11, '1'
	beq r9, r11, DESLIGA

APAGA:
	call LED_APAGA
	br FIM_COMANDO
	
ACENDE:
	call LED_ACENDE
	br FIM_COMANDO

COMECA:
	call ANIMACAO_COMECA
	br FIM_COMANDO

TERMINA:
	call ANIMACAO_TERMINA
	br FIM_COMANDO

LIGA:
	call CRONOMETRO_LIGA
	br FIM_COMANDO

DESLIGA:
	call CRONOMETRO_DESLIGA
	br FIM_COMANDO
	 
FIM_COMANDO:
	movia r10, BUFFER
	movia r8, TEXT_STRING
	br LOOP


WHILE:

br WHILE





TEXT_STRING:
.asciz "\nEntre com o comando: "

TEXT_ERROR:
.asciz "\nComando errado "


BUFFER:
.skip 50 						#5 caracteres

.end
