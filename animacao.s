.global ANIMACAO_COMECA

ANIMACAO_COMECA:
	movia r19, FLAG_ANIMACAO
	ldw r20, (r19)
	movi r20, 1
	stw r20, (r19) 
ret



.global ANIMACAO_TERMINA

ANIMACAO_TERMINA:

	movia r19, FLAG_ANIMACAO
	ldw r20, (r19)
	mov r20, r0
	stw r20, (r19)
ret



