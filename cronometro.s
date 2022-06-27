.global CRONOMETRO_LIGA

CRONOMETRO_LIGA:
	movia r19, FLAG_CRONOMETRO
	ldw r20, (r19)
	movi r20, 1
	stw r20, (r19)
	
ret



.global CRONOMETRO_DESLIGA

CRONOMETRO_DESLIGA:
	movia r19, FLAG_CRONOMETRO
	ldw r20, (r19)
	mov r20, r0
	stw r20, (r19)
	
	movia r18, 0x10000020			#reseta os displays
	movia r17, 0
	stwio r17, (r18)
ret

