
.global LED_APAGA

LED_APAGA:

	addi r10, r10, 1
	ldb r14, (r10)
	subi r14, r14, '0'
	
	slli r15, r14, 3
	slli r11, r14, 1
	add r14, r15, r11
	

	addi r10, r10, 1
	ldb r15, (r10)
	subi r15, r15, '0'
	
	add r14, r14, r15			#r14 = resultado dos 2 ultimos digitos
	
	movi r15, 1
	sll r15, r15, r14
	nor r15, r15, r15
	
	movia r13, leds
	movia r8, ESTADO_LEDS
	ldw r12, (r8)
	
	and r12, r12, r15
	
	stwio r12, (r13)
	
	stw r12, (r8)
	
ret



.global LED_ACENDE

LED_ACENDE:

	addi r10, r10, 1
	ldb r14, (r10)
	subi r14, r14, '0'
	
	slli r15, r14, 3
	slli r11, r14, 1
	add r14, r15, r11
	

	addi r10, r10, 1
	ldb r15, (r10)
	subi r15, r15, '0'
	
	add r14, r14, r15			#r14 = resultado dos 2 ultimos digitos
	
	movi r15, 1
	sll r15, r15, r14
	
	movia r13, leds
	movia r8, ESTADO_LEDS
	ldw r12, (r8)
	
	or r12, r12, r15
	
	stwio r12, (r13)
	
	stw r12, (r8)
	
ret


.equ leds, 0x10000000

ESTADO_LEDS:
	.word 0


