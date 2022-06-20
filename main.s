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


.org 0x20  #rti

		rdctl et, ipending					# Check if external interrupt occurred 
		beq et, r0, OTHER_EXCEPTIONS		# If zero, check exceptions */
		subi ea, ea, 4 						# Hardware interrupt, decrement ea to execute the interrupted */

		andi r13, et, 1 					# Check if irq1 asserted */
		beq r13, r0, OTHER_INTERRUPTS		# If not, check other external interrupts */
		call EXT_IRQ0 						# If yes, go to IRQ1 service routine */
		OTHER_INTERRUPTS:

		br END_HANDLER 						# Done with hardware interrupts */
		OTHER_EXCEPTIONS:
		
		END_HANDLER:
				
	eret
		


EXT_IRQ0:

		movia r13, FLAG_ANIMACAO
		ldw r17 ,(r13)
		beq r17, r0, SAI_IRQ0
		
		movia r13, ANIMACAO_LED
		
		ldw r14, (r13)
		
		movi r15, 17
		bne r14, r15, CONTINUA_ANIMACAO
		
		movi r14, -1
		
		CONTINUA_ANIMACAO:
		
		movia r18, 0x10000040
		ldwio r19, (r18)
		andi r19,r19,1
		
		movi r18, 1
		
		beq r19, r18, ANIMACAO_ANTIHORARIO	#if switch = 1
		
		ANIMACAO_HORARIO:
			subi r14, r14, 1
			br PULA
		
		ANIMACAO_ANTIHORARIO:
			addi r14, r14, 1
		
		PULA:
		
		stw r14, (r13)
		
		movi r15, 1
		sll r15, r15, r14
		
		movia r13, 0x10000000
		
		stwio r15, (r13)
		
		
		SAI_IRQ0:
		
		movia r14, 0x10002000
		stwio r0, (r14)
		
		ret

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
	
	
	#temporizador
	movia r15, 10000000
	
	movia r16, 0x10002000
	
	stwio r15, 12(r16)
	srli r15, r15, 16
	stwio r15, 12(r16)
	
	movi r15, 7 
	stwio r15, 4(r16)
	
	
	#interrupcao
	movi r18, 1
	wrctl ienable, r18
			
	movi r18, 1
	wrctl status, r18

	
	
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


.global FLAG_ANIMACAO
FLAG_ANIMACAO:
.word 0

TEXT_STRING:
.asciz "\nEntre com o comando: "

TEXT_ERROR:
.asciz "\nComando errado "

ANIMACAO_LED:
.word 0

BUFFER:
.skip 50 						#5 caracteres

.end
