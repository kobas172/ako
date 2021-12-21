.686
.model flat
public _odejmowanie

.code

_odejmowanie PROC
	push	ebp
	mov		ebp, esp
	push	ebx
	push	esi
	push	edi
	
	mov		ebx, [ebp+8]
	mov		ecx, [ebp+12]
	mov		eax, [ebx]
	mov		ebx, [ecx]
	mov		edi, [ebx]
	xor		edx, edx


	cmp edi, 0		; sprawdzenie czy jest 0
	je koniec
	cmp eax, 0		; sprawdzenie czy jest ujemne
	jge dzielenie
	mov edx, 0FFFFFFFFh

dzielenie:
	idiv	edi

koniec:
	pop		edi
	pop		esi
	pop		ebx
	pop		ebp
	ret

_odejmowanie ENDP
END