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


.global _start

_start:
								/* set up stack pointer */
movia sp, 0x007FFFFC 			/* stack starts from highest memory address in SDRAM */
movia r6, 0x10001000 			/* JTAG UART base address */
								/* print a text string */						
movia r10, BUFFER
movia r8, TEXT_STRING

LOOP:
ldb r5, 0(r8)
beq r5, zero, GET_JTAG /* string is null-terminated */
call PUT_JTAG
addi r8, r8, 1
br LOOP

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


WHILE:

br WHILE





TEXT_STRING:
.asciz "\nEntre com o comando: "

BUFFER:
.skip 50 						#5 caracteres

.end

